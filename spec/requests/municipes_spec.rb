# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Municipe do
  let(:json) { response.parsed_body }

  describe 'GET index' do
    let!(:municipes) { create_list(:municipe, 3) }
    let(:request) { get municipes_path, as: :json }

    before do
      municipes.map { |municipe| municipe.__elasticsearch__.index_document }
      described_class.__elasticsearch__.refresh_index!
      request
    end

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all municipies' do
      expect(response.body).to include(*municipes.map(&:name))
    end

    context 'when query is present' do
      let(:request) do
        get municipes_path, params: { query: municipes.first.name }, as: :json
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns filtered municipies', :aggregate_failures do
        expect(response.body).to include(municipes.first.name)
        expect(response.body).not_to include(*municipes.second.name)
      end
    end
  end

  describe 'Show /municipies/:id' do
    let!(:municipe) { create(:municipe) }
    let(:request) { get municipe_path(municipe), as: :json }

    before { request }

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns municipe' do
      expect(json['municipe']['name']).to eq(municipe.name)
      expect(json['municipe']['cpf']).to eq(municipe.cpf)
      expect(json['municipe']['cns']).to eq(municipe.cns)
    end

    it 'with the link for details' do
      expect(json['municipe']['links']['self']).to eq(municipe_path(municipe))
    end

    it 'with the link for photo file' do
      expect(
        json['municipe']['photo']
      ).to eq(Base64.strict_encode64(municipe.photo.download))
    end
  end

  describe 'POST /municipies' do
    let(:address_params) { attributes_for(:address) }
    let(:photo_params) do
      { data: Base64.strict_encode64(
        Rails.root.join('spec/support/images/selfie.png').read
      ) }
    end
    let(:municipe_params) do
      attributes_for(:municipe, name: 'Anakim Vader',
        photo: nil).merge(address_attributes: address_params)
    end
    let(:request) do
      post municipes_path, params: { municipe: municipe_params, photo: photo_params },
        headers: { accept: 'application/json' }
    end

    context 'when municipe is valid' do
      it 'creates municipe' do
        expect { request }.to change(described_class, :count).by(1)
        expect(response).to have_http_status(:created)

        municipe_recorded = described_class.find_by(name: 'Anakim Vader')
        expect(json['municipe']['name']).to eq(municipe_params[:name])
        expect(json['municipe']['cpf']).to eq(municipe_params[:cpf])
        expect(json['municipe']['cns']).to eq(municipe_params[:cns])
        expect(json['municipe']['phone']).to eq(municipe_params[:phone])
        expect(json['municipe']['email']).to eq(municipe_params[:email])
        expect(json['municipe']['status'].to_sym).to eq(municipe_params[:status].to_sym)
        expect(json['municipe']['photo']).not_to be_nil
        expect(municipe_recorded.photo).to be_attached
      end
    end

    context 'when municipe is invalid' do
      let(:municipe_params) { attributes_for(:municipe, name: nil) }

      before do
        request
      end

      it 'returns http unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT /municipies/:id' do
    let!(:municipe) { create(:municipe, name: 'Evandro') }
    let(:new_params) { attributes_for(:municipe) }
    let(:request) do
      put municipe_path(municipe), params: { municipe: new_params },
        headers: { accept: 'application/json' }
    end

    context 'when municipe is valid' do
      it 'updates municipe' do
        expect(municipe.name).to eq('Evandro')
        request

        expect(municipe.reload.name).not_to eq('Evandro')
        expect(response).to have_http_status(:ok)
        expect(municipe.name).to eq(new_params[:name])
      end
    end

    context 'when municipe is invalid' do
      let(:new_params) { attributes_for(:municipe, name: nil) }

      before do
        request
      end

      it 'returns http unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
