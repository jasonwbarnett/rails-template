def source_paths
  [File.join(File.expand_path(File.dirname(__FILE__)),'rails_root')] +
    Array(super)
end

gem('bootstrap-sass', '~> 3.3.1')
gem('autoprefixer-rails', '~> 4.0.2.1')
gem('simple_form', '~> 3.1.0')
gem('country_select', '~> 2.1.0')
gem('devise', '~> 3.4.1')

trying = true

inside(app_name) do
  run("bundle install")
  run("rails generate simple_form:install --bootstrap")
  run("rails generate devise:install")
  run("rails g devise:views")
  run("rails generate devise User")
end unless trying

#generate(:scaffold, "person name:string")
#route "root to: 'people#index'"
#rake("db:create")
#rake("db:migrate")

insert_into_file("config/environments/development.rb", %Q|  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }\n|, after: "config/application.rb.\n")

inside("app") do
  inside("assets") do
    inside("stylesheets") do
      remove_file('application.css')
      create_file('application.css.scss') do
        %Q|body { padding-top: 50px; }\n\n@import "bootstrap-sprockets";\n@import "bootstrap";\n|
      end
    end

    inside("javascripts") do
      insert_into_file('application.js', "//= require bootstrap-sprockets\n", after: "jquery_ujs\n")
      copy_file 'ie10-viewport-bug-workaround.js'
    end
  end

  inside 'views' do
    inside 'layouts' do
      remove_file 'application.html.erb'
      template 'application.html.erb'
    end
  end
end

git :init
git add: "."
git commit: %Q{ -m 'initial commit.' }
