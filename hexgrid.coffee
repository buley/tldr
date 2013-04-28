if Meteor.isClient then window.Hexgrid = (->
  
  #config
  id = "hexgrid"
  log = ->
    console.log.apply console, arguments  if "undefined" isnt typeof console and "function" is typeof console.log

  hexround = (number) ->
    Math.ceil number #(Math.round(number * 4) / 4).toFixed(2);

  
  # Trig 
  Trig = ->

  Trig.radiansToDegrees = (a) ->
    a * (180 / Math.PI)

  Trig.degreesToRadians = (a) ->
    a * (Math.PI / 180)

  Trig.dotProduct = (a, b) ->
    n = 0
    lim = Math.min(a.length, b.length)
    i = 0

    while i < lim
      n += a[i] * b[i]
      i++
    n

  Trig.crossProduct = (a, b) ->

  
  #Barycentric coordinate method
  #background: http://www.blackpawn.com/texts/pointinpoly/default.html
  #via http://koozdra.wordpress.com/2012/06/27/javascript-is-point-in-triangle/
  Trig.insideTriangle = (px, py, ax, ay, bx, by_, cx, cy) ->
    v0 = [cx - ax, cy - ay]
    v1 = [bx - ax, by_ - ay]
    v2 = [px - ax, py - ay]
    dot00 = (v0[0] * v0[0]) + (v0[1] * v0[1])
    dot01 = (v0[0] * v1[0]) + (v0[1] * v1[1])
    dot02 = (v0[0] * v2[0]) + (v0[1] * v2[1])
    dot11 = (v1[0] * v1[0]) + (v1[1] * v1[1])
    dot12 = (v1[0] * v2[0]) + (v1[1] * v2[1])
    invDenom = 1 / (dot00 * dot11 - dot01 * dot01)
    u = (dot11 * dot02 - dot01 * dot12) * invDenom
    v = (dot00 * dot12 - dot01 * dot02) * invDenom
    (u >= 0) and (v >= 0) and (u + v < 1)

  Trig.sameSide = (p1, p2, a, b) ->
    cp1 = Trig.crossProduct(b - a, p1 - a)
    cp2 = Trig.crossProduct(b - a, p2 - a)
    if Trig.dotProduct(cp1, cp2) >= 0
      true
    else
      false

  
  # Hexagon 
  _sin_60 = Math.sin(Trig.degreesToRadians(60))
  Hexagon = (c, x, y) ->
    @a = .5 * c
    @b = hexround(_sin_60 * c)
    @c = c
    @xo = x
    @yo = y

  that = this
  Hexagon::draw = (ctx, type, line_color, line_width, fill) ->
    xo = @xo
    yo = @yo
    width = @width
    ctx.save()
    ctx.fillStyle = fill
    ctx.strokeStyle = line_color
    ctx.strokeWidth = line_width
    ctx.beginPath()
    ctx.moveTo xo, yo + (width - (.25 * width))
    x = 0
    points = @points()
    xlen = points.length
    point = undefined
    while x < 6
      point = points[x]
      ctx.lineTo point[0], point[1]
      x += 1
    ctx.closePath()
    ctx.fill()
    ctx.stroke()
    ctx.restore()
    if "box" is type
      
      #box right
      ctx.beginPath()
      ctx.fillStyle = "#eee"
      ctx.lineStyle = line_color
      ctx.lineWidth = line_width
      ctx.moveTo points[6][0], points[6][1]
      ctx.lineTo xo, yo + (width - (.25 * width))
      ctx.lineTo points[5][0], points[5][1]
      ctx.lineTo points[4][0], points[4][1]
      ctx.lineTo points[3][0], points[3][1]
      ctx.closePath()
      ctx.stroke()
      ctx.fill()
      
      #box left
      ctx.beginPath()
      ctx.fillStyle = "#ccc"
      ctx.lineStyle = line_color
      ctx.lineWidth = line_width
      ctx.moveTo points[0][0], points[0][1]
      ctx.lineTo points[1][0], points[1][1]
      ctx.lineTo points[6][0], points[6][1]
      ctx.lineTo points[5][0], points[5][1]
      ctx.closePath()
      ctx.stroke()
      ctx.fill()
      
      #box top
      ctx.fillStyle = "#ddd"
      ctx.lineStyle = line_color
      ctx.lineWidth = line_width
      ctx.beginPath()
      ctx.moveTo points[6][0], points[6][1]
      ctx.lineTo points[1][0], points[1][1]
      ctx.lineTo points[2][0], points[2][1]
      ctx.lineTo points[3][0], points[3][1]
      ctx.closePath()
      ctx.stroke()
      ctx.fill()
    else if "3d" is type
      
      #bottom left
      #top left
      ctx.beginPath()
      ctx.lineStyle = "transparent"
      ctx.fillStyle = "#ccc"
      ctx.lineWidth = line_width
      ctx.moveTo points[6][0], points[6][1]
      ctx.lineTo points[0][0], points[0][1]
      ctx.lineTo points[5][0], points[5][1]
      ctx.lineTo points[6][0], points[6][1]
      ctx.stroke()
      ctx.fill()
      
      #left
      ctx.beginPath()
      ctx.lineStyle = "transparent"
      ctx.lineWidth = line_width
      ctx.fillStyle = "#ccc"
      ctx.moveTo points[6][0], points[6][1]
      ctx.lineTo points[1][0], points[1][1]
      ctx.lineTo points[0][0], points[0][1]
      ctx.lineTo points[6][0], points[6][1]
      ctx.stroke()
      ctx.fill()
      
      #top right
      ctx.beginPath()
      ctx.fillStyle = "#ddd"
      ctx.lineStyle = "#000"
      ctx.lineWidth = line_width
      ctx.moveTo points[6][0], points[6][1]
      ctx.lineTo points[3][0], points[3][1]
      ctx.lineTo points[2][0], points[2][1]
      ctx.lineTo points[6][0], points[6][1]
      ctx.fill()
      ctx.stroke()
      
      #top left
      ctx.beginPath()
      ctx.lineStyle = "#000"
      ctx.fillStyle = "#ddd"
      ctx.lineWidth = line_width
      ctx.moveTo points[6][0], points[6][1]
      ctx.lineTo points[2][0], points[2][1]
      ctx.lineTo points[1][0], points[1][1]
      ctx.lineTo points[6][0], points[6][1]
      ctx.stroke()
      ctx.fill()
      
      #right
      ctx.beginPath()
      ctx.lineStyle = line_color
      ctx.fillStyle = "#eee"
      ctx.lineWidth = line_width
      ctx.moveTo points[6][0], points[6][1]
      ctx.lineTo points[4][0], points[4][1]
      ctx.lineTo points[3][0], points[3][1]
      ctx.lineTo points[6][0], points[6][1]
      ctx.stroke()
      ctx.fill()
      
      #bottom right
      ctx.beginPath()
      ctx.lineStyle = line_color
      ctx.fillStyle = "#eee"
      ctx.lineWidth = line_width
      ctx.moveTo points[6][0], points[6][1]
      ctx.lineTo points[5][0], points[5][1]
      ctx.lineTo points[4][0], points[4][1]
      ctx.lineTo points[6][0], points[6][1]
      ctx.stroke()
      ctx.fill()

  Hexagon::xoffset = ->
    @xo

  Hexagon::yoffset = ->
    @yo

  Hexagon::width = ->
    2 * @c

  Hexagon::points = ->
    [@one(), @two(), @three(), @four(), @five(), @six(), @seven()]

  
  #x,y
  Hexagon::one = ->
    [@xo, hexround(@yo + @a + @c)]

  Hexagon::two = ->
    [@xo, hexround(@yo + @a)]

  Hexagon::three = ->
    [hexround(@xo + @b), @yo + 0]

  Hexagon::four = ->
    [hexround(@xo + (2 * @b)), hexround(@yo + @a)]

  Hexagon::five = ->
    [hexround(@xo + (2 * @b)), hexround(@yo + @a + @c)]

  Hexagon::six = ->
    [hexround(@xo + @b), hexround(@yo + (2 * @c))]

  Hexagon::seven = ->
    [hexround(@xo + @b), hexround(@yo + (2 * @c - (2 * @a)))]

  Hexagon::eight = ->
    [hexround(@xo + @b), hexround(@yo + (2 * @a))]

  
  #we know you've clicked inside
  #the hexagon if either 1) you've clicked in the main rectangle (easy)
  #or in the upper or lower triangles (ungodly difficult for math mortals)
  #trading off speed for simplicity: the time it would take to figure to figure out which triangle to check didn't beat
  #just checking both traignels
  Hexagon::hit = (x, y) ->
    points = @points()
    result = false
    if x >= points[1][0] and x < points[3][0] and y >= points[1][1] and y < points[4][1]
      result = true
    else
      
      #bottom left
      #bottom right
      result = Trig.insideTriangle(x, y, points[0][0], points[0][1], points[5][0], points[5][1], points[4][0], points[4][1])
      
      #top right
      #top left
      result = Trig.insideTriangle(x, y, points[1][0], points[1][1], points[2][0], points[2][1], points[3][0], points[3][1])  if false is result
    result

  
  # API 
  that = this
  API = (hexagon, canvas, context) ->
    @hexagon = hexagon
    @context = context
    @canvas = canvas

  API::image = (options) ->
    return  if "undefined" is typeof options
    src = options.src
    xPt = options.x
    yPt = options.y
    width = options.width
    height = options.height
    clip = options.clip or {}
    clipX = clip.x
    clipY = clip.y
    clipWidth = clip.width
    clipHeight = clip.height
    img = new Image()
    img.src = src
    api = this
    img.onload = ->
      
      #standard
      ctx = api.context
      pts = api.hexagon.points()
      x = 1
      ptct = pts.length
      pt = undefined
      ctx.save()
      ctx.beginPath()
      ctx.moveTo pts[0][0], pts[0][1]
      while x < 6
        pt = pts[x]
        ctx.lineTo pts[x][0], pts[x][1]
        x += 1
      ctx.closePath()
      ctx.clip()
      if "undefined" isnt typeof clipWidth
        
        #sliced images
        log "1", clip
        
        #api.context.drawImage(img, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight);
        ctx.drawImage img, xPt, yPt, width, height, clipX, clipY, clipWidth, clipHeight
      else if "undefined" isnt typeof width
        
        #scaled images
        log "2"
        
        #api.context.drawImage(img, x, y, width, height);
        ctx.drawImage img, xPt, yPt, width, height
      else
        log "3"
        ctx.drawImage img, xPt, yPt
      ctx.restore()

  videos = {}
  API::video = (options) ->
    return  if "undefined" is typeof options
    src = options.src
    xPt = options.x
    yPt = options.y
    width = options.width
    height = options.height
    clip = options.clip or {}
    clipX = clip.x
    clipY = clip.y
    clipWidth = clip.width
    clipHeight = clip.height
    api = this
    if "undefined" is typeof videos[src]
      video = document.createElement("video")
      section.appendChild video
      sources = [src]
      sourcelen = sources.length
      x = 0
      source = undefined
      while x < sourcelen
        source = sources[x]
        source_el = document.createElement("source")
        source_el.src = source
        type = null
        if source.toLowerCase().match(/\.ogg$/) and "maybe" is video.canPlayType("video/ogg")
          type = "video/ogg"
        else if source.toLowerCase().match(/\.mp4$/) and "maybe" is video.canPlayType("video/mp4")
          type = "video/mp4"
        else type = "video/webm"  if source.toLowerCase().match(/\.webm$/) and "maybe" is video.canPlayType("video/webm")
        source.type = type
        video.addEventListener "canplay", ->
          video.play()

        video.appendChild source_el
        x += 1
      videos[src] = video
    ctx = api.context
    video = videos[src]
    pts = api.hexagon.points()
    ptct = pts.length
    pt = undefined
    x = undefined
    lineTo = ctx.lineTo
    moveTo = ctx.moveTo
    drawImage = ctx.drawImage
    args = undefined
    if "undefined" isnt typeof clipWidth
      args = [video, xPt, yPt, width, height, clipX, clipY, clipWidth, clipHeight]
    else if "undefined" isnt typeof width
      args = [video, xPt, yPt, width, height]
    else
      args = [video, xPt, yPt]
    register ->
      ctx.save()
      ctx.beginPath()
      moveTo.apply ctx, pts[0]
      x = 1
      while x < 6
        lineTo.apply ctx, pts[x] #[ 0 ], pts[ x ][ 1 ] );
        x += 1
      ctx.closePath()
      ctx.clip()
      drawImage.apply ctx, args
      ctx.restore()


  registered = []
  rlen = undefined
  x = undefined
  register = (fn) ->
    registered.push fn
    rlen = registered.length

  
  #http://paulirish.com/2011/requestanimationframe-for-smart-animating/
  window.requestAnimFrame = (->
    window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or (callback) ->
      window.setTimeout callback, 1000 / 60
  )()
  that = this
  (hexloop = ->
    requestAnimFrame hexloop
    registered.forEach (fn) ->
      fn.apply that, arguments

  )()
  app = undefined
  views = undefined
  assets = undefined
  foreground = undefined
  background = undefined
  
  # Public 
  Public = (args) ->
    attr = undefined
    cache = null
    
    #setup
    app = document.getElementById(args.id)
    if null is app or "undefined" is typeof app
      app = document.createElement("section")
      app.id = args.id
      app.style.display = "none"
      body = document.getElementsByTagName("body")[0]
      body.appendChild app
    views = document.getElementById(args.id + "-views")
    if null is views or "undefined" is typeof views
      views = document.createElement("section")
      views.id = args.id + "-views"
      views.style.height = "100%"
      app.appendChild views
    assets = document.getElementById(args.id + "-assets")
    if null is assets or "undefined" is typeof assets
      assets = document.createElement("section")
      assets.id = args.id +  "-assets"
      assets.style.display = "none"
      app.appendChild assets
    foreground = document.getElementById(args.id + "-foreground")
    if null is foreground or "undefined" is typeof foreground
      foreground = document.createElement("section")
      foreground.id = args.id + "-foreground"
      foreground.style.height = "100%"
      views.appendChild foreground
    background = document.getElementById(args.id + "-background")
    if null is background or "undefined" is typeof background
      background = document.createElement("section")
      background.id = args.id + "-background"
      background.style.display = "none"
      views.appendChild background
    if "undefined" isnt typeof args["video"]
      cache = ((arg, that) ->
        ->
          that.video arg
      )(args["video"], this)
      delete args["video"]
    else if "undefined" isnt typeof args["image"]
      cache = ((arg, that) ->
        ->
          that.image arg
      )(args["image"], this)
      delete args["image"]
    for attr of args
      this[attr] = args[attr]  if args.hasOwnProperty(attr)
    @run()
    cache()  if null isnt cache
    @

  Public::sources = ->
    { videos: videos }

  Public::run = ->
    that = this
    [@setup, @create, @draw].forEach (fn) ->
      fn.apply that, []


  Public::detect = (e, handler) ->
    clickX = e.clientX
    clickY = e.clientY
    x = 0
    xlen = @grid.length
    row = undefined
    while x < xlen
      row = @grid[x]
      if clickY > row[0].yoffset() and clickY < row[0].yoffset() + row[0].width()
        y = 0
        ylen = row.length
        item = undefined
        while y < ylen
          item = row[y]
          if true is item.hit(clickX, clickY)
            if "function" is typeof handler
              handler
                row: x
                column: (y + 1)
                data: item
                api: new API(item, @canvas, @context)

          y += 1
      x += 1

  last = new Date().getTime()
  Public::mousemove = (e) ->
    heat = @heat or total: 0
    spent = @spent or total: 0
    that = this
    @detect e, (d) ->
      data = d.data
      if "undefined" isnt typeof that.previous
        if that.previous.data isnt data
          heat["total"]++
          heat[d.row] = heat[d.row] or {}
          heat[d.row][d.column] = heat[d.row][d.column] or 0
          heat[d.row][d.column]++
          current = new Date().getTime()
          diff = (if (null is last) then 0 else (current - last))
          p = that.previous
          spent["total"] += diff
          
          #spent[ p.row ][ p.column ] += diff;
          spent[d.row] = spent[d.row] or {}
          spent[d.row][d.column] = spent[d.row][d.column] or 0
          spent[d.row][d.column] += diff
          that.onmouseout that.previous  if "function" is typeof that.onmouseout
          if "function" is typeof that.onmouseover
            d.relactivity = heat[d.row][d.column] / heat.total
            d.activity = heat[d.row][d.column]
            d.reltime = spent[d.row][d.column] / spent.total
            d.time = spent[d.row][d.column]
            that.onmouseover d
          that.heat = heat
          that.spent = spent
          last = current
      that.previous = d


  Public::click = (e) ->
    @detect e, @onclick

  Public::mouseover = (e) ->
    @detect e, @onmouseover

  Public::mouseout = (e) ->
    spent = @spent or total: 0
    console.log "OUT", spent
    last = null

  Public::setup = ->
    @node = foreground
    unless Public::setup.added
      @media = {}
      @media.canvas = document.createElement("canvas")
      @media.context = @media.canvas.getContext("2d")
      @media.canvas.id = "hexgrid-media" #config var
      foreground.appendChild @media.canvas
      @canvas = document.createElement("canvas")
      @context = @canvas.getContext("2d")
      @canvas.id = "hexgrid-interactive" #config var
      foreground.appendChild @canvas
      Public::setup.added = true
    @line_width = @line.width
    @line_style = @line.color
    @canvas.width = @node.clientWidth
    @canvas.style.width = @node.clientWidth
    @canvas.height = @node.clientHeight
    @canvas.style.height = @node.clientHeight
    @canvas.style.zIndex = 2
    @canvas.style.position = "absolute"
    @bounds = @canvas.getBoundingClientRect()
    @model = width: @side
    w = @canvas.width - @line_width
    h = @canvas.height - @line_width
    @rows = (h - (h % (@side * 1.5))) / (@side * 1.5)
    @count = ((w - (1 * @side)) - ((w - (1 * @side)) % (@side * 1.75))) / (@side * 1.75)
    
    #
    @media.canvas.width = @node.clientWidth
    @media.canvas.style.width = @node.clientWidth
    @media.canvas.height = @node.clientHeight
    @media.canvas.style.height = @node.clientHeight
    @media.canvas.style.zIndex = 1
    @media.canvas.style.position = "absolute"

  Public::setup.added = false
  Public::create = ->
    row = 0
    idx = undefined
    hexagons = undefined
    hexagon = undefined
    rows = []
    width = @model.width
    while row < @rows
      hexagons = []
      yoffset = (1.5 * @model.width) * (row - 1)
      idx = 0
      while idx < @count
        xoffset = undefined
        if row
          if 0 is row % 2
            
            #xoffset = 0;
            xoffset = .5 * (1.75 * @model.width) + (idx * (1.75 * @model.width))
          else
            xoffset = idx * (1.75 * @model.width)
        xoffset = 0  if "undefined" is typeof xoffset or xoffset < 0
        yoffset = 0  if "undefined" is typeof yoffset or yoffset < 0
        hex = new Hexagon(width, xoffset, yoffset)
        hexagons.push hex
        idx += 1
      rows.push hexagons
      row += 1
    @grid = rows

  Public::draw = ->
    x = 0
    y = undefined
    rowlen = undefined
    gridlen = @grid.length
    row = undefined
    hex = undefined
    points = undefined
    while x < gridlen
      row = @grid[x]
      rowlen = row.length
      y = 0
      while y < rowlen
        hex = row[y]
        @hexagon hex
        y += 1
      x += 1
    unless Public::draw.added
      that = this
      window.addEventListener "resize", ->
        that.run.apply that, arguments

      @canvas.addEventListener "click", ->
        that.click.apply that, arguments

      @canvas.addEventListener "mousemove", ->
        that.mousemove.apply that, arguments

      @canvas.addEventListener "mouseout", ->
        that.mouseout.apply that, arguments

      Public::draw.added = true

  Public::hexagon = (hex) ->
    points = hex.points()
    xo = hex.xoffset()
    yo = hex.yoffset()
    width = hex.width()
    
    #this.box = ( Math.random() >.5 ) ? true : false;
    #this.threed = ( Math.random() > .7 ) ? true : false;
    boxtype = "normal"
    hex.draw @context, boxtype, @line.color, @line.width, @fill
    if "function" is typeof @ondraw
      @ondraw
        data: hex
        api: new API(hex, @canvas, @context)


  Public::video = (options) ->
    console.log "vargs", options
    return  if "undefined" is typeof options
    src = options.src
    xPt = options.x
    yPt = options.y
    width = options.width
    height = options.height
    clip = options.clip or {}
    clipX = clip.x
    clipY = clip.y
    clipWidth = clip.width
    clipHeight = clip.height
    api = this
    
    #setup
    if "undefined" is typeof videos[src]
      video = document.createElement("video")
      assets.appendChild video
      sources = [src]
      sourcelen = sources.length
      x = 0
      source = undefined
      while x < sourcelen
        source = sources[x]
        source_el = document.createElement("source")
        source_el.src = source
        type = null
        if source.toLowerCase().match(/\.ogg$/) and "maybe" is video.canPlayType("video/ogg")
          type = "video/ogg"
        else if source.toLowerCase().match(/\.mp4$/) and "maybe" is video.canPlayType("video/mp4")
          type = "video/mp4"
        else type = "video/webm"  if source.toLowerCase().match(/\.webm$/) and "maybe" is video.canPlayType("video/webm")
        source.type = type
        video.appendChild source_el
        x += 1
      videos[src] = video
    console.log "XXX", @media.context
    ctx = @media.context
    video = videos[src]
    x = undefined
    drawImage = ctx.drawImage
    args = undefined
    if "undefined" isnt typeof clipWidth
      args = [video, xPt, yPt, width, height, clipX, clipY, clipWidth, clipHeight]
    else if "undefined" isnt typeof width
      args = [video, xPt, yPt, width, height]
    else
      args = [video, xPt, yPt]
    register ->
      drawImage.apply ctx, args


  Public::image = (obj) ->

  Public::draw.added = false
  Public
)()
