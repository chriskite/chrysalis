class Chrysalis.Models.Repo extends Backbone.RelationalModel
  paramRoot: 'repo'

  relations: [
    type: Backbone.HasMany
    key: 'pull_requests'
    relatedModel: 'Chrysalis.Models.PullRequest'
    collectionType: 'Chrysalis.Collections.PullRequestsCollection'
    reverseRelation:
      key: 'repo'
    createModels: true
  ]

  whitelist_attrs: ['name', 'owner', 'token']

  defaults:
    name: null
    owner: null
    token: null
    client_id: null
    client_secret: null

Chrysalis.Models.Repo.setup()

class Chrysalis.Collections.ReposCollection extends Backbone.Collection
  model: Chrysalis.Models.Repo
  url: '/repos'
