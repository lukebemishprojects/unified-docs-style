require 'digest'

$processed_static_files ||= {}

module UnifiedDocsTheme
    class FlexibleStaticFile < Jekyll::StaticFile
        def initialize(site, base, dir, name, prefix)
            @real_dir = dir

            super(site, base, File.join(prefix, dir), name)
        end

        def path
            File.join(*[@base, @real_dir, @name].compact)
        end
    end

    class JavadocGenerator < Jekyll::Generator
        def generate(site)
            theme_data = site.config['unified-docs-theme']
            javadoc_data = theme_data ? theme_data['javadoc'] : {}
            javadoc_data.each do |id, data|
                Dir.glob(File.join(data['path'], '**/*')) do |path|
                    if File.file?(path)
                        rel_path = Pathname.new(path).relative_path_from(data['path'])
                        static_file = FlexibleStaticFile.new(site, data['path'], File.dirname(rel_path), File.basename(rel_path), File.join('javadoc', id))
                        site.static_files << static_file
                    end
                end
            end
        end
    end
end

Jekyll::Hooks.register :site, :post_write do |site|
    theme_data = site.config['unified-docs-theme']
    javadoc_data = theme_data ? theme_data['javadoc'] : {}
    javadoc_data.each do |id, data|
        nav_paths = theme_data ? theme_data['nav_pages'] : nil
        nav_paths = nav_paths ? nav_paths : site.pages.map() do |page|
            page.path
        end + javadoc_data.map() do |id, data|
            id
        end
        if not nav_paths.include?(id)
            nav_paths << id
        end
        nav_titles = []
        nav_urls = []
        real_paths = []
        for path in nav_paths
            page = site.pages.find() do |page|
                page.path == path
            end
            keeplooking = true
            if page
                title = page.data['title']
                if title
                    nav_titles << title
                    nav_urls << page.url
                    real_paths << path
                    keeplooking = false
                end
            end
            if keeplooking
                javadoc = javadoc_data.find() do |id, data|
                    id == path
                end
                if javadoc
                    nav_titles << javadoc[1]['title']
                    nav_urls << Jekyll::URL.new(
                        :template => "/javadoc/" + javadoc[0]
                    ).to_s
                    real_paths << path
                end
            end
        end
        zipped = real_paths.zip(nav_urls.zip(nav_titles))
        idx = zipped.find_index { |p, data| p == id }
        beforeentries = zipped[0...(idx+1)].map() do |path, (url, title)|
            '<li><a href='+url.dump+'>'+CGI.escapeHTML(title)+"</a></li>"
        end
        afterentries = zipped[(idx+1)..-1].map() do |path, (url, title)|
            '<li><a href='+url.dump+'>'+CGI.escapeHTML(title)+"</a></li>"
        end
        dest = File.join(site.dest, 'javadoc', id)
        Dir.glob(File.join(dest, '**/*.html')) do |path|
            current_hash = Digest::SHA256.file(path).hexdigest
            next if $processed_static_files[path] == current_hash

            text = File.read(path)
            text = text.gsub(/"[^"]*resource-files\/stylesheet.css"/, '"' + Jekyll::URL.new(
                :template => "/assets/css/javadoc.css"
            ).to_s + '"')
            text = text.gsub(/(id="navbar-top-firstrow"[^>]*>)/, '\1'+beforeentries.join()+'<ul class="nav-list">')
            if text.match?(/id="navbar-top-firstrow"[^>]*>/)
                p_1, p_r = text.split('id="navbar-top-firstrow"', 2)
                p_2, p_3 = p_r.split('</ul>', 2)
                text = p_1 + 'id="navbar-top-firstrow"' + p_2 + '</ul>'+afterentries.join()+'</ul>' + p_3
            end
            File.write(path, text)
            new_hash = Digest::SHA256.file(path).hexdigest
            $processed_static_files[path] = new_hash
        end
    end
end