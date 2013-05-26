class Search
	include ActiveModel::Validations

	attr_accessor :q;

	validates_presence_of :q
	validates_length_of :q, :maximum => 100

	def initialize(attributes={})
		@attributes = attributes
		@q = @attributes[:q]
	end

	def read_attribute_for_validation(key)
		@attributes[key]
	end

	def run 
		sql = '1=1 AND '
		terms = @q.split.map { |s| "%#{s}%" }
		conditions = terms.each_with_index.map { |s,i| "(users.first_name LIKE :param#{i} OR users.last_name LIKE :param#{i} OR users.email LIKE :param#{i})" }
		conditions = conditions.join(' OR ')

		parameters = {}
		terms.each_with_index do |s,i|
			parameters["param#{i}"] = s
		end
		puts "DEBUG::: query(#{sql + conditions}) + params(#{parameters.inspect})"
		return User.where(sql + conditions, parameters)
	end
end
