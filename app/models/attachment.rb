class Attachment < ActiveRecord::Base
  attr_accessible :file, :attachment_type, :assessment_id
  has_attached_file :file

  belongs_to :assessment
end
