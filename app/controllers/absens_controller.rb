class AbsensController < ApplicationController
  before_action :set_absen, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @absens = Absen.all
    respond_with(@absens)
  end

  def show
    respond_with(@absen)
  end

  def new
    @absen = Absen.new
    respond_with(@absen)
  end

  def edit
  end

  def create
    @absen = Absen.new(absen_params)
    @absen.save
    respond_with(@absen)
  end

  def update
    @absen.update(absen_params)
    respond_with(@absen)
  end

  def destroy
    @absen.destroy
    respond_with(@absen)
  end

  private
    def set_absen
      @absen = Absen.find(params[:id])
    end

    def absen_params
      params.require(:absen).permit(:nama, :alamat, :nim)
    end
end
