Chrysalis.Views.Repos ||= {}

class Chrysalis.Views.Repos.ShowView extends Backbone.View
  template: JST["backbone/templates/repos/show"]

  initialize: () ->
    @options.model.get('pull_requests').bind('reset', @addAll)

  addAllPullRequests: () =>
    @options.model.get('pull_requests').each(@addPullRequest)

  addPullRequest: (pullRequest) =>
    view = new Chrysalis.Views.PullRequests.PullRequestView({model : pullRequest})
    @$("#pull-requests").append(view.render().el)

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    @addAllPullRequests()
    return this
