class CreateAtms < ActiveRecord::Migration[5.1]
  def change
    create_table :atms do |t|
      t.json :dispenser

      t.timestamps
    end
  end
end
