class UnstructuredDataController < ApplicationController
  before_action :set_unstructured_datum, only: [:show, :edit, :update, :destroy]

  # GET /unstructured_data
  # GET /unstructured_data.json
  def index
      @unstructured_data = UnstructuredDatum.includes(:subcriterium).all
  end

  # GET /unstructured_data/1
  # GET /unstructured_data/1.json
  def show
  end

  # GET /unstructured_data/new
  def new
      @subcriteria = Subcriterium.where('tipe', false)
    @unstructured_datum = UnstructuredDatum.new
  end

  # GET /unstructured_data/1/edit
  def edit
  end

  # POST /unstructured_data
  # POST /unstructured_data.json
  def create
    @unstructured_datum = UnstructuredDatum.new(unstructured_datum_params)

    respond_to do |format|
      if @unstructured_datum.save
        format.html { redirect_to @unstructured_datum, notice: 'Unstructured datum was successfully created.' }
        format.json { render :show, status: :created, location: @unstructured_datum }
      else
        format.html { render :new }
        format.json { render json: @unstructured_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /unstructured_data/1
  # PATCH/PUT /unstructured_data/1.json
  def update
    respond_to do |format|
      if @unstructured_datum.update(unstructured_datum_params)
        format.html { redirect_to @unstructured_datum, notice: 'Unstructured datum was successfully updated.' }
        format.json { render :show, status: :ok, location: @unstructured_datum }
      else
        format.html { render :edit }
        format.json { render json: @unstructured_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unstructured_data/1
  # DELETE /unstructured_data/1.json
  def destroy
    @unstructured_datum.destroy
    respond_to do |format|
      format.html { redirect_to unstructured_data_url, notice: 'Unstructured datum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
    
    def ahp
        @subcriteria = Subcriterium.where(tipe: false).includes(:unstructured_data)
    end
    
    def ahpcalculate
        # Mulai Hitung AHP untuk setiap sub sub
        # Khusus topografi tidak memiliki sub, jadi tidak dihitung
        @subcriteria = Subcriterium.where(tipe: false).includes(:unstructured_data)
        @UD = {}
        @subcriteria.each do |sub|
            ud         = sub.unstructured_data
            panjangud  = ud.length
            
            # Mulai Hitung AHP untuk setiap unstructured_data(ud)
            # Simpan semua data AHP ud khusus id ini ke dalam variabel @subcriteria
            @UD[sub.id] = {}
            @UD[sub.id][:sum] = {}
            @UD[sub.id][:sumpv] = {}
            @UD[sub.id][:sqrt3] = {}
            @UD[sub.id][:bobot] = {}
            @UD[sub.id][:nilai] = {}
            ud.each_with_index do |baris, index|
                # Jika akar pangkat 3 ud kosong, ubah jadi 1
                @UD[sub.id][:sqrt3][index] = 1 if @UD[sub.id][:sqrt3][index] == nil;
                ud.each_with_index do |kolom, idx|
                    # Hitung nilai2 matrix nya berdasarkan input
                    if index == idx
                        @UD[sub.id][:nilai]["#{index}#{idx}"] = 1
                    elsif index < idx
                        @UD[sub.id][:nilai]["#{index}#{idx}"] = params[:ud][baris.id.to_s][kolom.id.to_s].to_f
                    else
                        @UD[sub.id][:nilai]["#{index}#{idx}"] = 1/params[:ud][kolom.id.to_s][baris.id.to_s].to_f
                    end
                    # Jumlahkan 1 kolom menurun
                    @UD[sub.id][:sum][idx] = @UD[sub.id][:sum][idx].to_f + @UD[sub.id][:nilai]["#{index}#{idx}"].to_f;
                    # Hitung produknya kemudian ambil akar pangkat 3 nya
                    @UD[sub.id][:sqrt3][index] = @UD[sub.id][:sqrt3][index].to_f * @UD[sub.id][:nilai]["#{index}#{idx}"].to_f
                    if idx == ud.length-1 then 
                        @UD[sub.id][:sqrt3][index] = @UD[sub.id][:sqrt3][index]**(1.to_f/(ud.length).to_f).to_f 
                    end
                    # Jumlahkan secara menurun hasil dari sqrt
                end
            end
            # hitung bobot per sub sub
            @UD[sub.id][:sumSqrt3] = 0.0
            ud.length.times { |i| @UD[sub.id][:sumSqrt3] = (@UD[sub.id][:sumSqrt3] + @UD[sub.id][:sqrt3][i].to_f).to_f }
            @UD[sub.id][:lambda]   = 0.0
            @UD[sub.id][:sumbobot]   = 0.0
            for i in 0..ud.length-1
                @UD[sub.id][:bobot][i] = (@UD[sub.id][:sqrt3][i].to_f/@UD[sub.id][:sumSqrt3].to_f)
                @UD[sub.id][:sumbobot] = (@UD[sub.id][:sumbobot] + @UD[sub.id][:bobot][i].to_f).to_f
                data = UnstructuredDatum.find(ud[i].id)
                data.ahp = @UD[sub.id][:bobot][i]
                data.save
                @UD[sub.id][:sumpv][i]= (@UD[sub.id][:sum][i]*@UD[sub.id][:bobot][i])
                @UD[sub.id][:lambda]  = (@UD[sub.id][:lambda] + @UD[sub.id][:sumpv][i])
            end
        end
#            render json: @UD.to_json
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unstructured_datum
      @unstructured_datum = UnstructuredDatum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unstructured_datum_params
      params.require(:unstructured_datum).permit(:name, :subcriterium_id)
    end
end
