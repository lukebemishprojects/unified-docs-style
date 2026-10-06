require 'digest'

$processed_static_files ||= {}

module UnifiedDocsTheme
    class DetailsBlock < Liquid::Block
        def initialize(tag_name, text, tokens)
            super
            @summary = text.strip()
        end

        def render(context)
            site = context.registers[:site]
            markdown= site.find_converter_instance(::Jekyll::Converters::Markdown)
            text = super
            "<details>" \
                "<summary>#{@summary}</summary>" \
                "#{markdown.convert(text.gsub(/^#{$/}/, "").gsub(/#{$/}$/, ""))}" \
            "</details>"
        end
    end

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

    def self.processNavEntries(site, nav_pages, this_jdoc, jdoc_contents)
        theme_data = site.config['unified-docs-theme']
        javadoc_data = theme_data ? theme_data['javadoc'] : {}

        all_pages = site.pages.dup
        for collection in site.collections
            all_pages.concat(collection[1].docs)
        end

        entries = []
        for navpage in nav_pages
            entry_url = navpage["permalink"]
            entry_title = navpage["title"]
            is_this_jdoc = false
            if navpage["page"]
                page = all_pages.find() do |page|
                    page.relative_path == navpage["page"]
                end
                if page
                    title = page.data['title']
                    entry_url = page.url
                    if title
                        entry_title = title
                    end
                end
            elsif navpage["javadoc"]
                javadoc = javadoc_data.find() do |id, data|
                    id == navpage["javadoc"]
                end
                if javadoc
                    entry_title = javadoc[1]['title']
                    entry_url = Jekyll::URL.new(
                        :template => "/javadoc/" + javadoc[0]
                    ).to_s
                    if javadoc[0] == this_jdoc
                        is_this_jdoc = true
                    end
                end
            end

            if entry_title
                target = ""
                haschildren = navpage["children"] and navpage["children"].length > 0
                if haschildren and navpage["dropdown"]
                    target << "<details><summary>"
                end
                if entry_url
                    target << '<a href='+entry_url.dump+'>'
                end
                target << CGI.escapeHTML(entry_title)
                if entry_url
                    target << "</a>"
                end
                if (haschildren or is_this_jdoc) and navpage["dropdown"]
                    target << "</summary>"
                end

                if is_this_jdoc
                    target << jdoc_contents
                end

                if haschildren
                    andentries = processNavEntries(site, navpage["children"], this_jdoc, jdoc_contents)
                    target << '<ul class="nav-list"><li>' + andentries.join("</li><li>") + "</li></ul>"
                    if navpage["dropdown"]
                        target << "</details>"
                    end
                end

                entries << target
            end
        end
        return entries
    end
end

Liquid::Template.register_tag('details', UnifiedDocsTheme::DetailsBlock)

Jekyll::Hooks.register :site, :post_write do |site|
    theme_data = site.config['unified-docs-theme']
    javadoc_data = theme_data ? theme_data['javadoc'] : {}
    javadoc_data.each do |id, data|
        nav_paths = theme_data ? theme_data['nav_pages'] : nil
        nav_paths = nav_paths ? nav_paths.dup : site.pages.map() do |page|
            {"page" => page.path}
        end + javadoc_data.map() do |id, data|
            {"javadoc" => id}
        end
        if not nav_paths.any? { |page| page["javadoc"] == id }
            nav_paths << {"javadoc" => id}
        end
        
        dest = File.join(site.dest, 'javadoc', id)
        Dir.glob(File.join(dest, '**/*.html')) do |path|
            current_hash = Digest::SHA256.file(path).hexdigest
            next if $processed_static_files[path] == current_hash

            text = File.read(path)
            text = text.gsub(/"[^"]*resource-files\/stylesheet.css"/, '"' + Jekyll::URL.new(
                :template => "/assets/css/javadoc.css"
            ).to_s + '"')

            text = text.gsub(/(<head>)/, '\1<script type="text/javascript" src="' + Jekyll::URL.new(
                :template => "/assets/js/javadoc.js"
            ).to_s + '"></script>')
            
            match = text.match(/(id="navbar-top-firstrow"[^>]*>)/)
            if match
                before = match.pre_match + match.to_s
                jdoc_contents, rest = match.post_match.split('</ul>', 2)
                jdoc_contents = '<ul class="nav-list">' + jdoc_contents + "</ul>"

                entries = UnifiedDocsTheme.processNavEntries(site, nav_paths, id, jdoc_contents)

                text = before + "<li>" + entries.join('</li><li>') + "</li></ul>" + rest;
            end
            File.write(path, text)
            new_hash = Digest::SHA256.file(path).hexdigest
            $processed_static_files[path] = new_hash
        end
    end
end