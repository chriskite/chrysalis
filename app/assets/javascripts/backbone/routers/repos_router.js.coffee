class Chrysalis.Routers.ReposRouter extends Backbone.Router
  initialize: (options) ->
    @repos = new Chrysalis.Collections.ReposCollection()
    @repos.reset(options.repos)
    setInterval =>
      @trigger('tick')
    , 5000

  routes:
    "new"      : "newRepo"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newRepo: ->
    @view?.remove()
    @view = new Chrysalis.Views.Repos.NewView(collection: @repos)
    $("#repos").html(@view.render().el)

  index: ->
    @view?.remove()
    @view = new Chrysalis.Views.Repos.IndexView(repos: @repos)
    $("#repos").html(@view.render().el)

  show: (id) ->
    @view?.remove()
    repo = @repos.get(id)

    @view = new Chrysalis.Views.Repos.ShowView(model: repo)
    @view.listenTo this, 'tick', =>
      repo.fetch success: ->
        repo.fetchRelated('pull_requests', {}, true)

    $("#repos").html(@view.render().el)

  edit: (id) ->
    @view?.remove()
    repo = @repos.get(id)

    @view = new Chrysalis.Views.Repos.EditView(model: repo)
    $("#repos").html(@view.render().el)
