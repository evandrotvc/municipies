# frozen_string_literal: true

require 'rails_helper'

class PassDateValidatable
  include ActiveModel::Validations
  attr_accessor :birth_date

  validates :birth_date, pass_date: true
end

describe PassDateValidator do
  subject(:validatable) { PassDateValidatable.new }

  describe '#validate_each' do
    context 'when birth_date is nil' do
      before { validatable.birth_date = nil }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when birth_date is in the future' do
      before { validatable.birth_date = Date.current + 1 }

      it 'is invalid' do
        expect(subject).not_to be_valid
        validatable.valid?
        expect(validatable.errors.attribute_names).to include(:birth_date)
      end
    end

    context 'when birth_date is before 1900' do
      before { validatable.birth_date = Date.new(1800, 1, 1) }

      it 'is invalid' do
        expect(subject).not_to be_valid
        validatable.valid?
        expect(validatable.errors.attribute_names).to include(:birth_date)
      end
    end

    context 'when birth_date is after current year' do
      before { validatable.birth_date = Date.current + 100 }

      it 'is invalid' do
        expect(subject).not_to be_valid
        validatable.valid?
        expect(validatable.errors.attribute_names).to include(:birth_date)
      end
    end

    context 'when birth_date is valid' do
      before { validatable.birth_date = Date.current - 20 }

      it 'is valid' do
        expect(subject).to be_valid
        validatable.valid?
        expect(validatable.errors.attribute_names).not_to include(:birth_date)
      end
    end
  end
end
