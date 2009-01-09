class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.string :wiki_title
      t.text :body
      t.text :body_html
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
