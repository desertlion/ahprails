class BelajarsController < ApplicationController
  before_action :set_belajar, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @belajars = Belajar.all
    respond_with(@belajars)
  end

  def show
    respond_with(@belajar)
  end

  def new
    @belajar = Belajar.new
    respond_with(@belajar)
  end

  def edit
  end

  def create
    @belajar = Belajar.new(belajar_params)
    @belajar.save
    respond_with(@belajar)
  end

  def update
    @belajar.update(belajar_params)
    respond_with(@belajar)
  end

  def destroy
    @belajar.destroy
    respond_with(@belajar)
  end

  private
    def set_belajar
      @belajar = Belajar.find(params[:id])
    end

    def belajar_params
      params.require(:belajar).permit(:nama, :ruang)
    end
end
