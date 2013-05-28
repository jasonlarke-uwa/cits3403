class Search
	include ActiveModel::Validations

	attr_accessor :q

	validates_presence_of :q, :message => "Cannot submit an empty query"
	validates_length_of :q, :maximum => 100

	def initialize(attributes={})
		@attributes = attributes
		@q = @attributes[:q]
	end

	def read_attribute_for_validation(key)
		@attributes[key]
	end

	def run 
		terms = @q.split.map { |s| "%#{s}%" }
		conditions = terms.each_with_index.map { |s,i| "(users.first_name LIKE :param#{i} OR users.last_name LIKE :param#{i} OR users.email LIKE :param#{i})" }
		conditions = conditions.join(' OR ')

		parameters = {}
		terms.each_with_index do |s,i|
			parameters[:"param#{i}"] = s
		end
		return User.where(conditions, parameters)
	end
end
