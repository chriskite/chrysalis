class Chrysalis.Models.Repo extends Backbone.Model
  paramRoot: 'repo'

  defaults:
    name: null
    owner: null
    token: null

class Chrysalis.Collections.ReposCollection extends Backbone.Collection
  model: Chrysalis.Models.Repo
  url: '/repos'
