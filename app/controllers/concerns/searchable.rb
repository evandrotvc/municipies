module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mappings do
      indexes :name, type: 'text'
      indexes :cpf, type: 'text'
      indexes :cns, type: 'text'
      indexes :email, type: 'text'
      indexes :phone, type: 'text'
      indexes :status, type: 'text'
    end

    def self.search(query)
      params = {
        query: {
          multi_match: {
            query:,
            fields: %w[name cpf cns email phone status],
            fuzziness: 'AUTO'
          }
        }
      }

      __elasticsearch__.search(params).records.to_a
    end
  end
end
