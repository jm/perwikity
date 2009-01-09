require 'ostruct'
Wiki = OpenStruct.new

Wiki.name = "Perwikity"
Wiki.description = "An elegant wiki system for anyone who respects their grandmother"
Wiki.license_line = "&copy; 2009 Your Own Organization : This stuff might also be Creative Commons"

Wiki.allow_anonymous_create = false
Wiki.allow_anonymous_edit = false
Wiki.allow_anonymous_revert = false
Wiki.allow_anonymous_view = true

Wiki.syntax_highlight = true

Wiki.anonymous_gravatar_id = Digest::MD5.hexdigest("anonymous (at) " + Wiki.name)

require 'RedCloth'
Formatter = RedCloth

# Change to Markdown if you want
#
#   require 'BlueCloth'
#   Formatter = BlueCloth

# Got a formatter that's not necessarily API-compliant?  Use
# the example class below to wrap it into something that is.
#
#   class MyFormatter
#     def initialize(string)
#       @html = MyThing.format(string)
#     end
# 
#     def to_html
#       @html
#     end
#   end
# 
#   Formatter = MyFormatter