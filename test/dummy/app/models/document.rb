class Document < ActiveRecord::Base
  validates :name, presence: true
end
