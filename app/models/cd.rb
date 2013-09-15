class Cd < ActiveRecord::Base
  belongs_to :band

  validates :title, presence: :true, uniqueness: :true
  validates :image, presence: true
  validates :link_amazon, presence: :true
end
