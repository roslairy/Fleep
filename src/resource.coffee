`res = {}`
res =
  atlas_game_plist : "res/game.plist",
  atlas_game_png : "res/game.png"
  aaargh_ttf :
    type : 'font',
    name : 'aaargh',
    srcs : ['res/Aaargh.ttf']

`g_resources = []`

g_resources.push res.atlas_game_plist
g_resources.push res.atlas_game_png
g_resources.push res.aaargh_ttf
