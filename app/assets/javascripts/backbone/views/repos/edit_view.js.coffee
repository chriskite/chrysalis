Chrysalis.Views.Repos ||= {}

class Chrysalis.Views.Repos.EditView extends Backbone.View
  template : JST["backbone/templates/repos/edit"]

  events :
    "submit #edit-repo" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (repo) =>
        @model = repo
        window.location.hash = "/#{@model.id}"
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
