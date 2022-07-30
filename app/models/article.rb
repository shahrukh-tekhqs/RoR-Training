class Article < ApplicationRecord
	validates :title, presence: true, length: {minimum:6, maximim:100}
	validates :description, presence: true, length: {minimum:10, maximim:300}
end