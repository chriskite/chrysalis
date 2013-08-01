Chrysalis.Views.PullRequests ||= {}

class Chrysalis.Views.PullRequests.PullRequestView extends Backbone.View
  template: JST["backbone/templates/pull_requests/pull_request"]

  events:
    "click .rebuild" : "rebuild"
    "click .status.badge-success"  : "statusModal"

  tagName: "tr"

  initialize: ->
    @listenTo @model, 'change', @render
    @listenTo @model, 'remove', @remove
    @listenTo @model, 'destroy', @remove

  remove: =>
    @$el.empty()

  rebuild: ->
    @model.rebuild()
    return false

  statusModal: ->
    $('#myModal').modal(remote: '/pull_requests/' + @model.get('id') + '/build_log')

  render: =>
    @$el.html(@template(@model.toJSON() ))
    return this
