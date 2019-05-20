class CreateArticlesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :url, null: false
      t.date :created_at
      t.date :updated_at
      t.integer  :user_id
    end
  end
end
