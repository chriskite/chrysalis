Chrysalis.Views.Repos ||= {}

class Chrysalis.Views.Repos.NewView extends Backbone.View
  template: JST["backbone/templates/repos/new"]

  events:
    "submit #new-repo": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    console.log(@model)

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (repo) =>
        @model = repo
        window.location.hash = "/#{@model.id}"

      error: (repo, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
