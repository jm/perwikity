module ActsLikeGit
  module ActiveRecordExt
    # This module covers the methods that allow rollback and other bits and pieces
    # 
    module VersionMethods
      def showing_latest_revision?
        self.version.blank? ? true : false
      end
      
      # Return the count of commits in git
      def versions
        self.git.commits
      end
      
      def revisions
        self.git.log('master', "#{model_folder}/#{model_id}")
      end
      
      # Revert the database version to the git commit version
      def revert_to(version_hash, perform_save = true)
        git_contents(version_hash).each do |blob|
          field = deblobify(blob)
          send("#{field.to_sym}=", blob.data)
        end
        
        @rollback = true
        save if perform_save # hm, not sure if I want to do this
      end

      # Get the data associated with this field for one commit.
      def get_version(field, version_hash)
        git_contents(version_hash).each do |blob|
          return blob.data if deblobify(blob) == field.to_s  
        end
      end
      
      # Find the complete (textual) history for a field
      def history(field)
        return [] if self.frozen? 

        commits = self.git.log('master', "#{model_folder}/#{model_id}/#{field}.txt")
        commits.collect {|c| (c.tree/model_folder/model_id/"#{field}.txt").data }
      end
      
      # Convenience method to give you an array of hashes
      # { :id => 'aee1be..', :data => 'monkey' }
      def history_hash(field)
        return {} if self.frozen? 

        commits = self.git.log('master', "#{model_folder}/#{model_id}/#{field}.txt")
        commits.inject([]) { |memo,iter|
          # You can get all sorts of information, like 'blame'
          commit = (iter.tree/model_folder/model_id/"#{field}.txt")
          memo << { :id => iter.id, :data => commit.data } #, :date => commit.committed_date }??
          memo
        }
      end

      protected
        # Removing .txt in one place from the blob. Should have a blobify too.
        def deblobify(blob)
          blob.name.gsub(".txt", "")
        end

        # Traversing through the commit subdirs... posts/6/title
        def git_contents(version_hash)
          self.git.commit(version_hash).tree.contents.first.contents.each do |tree|
            return tree.contents if tree.name == self.id.to_s
          end
        end
    end
  end
end
