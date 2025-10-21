module UsersHelper
  def profile_image(user, small)
    if user.profile_image.attached? && user.persisted? && user.errors[:profile_image].blank?
      image_tag url_for(user.profile_image), small: small
    else
      render partial: "users/default_avatar", locals: { user: user }
    end
  end
end
