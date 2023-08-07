class ChangeNotNullConstraintToTrueInCommentsUserId < ActiveRecord::Migration[7.0]
  def up
    change_column_null :comments, :user_id, true
  end

  def down
    change_column_null :comments, :user_id, false
  end
end
