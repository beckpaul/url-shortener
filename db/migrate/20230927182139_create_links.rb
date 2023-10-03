class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links do |t|
      t.string :url
      t.string :title
      t.string :description
      t.string :image
      t.json :favicon_hex, default: ["#000000", "#000000", "#000000"]
      t.integer :views_count, default: 0

      t.timestamps
    end
  end
end

