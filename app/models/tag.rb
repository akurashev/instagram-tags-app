class Tag < ApplicationRecord
  enum status: {
         new: 0,
         processing: 1,
         finished: 2
       }, _prefix: true

  validates :tag, presence: true
end
