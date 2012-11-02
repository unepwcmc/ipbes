class Contact < ActiveRecord::Base
  belongs_to :assessment
  validates_presence_of :name
end
