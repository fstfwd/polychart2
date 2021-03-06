module "Layer"
test "point", ->
  jsondata= [
    {x: 2, y: 4},
    {x: 3, y: 3}
  ]
  data = polyjs.debug.data (data: jsondata)
  spec =
    render: false
    layers: [
      data: data, type: 'point', x: 'x', y: 'y'
    ]
  graph = polyjs.debug.chart spec
  layer = graph.facet.panes[""].layers[0]

  equal layer.geoms[0].marks[0].type, 'circle'
  equal layer.geoms[0].marks[0].x, 2
  equal layer.geoms[0].marks[0].y, 4
  deepEqual layer.geoms[0].marks[0].color, polyjs.debug.const.scaleFns.identity(layer.defaults.color)
  deepEqual layer.geoms[0].evtData.x.in, [2]
  deepEqual layer.geoms[0].evtData.y.in, [4]

  equal layer.geoms[1].marks[0].type, 'circle'
  equal layer.geoms[1].marks[0].x, 3
  equal layer.geoms[1].marks[0].y, 3
  deepEqual layer.geoms[1].marks[0].color, polyjs.debug.const.scaleFns.identity(layer.defaults.color)
  deepEqual layer.geoms[1].evtData.x.in, [3]
  deepEqual layer.geoms[1].evtData.y.in, [3]

test "lines", ->
  # single line
  jsondata= [
    {x: 2, y: 4},
    {x: 3, y: 3}
  ]
  data = polyjs.debug.data (data: jsondata)
  spec =
    render: false
    layers: [
      data: data, type: 'line', x: 'x', y: 'y'
    ]
  graph = polyjs.debug.chart spec
  layer = graph.facet.panes[""].layers[0]

  equal layer.geoms[0].marks[0].type, 'line'
  deepEqual layer.geoms[0].marks[0].x, [2, 3]
  deepEqual layer.geoms[0].marks[0].y, [4, 3]
  deepEqual layer.geoms[0].marks[0].color, polyjs.debug.const.scaleFns.identity(layer.defaults.color)
  deepEqual layer.geoms[0].evtData, {}

  # one grouping
  jsondata= [
    {x: 2, y: 4, z: 'A'}
    {x: 3, y: 3, z: 'A'}
    {x: 1, y: 4, z: 2}
    {x: 5, y: 3, z: 2}
  ]
  data = polyjs.debug.data (data: jsondata)
  spec =
    render: false
    layers: [
      data: data, type: 'line', x: 'x', y: 'y', color: 'z'
    ]
  graph = polyjs.debug.chart spec
  layer = graph.facet.panes[""].layers[0]

  equal layer.geoms[0].marks[0].type, 'line'
  deepEqual layer.geoms[0].marks[0].x, [2, 3, 1, 5]
  deepEqual layer.geoms[0].marks[0].y, [4, 3, undefined, undefined]
  deepEqual layer.geoms[0].marks[0].color, 'A'
  deepEqual layer.geoms[0].evtData.z.in, ['A']
  deepEqual layer.geoms[1].marks[0].x, [1, 5, 2, 3]
  deepEqual layer.geoms[1].marks[0].y, [4, 3, undefined, undefined]
  deepEqual layer.geoms[1].marks[0].color, 2
  deepEqual layer.geoms[1].evtData.z.in, [2]

test "bars", ->
  jsondata= [
    {x: 'A', y: 4, z: 'foo'},
    {x: 'A', y: 3, z: 'bar'}
  ]
  data = polyjs.debug.data (data: jsondata)
  spec =
    render: false
    layers: [
      data: data, type: 'bar', x: 'x', y: 'y', id: 'z'
    ]
  graph = polyjs.debug.chart spec
  layer = graph.facet.panes[""].layers[0]

  equal layer.geoms['foo'].marks[0].type, 'rect'
  deepEqual layer.geoms['foo'].marks[0].x[0] , polyjs.debug.const.scaleFns.lower 'A'
  deepEqual layer.geoms['foo'].marks[0].x[1] , polyjs.debug.const.scaleFns.upper 'A'
  equal layer.geoms['foo'].marks[0].y[0] , 0
  equal layer.geoms['foo'].marks[0].y[1] , 4
  equal layer.geoms['bar'].marks[0].type, 'rect'
  deepEqual layer.geoms['bar'].marks[0].x[0] , polyjs.debug.const.scaleFns.lower 'A'
  deepEqual layer.geoms['bar'].marks[0].x[1] , polyjs.debug.const.scaleFns.upper 'A'
  equal layer.geoms['bar'].marks[0].y[0] , 4
  equal layer.geoms['bar'].marks[0].y[1] , 7

