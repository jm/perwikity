module ActsLikeGit
  class ModelInit
    # The Builder class is the core for the versioning definition block processing.
    # There are three methods you really need to pay attention to:
    #
    # - repository
    # - field
    # - commit
    #
    # The repository is an optional declaration that defines where the git 
    # repository will be saved.  You only need declare this once, you could
    # have a different repository per model if you wanted.  But why would you?
    #
    # The field method defines which field will be stored in the repository.
    # 
    # Commit takes a hash of options:
    #   message : a proc which returns a string (run in the instance scope)
    #     e.g. :message => lambda { "Committed by #{current_user.login}" }
    # 
    class Builder
      class << self      
        attr_accessor :repository, :versioned_fields, :commit_message
        
        # Set up all the collections. Consider this the equivalent of an
        # instance's initialize method.
        # 
        def setup(model_name)
          root = defined?( RAILS_ROOT ) ? RAILS_ROOT : "/.data"
          @repository       = File.join( root, "git_store" )
          @versioned_fields = []
        end

        # You can set a custom commit message.  Pass a string or a lambda.
        # 
        #  version.message = lambda { |u| "Committed by #{u.login}" }
        def message=(message)
          @commit_message = message
        end
                
        # acts_like_git needs a repository to save the versions 
        # in, without it, life just can't go on.  Pass in a 
        # file_path, or leave this to the default: 'RAILS_ROOT/git_store/#{plural_model_name}'
        #
        # Example
        #
        # version.repository = '/my/file/path'
        # 
        # 
        def repository=(file_path)
          # TODO - More file checks
          @repository = file_path
        end
        alias_method :set_location, :repository=
        alias_method :location,     :repository=
      end
    end
  end
end
