class CreateCeremonies < ActiveRecord::Migration[7.2]
  def change
    create_table :ceremonies do |t|
      t.string :name
      t.datetime :event_date

      t.timestamps
    end
  end
end
