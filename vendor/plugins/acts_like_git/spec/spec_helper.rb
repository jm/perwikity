$:.unshift File.dirname(__FILE__) + '/../lib'
require 'rubygems'

require 'spec'
require 'mocha'
module Test; module Unit; def self.run?; true end; end; end
Spec::Runner.configure do |config|
  config.mock_with :mocha
end

require 'active_record'
ActiveRecord::Base.logger = Logger.new(STDOUT) if 'irb' == $0
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :dbfile => ':memory:')
ActiveRecord::Migration.verbose = false

ActiveRecord::Base.silence do
  ActiveRecord::Schema.define(:version => 1) do
    with_options :force => true do |m|
      m.create_table 'posts' do |t|
        t.string  :title
        t.text    :body
        t.string  :version
        t.timestamps
      end

      m.create_table 'reviews' do |t|
        t.text    :content
        t.integer :user_id
        t.timestamps
      end

      m.create_table 'users' do |t|
        t.string :name
      end
    end
  end
end

require 'acts_like_git'
require File.dirname(__FILE__) + '/fixtures/models'

if ENV['debug'] == 'true'
  Grit.debug = true
end
