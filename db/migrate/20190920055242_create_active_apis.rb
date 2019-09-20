class CreateActiveApis < ActiveRecord::Migration[5.2]
  def change
    create_table :active_apis do |t|
      t.string :name
      t.string :api_url
      t.string :api_key
      t.boolean :active
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
