// Generated by CoffeeScript 1.9.1
Game = {};
Game.gameScene = function() {
  var gs;
  gs = cc.Scene.extend({
    onEnter: function() {
      var _gs;
      _gs = this;
      this._super();
      this.isAnim = false;
      this.bg = new cc.DrawNode();
      this.bg.drawRect(cc.p(0, 0), cc.p(720, 1280), cc.color(242, 242, 242, 255));
      this.bglayer = new cc.Layer;
      this.bglayer.addChild(this.bg);
      this.addChild(this.bglayer);
      this.leftCb = function() {
        if (!_gs.isAnim && _gs.curLevel !== 1) {
          _gs.curLevel--;
          return _gs.changeLevel(_gs.curLevel);
        }
      };
      this.refreshCb = function() {
        return _gs.changeLevel(_gs.curLevel);
      };
      this.rightCb = function() {
        if (!_gs.isAnim && _gs.curLevel !== 40) {
          _gs.curLevel++;
          return _gs.changeLevel(_gs.curLevel);
        }
      };
      this.winCb = function() {
        if (_gs.curLevel !== 40) {
          _gs.curLevel++;
          return _gs.changeLevel(_gs.curLevel);
        } else {
          return _gs.changeLevel(1);
        }
      };
      this.ui = UI.createUI(this.leftCb, this.refreshCb, this.rightCb);
      this.addChild(this.ui);
      this.pokerArea = PokerArea.createPokerArea();
      this.addChild(this.pokerArea);
      this.curLevel = 1;
      this.startLevel = function(level) {
        this.isAnim = true;
        this.pokerArea.showMatrix(Level.levelData[level], this.winCb, function() {
          return _gs.isAnim = false;
        });
        return this.ui.changeIndex(level);
      };
      this.changeLevel = function(level) {
        this.isAnim = true;
        return this.pokerArea.hideMatrix(function() {
          return _gs.startLevel(level);
        });
      };
      return this.startLevel(1);
    }
  });
  return gs;
};
