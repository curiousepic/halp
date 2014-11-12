class Problem < ActiveRecord::Base
  belongs_to :user
  has_many :notes
  has_attached_file :image
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/


  validates :user, presence: true
  validates :description, presence: true
  validates :tried, presence: true
end
