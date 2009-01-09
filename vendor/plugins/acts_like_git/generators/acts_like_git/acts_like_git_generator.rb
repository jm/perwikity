class ActsLikeGitGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.migration_template 'migration:migration.rb', "db/migrate", {
        :assigns => version_attributes, 
        :migration_file_name => "add_version_field_to_#{custom_file_name}" 
      }
    end
  end

private  

  def custom_file_name
    custom_name = class_name.underscore.downcase
    custom_name = custom_name.pluralize if ActiveRecord::Base.pluralize_table_names
  end

  def version_attributes
    returning(assigns = {}) do
      assigns[:migration_action] = "add" 
      assigns[:class_name] = "add_version_field_to_#{custom_file_name}" 
      assigns[:table_name] = custom_file_name
      assigns[:attributes] = [Rails::Generator::GeneratedAttribute.new("version", "string")]
    end
  end
end
