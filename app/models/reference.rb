class Reference < ActiveRecord::Base
  attr_accessible :file, :reference_type, :reference_text, :assessment_id
  has_attached_file :file,
    :url => "/system/assessment/:assessment_id/:class/:attachment/:id/:style/:basename.:extension"

  belongs_to :assessment
end
