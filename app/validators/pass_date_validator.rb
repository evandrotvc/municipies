# frozen_string_literal: true

class PassDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    if value > Date.current
      message = options[:message] || :pass_date
      record.errors.add(attribute, message)
    elsif value.year < 1900 || value.year > Date.current.year
      record.errors.add(attribute, :invalid_date)
    end
  end
end
