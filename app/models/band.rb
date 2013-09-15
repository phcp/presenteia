class Band < ActiveRecord::Base
  has_many :bands, class_name: "Band", foreign_key: :band_id
  has_many :cds, dependent: :destroy

  validates :name, presence: :true, uniqueness: :true
end
