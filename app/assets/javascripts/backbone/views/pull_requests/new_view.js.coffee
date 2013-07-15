Chrysalis.Views.PullRequests ||= {}

class Chrysalis.Views.PullRequests.NewView extends Backbone.View
  template: JST["backbone/templates/pull_requests/new"]

  events:
    "submit #new-pull_request": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (pull_request) =>
        @model = pull_request
        window.location.hash = "/#{@model.id}"

      error: (pull_request, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
