class Band < ActiveRecord::Base
  has_many :bands, class_name: "Band", foreign_key: :band_id
  has_many :cds, dependent: :destroy

  validates :name, presence: :true, uniqueness: :true

  def self.get_recommendation(artists)
    bands = Band.where(name: artists.map{ |a| a["name"]})
    similars = bands.try { |b| b.map { |band| band.bands }.flatten! }
    similars.try { |s| s.map { |similar| similar.cds }.flatten! }
  end
end
