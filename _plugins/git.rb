require 'octokit'

module Jekyll
  class GitActivityTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      config = YAML.load_file('_config.yml')
      author_codename = config['author']['github']
      starred = Octokit.starred author_codename

      result = ""

      starred.each do |starred_repo|
        result << <<-HTML_END
          <li>
            <figure>
              <i class="icon icon-github icon-4x"></i>
              <h4>#{ starred_repo.name }</h4>
              <small>#{ starred_repo.description }</small>
              <figcaption>
                <h3>#{ starred_repo.name }</h3>
                <span><a href="#{ starred_repo.owner.html_url}">#{ starred_repo.owner.login }</a></span>
                <a href="#{ starred_repo.html_url }">Check it out</a>
              </figcaption>
            </figure>
          </li>
        HTML_END
      end
      "<ul class=\"grid cs-style-3\">#{result}</ul>"
    end
  end
end

Liquid::Template.register_tag('gitstarred', Jekyll::GitActivityTag)
