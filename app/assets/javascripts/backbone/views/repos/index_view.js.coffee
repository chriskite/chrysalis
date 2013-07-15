Chrysalis.Views.Repos ||= {}

class Chrysalis.Views.Repos.IndexView extends Backbone.View
  template: JST["backbone/templates/repos/index"]

  initialize: () ->
    @options.repos.bind('reset', @addAll)

  addAll: () =>
    @options.repos.each(@addOne)

  addOne: (repo) =>
    view = new Chrysalis.Views.Repos.RepoView({model : repo})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(repos: @options.repos.toJSON() ))
    @addAll()

    return this
