module ActsLikeGit
  # Core additions to ActiveRecord models - Explore versioning for linking models
  # to a git repository.
  #
  module ActiveRecordExt
    autoload :Base,           'acts_like_git/active_record_ext/base'  
    autoload :Callbacks,      'acts_like_git/active_record_ext/callbacks'
    autoload :Git,            'acts_like_git/active_record_ext/git'
    autoload :VersionMethods, 'acts_like_git/active_record_ext/version_methods'
  end
end
