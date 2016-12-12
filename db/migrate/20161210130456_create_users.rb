class CreateUsers < ActiveRecord::Migration[5.0]
  def up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.boolean :admin, default: false
      t.string :password_digest
      t.string :remember_digest

      t.timestamps
    end

    add_index :users, :email, unique: true
  end

  def down
    remove_index :users, :email
    drop_table :users
  end
end
