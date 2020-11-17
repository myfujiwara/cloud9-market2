module UsersHelper
  
  def user_sign_in(user)
    session[:user_id] = user.id
  end
    
  def current_user
    if @current_user.nil?
       @current_user = User.find_by(id: session[:user_id])
    else
       @current_user
    end
  end
  
  def user_signed_in?
   current_user.present?
  end
 
  def user_sign_out
   session.delete(:user_id)
   @current_user = nil
  end
 
  def authorize
   redirect_to sign_in_path unless user_signed_in?
  end

  def redirect_to_top_if_signed_in
   redirect_to top_path and return if user_signed_in?
  end
  
  def image_url(user)
   if user.image.blank?
    "https://dummyimage.com/200x200/000/fff"
   else
    "/users/#{@user.image}"
   end
  end
end