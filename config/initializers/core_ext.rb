class String
  # Renders a wiki-ish title from a string.  Capitalization
  # reduces the possibility of it conflicting with Rails actions.
  #
  # === Examples
  #
  #   "what how".to_wiki_title      # => WhatHow
  #   "du*DE_)".to_wiki_title       # => DuDE_
  #   "moo   moo".to_wiki_title     # => MooMoo
  #
  def to_wiki_title
    str = self.strip.downcase.gsub(/\s/, "_")
    
    # Borrowed from permalink-fu
    str.gsub!(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
    str.gsub!(/[^\w_ \_]+/i,   '') # Remove unwanted chars.
    str.gsub!(/[ \_]+/i,      '_') # No more than one of the separator in a row.
    str.gsub!(/^\_|\_$/i,      '') # Remove leading/trailing separator.
    
    str.gsub!(/_(.)/) do
      "_" + $1.upcase
    end
    
    str.gsub!(/(^.)/) do
      $1.upcase
    end
    
    str
  end
end