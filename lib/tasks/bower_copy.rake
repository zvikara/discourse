# bower-rails is a javascript package manager.
# It uses a Bowerfile, similar to how bundler uses a Gemfile.
# Bower-rails is based on bower which is based on node.js.
# Since we don't require users to have node.js and bower installed,
# we need to check in the donloaded javascript packages.
# But because bower downloads entire repositories, we uses this task
# to copy just the required javascript files
# from vendor/assets/bower_components to vendor/assets/javascripts
# This also keeps the same file names an location for backward compatibility.

#require 'bower-rails'
namespace :bower do
  desc "Copy assets from vendor/assets/bower_components to vendor/assets/javascripts and vendor/assets/stylesheets"
  task :copy => :environment do
    source_dir = Rails.root.join("vendor", "assets", "bower_components")
    scripts_dir = Rails.root.join("vendor", "assets", "javascripts")
    styles_dir = Rails.root.join("vendor", "assets", "stylesheets")

    files = HashWithIndifferentAccess.new(YAML.load_file(Rails.root.join('vendor', 'assets', 'bower.yaml')))
    files.each do |source, target|
      target = target || File.basename(source)
      #puts "#{source} => #{target}\n"
      case File.extname(target)
      when ".js", ".coffee"
        puts "script: #{target}"
        target = File.join(scripts_dir, target)
      when ".css", ".scss"
        puts "style : #{target}"
        target = File.join(styles_dir, target)
      else
        puts "ignore: #{target}"
        target = nil
      end
      if target
        source = File.join(source_dir, source)
        #puts "- #{source} => #{target}\n"
        #FileUtils.cp_r source, target
      end
    end
  end
end
