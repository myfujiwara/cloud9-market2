class UsersController < ApplicationController
  before_action :authorize, except: [:sign_up, :sign_up_process, :sign_in, :sign_in_process]
  before_action :redirect_to_top_if_signed_in, only: [:sign_up, :sign_in]
  
  
  def profiles
   @user = User.find(current_user.id)
   @products = Product.where(user_id: @user.id)
  end
  
  def sign_up
   @user = User.new
   render layout: "application_not_login"
  end
  
  def sign_up_process
   user = User.new(user_params) 
   if user.save
    user_sign_in(user)
    flash[:success] = "ユーザー登録に成功しました。"
    redirect_to("/users/sign_in")
   else
    flash[:danger] = "ユーザー登録に失敗しました。"
    redirect_to("/users/sign_up")
   end
  end
  
  def sign_in
   @user = User.new
   render layout: "application_not_login"
  end
  
  def sign_in_process
    # user = User.find_by(email: user_params[:email], password: user_params[:password])
    password_md5 = User.generate_password(user_params[:password])
    user = User.find_by(email: user_params[:email], password: password_md5)
    
   if user
    user_sign_in(user)
    redirect_to ("/users/profiles") and return
   else
    flash[:danger] = "サインインに失敗しました。"
    redirect_to("/users/sign_in")
   end
  end
  
  def sign_out
   user_sign_out
   redirect_to sign_in_path and return
  end
    
  def likes
   @user = User.find(current_user.id)
   @userlikes = UserLike.where(user_id: @user.id)
  end
  
  def edit
   @user = User.find(current_user.id)
  end
  
  def update
    @user = User.find(current_user.id)
    
    @user.name = params[:name]
    @user.comment = params[:comment]
    if params[:user][:password].blank?
      params[:user].delete("password")
    else
      @user.password = params[:password]
    end
    current_user.update(user_params)
    
    upload_file = params[:user][:image]
    if upload_file.present?
      upload_file_name = upload_file.original_filename
      output_dir = Rails.root.join('public', 'users')
      output_path = output_dir + upload_file_name
      
      File.open(output_path, 'w+b') do |f|
      f.write(upload_file.read)
      end
    current_user.update(user_params.merge({image: upload_file.original_filename}))
    end
      redirect_to("/") 
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :comment, :image)
  end
end