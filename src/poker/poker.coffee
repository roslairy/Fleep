`Poker = {}`

pokerTouch = cc.EventListener.create(
  event : cc.EventListener.TOUCH_ONE_BY_ONE,
  swallowTouches : true,
  onTouchBegan : (touch, event) ->
    target = event.getCurrentTarget()
    locationInNode = target.convertToNodeSpace touch.getLocation()
    size = target.getContentSize()
    rect = cc.rect 0, 0, size.width, size.height

    if cc.rectContainsPoint rect, locationInNode
      true
    else
      false

  onTouchEnded : (touch, event) ->
    target = event.getCurrentTarget()
    target.eventTouch.invoke(target)
)

Poker.pokerTouch = pokerTouch
Poker.POKER_COLOR_BLUE = "blue.png"
Poker.POKER_COLOR_RED = "red.png"
Poker.POKER_COLOR_GREEN = "green.png"
Poker.POKER_COLOR_PURPLE = "purple.png"

Poker.createPoker = (point , pointIndex, typeCount) ->
  poker = new cc.Sprite()
  cc.eventManager.addListener(Poker.pokerTouch.clone(), poker)
  poker.pointIndex = pointIndex
  poker.scaleY = 0
  poker.typeCount = typeCount
  poker.currentType = 0
  poker.x = point.x
  poker.y = point.y
  poker.isAnim = off
  poker.isShown = off
  flipIn = cc.scaleTo 0.03, 1, 0
  flipIn.easing cc.easeCircleActionIn()
  flipOut = cc.scaleTo 0.16, 1, 1
  flipOut.easing cc.easeCircleActionOut()
  disappear = cc.scaleTo 0.16, 1, 0
  disappear.easing cc.easeQuarticActionOut()
  poker.flipIn = flipIn
  poker.flipOut = flipOut
  poker.disappearAnim = disappear
  poker.POKER_COLOR_BLUE = "blue.png"
  poker.POKER_COLOR_RED = "red.png"
  poker.POKER_COLOR_GREEN = "green.png"
  poker.POKER_COLOR_PURPLE = "purple.png"
  poker.type = [
    poker.POKER_COLOR_BLUE,
    poker.POKER_COLOR_RED,
    poker.POKER_COLOR_PURPLE,
    poker.POKER_COLOR_GREEN
  ]

  poker.showColor = null;
  poker.changeColor = () ->
    @currentType++
    @currentType %= @typeCount
    @setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(@type[@currentType]))
    @showColor = @type[@currentType]

  poker.toColor = (type) ->
    @currentType = type
    @setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(@type[@currentType]))
    @showColor = @type[@currentType]

  poker.onAnimBegin = () ->
    @isAnim = true

  poker.onAnimEnd = () ->
    @isAnim = false
    @eventAnimEnd.invoke(@)

  poker.setSpriteFrame poker.type[poker.currentType]
  poker.eventTouch = Utils.event_1()
  poker.eventAnimEnd = Utils.event_1()

  poker.flip = () ->
    if not @isAnim
      sequence = cc.sequence([
        cc.callFunc(@onAnimBegin, @),
        @flipIn,
        cc.callFunc(@changeColor, @),
        @flipOut,
        cc.callFunc(@onAnimEnd, @)
      ])
      @runAction(sequence)
    @

  poker.appear = () ->
    if not (@isAnim or @isShown)
      sequence = cc.sequence([
        cc.callFunc(@onAnimBegin, @),
        @flipOut,
        cc.callFunc(@onAnimEnd, @)
      ])
      @runAction(sequence)
    @

  poker.disappear = () ->
    if not (@isAnim or @isShown)
      sequence = cc.sequence([
        cc.callFunc(@onAnimBegin, @),
        @disappearAnim,
        cc.callFunc(@onAnimEnd, @)
      ])
      @runAction(sequence)
    @

  poker

