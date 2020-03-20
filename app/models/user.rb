class User < ApplicationRecord
  
  before_create :convert_password
  
  def convert_password
    self.password = User.generate_password(self.password)
  end
  
  def self.generate_password(password)
    salt = "h!hgamcRAdh38bajhvgai17ysvb"
    Digest::MD5.hexdigest(salt + password)
  end
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
  validates :name, presence: true
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX} ,uniqueness: true
  validates :password, confirmation: true, length:{minimum: 8} 
  
  has_many :products
  has_many :user_likes
  
  # 投稿が特定のユーザーにいいね！されているかどうかを判定
  def like_from?(user)
    self.user_likes.exists?(user_id: user.id)
  end
end