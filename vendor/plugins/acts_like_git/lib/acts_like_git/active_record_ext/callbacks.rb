gem 'mojombo-grit', '~> 0.9'
require 'grit'
require 'fileutils'

module ActsLikeGit
  module ActiveRecordExt
    # This module contains all the methods to navigate your versions.
    # 
    module Callbacks
      def self.included(target)
        target.class_eval do
          # The define_callbacks method was added post Rails 2.0.2 - if it
          # doesn't exist, we define the callback manually
          #
          if respond_to?(:define_callbacks)
            define_callbacks :after_commit
          else
            class << self
              # Handle after_commit callbacks - call all the registered callbacks.
              #
              def after_commit(*callbacks, &block)
                callbacks << block if block_given?
                write_inheritable_array(:after_commit, callbacks)
              end
            end
          end
          
          alias_method_chain :save,     'after_commit_callback'
          alias_method_chain :save!,    'after_commit_callback'
          alias_method_chain :destroy,  'after_commit_callback'
        end
      end
      
      def after_commit
        # Deliberately blank.
      end
      
      # Normal boolean save wrapped in a handler for the after_commit
      # callback.
      # 
      def save_with_after_commit_callback(*args)
        value = save_without_after_commit_callback(*args)
        callback(:after_commit) if value
        return value
      end
      
      # Forceful save wrapped in a handler for the after_commit callback.
      #
      def save_with_after_commit_callback!(*args)
        value = save_without_after_commit_callback!(*args)
        callback(:after_commit) if value
        return value
      end
      
      # Normal destroy wrapped in a handler for the after_commit callback.
      #
      def destroy_with_after_commit_callback
        value = destroy_without_after_commit_callback
        callback(:after_commit) if value
        return value
      end
      
      def git
        init_git_directory
        @git ||= Grit::Repo.new(self.git_settings.repository)
      end
      
      def local_versioned_fields_values
        @local_versioned_fields_values||={}
      end
      
    private
      
      def init_git_directory
        unless File.exists?(self.git_settings.repository)
          FileUtils.mkdir_p(self.git_settings.repository) 
          Grit::Repo.init_bare(self.git_settings.repository)
        end
      end
    end
  end
end
