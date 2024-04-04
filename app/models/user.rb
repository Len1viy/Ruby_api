class User < ApplicationRecord
  has_many :enrollments
  has_many :courses, through: :enrollments
  has_many :courses
end
