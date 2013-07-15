Chrysalis.Views.PullRequests ||= {}

class Chrysalis.Views.PullRequests.ShowView extends Backbone.View
  template: JST["backbone/templates/pull_requests/show"]

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
