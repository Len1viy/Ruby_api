class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
