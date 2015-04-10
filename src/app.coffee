# 读取plist的文件
###
HelloWorldLayer = cc.Layer.extend(
    sprite:null
    ctor: () ->
        this._super()
        cc.spriteFrameCache.addSpriteFrames(res.atlas_game_plist)
        pokerTest = Poker.createPoker(cc.p(200, 200), cc.p(0, 0))
        pokerTest.eventTouch.add(() -> pokerTest.flip pokerTest.POKER_COLOR_GREEN)
        pokerTest.appear(pokerTest.POKER_COLOR_BLUE)
        this.addChild(pokerTest)
        true
)
###


`app = {}`

app.scene = Game.gameScene()
