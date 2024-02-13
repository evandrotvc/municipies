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

    it 'validates if :cpf is valid' do
      municipe.cpf = '111.561.236-63'
      municipe.validate
      expect(municipe.errors).to have_key(:cpf)
    end

    it 'validates if :cns is valid' do
      municipe.cns = '12345000000'
      municipe.validate
      expect(municipe.errors).to have_key(:cns)
    end

    it 'validates if :email is valid' do
      municipe.email = 'email'
      municipe.validate
      expect(municipe.errors).to have_key(:email)
    end

    it 'validates if :birth_date is valid' do
      municipe.birth_date = Date.current + 1.year
      municipe.validate
      expect(municipe.errors).to have_key(:birth_date)
    end
  end

  describe 'relations' do
    it { is_expected.to have_one_attached(:photo) }
    it { is_expected.to have_one(:address) }
  end

  describe 'should index fields in elasticSearch' do
    let!(:municipe) { create(:municipe, name: 'Harry Potter') }

    xit 'indexes the address in Elasticsearch' do
      @query = {
        query: {
          term: {
            _id: municipe.id.to_s
          }
        }
      }

      municipe.__elasticsearch__.index_document
      municipe.class.__elasticsearch__.refresh_index!

      response_elastic = described_class.__elasticsearch__.search(@query)
      name_elastic = response_elastic.response['hits']['hits'].first._source['name']

      expect(name_elastic).to eq(municipe.name)

      municipe.name = 'Teste'

      municipe.__elasticsearch__.index_document
      municipe.class.__elasticsearch__.refresh_index!

      response_elastic = described_class.__elasticsearch__.search(@query)
      name_elastic = response_elastic.response['hits']['hits'].first._source['name']

      expect(name_elastic).to eq('Teste')
    end
  end

  describe '#search' do
    let!(:municipe1) { create(:municipe, name: 'John Doe', cns: '197544549140008') }
    let!(:municipe2) { create(:municipe, name: 'Jane Doe', cns: '278244365930009') }

    before do
      described_class.all.map { |municipe| municipe.__elasticsearch__.index_document }
      described_class.__elasticsearch__.refresh_index!
    end

    context 'should filter name municipe in elasticSearch' do
      xit 'returns municipe matching the query' do
        expect(described_class.search('John').map(&:id)).to include(municipe1.id)
      end

      xit 'does not return municipe not matching the query' do
        expect(described_class.search('John').map(&:id)).not_to include(municipe2.id)
      end

      xit 'returns municipe matching the query cns' do
        expect(described_class.search('197544549140008').map(&:id)).to include(municipe1.id)
      end

      xit 'does not return municipe not matching the query cns' do
        expect(described_class.search('197544549140008').map(&:id)).not_to include(municipe2.id)
      end
    end
  end
end
