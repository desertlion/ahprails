class SubcriteriaController < ApplicationController
    before_action :set_subcriterium, only: [:show, :edit, :update, :destroy]

    # GET /subcriteria
    # GET /subcriteria.json
    def index
        @criterium_id = params[:criterium_id]
        @subcriteria = Subcriterium.includes(:criterium).where(:criteria_id => @criterium_id)
    end

    # GET /subcriteria/1
    def show
        @subcriterium = Subcriterium.includes(:criterium).find(params[:id])
    end

    # GET /subcriteria/new
    def new
        @criterium    = Criterium.find(params[:criterium_id])
        @subcriterium = Subcriterium.new
    end

    # GET /subcriteria/1/edit
    def edit
        @criterium    = Criterium.find(params[:criterium_id])
        @subcriterium = Subcriterium.includes(:criterium).find(params[:id])
    end

    # POST /subcriteria
    # POST /subcriteria.json
    def create
        @criterium    = Criterium.find(params[:criterium_id])
        @subcriterium = Subcriterium.new(subcriterium_params)

        respond_to do |format|
            if @subcriterium.save
                format.html { redirect_to criterium_subcriteria_path, notice: 'Subcriterium was successfully created.' }
                format.json { render :show, status: :created, location: @subcriterium }
            else
                format.html { render :new }
                format.json { render json: @subcriterium.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /subcriteria/1
    # PATCH/PUT /subcriteria/1.json
    def update
        respond_to do |format|
            if @subcriterium.update(subcriterium_params)
                format.html { redirect_to criterium_subcriteria_path(@subcriterium), notice: 'Subcriterium was successfully updated.' }
                format.json { render :show, status: :ok, location: @subcriterium }
            else
                format.html { render :edit }
                format.json { render json: @subcriterium.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /subcriteria/1
    # DELETE /subcriteria/1.json
    def destroy
        @subcriterium.destroy
        respond_to do |format|
            format.html { redirect_to subcriteria_url, notice: 'Subcriterium was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_subcriterium
        @subcriterium = Subcriterium.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subcriterium_params
        params.require(:subcriterium).permit(:name, :criteria_id, :tipe)
    end
end
