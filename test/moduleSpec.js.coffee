describe 'DragDrop', ->
  $compile = $rootScope = null

  beforeEach ->
    module 'DragDrop'

  beforeEach ->
    inject( (_$compile_, _$rootScope_) ->
      $compile = _$compile_
      $rootScope = _$rootScope_
    )

  it 'compiles successfully', ->
    element = $compile("<div drag-drop></div")($rootScope)
    $rootScope.$digest()
