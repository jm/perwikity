module ActsLikeGit
  class ModelInit
    attr_accessor :versioned_fields, :versioned_fields_values, :repository, :table_name, :commit_message
    
    # TODO: document this
    #
    def initialize(model, &block)
      @repository = ""
      @table_name = model.name.tableize
      
      initialize_from_builder( &block ) if block_given?
    end
    
    # TODO: document this
    #
    def initialize_from_builder(&block)
      builder = Class.new(Builder)
      builder.setup(@table_name)
      
      builder.instance_eval(&block)
      
      @versioned_fields_values = {}
      @versioned_fields = builder.versioned_fields
      @commit_message = builder.commit_message
      @repository = builder.repository
    end
    
    autoload :Builder, 'acts_like_git/model_init/builder'
  end
end
