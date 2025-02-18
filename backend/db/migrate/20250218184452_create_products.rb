class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products, id: :uuid do |t|
      t.string :title, null: false
      t.decimal :price, precision: 6, scale: 2, null: false, default: 0
      t.string :currency, null: false, default: "PLN"
      t.references :ceremony, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
