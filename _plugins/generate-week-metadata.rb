module Week
  class Generator < Jekyll::Generator
  	priority :normal

    def generate(site)
    	site.collections["weeks"].docs.map do |doc|
    		paths = doc.cleaned_relative_path.split(File::SEPARATOR)[1...-1]
    		doc.data["paths"] = paths
    		doc.data["week"] = paths[0] unless doc.data["week"] && doc.data["week"] != "na"
    	end
    end
  end
end