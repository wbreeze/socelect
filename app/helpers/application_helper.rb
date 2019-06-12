module ApplicationHelper
  def set_page_title(title)
    content_for(:page_title) { title }
  end

  def site_name
    Rails.application.credentials.application_name || request.host
  end

  def home_button
    label = "#{site_name} home".capitalize
    button_to(label, root_path, :method => :get)
  end
end
