class Tag < ApplicationRecord
  enum status: {
         new: 0,
         enqueued: 1,
         processing: 2,
         finished: 3
       }, _prefix: true

  validates :tag, presence: true
end
