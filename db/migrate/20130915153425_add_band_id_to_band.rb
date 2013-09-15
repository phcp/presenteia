class AddBandIdToBand < ActiveRecord::Migration
  def self.up
    add_column :bands, :band_id, :integer
  end

  def self.down
    remove_column :bands, :band_id
  end
end
