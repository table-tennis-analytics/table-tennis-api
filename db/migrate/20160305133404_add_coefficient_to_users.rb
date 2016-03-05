class AddCoefficientToUsers < ActiveRecord::Migration
  def change
    add_column :users, :coefficient, :float, default: 0.0, null: false
    add_index :users, :coefficient
  end
end
