app = angular.module 'DragDrop'

app.directive 'dragDrop', ->
  restrict: "A"
  replace: true
  template: '<div>Dragon Drop</div>'
  scope: true
