class Chrysalis.Routers.ReposRouter extends Backbone.Router
  initialize: (options) ->
    @repos = new Chrysalis.Collections.ReposCollection()
    @repos.reset(options.repos)

  routes:
    "new"      : "newRepo"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newRepo: ->
    @view = new Chrysalis.Views.Repos.NewView(collection: @repos)
    $("#repos").html(@view.render().el)

  index: ->
    @view = new Chrysalis.Views.Repos.IndexView(repos: @repos)
    $("#repos").html(@view.render().el)

  show: (id) ->
    repo = @repos.get(id)

    @view = new Chrysalis.Views.Repos.ShowView(model: repo)
    $("#repos").html(@view.render().el)

    setInterval ->
      repo.fetch success: ->
        repo.fetchRelated('pull_requests', {}, true)
    , 3000

  edit: (id) ->
    repo = @repos.get(id)

    @view = new Chrysalis.Views.Repos.EditView(model: repo)
    $("#repos").html(@view.render().el)
