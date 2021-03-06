class Admin::ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :authenticate_admin!

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to admin_path }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
        flash[:error] = @product.errors.full_messages
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to admin_path}
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
        flash[:error] = @product.errors.full_messages
      end
    end

  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to admin_path}
      format.json { head :no_content }
    end
  end

  def csv_upload
    data = params[:csv_file].read.split("\n")
    data.each do |line|
      attr = line.split(",").map(&:strip)
      Product.create title: attr[0], description: attr[1], stock: 0
    end
    redirect_to admin_path
  end

  def delete_primary_image
    @primary_image = ActiveStorage::Attachment.find(params[:id])
    @primary_image.purge_later
    redirect_back(fallback_location: request.referer)
  end

  def delete_supporting_image
    @supporting_image = ActiveStorage::Attachment.find(params[:id])
    @supporting_image.purge_later
    redirect_back(fallback_location: request.referer)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:title, :description, :status, :stock, :primary_image, :category_ids=>[], :supporting_images=>[])
    end
end
