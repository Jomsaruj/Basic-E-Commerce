class Product < ApplicationRecord
    enum status: { draft: 0, published: 1, archived: 2  }

    has_one_attached :primary_image
    has_many_attached :supporting_images
    
    validates :title, length: {minimum: 1}
    validates :description, length: {minimum: 3}
    validates :stock, numericality: {greater_than_or_equal_to: 0}

    has_many :categories_products
    has_many :categories, through: :categories_products

end