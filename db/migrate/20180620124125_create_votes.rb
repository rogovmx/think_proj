class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :vote
      t.integer :user_id, index: true
      t.references :voteable, polymorphic: true, index: true
      t.timestamps
    end
  end
end