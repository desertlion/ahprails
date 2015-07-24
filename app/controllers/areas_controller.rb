class AreasController < ApplicationController
    before_action :set_area, only: [:show, :edit, :update, :destroy]
    before_action :set_detail, only: [:new, :edit, :create, :update, :calculate]

    # GET /areas
    # GET /areas.json
    def index
        @areas = Area.all
    end

    # GET /areas/1
    # GET /areas/1.json
    def show
    end

    # GET /areas/new
    def new
        @area = Area.new
    end

    # GET /areas/1/edit
    def edit
    end

    # POST /areas
    # POST /areas.json
    def create
        @area = Area.new(area_params)
        respond_to do |format|
            if @area.save
                # Jika pembuatan area berhasil, buat juga parameter nya
                @details.each do |detail|
                    #if AreaDetail.where(name: detail[:name]) != nil
                    #end
                    datadetail = AreaDetail.new
                    datadetail.area_id = @area.id
                    datadetail.name    = detail[:name]
                    datadetail.detail  = params[:detail][0][detail[:name]]
                    datadetail.detail_type = detail[:tipe]
                    datadetail.detail_id   = detail[:id]
                    datadetail.save
                end
                format.html { redirect_to @area, notice: 'Area was successfully created.' }
                format.json { render :show, status: :created, location: @area }
            else
                format.html { render :new }
                format.json { render json: @area.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /areas/1
    # PATCH/PUT /areas/1.json
    def update
        respond_to do |format|
            if @area.update(area_params)
                # Jika perubahan area berhasil, buat juga parameter nya
                @details.each do |detail|
                    cariDetail = AreaDetail.where(name: detail[:name]).where(area_id: @area.id).first
                    if cariDetail != nil
                        datadetail = cariDetail
                    else
                        datadetail = AreaDetail.new
                    end
                    datadetail.area_id = @area.id.to_i
                    datadetail.name    = detail[:name]
                    datadetail.detail  = params[:detail][@area.id.to_s][detail[:name]]
                    datadetail.detail_type = detail[:tipe]
                    datadetail.detail_id   = detail[:id]
                    datadetail.save
                end
                format.html { redirect_to @area, notice: 'Area was successfully updated.' }
                format.json { render :show, status: :ok, location: @area }
            else
                format.html { render :edit }
                format.json { render json: @area.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /areas/1
    # DELETE /areas/1.json
    def destroy
        @area.destroy
        respond_to do |format|
            format.html { redirect_to areas_url, notice: 'Area was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    # GET /areas/:id/calculate
    def calculate
        # ambil data area beserta detailnya
        @area = Area.includes(:area_detail).find(params[:id])
        # ambil data tanaman
        @plants = Plant.includes(:plant_detail).all
        # data criteria
        @criteria = Criterium.includes(:subcriteria)
        # definisikan gaps
        @gaps = []
        # definisikan variabel untuk score nanti
        @gapsScore = {}
        # ambil ahp untuk data unstructured
        @ahpUD = UnstructuredDatum.all
        @details.each do |detail|
            data           = {}
            data[:name]    = detail[:name]
            data[:plants]  = []
            data[:isRange] = false
            data[:isUnstructured] = (detail[:tipe]=='unstructured') ? true : false
            data[:ahplahan] = detail[:ahp]
            data[:tipe] = detail[:tipe]
            @plants.each do |plant|
                planttemp           = {}
                profile             = 0
                planttemp[:name]    = plant[:name]
                planttemp[:profile] = plant.plant_detail.where(name: detail[:name]).first.detail
                planttemp[:profilelahan] = @area.area_detail.where(name: detail[:name]).first.detail
                profile                  = planttemp[:profile].split("-")
                # jika nilai profile berupa range, tidak akan ada GAP
                if profile[1] != nil
                    data[:isRange] = true
                    # hitung interpolasinya dan dapatkan score
                    # rumus = f(x)=  {y2-y1} over {x2-x1} left (x-x1 right ) +y1
                    # x = profilelahan
                    rangeMin = profile[0].to_f
                    rangeMax = profile[1].to_f
                    planttemp[:score]   = countScore(rangeMin,rangeMax,planttemp[:profilelahan])
                else
                    if detail[:tipe] == 'unstructured' then
                        planttemp[:ahp] = @ahpUD.where("lower(name) = ?", planttemp[:profile].downcase).first[:ahp]
                        planttemp[:gap] = data[:ahplahan].to_f - planttemp[:ahp].to_f
                        planttemp[:ahplahan] = @ahpUD.where("lower(name) = ?", planttemp[:profilelahan].downcase).first[:ahp]
                        planttemp[:score] = countScoreFromGapUD(planttemp[:gap])
                    else
                        # bukan unstructured
                        # hitung dulu gapnya
                        planttemp[:gap]   = planttemp[:profilelahan].to_f - planttemp[:profile].to_f
                        planttemp[:score] = countScoreFromGap(planttemp[:gap])
                    end
                end
                    if @gapsScore[plant.name] == nil
                        @gapsScore[plant.name] = {}
                    end
                    @gapsScore[plant.name][detail[:name]] = planttemp[:score]
#                 @gapsScore.push({name: plant.name, score: planttemp[:score], parameter: detail[:name]})
                data[:plants].push(planttemp)
            end
            @gaps.push(data);
        end
#         render json: @gaps and return
    end

    private
        def countScoreFromGapUD(gap)
            gap = gap.to_f
            # Buat tabel bobot gap
            i = 0
            gapsebelum = 0
            bobotsebelum = 0.00
            if gap > 0 then
                atas = 11.5
                angkaatas = 0
                (0..10).each do |n|
                    angkaatas = angkaatas + 10
                    atas = atas - 1.0
                    if ( gap > n && n < 1 ) then
                        return (( 11.5 - 10 )  / ( 10 - 0 ) * ( gap ) + 10.5 ).to_f
                    elsif gap > n && n > 0 then
                        return ((bobotsebelum.to_f - atas) / (n - gapsebelum.to_f) * (gap.to_f - gapsebelum.to_f) + atas).to_f
                    end
                    gapsebelum = angkaatas
                    bobotsebelum = atas
                end
            else
                atas = 11
                angkaatas = -110
                (1..11).each do |n|
                    if n == 11
                        return (( 11.5 - 10 )  / ( 10 - 0 ) * ( gap ) + 10.5 ).to_f
                    else
                        if ( gap > angkaatas && n < 1 ) then
                            return (( 11.5 - 10 )  / ( 10 - 0 ) * ( gap ) + 10.5 ).to_f
                        elsif gap > angkaatas && n > 0 then
                            return ((bobotsebelum.to_f - atas) / (n - gapsebelum.to_f) * (gap.to_f - gapsebelum.to_f) + atas).to_f
                        end
                        angkaatas = angkaatas + 10
                        atas = atas - 1.0
                    end
                    gapsebelum = angkaatas
                    bobotsebelum = atas
                end
            end
        end
        def countScoreFromGap(gap)
            gap = gap.to_f
            # Buat tabel bobot gap
            hasil = []
            atas  = 11
            angkaatas = 0
            (0..10).each do |n|
                if n == 0
                    hasil.push({
                        gap: 0,
                        bobot: 11
                    })
                else
                    angkaatas = angkaatas + 10
                    atas = atas - 1.0
                    hasil.push({ gap: -(angkaatas).to_f, bobot: atas})
                end
            end
            atas = 11.5
            angkaatas = 0
            (1..10).each do |n|
                if n == 0
                    hasil.push({
                        gap: 0,
                        bobot: 11
                    })
                else
                    angkaatas = angkaatas + 10
                    atas = atas - 1.0
                    hasil.push({ gap: (angkaatas).to_f, bobot: atas})
                end
            end
            bobot = 0
            hasil.each do |data|
                if data[:gap] == gap then
                    bobot = data[:bobot]
                    return bobot
                    break
                else
                    bobot = 0
                end
            end
                # udah selesai 1 looping dan belum dapet, berarti ga sama, pake interval, interpolasi
                sebelum = {}
                i=1
                hasil.each do |data|
                    if gap > 0
                        if data[:gap] > 0 && data[:gap].to_f > gap.to_f && i!=1 then
                            return data[:gap]
                            return "((#{sebelum.to_json} - #{data[:bobot].to_f}) / ( #{sebelum[:gap].to_f} - #{data[:gap].to_f} ) * ( #{gap} ) + #{data[:bobot].to_f} ).to_f"
                        else
#                             next
                            return data if i > 30
                        end
                    else
                        return 'negative'
                    end
                    sebelum = data
                    i = i + 1
                end
        end
    def countScore(kiri,kanan,x)
        batasbawah = 1
        batasatas  = 3
        score      = 0.0
        x          = x.to_f
        if x < kiri then
            atas = batasatas - batasbawah
            bawah = kiri
            kanan2 = batasbawah
            kanan1 = x
            x1     = 0
#             return "#{atas} / #{bawah} * ( #{x} - #{kanan} = #{kanan1}) + #{kanan2}, x1 = #{x1}"
        elsif x >= kiri && x <= kanan
            return batasatas.to_f
        else
            atas            = batasbawah - batasatas
            kanan2          = batasatas
            selisihinterval = kanan-kiri
            x1temp          = ( kanan.to_f + selisihinterval.to_f )
            x1              = (x > x1temp) ? ( kiri.to_f + kiri.to_f) : x1temp
            bawah           = ( x1 - kanan.to_f ).to_f
            kanan1          = x - kanan
#             return "#{atas} / #{bawah} * ( #{x} - #{kanan} = #{kanan1}) + #{kanan2}, x1 = #{x1}"
        end
            score = ( (atas / bawah).to_f * kanan1.to_f ) + kanan2.to_f
            return score.to_f
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_area
        @area = Area.includes(:area_detail).find(params[:id])
    end

    def set_detail
        @details = []
        criteria = Criterium.includes(:subcriteria)
        #setiap looping sambil check ke database ada nilai ga
        # plus check ada ga yang bertipe unstructured data
        unstructureddata = UnstructuredDatum.select("subcriterium_id").group("subcriterium_id")
        @UData = []
        unstructureddata.each do |uD|
            @UData.push(uD.subcriterium_id)
        end
        criteria.each do |kriteria|
            if kriteria.subcriteria.length > 0
                sub = kriteria.subcriteria
                sub.each do |subkriteria|
                    tipe = 'subcriteria'
                    if @UData.include?(subkriteria.id)
                        tipe = 'unstructured'
                    end
                    @details.push({
                        tipe: tipe,
                        id: subkriteria.id,
                        name: subkriteria.name,
                        ahp: subkriteria.ahp
                    })
                end
            else
                @details.push({tipe: 'criteria', id: kriteria.id, name: kriteria.name, ahp: kriteria.ahp})
            end
        end
#         render json: @details and return
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def area_params
        params.require(:area).permit(:name)
    end
end
