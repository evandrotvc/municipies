# frozen_string_literal: true

json.extract!(
  municipe, :id, :name, :email, :cpf, :cns, :phone, :birth_date, :status
)

json.photo Base64.strict_encode64(municipe.photo.download)

json.address do
  json.extract!(
    municipe.address, :id, :street, :city, :ibge_code,
    :zipcode, :complement, :neighborhood, :uf
  )
end

json.links do
  json.self municipe_path(municipe)
end
