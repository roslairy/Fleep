`PokerArea = {}`

PokerArea.POKER_AREA_TYPE_3X3 = 0
PokerArea.POKER_AREA_TYPE_5X3 = 1
PokerArea.POKER_AREA_TYPE_5X5 = 2

PokerArea.createPokerArea = () =>
  pokerArea = new cc.Layer();
  pokerArea.x = 60
  pokerArea.y = 280
  pokerArea.isAnim = off
  pokerArea.isShown = off
  pokerArea.interval = 0
  pokerArea.onAnimStart = () -> @isAnim = on
  pokerArea.onAnimEnd = () -> @isAnim = off; @checkWin()
  pokerArea.onAppear = () -> @isShown = on
  pokerArea.onDisappear = () -> @isShown = off
  pokerArea.typeCount = 2
  pokerArea.areaType = 0
  pokerArea.wincb = null
  pokerArea.fillSelector = (node) ->
    xIndex = node.x
    yIndex = node.y
    xRoot = 0
    yRoot = 0
    switch pokerArea.areaType
      when PokerArea.POKER_AREA_TYPE_3X3 then xRoot = 120; yRoot = 120
      when PokerArea.POKER_AREA_TYPE_5X3 then xRoot = 0; yRoot = 120
      when PokerArea.POKER_AREA_TYPE_5X5 then xRoot = 0; yRoot = 0
    x = (xIndex - 1) * 120 + 60 + xRoot
    y = (yIndex - 1) * 120 + 60 + yRoot
    node.content = Poker.createPoker(cc.p(x, y), cc.p(xIndex, yIndex), pokerArea.typeCount)
    node.content.eventTouch.add((poker) -> pokerArea.onPokerTouch(poker))
    pokerArea.addChild(node.content)
  pokerArea.showMatrix = (data, winCallBack, cb) ->
    _pa = @
    @areaType = data.areaType
    @typeCount = data.typeCount
    @wincb = winCallBack
    if @matrix != undefined
      @matrix.all().forEach(
        (node) ->
          _pa.removeChild(node.content)
      )
    @matrix = switch @areaType
      when PokerArea.POKER_AREA_TYPE_3X3 then @interval = (0.27 / 9);Utils.matrix(3, 3, @fillSelector)
      when PokerArea.POKER_AREA_TYPE_5X3 then @interval = (0.27 / 15);Utils.matrix(5, 3, @fillSelector)
      when PokerArea.POKER_AREA_TYPE_5X5 then @interval = (0.27 / 25);Utils.matrix(5, 5, @fillSelector)
      else Utils.matrix(5, 5, @fillSelector)
    @onAnimStart()
    @onAppear()
    @step(
      @matrix.step(),
      (poker) -> poker.appear(); poker.toColor(data.areaData[poker.pointIndex.x][poker.pointIndex.y]),
      (poker) -> poker.eventAnimEnd.add(
        (_p) ->
          pokerArea.onAnimEnd()
          poker.eventAnimEnd.clear()
          cb()
      ),
      @interval
    )
  pokerArea.hideMatrix = (cb) ->
    @onAnimStart()
    @onDisappear()
    @step(
      @matrix.step(),
      (poker) -> poker.disappear(),
      (poker) -> poker.eventAnimEnd.add(
        (_p) ->
          pokerArea.onAnimEnd()
          poker.eventAnimEnd.clear()
          cb()
      ),
      @interval
    )
  pokerArea.step = (sort, selector, lastSelector, interval) ->
    sort.reverse()
    @schedule(
      () ->
        elem = sort.pop()
        selector elem.content
        if sort.length == 0 then lastSelector elem.content
      ,
      interval,
      sort.length - 1,
      0,
      ""
    )
  pokerArea.onPokerTouch = (poker) ->
    return if @isAnim or not @isShown
    node = @matrix.findNode(poker)
    sort = node.getAllDirection()
    @onAnimStart()
    @step(
      sort,
      (poker) -> poker.flip(),
      (poker) -> poker.eventAnimEnd.add(
        (_p) ->
          pokerArea.onAnimEnd()
          poker.eventAnimEnd.clear()
      ),
      0.27 / 5
    )
  pokerArea.checkWin = () ->
    return off if not @isShown
    result = on
    @matrix.all().forEach(
      (elem) ->
        if elem.content.currentType != 0 then result = off
    )
    if result then @wincb()
  pokerArea.getData = () ->
    data = {}
    data.areaType = @areaType
    data.typeCount = @typeCount
    data.areaData = []
    for i in [1..@matrix.x]
      data.areaData[i] = []
      for j in [1..@matrix.y]
        data.areaData[i][j] = @matrix.getNode(i, j).content.currentType
    data

  #test
  ###
  data = {
    areaType : 2,
    typeCount : 4,
    areaData : [
      null,
      [null, 0, 0, 0, 0, 0],
      [null, 0, 0, 0, 0, 0],
      [null, 0, 0, 0, 0, 0],
      [null, 0, 0, 0, 0, 0],
      [null, 0, 0, 0, 0, 0]
    ]
  }
  pokerArea.showMatrix(data, () -> .log JSON.stringify(pokerArea.getData().areaData))
  ###
  #test

  pokerArea