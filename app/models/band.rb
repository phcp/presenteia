class Band < ActiveRecord::Base
  has_many :bands
  has_many :cds, dependent: :destroy
end
