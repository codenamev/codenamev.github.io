require 'octokit'

desc "Generate pages from GitHub"
task :github_stats do
  gh_user     = ask("Please enter your GitHub username: ")
  gh_password = ask("Please enter your GitHub password (we do NOT store this): ") { |q| q.echo = false }

  begin
    github        = Github.new :basic_auth => "#{gh_user}:#{gh_password}"
    authorization = github.oauth.create 'scopes' => ['repo']
    oauth_token   = authorization[:token]
    `git config --global --replace-all github.oauth-token #{oauth_token}`
  rescue
    puts "\nInvalid username or password"
  else
    puts "\nYour GitHub account was successfully setup!"
  end

  # Now fetch and store github data
  config = YAML.load_file('_config.yml')
  author_codename = config['author']['github']
  starred = Octokit.starred author_codename

  starred.each do |starred_repo|

  end
end # task :preview
