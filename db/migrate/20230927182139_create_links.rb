class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links do |t|
      t.string :url
      t.string :title
      t.string :desceription
      t.string :image
      t.integer :view_counts

      t.timestamps
    end
  end
end
