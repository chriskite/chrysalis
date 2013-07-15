class Chrysalis.Routers.PullRequestsRouter extends Backbone.Router
  initialize: (options) ->
    @pullRequests = new Chrysalis.Collections.PullRequestsCollection()
    @pullRequests.reset options.pullRequests

  routes:
    "new"      : "newPullRequest"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newPullRequest: ->
    @view = new Chrysalis.Views.PullRequests.NewView(collection: @pull_requests)
    $("#pull_requests").html(@view.render().el)

  index: ->
    @view = new Chrysalis.Views.PullRequests.IndexView(pull_requests: @pull_requests)
    $("#pull_requests").html(@view.render().el)

  show: (id) ->
    pull_request = @pull_requests.get(id)

    @view = new Chrysalis.Views.PullRequests.ShowView(model: pull_request)
    $("#pull_requests").html(@view.render().el)

  edit: (id) ->
    pull_request = @pull_requests.get(id)

    @view = new Chrysalis.Views.PullRequests.EditView(model: pull_request)
    $("#pull_requests").html(@view.render().el)
