require 'rails_helper'

RSpec.describe UpdateIndexElasticSearchJob do
  describe '#perform' do
    let(:municipe1) { create(:municipe, name: 'Evandro') }
    let(:municipe2) { create(:municipe, name: 'Teste') }

    it 'not exists indexes from Municipes in Elasticsearch' do
      query = { query: { match_all: {} } }
      response_elastic = Municipe.__elasticsearch__.search(query)

      names_indexeds = response_elastic.response['hits']['hits'].map do |municipe|
        municipe._source['name']
      end

      expect(names_indexeds).not_to include('Evandro')
    end

    it 'must exist index from municipe after run job' do
      query = {
        query: {
          term: {
            _id: municipe2.id.to_s
          }
        }
      }
      described_class.perform_now

      response_elastic = Municipe.__elasticsearch__.search(query)
      name_elastic = response_elastic.response['hits']['hits'].first._source['name']

      expect(name_elastic).to eq(municipe2.name)
    end
  end
end
