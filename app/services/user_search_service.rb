module UserSearchService
  def self.find(query = '')
    User.where('metadata LIKE :query OR email LIKE :query OR full_name LIKE :query', query: "%#{query}%")
  end
end