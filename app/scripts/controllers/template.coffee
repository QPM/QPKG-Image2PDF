app.controller "TemplateCtrl", ($scope, SelectSvc) ->
  window.selected = SelectSvc.fetch()