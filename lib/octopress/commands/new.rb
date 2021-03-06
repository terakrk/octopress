module Octopress
  class New < Command
    def self.init_with_program(p)
      p.command(:new) do |c|
        c.syntax 'new <PATH>'
        c.description 'Creates a new site with Jekyll and Octopress scaffolding at the specified path.'
        c.option 'force', '--force', 'Force creation even if path already exists.'
        c.option 'blank', '--blank', 'Creates scaffolding but with empty files.'
        
        c.action do |args, options|
          if args.empty?
            c.logger.error "You must specify a path."
          else
            Jekyll::Commands::New.process(args, options)
            Octopress::Scaffold.new(args, options).write
          end
        end

        c.command(:page) do |c|
          c.syntax 'page <PATH> [options]'
          c.description 'Add a new page to your Jekyll site.'
          c.option 'title', '--title TITLE', 'String to be added as the title in the YAML front-matter.'
          CommandHelpers.add_page_options c
          CommandHelpers.add_common_options c

          c.action do |args, options|
            options['path'] = args.first
            Page.new(Octopress.site(options), options).write
          end
        end

        c.command(:post) do |c|
          c.syntax 'post <TITLE> [options]'
          c.description 'Add a new post to your Jekyll site.'
          CommandHelpers.add_page_options c
          c.option 'slug', '--slug SLUG', 'Use this slug in filename instead of sluggified post title.'
          c.option 'dir', '--dir DIR', 'Create post at _posts/DIR/.'
          CommandHelpers.add_common_options c

          c.action do |args, options|
            options['title'] = args.first
            Post.new(Octopress.site(options), options).write
          end
        end

        c.command(:draft) do |c|
          c.syntax 'draft <TITLE> [options]'
          c.description 'Add a new draft post to your Jekyll site.'
          CommandHelpers.add_page_options c
          c.option 'slug', '--slug SLUG', 'Use this slug in filename instead of sluggified post title.'
          CommandHelpers.add_common_options c

          c.action do |args, options|
            options['title'] = args.first
            Draft.new(Octopress.site(options), options).write
          end
        end
      end
    end
  end
end
