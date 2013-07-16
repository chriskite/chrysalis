class Chrysalis.Models.Repo extends Backbone.RelationalModel
  paramRoot: 'repo'

  relations: [
    type: Backbone.HasMany
    key: 'pull_requests'
    relatedModel: 'PullRequest'
    collectionType: 'PullRequestCollection'
    reverseRelation:
      key: 'repo_id'
      includeInJSON: 'id'
  ]

  defaults:
    name: null
    owner: null
    token: null

class Chrysalis.Collections.ReposCollection extends Backbone.Collection
  model: Chrysalis.Models.Repo
  url: '/repos'
