class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include UsersHelper
  
  before_action :set_search

  def set_search
    @search = Product.ransack(params[:q])
    @search_products = @search.result.order("id desc")
  end
end
