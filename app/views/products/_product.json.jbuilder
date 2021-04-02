json.extract! product, :id, :title, :catagorie, :description, :stock, :created_at, :updated_at
json.url product_url(product, format: :json)
