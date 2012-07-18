class Assessment < ActiveRecord::Base
  belongs_to :editor, class_name: 'User', foreign_key: 'editor_id'

  has_many :answers
  has_many :contacts
end
