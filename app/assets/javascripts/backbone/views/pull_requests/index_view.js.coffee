Chrysalis.Views.PullRequests ||= {}

class Chrysalis.Views.PullRequests.IndexView extends Backbone.View
  template: JST["backbone/templates/pull_requests/index"]

  initialize: () ->
    @options.pullRequests.bind('reset', @addAll)

  addAll: () =>
    @options.pullRequests.each(@addOne)

  addOne: (pullRequest) =>
    view = new Chrysalis.Views.PullRequests.PullRequestView({model : pullRequest})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(pullRequests: @options.pullRequests.toJSON() ))
    @addAll()

    return this
