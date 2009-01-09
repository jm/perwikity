require 'fileutils'

namespace :app do
  task :setup => :environment do
    puts "** Setting up database"
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke

    puts "** Initializing Git repositories"
    ["", "_development", "_test"].each do |p|
      path = "#{Rails.root}/db/git#{p}"
      puts "init in #{path}"

      FileUtils.mkdir_p(path)
      `cd #{path}; git init; cd #{Rails.root}`
    end
    
    puts
    puts "** Creating home page"
    page = Page.create(:title => "Home", :body => "h1. Welcome to Perwikity!\n\nPlease enjoy.  *Edit this page!*")  
    
    require 'pp' 
    pp page 
    
    puts
    puts "** DONE."
  end
end