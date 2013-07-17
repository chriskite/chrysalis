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

class Chrysalis.Collections.PullRequestsCollection extends Backbone.Collection
  model: Chrysalis.Models.PullRequest
  url: '/pull_requests'
