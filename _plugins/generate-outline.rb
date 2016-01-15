module Outline
  class Generator < Jekyll::Generator
    def generate(site)
    	site.collections["weeks"].docs.map do |doc|
    		# p doc.content
    		# paths = doc.cleaned_relative_path.split(File::SEPARATOR)[1...-1]
    		# doc.data["paths"] = paths
    		# doc.data["week"] = paths[0]

    		# TODO?
    	end
    end
  end
end