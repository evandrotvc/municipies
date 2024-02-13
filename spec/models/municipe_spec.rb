# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Municipe do
  describe 'validations' do
    subject(:municipe) { described_class.new }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:cpf) }
    it { is_expected.to validate_presence_of(:cns) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:birth_date) }
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:photo) }

    it { is_expected.to validate_length_of(:name).is_at_least(3) }
    it { is_expected.to define_enum_for(:status).with_values(active: 0, inactive: 1) }

    context 'with cpf validation' do
      it 'cpf is invalid' do
        municipe.cpf = '111.561.236-6'
        municipe.validate

        expect(municipe.errors).to have_key(:cpf)
      end

      it 'cpfs is valid' do
        municipe.cpf = '865.922.358-61'
        municipe.validate
        expect(municipe.errors).not_to have_key(:cpf)
      end
    end

    context 'with cns validation' do
      it 'cns is invalid' do
        municipe.cns = '12345'
        municipe.validate
        expect(municipe.errors).to have_key(:cns)
      end

      it 'cns is valid' do
        municipe.cns = '209179687130003'
        municipe.validate
        expect(municipe.errors).not_to have_key(:cns)
      end
    end

    context 'with email format validation' do
      it 'is invalid when email format is incorrect' do
        municipe = described_class.new(email: 'invalid_email.com')
        municipe.valid?
        expect(municipe.errors).to have_key(:email)
      end

      it 'is valid when email format is correct' do
        municipe = described_class.new(email: 'valid@example.com')
        municipe.valid?
        expect(municipe.errors).not_to have_key(:email)
      end
    end

    context 'with birth_date format validation' do
      it 'birth_date is invalid' do
        municipe.birth_date = Date.current + 1.year
        municipe.validate
        expect(municipe.errors).to have_key(:birth_date)
      end

      it 'birth_date is valid' do
        municipe.birth_date = Date.current
        municipe.validate
        expect(municipe.errors).not_to have_key(:birth_date)
      end
    end

    context 'with phone_format validation' do
      it 'is invalid with an invalid phone format' do
        municipe = described_class.new(phone: '1234abcd')
        municipe.validate

        expect(municipe.errors[:phone]).to include(
          I18n.t('activerecord.errors.models.municipe.attributes.phone.invalid_format')
        )
      end

      it 'is valid with a valid phone format' do
        municipe = described_class.new(phone: '5561920304050')
        municipe.validate
        expect(municipe.errors[:phone]).to be_empty
      end
    end

    describe 'relations' do
      it { is_expected.to have_one_attached(:photo) }
      it { is_expected.to have_one(:address) }
    end
  end
end
