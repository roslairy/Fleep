`Utils = {}`

##########################
#       Event
##########################
Utils.event_0 = () ->
  event = {}
  event.listeners = []
  event.add = (selector) -> @listeners.push selector
  event.clear = () -> @listeners = []
  event.invoke = () -> listener() for listener in @listeners
  event

Utils.event_1 = () ->
  event = {}
  event.listeners = []
  event.add = (selector) -> @listeners.push selector
  event.clear = () -> @listeners = []
  event.invoke = (arg1) -> listener(arg1) for listener in @listeners
  event

Utils.matrixNode = (matrix, x, y) ->
  matrixNode = {}
  matrixNode.matrix = matrix
  matrixNode.x = x
  matrixNode.y = y
  matrixNode.content = null
  matrixNode.left = () -> @matrix.getNode(x - 1, y)
  matrixNode.right = () -> @matrix.getNode(x + 1, y)
  matrixNode.above = () -> @matrix.getNode(x, y + 1)
  matrixNode.bottom = () -> @matrix.getNode(x, y - 1)
  matrixNode.getAllDirection = () ->
    s = @
    result = [@]
    tmp = []
    tmp.push @left()
    tmp.push @right()
    tmp.push @above()
    tmp.push @bottom()
    tmp.sort((a, b) ->
      aWeight = Math.abs(a.x - s.x) + Math.abs(a.y - s.y)
      bWeidht = Math.abs(b.x - s.x) + Math.abs(b.y - s.y)
      if aWeight > bWeidht then 1 else -1
    )
    result.concat(tmp)

  matrixNode

Utils.matrix = (x, y, fillSelector) ->
  matrix = {}
  matrix.x = x
  matrix.y = y
  matrix.nodes = []
  for i in [1..x]
    matrix.nodes[i] = []
    for j in [1..y]
      matrix.nodes[i][j] = Utils.matrixNode(matrix, i, j)
      fillSelector(matrix.nodes[i][j])

  matrix.getNode = (x, y) ->
    while x > @x
      x -= @x
    while x < 1
      x += @x
    while y > @y
      y -= @y
    while y < 1
      y += @y
    @nodes[x][y]

  matrix.all = () ->
    result = []
    for i in [1..@x]
      for j in [1..@y]
        result.push @nodes[i][j]
    result

  matrix.step = () ->
    result = []
    x = 0
    while x < @x
      x++
      _y = 1
      _x = x
      while _x >= 1 and _y <= @y
        result.push @getNode(_x, _y)
        _x--
        _y++
    y = 1
    while y < @y
      y++
      _y = y
      _x = x
      while _x >= 1 and _y <= @y
        result.push @getNode(_x, _y)
        _x--
        _y++
    result

  matrix.findNode = (content) ->
    result = null
    @nodes.forEach(
      (arrays) ->
        arrays.forEach(
          (elem) -> if elem.content == content then result = elem
        )
    )
    result

  matrix