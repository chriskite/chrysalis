Chrysalis.Views.Repos ||= {}

class Chrysalis.Views.Repos.EditView extends Backbone.View
  template : JST["backbone/templates/repos/edit"]

  events :
    "submit #edit-repo" : "update"
    "click .destroy" : "destroy"
    "click input:checkbox" : "check"

  destroy: () ->
    @model.destroy()
    window.location.hash = ""
    return false

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (repo) =>
        @model = repo
        window.location.hash = "/#{@model.id}"
    )

  check: (e) ->
    if e.currentTarget.checked == true
      e.currentTarget.value = "true"
    else
      e.currentTarget.value = "false"

  render : ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
