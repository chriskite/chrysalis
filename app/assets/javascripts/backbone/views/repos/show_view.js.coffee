Chrysalis.Views.Repos ||= {}

class Chrysalis.Views.Repos.ShowView extends Backbone.View
  template: JST["backbone/templates/repos/show"]

  initialize: () ->
    @options.model.get('pull_requests').bind('reset', @resetAllPullRequests)
    @options.model.get('pull_requests').bind('add', @addPullRequest)

  resetAllPullRequests: () =>
    @$("#pull-requests").empty()
    @addAllPullRequests()

  addAllPullRequests: () =>
    @options.model.get('pull_requests').each(@addPullRequest)

  addPullRequest: (pullRequest) =>
    view = new Chrysalis.Views.PullRequests.PullRequestView({model : pullRequest})
    @$("#pull-requests tr th").parent().eq(0).after(view.render().el)

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    @addAllPullRequests()
    return this
