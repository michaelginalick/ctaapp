class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :phone
      t.string :password_digest

      t.timestamps
    end
    add_index(:users, :id)
  end



end
