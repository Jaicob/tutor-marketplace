module ApplicationHelper

  def on_dashboard?

    @dashboard_links = {
      'Dashboard' => '/dashboard',
      'Schedule' => '/schedule',
      'Courses' => '/courses',
      'Profile' => '/profile',
      'Settings' => '/settings' 
    }

    @dashboard_links.each do |title, url|
      if request.original_url.include?(url)
        @current = title.downcase 
      else
        @current = nil
      end
    end
  end

end