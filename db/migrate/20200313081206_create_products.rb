class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.integer :price
      t.string :image1
      t.string :image2
      t.string :image3
      t.integer :status
      
      t.timestamps
    end
  end
end
