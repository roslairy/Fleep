
cc.game.onStart = () ->
  cc.view.adjustViewPort(true)
  cc.view.setDesignResolutionSize(720, 1280, cc.ResolutionPolicy.SHOW_ALL)
  cc.view.resizeWithBrowserSize(true)
  cc.LoaderScene.preload(g_resources, () ->
    cc.spriteFrameCache.addSpriteFrames(res.atlas_game_plist)
    cc.director.runScene(new app.scene)
  , this);


cc.game.run();