class Chrysalis.Models.PullRequest extends Backbone.RelationalModel
  paramRoot: 'pull_request'

  defaults:
    repo_id: null
    branch: null
    status: null

class Chrysalis.Collections.PullRequestsCollection extends Backbone.Collection
  model: Chrysalis.Models.PullRequest
  url: '/pull_requests'
