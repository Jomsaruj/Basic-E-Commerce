class AdminController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :authenticate_admin!
  
  def index
    @search = params[:search]

    @products = Product.all
    @products = @products
      .where("title LIKE ? or description LIKE ?", "%#{@search}%", "%#{@search}%") if @search.present?
    @products = @products.page(params[:page]).per(12)

    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(Product.all), file_name: 'products.csv' }
    end
  end

  private

  def generate_csv(products)
    products.map { |a| [a.title, a.description, a.created_at.to_date].join(',') }.join("\n")
  end
end
