class Page < ActiveRecord::Base
  validates_presence_of :title
  before_save :render_attributes
  
  versioning(:title, :wiki_title, :user_id, :body, :body_html) do |version|
    if Rails.env.test?
      version.repository = "#{Rails.root}/db/git_test"
    elsif Rails.env.development?
      version.repository = "#{Rails.root}/db/git_development"
    else
      version.repository = "#{Rails.root}/db/git"
    end
    
    version.message = :commit_message
  end
  
  belongs_to :user
  
  # Render down our formatted text + render the wiki title
  def render_attributes
    self.wiki_title = self.title.to_wiki_title
    self.body_html = Formatter.new(self.body).to_html
  end
  
  # We'll use the commit message a meta-data
  def commit_message
    user_name = user ? user.login : "anonymous"
    
    if revisions.empty?
      "initial #{user_name}"
    elsif @rollback
      "rollback #{self.log.first} #{user_name}"
    else
      "edit #{self.log.first} #{user_name}"
    end
  end
  
  # Hey it's like permalink-fu except smaller and
  # not conflicting with alg
  def to_param
    wiki_title(false)
  end
end