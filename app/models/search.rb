class Search
	include ActiveModel::Validations

	attr_accessor :q;

	def initialize(query)
		@q = query
	end

	def valid?
		if @q.blank?
			@errors.add('q', 'Query is a required field. Please specify it.')
			return false			
		elsif @q.length > 100
			@errors.add('q', 'Query cannot exceed 100 characters.')
			return false
		end

		return true
	end

	def run 
		sql = '1=1 AND '
		terms = @q.split.map { |s| "%#{s}%" }
		conditions = terms.map { |s| "(users.first_name LIKE ? OR users.last_name LIKE ? OR users.email LIKE ?)" }
		conditions = conditions.join(' OR ')

		n = terms.count
		n.times do 
			terms += terms
		end

		return User.where(sql, *terms)
	end
end
