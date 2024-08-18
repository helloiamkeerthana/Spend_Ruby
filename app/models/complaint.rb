class Complaint < ApplicationRecord
  validates :content, presence: true

  before_save :categorize_complaint

  private

  def categorize_complaint
    response = OpenAIService.categorize_complaint(content)
    self.category = response[:category]
    self.sub_category = response[:sub_category]
  end
end
