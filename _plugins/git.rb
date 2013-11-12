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
        repo_url = "https://github.com/#{starred_repo.full_name}"
        result << <<-HTML_END
          <li>
            <figure>
              <i class="icon icon-github icon-4x"></i>
              <h4>#{ starred_repo.name }</h4>
              <small>#{ starred_repo.description }</small>
              <figcaption>
                <h3>#{ starred_repo.name }</h3>
                <span><a href="https://github.com/#{ starred_repo.owner.login }" target="_blank"><img src="http://www.gravatar.com/avatar/#{ starred_repo.owner.gravatar_id }" width="24" height="24" algin="left">#{ starred_repo.owner.login }</a></span>
                <a href="#{ repo_url }" target="_blank">Check it out</a>
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
