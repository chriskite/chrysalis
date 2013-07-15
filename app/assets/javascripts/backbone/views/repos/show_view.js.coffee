Chrysalis.Views.Repos ||= {}

class Chrysalis.Views.Repos.ShowView extends Backbone.View
  template: JST["backbone/templates/repos/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
