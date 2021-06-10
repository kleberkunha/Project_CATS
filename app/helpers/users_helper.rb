module UsersHelper
  ADMIN_ID = '1'.freeze # Ruby Freeze method basically make object constant or immutable
  def admin?
    result = false
    if current_user != nil && ADMIN_ID == current_user.id.to_s
      result = true
    end
    result
  end
end