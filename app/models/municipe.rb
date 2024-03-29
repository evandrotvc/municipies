# frozen_string_literal: true

class Municipe < ApplicationRecord
  include Searchable

  has_one_attached :photo

  has_one :address, dependent: :destroy

  accepts_nested_attributes_for :address

  enum status: { active: 0, inactive: 1 }, _default: :active

  scope :order_by_name, -> { order(:name) }

  validates :name, :cpf, :cns, :email, :birth_date, :status, :photo,
    presence: true
  validates :name, length: { minimum: 3 }
  validates :cpf, cpf: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :cns, cns: true
  validates :birth_date, pass_date: true
  validates :phone, presence: true
  validate :phone_format

  after_save :information_updates_email, :enqueue_job_elastic_search
  after_save :send_sms

  def phone_format
    return if phone.blank? || phone.match?(/\A\d+\z/)

    errors.add(:phone, :invalid_format)
  end

  def self.translated_statuses
    statuses.keys.map do |status|
      [I18n.t("activerecord.attributes.municipe.statuses.#{status}"), status]
    end
  end

  def as_indexed_json(_options = {})
    indexed_json = as_json(except: %i[created_at updated_at photo])
    indexed_json['ibge_code'] = address.ibge_code
    indexed_json['ibge_uf'] = address.uf

    indexed_json
  end

  def enqueue_job_elastic_search
    UpdateIndexElasticSearchJob.perform_later
  end

  private

  def information_updates_email
    MunicipeMailer.with(municipe: self).info_changed.deliver_later
  end

  def send_sms
    # TwilioMessenger.new("Olá, #{name}, seu cadastro foi criado/atualizado com sucesso!",
    #   phone).call
  end
end
