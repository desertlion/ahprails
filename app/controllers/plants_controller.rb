class PlantsController < ApplicationController
    before_action :set_plant, only: [:show, :edit, :update, :destroy, :detail]
    before_action :set_detail, only: [:new, :edit, :create, :update]

    # GET /plants
    # GET /plants.json
    def index
        @plants = Plant.all
    end

    # GET /plants/1
    # GET /plants/1.json
    def show
    end

    # GET /plants/new
    def new
        @plant = Plant.new
    end

    # GET /plants/1/edit
    def edit
    end

    # POST /plants
    # POST /plants.json
    def create
        @plant = Plant.new(plant_params)

        respond_to do |format|
            if @plant.save
                # Jika pembuatan tanaman berhasil, buat juga parameter nya
                @details.each do |detail|
                    datadetail = PlantDetail.new
                    datadetail.area_id = @plant.id
                    datadetail.name    = detail[:name]
                    datadetail.detail  = params[:detail][0][detail[:name]]
                    datadetail.detail_type = detail[:tipe]
                    datadetail.detail_id   = detail[:id]
                    datadetail.save
                end
                format.html { redirect_to @plant, notice: 'Plant was successfully created.' }
                format.json { render :show, status: :created, location: @plant }
            else
                format.html { render :new }
                format.json { render json: @plant.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /plants/1
    # PATCH/PUT /plants/1.json
    def update
        respond_to do |format|
            if @plant.update(plant_params)
                # Jika perubahan area berhasil, buat juga parameter nya
                @details.each do |detail|
                    cariDetail = PlantDetail.where(name: detail[:name], plant_id: @plant.id).first
                    if cariDetail != nil
                        datadetail = cariDetail
                    else
                        datadetail = PlantDetail.new
                    end
                    datadetail.plant_id = @plant.id.to_i
                    datadetail.name    = detail[:name]
                    datadetail.detail  = params[:detail][@plant.id.to_s][detail[:name]]
                    datadetail.detail_type = detail[:tipe]
                    datadetail.detail_id   = detail[:id]
                    datadetail.save
                end
                format.html { redirect_to @plant, notice: 'Plant was successfully updated.' }
                format.json { render :show, status: :ok, location: @plant }
            else
                format.html { render :edit }
                format.json { render json: @plant.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /plants/1
    # DELETE /plants/1.json
    def destroy
        @plant.destroy
        respond_to do |format|
            format.html { redirect_to plants_url, notice: 'Plant was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def detail
        @details = []
        criteria = Criterium.includes(:subcriteria)
        #setiap looping sambil check ke database ada nilai ga
        criteria.each do |kriteria|
            if kriteria.subcriteria.length > 0
                sub = kriteria.subcriteria
                sub.each do |subkriteria|
                    @details.push({
                        tipe: 'subcriteria',
                        id: subkriteria.id,
                        name: subkriteria.name,
                        value: 0
                        })
                end
            else
                @details.push({tipe: 'criteria', id: kriteria.id, name: kriteria.name, value: 0})
            end
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_plant
        @plant = Plant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plant_params
        params.require(:plant).permit(:name, :profile)
    end

    def set_detail
        @details = []
        criteria = Criterium.includes(:subcriteria)
        #setiap looping sambil check ke database ada nilai ga
        criteria.each do |kriteria|
            if kriteria.subcriteria.length > 0
                sub = kriteria.subcriteria
                sub.each do |subkriteria|
                    @details.push({
                        tipe: 'subcriteria',
                        id: subkriteria.id,
                        name: subkriteria.name
                        })
                end
            else
                @details.push({tipe: 'criteria', id: kriteria.id, name: kriteria.name})
            end
        end
    end
end
