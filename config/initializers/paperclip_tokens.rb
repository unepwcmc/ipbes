Paperclip::Attachment.interpolations[:assessment_id] = proc do |attachment, style|
  attachment.instance.assessment_id
end
