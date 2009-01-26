# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def wiki_link(text)
    text.gsub(/\[\[([^\]\n\|]+)(\|([^\]\n\|]+))?\]\]/) do |s|
      title = $1.to_wiki_title
      link_to($3 || $1, page_path(title.to_wiki_title), :class => (Page.find_by_wiki_title(title) ? 'wiki-page' : 'missing-page'))
    end
  end
  
  def side_block(title = nil, &block)
    @content_for_side ||= ""
    
    html = capture(&block)
    title = "<h1>#{title}</h1>" if title
    
    @content_for_side += "<div class=\"side-block\">
      #{title}
      #{html}
     </div>
    "
  end
  
  def history_list_for(page, limit = true)
    revisions = (limit ? page.revisions[0..5] : page.revisions)
    "<ul>" + revisions.map do |r|
              "<li>#{revision_text(r, page)}</li>"
             end.join("\n") + "</ul>"
  end
  
  def revision_text(r, page)
    text = "<span class='date'>#{r.date.strftime('%D %T')}</span><br /><strong>" + r.id.slice(0,7) + "</strong> &ndash; "
    
    if r.message =~ /edit/
      text += "edited by #{r.message.split(' ').last}"
    elsif r.message =~ /rollback/
      text += "reverted by #{r.message.split(' ').last}"
    else
      text += "created"
    end
        
    text += " &ndash; #{link_to 'revert to this', revert_page_path(page, :revision => r.id), :method => :post}" unless r.id == page.revisions.first.id
    text
  end
end
