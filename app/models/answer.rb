class Answer < ActiveRecord::Base
  belongs_to :assessment

  # Convert geo_countries text value from Array to Comma-separated values
  before_save do
    if self.text_value.kind_of?(Array)
      self.text_value = self.text_value.uniq.reject!{ |c| c.empty? }.join(',')
    end
  end
end
