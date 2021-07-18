class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, primary_key: %i[id version] do |t|
      t.bigserial :id, null: false
      t.integer :version, null: false, default: 0
      t.string :name

      t.timestamps
    end
  end
end
