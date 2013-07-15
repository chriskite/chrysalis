class Chrysalis.Routers.ReposRouter extends Backbone.Router
  initialize: (options) ->
    @repos = new Chrysalis.Collections.ReposCollection()

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
    @repos.fetch success: =>
      console.log 'success'
      $("#repos").html(@view.render().el)

  show: (id) ->
    repo = @repos.get(id)

    @view = new Chrysalis.Views.Repos.ShowView(model: repo)
    $("#repos").html(@view.render().el)

  edit: (id) ->
    repo = @repos.get(id)

    @view = new Chrysalis.Views.Repos.EditView(model: repo)
    $("#repos").html(@view.render().el)