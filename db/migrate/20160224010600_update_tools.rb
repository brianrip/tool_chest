class UpdateTools < ActiveRecord::Migration
  def change
    change_table :tools do |t|
      t.integer :user_id
    end
  end
end
