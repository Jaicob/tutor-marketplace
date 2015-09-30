json.student do
  json.user do
    json.full_name @student.user.full_name
  end

  json.card do
    json.card @student.card_brand + " **** " + @student.last_4_digits
    json.customer @student.customer_id
  end
end