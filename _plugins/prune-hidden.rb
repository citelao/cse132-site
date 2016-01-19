##
# For all collections, prune any files with `output: false` in the yaml.
module Prune
  class Generator < Jekyll::Generator
  	safe true
  	
    def generate(site)
        site.collections.each do |name, coll|
            coll.docs.select! do |doc|
                doc.data["output"] != false
            end
        end
    end
  end
end