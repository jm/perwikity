module ActsLikeGit
  module Version  #:nodoc:
    MAJOR   = 0
    MINOR   = 0
    TINY    = 1
    STRING  = [MAJOR, MINOR, TINY].join('.')
  end
  
  # A ConnectionError will get thrown when a connection to git can't be made.
  class ConnectionError < StandardError
  end
  
  class << self
    # The collection of versioned models. Keep in mind that Rails lazily loads
    # its classes, so this may not actually be populated with _all_ the models
    # that have versioned fields.
    # 
    # Note::  By default, models are not tracked. To enable the tracking, set this
    #         to an array. Set it back to +nil+ to disable it again. For example:
    #         
    #           ActsLikeGit.all_versioned_models = []
    #
    attr_accessor :all_versioned_models
    
    # Check if versioning is disabled.
    # 
    def versioning_enabled?
      @@versioning_enabled =  true unless defined?(@@versioning_enabled)
      @@versioning_enabled == true
    end
    
    # Enable/disable versioning - you may want to do this while migrating data.
    # 
    #   ActsLikeGit.versioning_enabled = false
    # 
    def versioning_enabled=(value)
      @@versioning_enabled = value
    end
  end
  
  autoload :ActiveRecordExt,  'acts_like_git/active_record_ext'
  autoload :ModelInit,        'acts_like_git/model_init'
end

ActiveRecord::Base.extend ActsLikeGit::ActiveRecordExt::Base
