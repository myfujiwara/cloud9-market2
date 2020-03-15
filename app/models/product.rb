class Product < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :user_likes, dependent: :destroy
  
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true
  
  # 投稿が特定のユーザーにいいね！されているかどうかを判定
  def like_from?(user)
    self.user_likes.exists?(user_id: user.id)
  end
end