class CreateCeremonies < ActiveRecord::Migration[7.2]
  def change
    enable_extension "pgcrypto"

    create_table :ceremonies, id: :uuid do |t|
      t.string :name, limit: 255
      t.datetime :event_date
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
