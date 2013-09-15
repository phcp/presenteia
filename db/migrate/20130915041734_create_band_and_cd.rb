class CreateBandAndCd < ActiveRecord::Migration
  def up
    create_table :bands do |t|
      t.string :name
      t.timestamps
    end

    create_table :cds do |t|
      t.belongs_to :band
      t.string :title
      t.string :image
      t.string :link_amazon
      t.timestamps
    end
  end

  def down
    drop_table :band
  end
end
