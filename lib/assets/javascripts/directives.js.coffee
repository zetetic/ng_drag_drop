app = angular.module "DragDrop"

class Drawable
  constructor: (paper) ->
    @paper = paper


class Expression extends Drawable
  constructor: (paper, options) ->
    @text = options.text
    @container = options.container
    super paper

  draw: (x, y) ->
    @set = @paper.set()
    @text_x_offset = 40
    @text_y_offset = 10

    @r = @paper.rect(x, y, 80, 20).attr({"fill","lightgrey"})
    @t = @paper.text(x+@text_x_offset, y+@text_y_offset, @text).attr({"font-size":"14"})
    @set.push(@r, @t)

    #@set.hover =>
      #@r.animate Raphael.animation({"fill":"yellow"}, 200)
    #, =>
      #@r.animate Raphael.animation({"fill":"lightgrey"}, 200)

    dragMove = (dx, dy) =>
      @moveTo(@ox + dx, @oy + dy)
      eve('move', this)

    dragStart = =>
      @ox = @r.attr('x')
      @oy = @r.attr('y')
      e.attr({opacity: 1}) for e in @set

    dragEnd = =>
      eve('drop', this)

    @set.drag(dragMove, dragStart, dragEnd)

  moveTo: (x, y) ->
    @r.attr({x: x, y: y})
    @t.attr({x: x+@text_x_offset, y: y+@text_y_offset})

  setTarget: (target) ->
    if @target?
      # Open the old target
      @target.open = true
    @target = target


class DropArea extends Drawable
  openTarget: ->
    (dropTarget for dropTarget in @dropTargets when dropTarget.open)[0]

  place: (expression) ->
    target = @openTarget()
    throw new Error 'no target' unless target?
    target.store(expression)

  draw: (r) ->
    dropArea = this

    eve.on 'drop', ->
      x = this.r.attr('x')
      y = this.r.attr('y')
      if r.isPointInside(x, y)
        this.container = dropArea
        this.container.place(this)

    eve.on 'move', ->
      x = this.r.attr('x')
      y = this.r.attr('y')
      if r.isPointInside(x, y)
        target = dropArea.openTarget()


class Bank extends DropArea
  constructor: (paper, options) ->
    @location = options.location
    @size = options.size
    @expressions = []
    for data in options.expressions
      angular.extend(data, {container: this})
      @expressions.push(new Expression(paper, data))
    @dropTargets = []
    super paper

  draw: ->
    top = @paper.height - @size
    left = 20
    r = @paper.rect(0, @paper.height - @size, @paper.width, @size).attr({"fill":"lightgrey"})
    for x in [0..@expressions.length-1] by 2
      expression = @expressions[x]
      if expression
        @setupExpression(expression, left+(x*60), top+10)
      expression = @expressions[x+1]
      if expression
        @setupExpression(expression, left+(x*60), top+40)
    super r

  setupExpression: (expression, x, y) ->
    expression.draw(x, y)
    target = new DropTarget(@paper, x, y)
    target.store(expression)
    @dropTargets.push(target)


class DropTarget extends Drawable
  constructor: (paper, x, y) ->
    @x = x
    @y = y
    @open = true
    super paper

  store: (expression) ->
    expression.moveTo @x, @y
    expression.setTarget(this)
    @open = false


class Zone extends DropArea
  constructor: (paper, options) ->
    @title = options.title
    @titleSize  = parseInt(options.title_size, 0)
    @expressions = []
    super paper

  draw: (width, x, bankSize) ->
    # Draw the title area and print the title
    height = @titleSize
    @paper.rect(x, 0, width, height)
    @paper.text(x + (width/2), height/2, @title).attr({"font-size":"14"})

    # Draw the zone boundary
    r = @paper.rect(x, height, @paper.width/2, @paper.height-bankSize-@titleSize)

    # Set up the drop targets
    @dropTargets = []
    @dropTargets.push(new DropTarget(@paper, x + 10, @titleSize + 10))
    @dropTargets.push(new DropTarget(@paper, x + 10, @titleSize + 40))
    @dropTargets.push(new DropTarget(@paper, x + 10, @titleSize + 70))
    @dropTargets.push(new DropTarget(@paper, x + 10, @titleSize + 100))
    @dropTargets.push(new DropTarget(@paper, x + 10, @titleSize + 130))
    @dropTargets.push(new DropTarget(@paper, x + 10, @titleSize + 160))

    super r


class Zones extends Drawable
  constructor: (paper, options) ->
    @zones = []
    @zones.push(new Zone(paper, zoneData)) for zoneData in options.zones
    @bankSize = options.bank_size
    super paper

  draw: ->
    switch @size()
      when 1
        @zones[0].draw(@paper.width, 0, @bankSize)
      when 2
        @zones[0].draw(@paper.width / 2, 0, @bankSize)
        @zones[1].draw(@paper.width / 2, ( @paper.width /2 ), @bankSize)

  size: ->
    @zones.length


app.directive "dragDrop", ->
  restrict: "A"
  replace: true
  scope: false
  template: '<div></div>'
  link: (scope, element, attrs) ->
    element.css('cursor','pointer')
    width        = parseInt attrs.width, 0
    height       = parseInt attrs.height, 0
    canvas       = element[0]
    paper        = new Raphael(canvas, width, height)
    scope.bank   = new Bank(paper, scope.settings.bank)
    zoneOptions  = {bank_size:scope.settings.bank.size, zones:scope.settings.zones}
    scope.zones  = new Zones(paper, zoneOptions)

    # Draw the outer container
    paper.rect(0, 0, width, height).attr({"fill":"white","stroke":"black"})

    scope.bank.draw()
    scope.zones.draw()
