module PagesHelper
  def revert_link_class(commit)
    (commit.message =~ /^rollback/) ? 'rollback' : 'edit'
  end

  def formatter_help
    render :partial => "shared/formatter_help/#{Formatter.ancestors.first.name.underscore}"
  end
end
