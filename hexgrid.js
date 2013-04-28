// Generated by CoffeeScript 1.4.0
(function() {

  if (Meteor.isClient) {
    window.Hexgrid = (function() {
      var API, Hexagon, Public, Trig, app, assets, background, foreground, hexloop, hexround, id, last, log, register, registered, rlen, that, videos, views, x, _sin_60;
      id = "hexgrid";
      log = function() {
        if ("undefined" !== typeof console && "function" === typeof console.log) {
          return console.log.apply(console, arguments);
        }
      };
      hexround = function(number) {
        return Math.ceil(number);
      };
      Trig = function() {};
      Trig.radiansToDegrees = function(a) {
        return a * (180 / Math.PI);
      };
      Trig.degreesToRadians = function(a) {
        return a * (Math.PI / 180);
      };
      Trig.dotProduct = function(a, b) {
        var i, lim, n;
        n = 0;
        lim = Math.min(a.length, b.length);
        i = 0;
        while (i < lim) {
          n += a[i] * b[i];
          i++;
        }
        return n;
      };
      Trig.crossProduct = function(a, b) {};
      Trig.insideTriangle = function(px, py, ax, ay, bx, by_, cx, cy) {
        var dot00, dot01, dot02, dot11, dot12, invDenom, u, v, v0, v1, v2;
        v0 = [cx - ax, cy - ay];
        v1 = [bx - ax, by_ - ay];
        v2 = [px - ax, py - ay];
        dot00 = (v0[0] * v0[0]) + (v0[1] * v0[1]);
        dot01 = (v0[0] * v1[0]) + (v0[1] * v1[1]);
        dot02 = (v0[0] * v2[0]) + (v0[1] * v2[1]);
        dot11 = (v1[0] * v1[0]) + (v1[1] * v1[1]);
        dot12 = (v1[0] * v2[0]) + (v1[1] * v2[1]);
        invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
        u = (dot11 * dot02 - dot01 * dot12) * invDenom;
        v = (dot00 * dot12 - dot01 * dot02) * invDenom;
        return (u >= 0) && (v >= 0) && (u + v < 1);
      };
      Trig.sameSide = function(p1, p2, a, b) {
        var cp1, cp2;
        cp1 = Trig.crossProduct(b - a, p1 - a);
        cp2 = Trig.crossProduct(b - a, p2 - a);
        if (Trig.dotProduct(cp1, cp2) >= 0) {
          return true;
        } else {
          return false;
        }
      };
      _sin_60 = Math.sin(Trig.degreesToRadians(60));
      Hexagon = function(c, x, y) {
        this.a = .5 * c;
        this.b = hexround(_sin_60 * c);
        this.c = c;
        this.xo = x;
        return this.yo = y;
      };
      that = this;
      Hexagon.prototype.draw = function(ctx, type, line_color, line_width, fill) {
        var point, points, width, x, xlen, xo, yo;
        xo = this.xo;
        yo = this.yo;
        width = this.width;
        ctx.save();
        ctx.fillStyle = fill;
        ctx.strokeStyle = line_color;
        ctx.strokeWidth = line_width;
        ctx.beginPath();
        ctx.moveTo(xo, yo + (width - (.25 * width)));
        x = 0;
        points = this.points();
        xlen = points.length;
        point = void 0;
        while (x < 6) {
          point = points[x];
          ctx.lineTo(point[0], point[1]);
          x += 1;
        }
        ctx.closePath();
        ctx.fill();
        ctx.stroke();
        ctx.restore();
        if ("box" === type) {
          ctx.beginPath();
          ctx.fillStyle = "#eee";
          ctx.lineStyle = line_color;
          ctx.lineWidth = line_width;
          ctx.moveTo(points[6][0], points[6][1]);
          ctx.lineTo(xo, yo + (width - (.25 * width)));
          ctx.lineTo(points[5][0], points[5][1]);
          ctx.lineTo(points[4][0], points[4][1]);
          ctx.lineTo(points[3][0], points[3][1]);
          ctx.closePath();
          ctx.stroke();
          ctx.fill();
          ctx.beginPath();
          ctx.fillStyle = "#ccc";
          ctx.lineStyle = line_color;
          ctx.lineWidth = line_width;
          ctx.moveTo(points[0][0], points[0][1]);
          ctx.lineTo(points[1][0], points[1][1]);
          ctx.lineTo(points[6][0], points[6][1]);
          ctx.lineTo(points[5][0], points[5][1]);
          ctx.closePath();
          ctx.stroke();
          ctx.fill();
          ctx.fillStyle = "#ddd";
          ctx.lineStyle = line_color;
          ctx.lineWidth = line_width;
          ctx.beginPath();
          ctx.moveTo(points[6][0], points[6][1]);
          ctx.lineTo(points[1][0], points[1][1]);
          ctx.lineTo(points[2][0], points[2][1]);
          ctx.lineTo(points[3][0], points[3][1]);
          ctx.closePath();
          ctx.stroke();
          return ctx.fill();
        } else if ("3d" === type) {
          ctx.beginPath();
          ctx.lineStyle = "transparent";
          ctx.fillStyle = "#ccc";
          ctx.lineWidth = line_width;
          ctx.moveTo(points[6][0], points[6][1]);
          ctx.lineTo(points[0][0], points[0][1]);
          ctx.lineTo(points[5][0], points[5][1]);
          ctx.lineTo(points[6][0], points[6][1]);
          ctx.stroke();
          ctx.fill();
          ctx.beginPath();
          ctx.lineStyle = "transparent";
          ctx.lineWidth = line_width;
          ctx.fillStyle = "#ccc";
          ctx.moveTo(points[6][0], points[6][1]);
          ctx.lineTo(points[1][0], points[1][1]);
          ctx.lineTo(points[0][0], points[0][1]);
          ctx.lineTo(points[6][0], points[6][1]);
          ctx.stroke();
          ctx.fill();
          ctx.beginPath();
          ctx.fillStyle = "#ddd";
          ctx.lineStyle = "#000";
          ctx.lineWidth = line_width;
          ctx.moveTo(points[6][0], points[6][1]);
          ctx.lineTo(points[3][0], points[3][1]);
          ctx.lineTo(points[2][0], points[2][1]);
          ctx.lineTo(points[6][0], points[6][1]);
          ctx.fill();
          ctx.stroke();
          ctx.beginPath();
          ctx.lineStyle = "#000";
          ctx.fillStyle = "#ddd";
          ctx.lineWidth = line_width;
          ctx.moveTo(points[6][0], points[6][1]);
          ctx.lineTo(points[2][0], points[2][1]);
          ctx.lineTo(points[1][0], points[1][1]);
          ctx.lineTo(points[6][0], points[6][1]);
          ctx.stroke();
          ctx.fill();
          ctx.beginPath();
          ctx.lineStyle = line_color;
          ctx.fillStyle = "#eee";
          ctx.lineWidth = line_width;
          ctx.moveTo(points[6][0], points[6][1]);
          ctx.lineTo(points[4][0], points[4][1]);
          ctx.lineTo(points[3][0], points[3][1]);
          ctx.lineTo(points[6][0], points[6][1]);
          ctx.stroke();
          ctx.fill();
          ctx.beginPath();
          ctx.lineStyle = line_color;
          ctx.fillStyle = "#eee";
          ctx.lineWidth = line_width;
          ctx.moveTo(points[6][0], points[6][1]);
          ctx.lineTo(points[5][0], points[5][1]);
          ctx.lineTo(points[4][0], points[4][1]);
          ctx.lineTo(points[6][0], points[6][1]);
          ctx.stroke();
          return ctx.fill();
        }
      };
      Hexagon.prototype.xoffset = function() {
        return this.xo;
      };
      Hexagon.prototype.yoffset = function() {
        return this.yo;
      };
      Hexagon.prototype.width = function() {
        return 2 * this.c;
      };
      Hexagon.prototype.points = function() {
        return [this.one(), this.two(), this.three(), this.four(), this.five(), this.six(), this.seven()];
      };
      Hexagon.prototype.one = function() {
        return [this.xo, hexround(this.yo + this.a + this.c)];
      };
      Hexagon.prototype.two = function() {
        return [this.xo, hexround(this.yo + this.a)];
      };
      Hexagon.prototype.three = function() {
        return [hexround(this.xo + this.b), this.yo + 0];
      };
      Hexagon.prototype.four = function() {
        return [hexround(this.xo + (2 * this.b)), hexround(this.yo + this.a)];
      };
      Hexagon.prototype.five = function() {
        return [hexround(this.xo + (2 * this.b)), hexround(this.yo + this.a + this.c)];
      };
      Hexagon.prototype.six = function() {
        return [hexround(this.xo + this.b), hexround(this.yo + (2 * this.c))];
      };
      Hexagon.prototype.seven = function() {
        return [hexround(this.xo + this.b), hexround(this.yo + (2 * this.c - (2 * this.a)))];
      };
      Hexagon.prototype.eight = function() {
        return [hexround(this.xo + this.b), hexround(this.yo + (2 * this.a))];
      };
      Hexagon.prototype.hit = function(x, y) {
        var points, result;
        points = this.points();
        result = false;
        if (x >= points[1][0] && x < points[3][0] && y >= points[1][1] && y < points[4][1]) {
          result = true;
        } else {
          result = Trig.insideTriangle(x, y, points[0][0], points[0][1], points[5][0], points[5][1], points[4][0], points[4][1]);
          if (false === result) {
            result = Trig.insideTriangle(x, y, points[1][0], points[1][1], points[2][0], points[2][1], points[3][0], points[3][1]);
          }
        }
        return result;
      };
      that = this;
      API = function(hexagon, canvas, context) {
        this.hexagon = hexagon;
        this.context = context;
        return this.canvas = canvas;
      };
      API.prototype.image = function(options) {
        var api, clip, clipHeight, clipWidth, clipX, clipY, height, img, src, width, xPt, yPt;
        if ("undefined" === typeof options) {
          return;
        }
        src = options.src;
        xPt = options.x;
        yPt = options.y;
        width = options.width;
        height = options.height;
        clip = options.clip || {};
        clipX = clip.x;
        clipY = clip.y;
        clipWidth = clip.width;
        clipHeight = clip.height;
        img = new Image();
        img.src = src;
        api = this;
        return img.onload = function() {
          var ctx, pt, ptct, pts, x;
          ctx = api.context;
          pts = api.hexagon.points();
          x = 1;
          ptct = pts.length;
          pt = void 0;
          ctx.save();
          ctx.beginPath();
          ctx.moveTo(pts[0][0], pts[0][1]);
          while (x < 6) {
            pt = pts[x];
            ctx.lineTo(pts[x][0], pts[x][1]);
            x += 1;
          }
          ctx.closePath();
          ctx.clip();
          if ("undefined" !== typeof clipWidth) {
            log("1", clip);
            ctx.drawImage(img, xPt, yPt, width, height, clipX, clipY, clipWidth, clipHeight);
          } else if ("undefined" !== typeof width) {
            log("2");
            ctx.drawImage(img, xPt, yPt, width, height);
          } else {
            log("3");
            ctx.drawImage(img, xPt, yPt);
          }
          return ctx.restore();
        };
      };
      videos = {};
      API.prototype.video = function(options) {
        var api, args, clip, clipHeight, clipWidth, clipX, clipY, ctx, drawImage, height, lineTo, moveTo, pt, ptct, pts, source, source_el, sourcelen, sources, src, type, video, width, x, xPt, yPt;
        if ("undefined" === typeof options) {
          return;
        }
        src = options.src;
        xPt = options.x;
        yPt = options.y;
        width = options.width;
        height = options.height;
        clip = options.clip || {};
        clipX = clip.x;
        clipY = clip.y;
        clipWidth = clip.width;
        clipHeight = clip.height;
        api = this;
        if ("undefined" === typeof videos[src]) {
          video = document.createElement("video");
          section.appendChild(video);
          sources = [src];
          sourcelen = sources.length;
          x = 0;
          source = void 0;
          while (x < sourcelen) {
            source = sources[x];
            source_el = document.createElement("source");
            source_el.src = source;
            type = null;
            if (source.toLowerCase().match(/\.ogg$/) && "maybe" === video.canPlayType("video/ogg")) {
              type = "video/ogg";
            } else if (source.toLowerCase().match(/\.mp4$/) && "maybe" === video.canPlayType("video/mp4")) {
              type = "video/mp4";
            } else {
              if (source.toLowerCase().match(/\.webm$/) && "maybe" === video.canPlayType("video/webm")) {
                type = "video/webm";
              }
            }
            source.type = type;
            video.addEventListener("canplay", function() {
              return video.play();
            });
            video.appendChild(source_el);
            x += 1;
          }
          videos[src] = video;
        }
        ctx = api.context;
        video = videos[src];
        pts = api.hexagon.points();
        ptct = pts.length;
        pt = void 0;
        x = void 0;
        lineTo = ctx.lineTo;
        moveTo = ctx.moveTo;
        drawImage = ctx.drawImage;
        args = void 0;
        if ("undefined" !== typeof clipWidth) {
          args = [video, xPt, yPt, width, height, clipX, clipY, clipWidth, clipHeight];
        } else if ("undefined" !== typeof width) {
          args = [video, xPt, yPt, width, height];
        } else {
          args = [video, xPt, yPt];
        }
        return register(function() {
          ctx.save();
          ctx.beginPath();
          moveTo.apply(ctx, pts[0]);
          x = 1;
          while (x < 6) {
            lineTo.apply(ctx, pts[x]);
            x += 1;
          }
          ctx.closePath();
          ctx.clip();
          drawImage.apply(ctx, args);
          return ctx.restore();
        });
      };
      registered = [];
      rlen = void 0;
      x = void 0;
      register = function(fn) {
        registered.push(fn);
        return rlen = registered.length;
      };
      window.requestAnimFrame = (function() {
        return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || function(callback) {
          return window.setTimeout(callback, 1000 / 60);
        };
      })();
      that = this;
      (hexloop = function() {
        requestAnimFrame(hexloop);
        return registered.forEach(function(fn) {
          return fn.apply(that, arguments);
        });
      })();
      app = void 0;
      views = void 0;
      assets = void 0;
      foreground = void 0;
      background = void 0;
      Public = function(args) {
        var attr, body, cache;
        attr = void 0;
        cache = null;
        app = document.getElementById(args.id);
        if (null === app || "undefined" === typeof app) {
          app = document.createElement("section");
          app.id = args.id;
          app.style.display = "none";
          body = document.getElementsByTagName("body")[0];
          body.appendChild(app);
        }
        views = document.getElementById(args.id + "-views");
        if (null === views || "undefined" === typeof views) {
          views = document.createElement("section");
          views.id = args.id + "-views";
          views.style.height = "100%";
          app.appendChild(views);
        }
        assets = document.getElementById(args.id + "-assets");
        if (null === assets || "undefined" === typeof assets) {
          assets = document.createElement("section");
          assets.id = args.id + "-assets";
          assets.style.display = "none";
          app.appendChild(assets);
        }
        foreground = document.getElementById(args.id + "-foreground");
        if (null === foreground || "undefined" === typeof foreground) {
          foreground = document.createElement("section");
          foreground.id = args.id + "-foreground";
          foreground.style.height = "100%";
          views.appendChild(foreground);
        }
        background = document.getElementById(args.id + "-background");
        if (null === background || "undefined" === typeof background) {
          background = document.createElement("section");
          background.id = args.id + "-background";
          background.style.display = "none";
          views.appendChild(background);
        }
        if ("undefined" !== typeof args["video"]) {
          cache = (function(arg, that) {
            return function() {
              return that.video(arg);
            };
          })(args["video"], this);
          delete args["video"];
        } else if ("undefined" !== typeof args["image"]) {
          cache = (function(arg, that) {
            return function() {
              return that.image(arg);
            };
          })(args["image"], this);
          delete args["image"];
        }
        for (attr in args) {
          if (args.hasOwnProperty(attr)) {
            this[attr] = args[attr];
          }
        }
        this.run();
        if (null !== cache) {
          cache();
        }
        return this;
      };
      Public.prototype.sources = function() {
        return {
          videos: videos
        };
      };
      Public.prototype.run = function() {
        that = this;
        return [this.setup, this.create, this.draw].forEach(function(fn) {
          return fn.apply(that, []);
        });
      };
      Public.prototype.detect = function(e, handler) {
        var clickX, clickY, item, row, xlen, y, ylen, _results;
        clickX = e.clientX;
        clickY = e.clientY;
        x = 0;
        xlen = this.grid.length;
        row = void 0;
        _results = [];
        while (x < xlen) {
          row = this.grid[x];
          if (clickY > row[0].yoffset() && clickY < row[0].yoffset() + row[0].width()) {
            y = 0;
            ylen = row.length;
            item = void 0;
            while (y < ylen) {
              item = row[y];
              if (true === item.hit(clickX, clickY)) {
                if ("function" === typeof handler) {
                  handler({
                    row: x,
                    column: y + 1,
                    data: item,
                    api: new API(item, this.canvas, this.context)
                  });
                }
              }
              y += 1;
            }
          }
          _results.push(x += 1);
        }
        return _results;
      };
      last = new Date().getTime();
      Public.prototype.mousemove = function(e) {
        var heat, spent;
        heat = this.heat || {
          total: 0
        };
        spent = this.spent || {
          total: 0
        };
        that = this;
        return this.detect(e, function(d) {
          var current, data, diff, p;
          data = d.data;
          if ("undefined" !== typeof that.previous) {
            if (that.previous.data !== data) {
              heat["total"]++;
              heat[d.row] = heat[d.row] || {};
              heat[d.row][d.column] = heat[d.row][d.column] || 0;
              heat[d.row][d.column]++;
              current = new Date().getTime();
              diff = (null === last ? 0 : current - last);
              p = that.previous;
              spent["total"] += diff;
              spent[d.row] = spent[d.row] || {};
              spent[d.row][d.column] = spent[d.row][d.column] || 0;
              spent[d.row][d.column] += diff;
              if ("function" === typeof that.onmouseout) {
                that.onmouseout(that.previous);
              }
              if ("function" === typeof that.onmouseover) {
                d.relactivity = heat[d.row][d.column] / heat.total;
                d.activity = heat[d.row][d.column];
                d.reltime = spent[d.row][d.column] / spent.total;
                d.time = spent[d.row][d.column];
                that.onmouseover(d);
              }
              that.heat = heat;
              that.spent = spent;
              last = current;
            }
          }
          return that.previous = d;
        });
      };
      Public.prototype.click = function(e) {
        return this.detect(e, this.onclick);
      };
      Public.prototype.mouseover = function(e) {
        return this.detect(e, this.onmouseover);
      };
      Public.prototype.mouseout = function(e) {
        var spent;
        spent = this.spent || {
          total: 0
        };
        console.log("OUT", spent);
        return last = null;
      };
      Public.prototype.setup = function() {
        var h, w;
        this.node = foreground;
        if (!Public.prototype.setup.added) {
          this.media = {};
          this.media.canvas = document.createElement("canvas");
          this.media.context = this.media.canvas.getContext("2d");
          this.media.canvas.id = "hexgrid-media";
          foreground.appendChild(this.media.canvas);
          this.canvas = document.createElement("canvas");
          this.context = this.canvas.getContext("2d");
          this.canvas.id = "hexgrid-interactive";
          foreground.appendChild(this.canvas);
          Public.prototype.setup.added = true;
        }
        this.line_width = this.line.width;
        this.line_style = this.line.color;
        this.canvas.width = this.node.clientWidth;
        this.canvas.style.width = this.node.clientWidth;
        this.canvas.height = this.node.clientHeight;
        this.canvas.style.height = this.node.clientHeight;
        this.canvas.style.zIndex = 2;
        this.canvas.style.position = "absolute";
        this.bounds = this.canvas.getBoundingClientRect();
        this.model = {
          width: this.side
        };
        w = this.canvas.width - this.line_width;
        h = this.canvas.height - this.line_width;
        this.rows = (h - (h % (this.side * 1.5))) / (this.side * 1.5);
        this.count = ((w - (1 * this.side)) - ((w - (1 * this.side)) % (this.side * 1.75))) / (this.side * 1.75);
        this.media.canvas.width = this.node.clientWidth;
        this.media.canvas.style.width = this.node.clientWidth;
        this.media.canvas.height = this.node.clientHeight;
        this.media.canvas.style.height = this.node.clientHeight;
        this.media.canvas.style.zIndex = 1;
        return this.media.canvas.style.position = "absolute";
      };
      Public.prototype.setup.added = false;
      Public.prototype.create = function() {
        var hex, hexagon, hexagons, idx, row, rows, width, xoffset, yoffset;
        row = 0;
        idx = void 0;
        hexagons = void 0;
        hexagon = void 0;
        rows = [];
        width = this.model.width;
        while (row < this.rows) {
          hexagons = [];
          yoffset = (1.5 * this.model.width) * (row - 1);
          idx = 0;
          while (idx < this.count) {
            xoffset = void 0;
            if (row) {
              if (0 === row % 2) {
                xoffset = .5 * (1.75 * this.model.width) + (idx * (1.75 * this.model.width));
              } else {
                xoffset = idx * (1.75 * this.model.width);
              }
            }
            if ("undefined" === typeof xoffset || xoffset < 0) {
              xoffset = 0;
            }
            if ("undefined" === typeof yoffset || yoffset < 0) {
              yoffset = 0;
            }
            hex = new Hexagon(width, xoffset, yoffset);
            hexagons.push(hex);
            idx += 1;
          }
          rows.push(hexagons);
          row += 1;
        }
        return this.grid = rows;
      };
      Public.prototype.draw = function() {
        var gridlen, hex, points, row, rowlen, y;
        x = 0;
        y = void 0;
        rowlen = void 0;
        gridlen = this.grid.length;
        row = void 0;
        hex = void 0;
        points = void 0;
        while (x < gridlen) {
          row = this.grid[x];
          rowlen = row.length;
          y = 0;
          while (y < rowlen) {
            hex = row[y];
            this.hexagon(hex);
            y += 1;
          }
          x += 1;
        }
        if (!Public.prototype.draw.added) {
          that = this;
          window.addEventListener("resize", function() {
            return that.run.apply(that, arguments);
          });
          this.canvas.addEventListener("click", function() {
            return that.click.apply(that, arguments);
          });
          this.canvas.addEventListener("mousemove", function() {
            return that.mousemove.apply(that, arguments);
          });
          this.canvas.addEventListener("mouseout", function() {
            return that.mouseout.apply(that, arguments);
          });
          return Public.prototype.draw.added = true;
        }
      };
      Public.prototype.hexagon = function(hex) {
        var boxtype, points, width, xo, yo;
        points = hex.points();
        xo = hex.xoffset();
        yo = hex.yoffset();
        width = hex.width();
        boxtype = "normal";
        hex.draw(this.context, boxtype, this.line.color, this.line.width, this.fill);
        if ("function" === typeof this.ondraw) {
          return this.ondraw({
            data: hex,
            api: new API(hex, this.canvas, this.context)
          });
        }
      };
      Public.prototype.video = function(options) {
        var api, args, clip, clipHeight, clipWidth, clipX, clipY, ctx, drawImage, height, source, source_el, sourcelen, sources, src, type, video, width, xPt, yPt;
        console.log("vargs", options);
        if ("undefined" === typeof options) {
          return;
        }
        src = options.src;
        xPt = options.x;
        yPt = options.y;
        width = options.width;
        height = options.height;
        clip = options.clip || {};
        clipX = clip.x;
        clipY = clip.y;
        clipWidth = clip.width;
        clipHeight = clip.height;
        api = this;
        if ("undefined" === typeof videos[src]) {
          video = document.createElement("video");
          assets.appendChild(video);
          sources = [src];
          sourcelen = sources.length;
          x = 0;
          source = void 0;
          while (x < sourcelen) {
            source = sources[x];
            source_el = document.createElement("source");
            source_el.src = source;
            type = null;
            if (source.toLowerCase().match(/\.ogg$/) && "maybe" === video.canPlayType("video/ogg")) {
              type = "video/ogg";
            } else if (source.toLowerCase().match(/\.mp4$/) && "maybe" === video.canPlayType("video/mp4")) {
              type = "video/mp4";
            } else {
              if (source.toLowerCase().match(/\.webm$/) && "maybe" === video.canPlayType("video/webm")) {
                type = "video/webm";
              }
            }
            source.type = type;
            video.addEventListener("canplay", function() {
              return video.play();
            });
            video.appendChild(source_el);
            x += 1;
          }
          videos[src] = video;
        }
        console.log("XXX", this.media.context);
        ctx = this.media.context;
        video = videos[src];
        x = void 0;
        drawImage = ctx.drawImage;
        args = void 0;
        if ("undefined" !== typeof clipWidth) {
          args = [video, xPt, yPt, width, height, clipX, clipY, clipWidth, clipHeight];
        } else if ("undefined" !== typeof width) {
          args = [video, xPt, yPt, width, height];
        } else {
          args = [video, xPt, yPt];
        }
        return register(function() {
          return drawImage.apply(ctx, args);
        });
      };
      Public.prototype.image = function(obj) {};
      Public.prototype.draw.added = false;
      return Public;
    })();
  }

}).call(this);
