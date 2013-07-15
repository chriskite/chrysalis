Chrysalis.Views.Repos ||= {}

class Chrysalis.Views.Repos.RepoView extends Backbone.View
  template: JST["backbone/templates/repos/repo"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
