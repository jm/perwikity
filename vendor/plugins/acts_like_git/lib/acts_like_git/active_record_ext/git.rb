module ActsLikeGit
  module ActiveRecordExt
    # This module covers the specific git interaction.
    # 
    module Git
      # List all the fields that are dirty that we version
      def changed_versioned_fields
        @version
        return [] unless changed?
        self.git_settings.versioned_fields & self.changes.keys.collect {|f| f.intern }
      end
      
      # Add all the changes to this model to git
      def git_commit
        init_structure
        sha = add_all_changes_to_git
        
        if self.attributes.has_key?("version") 
          self.version = sha
          self.connection.update("UPDATE #{self.class.table_name} SET version='#{sha}' WHERE id='#{self.id}'")
        end
        
        return sha
      end

      def git_delete
        self.local_versioned_fields_values.each do |field, value|
          self.git.remove(field_path(field))
        end
        
        self.git.commit_index("Removing files for #{self.class}, id: #{self.id}")
      end
      
      def write_git_method(column, value)
        self.local_versioned_fields_values[column] = value.to_s
        write_attribute column, value # Not sure if this is necessary; so we get 'changed?' field
      end
      
      def read_git_method(column)
        if v = self.local_versioned_fields_values[column]
          return v
        end
        
        last_commit = self.git.log.first
        (last_commit.tree/model_folder/model_id/"#{column}.txt").data
      rescue Object => e
        ''
      end
      
      def model_folder
        self.class.to_s.tableize
      end
      
      def model_id
        self.id.to_s
      end
      
      # Return a list of commits strings for this model
      def log
        commits = self.git.log('master', "#{model_folder}/#{model_id}")
        commits.collect {|c| c.id }
      end
      
    private
      
      def init_structure
        @model_folder = self.class.to_s.tableize
        @model_id = self.id.to_s
        @model_user = Grit::Actor.new("ActsAsGit", 'aag@email.com')
      end
      
      def add_all_changes_to_git
        last_commit = self.git.log.first rescue nil
        last_tree = last_commit.tree.id rescue nil
        
        begin
          i = self.git.index
        #rescue Grit::InvalidGitRepositoryError
        #  raise "Can't find the repository at #{@repository}"
        
        end
        
        i.read_tree(last_tree) if last_tree
        
        self.local_versioned_fields_values.each do |field, value|
          i.add(field_path(field), value)
        end
        
        commit_all(i, last_commit, last_tree)
      end
      
      # returns new commit sha
      def commit_all(index, last_commit, last_tree)
        callback = self.git_settings.commit_message
        # $stderr.puts self.git_settings.inspect
        message = case callback
        when Symbol
          self.send(callback)
        when Proc
          callback.call(self)
        else
          "new version of #{self.class}, id: #{self.id.to_s}" 
        end
        lc = (last_commit ? [last_commit.id] : nil)
        index.commit(message, lc, @model_user)
      end
      
      def field_path(field)
        File.join(@model_folder, @model_id, "#{field}.txt")
      end
    end
  end
end
