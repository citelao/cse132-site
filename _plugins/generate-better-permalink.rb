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
        	items = (site.posts.docs + collections_docs + site.pages)
            items.each do |item|
                item.data["permalink"] = generate_permalink(item)
            end
        end

        def generate_permalink(item)
        	return unless item.data["permalink"]

            replacement_keys = item["permalink"].scan(/:\w+/).map { |s| s.slice(1..-1) }

            return item.data["permalink"] unless replacement_keys.length > 0

            keys, values = replacement_keys.map { |r|
                next if item.url_placeholders.keys.include? r.to_sym
                next if r == "permalink" # haha don't try that.

                [r.to_sym, item.data[r].to_s]
            }.transpose
            replacements = Hash[*keys.zip(values).flatten]

            template = (item.respond_to? :url_template) ? item.url_template : item.template

            URL.new({
                :template => template,
                :placeholders => replacements,
                :permalink => item.permalink
            }).to_s
        end
    end
end