class UpdateIndexElasticSearchJob < ApplicationJob
  sidekiq_options queue: 'very_low', retry: false

  def perform
    Municipe.all.each do |municipe|
      municipe.__elasticsearch__.index_document
    end

    Municipe.__elasticsearch__.refresh_index!
  end
end
