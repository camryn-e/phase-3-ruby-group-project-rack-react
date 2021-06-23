class CreatePrideEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :pride_events do |t|
      t.string :title
      t.string :category
      t.string :description
      t.string :age_rating
      t.integer :city_id
    end
  end
end
