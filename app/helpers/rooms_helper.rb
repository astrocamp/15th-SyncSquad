module RoomsHelper
	def format_user_email(user)
    user.email.split("@").first.split("-").reverse.map(&:capitalize).join(" ")
  end
end
