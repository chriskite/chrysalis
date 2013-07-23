class Chrysalis.Models.PullRequest extends Backbone.RelationalModel
  paramRoot: 'pull_request'

  defaults:
    repo_id: null
    status: null
    title: null
    url: null
    user_login: null
    user_avatar_url: null
    created_at: null
    updated_at: null
    github_created_at: null
    github_updated_at: null

  jiraIssue: ->
    match = @get('title').match(/[A-Z]*-[0-9]*/)?[0]

  website: ->
    nginx_template = @get('repo').get('nginx_template')
    if !!nginx_template && @get('repo').get('should_provision_nginx')
      match = /server_name (.*);/i.exec(nginx_template)
      return match?[1].replace('{{number}}', @get('number'))
    null

class Chrysalis.Collections.PullRequestsCollection extends Backbone.Collection
  model: Chrysalis.Models.PullRequest
  url: '/pull_requests'
