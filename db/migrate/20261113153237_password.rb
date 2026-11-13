class Password < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :password, :password_digest
    rename_column :users, :email, :username
  end
end
