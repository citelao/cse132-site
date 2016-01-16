##
# Parse permalinks and superimpose YAML data when called for.
# Unimplemented, but will be *amazing* for creating pretty URLs.
#
# Inspired by 
# http://stackoverflow.com/questions/16235601/what-are-the-steps-to-getting-this-custom-permalink-scheme-in-jekyll
module Jekyll
    class PermalinkRewriter < Generator
        safe true
        priority :low

        def generate(site)
        	collections_docs = site.collections.values.map { |e| e.docs }.flatten
        	items = (site.posts.docs + collections_docs)
            items.each do |item|
                parser(item)
            end
        end

        def parser(item)
        	# p item.data
        	# return unless item.data["permalink"]

        	# p item.data["permalink"]
            # TODO
        end
    end
end