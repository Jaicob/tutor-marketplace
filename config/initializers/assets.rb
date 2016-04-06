# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w(
  Jcrop/css/Jcrop.gif
	dashboard/courses.js
	dashboard/schedule.js
	single_views/search.js
	single_views/indirect_search.js
	custom/admin_panel.css.scss
	custom/dashboard_nav.css.scss
	vendor/modernizr.js
	fullcalendar/dist/fullcalendar.min.css
	overrides/schedule.css
  hotjar.js
  checkout/available_times.js
)