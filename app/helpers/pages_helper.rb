module PagesHelper
  def revert_link_class(commit)
    (commit.message =~ /^rollback/) ? 'rollback' : 'edit'
  end
end
