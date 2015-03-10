class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :heading
      t.text :body
      t.decimal :price
      t.string :neighborhood
      t.string :external_url
      t.string :timestamp
      t.integer :sqft
      t.integer :bedrooms
      t.integer :bathrooms
      t.string :parking

      t.timestamps null: false
    end
  end
end
