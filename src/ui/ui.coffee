`UI = {}`

UI.btnListener = () ->
  cc.EventListener.create(
    event : cc.EventListener.TOUCH_ONE_BY_ONE,
    swallowTouches : true,
    onTouchBegan : (touch, event) ->
      target = event.getCurrentTarget()
      spr = target.btnSpr
      locationInNode = spr.convertToNodeSpace touch.getLocation()
      size = spr.getContentSize()
      rect = cc.rect 0, 0, size.width, size.height

      if cc.rectContainsPoint rect, locationInNode
        target.fadeEff()
        true
      else
        false

    onTouchEnded : (touch, event) ->
      target = event.getCurrentTarget()
      target.eventTouch.invoke()
  )

UI.createButton = (pic, pos) ->
  btn = new cc.Layer()
  btn.btnSpr = new cc.Sprite(pic)
  btn.eventTouch = Utils.event_0()
  btn.btnSpr.x = pos.x
  btn.btnSpr.y = pos.y
  btn.addChild(btn.btnSpr)
  btn.btnEff = new cc.Sprite("#circle.png")
  btn.btnEff.x = pos.x
  btn.btnEff.y = pos.y
  btn.btnEff.opacity = 0
  btn.fadeEff = () ->
    @btnEff.opacity = 255
    fade = cc.fadeOut(0.4)
    fade.easing cc.easeQuadraticActionIn()
    @btnEff.runAction(fade)
  btn.addChild(btn.btnEff)
  btn.listener = UI.btnListener()
  cc.eventManager.addListener(btn.listener, btn)
  btn

UI.createIndex = (index) ->
  delt = 40
  interval = 0.3
  layer = new cc.Layer()
  layer.curIndex = index
  layer.curInd = new cc.LabelTTF(index.toString(), 'aaargh', 72)
  layer.curInd.setFontFillColor(cc.color(64, 86, 99, 255))
  layer.curInd.x = 360
  layer.curInd.y = 1190
  layer.lastInd = new cc.LabelTTF(index.toString(), 'aaargh', 72)
  layer.lastInd.setFontFillColor(cc.color(64, 86, 99, 255))
  layer.lastInd.x = 360 - delt
  layer.lastInd.y = 1190
  layer.lastInd.opacity = 0
  ###
  layer.instruction = new cc.LabelTTF('Touch the central red', 'aaargh', 54)
  layer.instruction.setFontFillColor(cc.color(64, 86, 99, 255))
  layer.instruction.x = 360
  layer.instruction.y = 1280 - 320
  layer.instruction.opacity = 0
  ###
  layer.addChild(layer.curInd)
  layer.addChild(layer.lastInd)
  #layer.addChild(layer.instruction)
  layer.changeIndex = (_index, cb) ->
    @lastInd.setString(@curIndex.toString())
    @lastInd.x = 360
    @lastInd.y = 1190
    @lastInd.opacity = 255
    @curInd.setString(_index.toString())
    @curInd.x = 360 + delt
    @curInd.y = 1190
    @curInd.opacity = 0
    @curIndex = _index
    moveOut = cc.moveTo(interval, cc.p(360 - delt, 1190))
    moveOut.easing cc.easeQuadraticActionIn()
    fadeOut = cc.fadeOut(interval)
    fadeOut.easing cc.easeQuadraticActionIn()
    moveIn = cc.moveTo(interval, cc.p(360, 1190))
    moveIn.easing cc.easeQuadraticActionOut()
    fadeIn = cc.fadeIn(interval)
    fadeIn.easing cc.easeQuadraticActionOut()
    @lastInd.runAction(moveOut)
    @lastInd.runAction(fadeOut)
    @curInd.runAction(moveIn)
    @curInd.runAction(fadeIn)
  layer

UI.createUI = (leftCb, refreshCb, rightCb) ->
  ui = new cc.Layer()
  ui.left = UI.createButton("#left.png", cc.p(64, 80))
  ui.left.eventTouch.add(leftCb)
  ui.refresh = UI.createButton("#refresh.png", cc.p(360, 80))
  ui.refresh.eventTouch.add(refreshCb)
  ui.right = UI.createButton("#right.png", cc.p(720 - 64, 80))
  ui.right.eventTouch.add(rightCb)
  ui.index = UI.createIndex(1)
  ui.addChild(ui.left)
  ui.addChild(ui.refresh)
  ui.addChild(ui.right)
  ui.addChild(ui.index)
  ui.changeIndex = (index) ->
    ui.index.changeIndex index
  ui
