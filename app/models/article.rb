# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  title      :string
#  content    :text
#  image      :string
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Article < ApplicationRecord
  # Relations
  belongs_to :user
  has_many :comments, dependent: :destroy

  # Validations
  validates :title, presence: true
end
