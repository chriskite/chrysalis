Chrysalis.Views.Repos ||= {}

class Chrysalis.Views.Repos.RepoView extends Backbone.View
  template: JST["backbone/templates/repos/repo"]

  tagName: "tr"

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
