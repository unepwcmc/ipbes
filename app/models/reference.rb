class Reference < ActiveRecord::Base
  attr_accessible :file, :reference_type, :assessment_id
  has_attached_file :file

  belongs_to :assessment
end
