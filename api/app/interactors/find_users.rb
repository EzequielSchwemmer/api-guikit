class FindUsers
  include Interactor

  def call
    find_users
  end

  private

  def find_users
    user_ids = User.where(id: context.json.keys).pluck(:id).map(&:to_s)
    context.not_found_users = context.json.keys - user_ids
    context.json.slice!(*user_ids)
  end
end
