# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :municipe

  validates :zipcode, :street, :neighborhood, :city, :uf, presence: true
end
