class ProductsController < ApplicationController
  
    before_action :authorize
 
  def lists
    @products = Product.all
    @products = @products.where("description like ? or name like ?", "%#{params[:word]}%", "%#{params[:word]}%") if params[:word].present?
    @products = @products.where(category_id: params[:category]) if params[:category].present?
    @products = @products.where(price: params[:price_low]..params[:price_high]) if params[:price_low].present? if params[:price_high].present?
    @products = @products.where("price >= ?", params[:price_low]) if params[:price_low].present? 
    @products = @products.where("price <= ?", params[:price_high]) if params[:price_high].present? 
    @products = @products.order(params[:change]) if params[:change].present?
    @products = @products.order("id desc")
  end
  
  def show
    @products = Product.where(user_id: current_user.id)
    @products = @products.order("id desc")
  end
  
  def new
    @product= Product.new
  end
  
  def create
    @product = Product.new(product_params)
    @product.status = 0
    
    if params[:product][:image1]
      upload_file1 = params[:product][:image1]
      upload_file_name1 = upload_file1.original_filename
      output_dir = Rails.root.join('public', 'images')
      output_path = output_dir + upload_file_name1

      File.open(output_path, 'w+b') do |f|
       f.write(upload_file1.read)
      end
      @product.image1 = upload_file_name1
    end

    #画像２枚目
    if params[:product][:image2]
      upload_file2 = params[:product][:image2]
      upload_file_name2 = upload_file2.original_filename
      output_dir = Rails.root.join('public', 'images')
      output_path = output_dir + upload_file_name2

      File.open(output_path, 'w+b') do |f|
       f.write(upload_file2.read)
      end
      @product.image2 = upload_file_name2
    end

    #画像３枚目
    if params[:product][:image3]
      upload_file3 = params[:product][:image3]
      upload_file_name3 = upload_file3.original_filename
      output_dir = Rails.root.join('public', 'images')
      output_path = output_dir + upload_file_name3

      File.open(output_path, 'w+b') do |f|
       f.write(upload_file3.read)
      end
      @product.image3 = upload_file_name3
    end
      
     if @product.save
      flash[:success] = "出品しました。"
      redirect_to ("/") and return
     else
      flash[:danger] = "出品に失敗しました。"
      redirect_to ("/users/products/new") and return
     end
  end
  
  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    flash[:success] = "削除しました。"
    redirect_to("/")
  end

  
  def likes
    @product = Product.find(params[:id])
    if UserLike.exists?(product_id: @product.id, user_id: current_user.id)
          # いいねを削除
      UserLike.find_by(product_id: @product.id, user_id: current_user.id).destroy
    else
          # いいねを登録
      UserLike.create(product_id: @product.id, user_id: current_user.id)
    end
    redirect_to("/")
  end
  
  def markets
    @product = Product.find(params[:id])
    @category = Category.where(product_id: @product.id)
    @products = Product.all
  end
  
  def payment
    @product = Product.find(params[:id])
  end
  
  def sold
    @product = Product.find(params[:id])
    @product.update(status: 1)
    @product.save
      flash[:success] = "購入しました。"
    redirect_to ("/") and return
  end
  
  def details
    @product = Product.find(params[:id])
    @category = Category.where(product_id: @product.id)
  end
  
  def product_edit
    @product = Product.find(params[:id])
    @category = Category.find(params[:id])
  end
  
  def product_update
    @product = Product.find(params[:id])
    @category = Category.find(params[:id])
    
    @product.name = params[:name]
    @product.description = params[:description]
    @product.price = params[:price]
    @category.id = params[:id]
    @product.update(product_params)
    
    if params[:product][:image1]
      upload_file1 = params[:product][:image1]
      upload_file_name1 = upload_file1.original_filename
      output_dir = Rails.root.join('public', 'images')
      output_path = output_dir + upload_file_name1

      File.open(output_path, 'w+b') do |f|
       f.write(upload_file1.read)
      end
      @product.update(product_params.merge({image1: upload_file1.original_filename}))
    end

    if params[:product][:image2]
      upload_file2 = params[:product][:image2]
      upload_file_name2 = upload_file2.original_filename
      output_dir = Rails.root.join('public', 'images')
      output_path = output_dir + upload_file_name2

      File.open(output_path, 'w+b') do |f|
       f.write(upload_file2.read)
      end
      @product.update(product_params.merge({image2: upload_file2.original_filename}))
    end

    if params[:product][:image3]
      upload_file3 = params[:product][:image3]
      upload_file_name3 = upload_file3.original_filename
      output_dir = Rails.root.join('public', 'images')
      output_path = output_dir + upload_file_name3

      File.open(output_path, 'w+b') do |f|
       f.write(upload_file3.read)
      end
      @product.update(product_params.merge({image3: upload_file3.original_filename}))
    end
    redirect_to ("/users/products/#{@product.id}") and return
  end
  
  private
    def product_params
      params.require(:product).permit(:description, :name, :price, :image1, :image2, :image3, :status, :id)
                              .merge(user_id: current_user.id, category: Category.find(params[:product][:category]))
    end
end