// Generated by CoffeeScript 1.9.1
PokerArea = {};
PokerArea.POKER_AREA_TYPE_3X3 = 0;

PokerArea.POKER_AREA_TYPE_5X3 = 1;

PokerArea.POKER_AREA_TYPE_5X5 = 2;

PokerArea.createPokerArea = (function(_this) {
  return function() {
    var pokerArea;
    pokerArea = new cc.Layer();
    pokerArea.x = 60;
    pokerArea.y = 280;
    pokerArea.isAnim = false;
    pokerArea.isShown = false;
    pokerArea.interval = 0;
    pokerArea.onAnimStart = function() {
      return this.isAnim = true;
    };
    pokerArea.onAnimEnd = function() {
      this.isAnim = false;
      return this.checkWin();
    };
    pokerArea.onAppear = function() {
      return this.isShown = true;
    };
    pokerArea.onDisappear = function() {
      return this.isShown = false;
    };
    pokerArea.typeCount = 2;
    pokerArea.areaType = 0;
    pokerArea.wincb = null;
    pokerArea.fillSelector = function(node) {
      var x, xIndex, xRoot, y, yIndex, yRoot;
      xIndex = node.x;
      yIndex = node.y;
      xRoot = 0;
      yRoot = 0;
      switch (pokerArea.areaType) {
        case PokerArea.POKER_AREA_TYPE_3X3:
          xRoot = 120;
          yRoot = 120;
          break;
        case PokerArea.POKER_AREA_TYPE_5X3:
          xRoot = 0;
          yRoot = 120;
          break;
        case PokerArea.POKER_AREA_TYPE_5X5:
          xRoot = 0;
          yRoot = 0;
      }
      x = (xIndex - 1) * 120 + 60 + xRoot;
      y = (yIndex - 1) * 120 + 60 + yRoot;
      node.content = Poker.createPoker(cc.p(x, y), cc.p(xIndex, yIndex), pokerArea.typeCount);
      node.content.eventTouch.add(function(poker) {
        return pokerArea.onPokerTouch(poker);
      });
      return pokerArea.addChild(node.content);
    };
    pokerArea.showMatrix = function(data, winCallBack, cb) {
      var _pa;
      _pa = this;
      this.areaType = data.areaType;
      this.typeCount = data.typeCount;
      this.wincb = winCallBack;
      if (this.matrix !== void 0) {
        this.matrix.all().forEach(function(node) {
          return _pa.removeChild(node.content);
        });
      }
      this.matrix = (function() {
        switch (this.areaType) {
          case PokerArea.POKER_AREA_TYPE_3X3:
            this.interval = 0.27 / 9;
            return Utils.matrix(3, 3, this.fillSelector);
          case PokerArea.POKER_AREA_TYPE_5X3:
            this.interval = 0.27 / 15;
            return Utils.matrix(5, 3, this.fillSelector);
          case PokerArea.POKER_AREA_TYPE_5X5:
            this.interval = 0.27 / 25;
            return Utils.matrix(5, 5, this.fillSelector);
          default:
            return Utils.matrix(5, 5, this.fillSelector);
        }
      }).call(this);
      this.onAnimStart();
      this.onAppear();
      return this.step(this.matrix.step(), function(poker) {
        poker.appear();
        return poker.toColor(data.areaData[poker.pointIndex.x][poker.pointIndex.y]);
      }, function(poker) {
        return poker.eventAnimEnd.add(function(_p) {
          pokerArea.onAnimEnd();
          poker.eventAnimEnd.clear();
          return cb();
        });
      }, this.interval);
    };
    pokerArea.hideMatrix = function(cb) {
      this.onAnimStart();
      this.onDisappear();
      return this.step(this.matrix.step(), function(poker) {
        return poker.disappear();
      }, function(poker) {
        return poker.eventAnimEnd.add(function(_p) {
          pokerArea.onAnimEnd();
          poker.eventAnimEnd.clear();
          return cb();
        });
      }, this.interval);
    };
    pokerArea.step = function(sort, selector, lastSelector, interval) {
      sort.reverse();
      return this.schedule(function() {
        var elem;
        elem = sort.pop();
        selector(elem.content);
        if (sort.length === 0) {
          return lastSelector(elem.content);
        }
      }, interval, sort.length - 1, 0, "");
    };
    pokerArea.onPokerTouch = function(poker) {
      var node, sort;
      if (this.isAnim || !this.isShown) {
        return;
      }
      node = this.matrix.findNode(poker);
      sort = node.getAllDirection();
      this.onAnimStart();
      return this.step(sort, function(poker) {
        return poker.flip();
      }, function(poker) {
        return poker.eventAnimEnd.add(function(_p) {
          pokerArea.onAnimEnd();
          return poker.eventAnimEnd.clear();
        });
      }, 0.27 / 5);
    };
    pokerArea.checkWin = function() {
      var result;
      if (!this.isShown) {
        return false;
      }
      result = true;
      this.matrix.all().forEach(function(elem) {
        if (elem.content.currentType !== 0) {
          return result = false;
        }
      });
      if (result) {
        return this.wincb();
      }
    };
    pokerArea.getData = function() {
      var data, i, j, k, l, ref, ref1;
      data = {};
      data.areaType = this.areaType;
      data.typeCount = this.typeCount;
      data.areaData = [];
      for (i = k = 1, ref = this.matrix.x; 1 <= ref ? k <= ref : k >= ref; i = 1 <= ref ? ++k : --k) {
        data.areaData[i] = [];
        for (j = l = 1, ref1 = this.matrix.y; 1 <= ref1 ? l <= ref1 : l >= ref1; j = 1 <= ref1 ? ++l : --l) {
          data.areaData[i][j] = this.matrix.getNode(i, j).content.currentType;
        }
      }
      return data;
    };

    /*
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
     */
    return pokerArea;
  };
})(this);
