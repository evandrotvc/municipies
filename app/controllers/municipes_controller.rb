# frozen_string_literal: true

class MunicipesController < ApplicationController
  before_action :set_municipe, only: %i[show update photo_file]

  def index
    if params[:query].present?
      query = params[:query].downcase
      query = I18n.transliterate(query)
      @municipes = Municipe.where('lower(unaccent(name)) ilike ?',
        "%#{query}%").order_by_name
      @municipes = Municipe.search(params[:query])
    else
      @municipes = Municipe.order_by_name
    end
    # if params[:query].present?
    #   @municipes = Municipe.search(params[:query])
    # else
    #   @municipes = Municipe.order_by_name
    # end
  end

  def show; end

  def new
    @municipe = Municipe.new
    @municipe.build_address
  end

  def create
    @municipe = Municipe.new(municipe_params)

    process_base64_photo if photo_params[:data].present?

    if @municipe.save
      render :show, status: :created
    else
      render :errors, status: :unprocessable_entity
    end
  end

  def update
    byebug
    process_base64_photo if params[:photo].present?

    if @municipe.update(municipe_params)
      render :show, status: :ok
    else
      render :errors, status: :unprocessable_entity
    end
  end

  private

  def process_base64_photo
    photo_data = photo_params[:data]

    decoded_data = Base64.decode64(photo_data)
    @municipe.photo.attach(io: StringIO.new(decoded_data), filename: 'photo.png',
      content_type: 'image/png')
  end

  def set_municipe
    municipe = Municipe.find(params[:id])
    @municipe = helpers.decorate(municipe)
  end

  def municipe_params
    params.require(:municipe).permit(
      :name, :cpf, :cns, :birth_date, :email, :phone, :status,
      address_attributes: %i[zipcode street complement neighborhood city uf ibge_code]
    )
  end

  def photo_params
    params.require(:photo).permit(:data)
  end
end
