require 'fileutils'

class FolderGenerator

  def self.generate
    references = Reference.all
    references.each do |reference|
      FileUtils::mkdir_p("tmp/#{reference.assessment_id}/references/files/#{reference.id}/original/")
    end
  end
end
