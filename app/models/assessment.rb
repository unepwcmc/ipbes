class Assessment < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :contacts, dependent: :destroy

  accepts_nested_attributes_for :answers, reject_if: lambda { |a| a[:text_value].blank? }, allow_destroy: true
  accepts_nested_attributes_for :contacts, reject_if: lambda { |a| a[:name].blank? }, allow_destroy: true

  validates :title, presence: true, uniqueness: true
end
