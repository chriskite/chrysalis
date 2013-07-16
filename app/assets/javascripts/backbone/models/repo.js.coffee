class Chrysalis.Models.Repo extends Backbone.RelationalModel
  paramRoot: 'repo'

  relations: [
    type: Backbone.HasMany
    key: 'pull_requests'
    relatedModel: 'Chrysalis.Models.PullRequest'
    collectionType: 'Chrysalis.Collections.PullRequestsCollection'
    reverseRelation:
      key: 'repo_id'
      includeInJSON: Backbone.Model.prototype.idAttribute
    createModels: true
  ]

  defaults:
    name: null
    owner: null
    token: null

Chrysalis.Models.Repo.setup()

class Chrysalis.Collections.ReposCollection extends Backbone.Collection
  model: Chrysalis.Models.Repo
  url: '/repos'
