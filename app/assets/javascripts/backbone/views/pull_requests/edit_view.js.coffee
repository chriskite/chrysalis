Chrysalis.Views.PullRequests ||= {}

class Chrysalis.Views.PullRequests.EditView extends Backbone.View
  template: JST["backbone/templates/pull_requests/edit"]

  events:
    "submit #edit-pull_request": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (pull_request) =>
        @model = pull_request
        window.location.hash = "/#{@model.id}"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
