class Assessment < ActiveRecord::Base
  belongs_to :editor, class_name: 'User', foreign_key: 'editor_id'

  has_many :answers, dependent: :destroy
  has_many :contacts

  accepts_nested_attributes_for :answers

  validates :title, presence: true, uniqueness: true
end
