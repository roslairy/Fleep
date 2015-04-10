`Game = {}`

Game.gameScene = () ->
  gs = cc.Scene.extend(
    onEnter : () ->
      _gs = @
      @_super()
      @isAnim = off

      @bg = new cc.DrawNode()
      @bg.drawRect(cc.p(0, 0), cc.p(720, 1280), cc.color(242, 242, 242, 255))
      @bglayer = new cc.Layer
      @bglayer.addChild @bg
      @addChild(@bglayer)

      @leftCb = () -> if not _gs.isAnim and _gs.curLevel != 1 then _gs.curLevel--; _gs.changeLevel(_gs.curLevel)
      @refreshCb = () -> _gs.changeLevel(_gs.curLevel)
      @rightCb = () -> if not _gs.isAnim and _gs.curLevel != 40 then _gs.curLevel++; _gs.changeLevel(_gs.curLevel)
      @winCb = () -> if _gs.curLevel != 40
          _gs.curLevel++
          _gs.changeLevel(_gs.curLevel);
        else
          _gs.changeLevel(1)

      @ui = UI.createUI(@leftCb, @refreshCb, @rightCb)
      @addChild(@ui)

      @pokerArea = PokerArea.createPokerArea()
      @addChild(@pokerArea)

      @curLevel = 1
      @startLevel = (level) ->
        @isAnim = on
        @pokerArea.showMatrix(Level.levelData[level], @winCb,
          () ->
            _gs.isAnim = false
        )
        @ui.changeIndex(level)
      @changeLevel = (level) ->
        @isAnim = true
        @pokerArea.hideMatrix(() -> _gs.startLevel(level))

      @startLevel(1)
  )


  gs
