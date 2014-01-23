describe 'DragDrop', ->
  $compile = $rootScope = null

  beforeEach ->
    module 'DragDrop'

  beforeEach ->
    inject( (_$compile_, _$rootScope_) ->
      $compile = _$compile_
      $rootScope = _$rootScope_
    )

  describe 'with valid settings', ->
    beforeEach ->
      $rootScope.settings =
        bank:
          location:'bottom'
          size:'70'
          expressions:
            [
              {text:'2.36 + 3.06'},
              {text:'2.16 + 3.36'},
              {text:'2.71 x 2'},
              {text:'1.80 x 3'},
              {text:'9.53 - 4.11'},
              {text:'8.01 - 2.69'}
            ]
        zones:
          [{
            title:'Title1'
            size:'50'
          }]

    it 'configures successfully', ->
      element = $compile("<div drag-drop></div")($rootScope)
      $rootScope.$digest()
      expect($rootScope.bank).toBeDefined()
