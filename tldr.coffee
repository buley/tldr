# Stories
Stories = new Meteor.Collection("stories");
Users = new Meteor.Collection("users");
that = @
that.video = null

timestampToPrettyDate = (t) ->
  running = Math.round(t)
  remainder = running % 3600
  running = ( running - ( running % 3600 ) )
  hours = ( running / 3600 ).toString()
  hours = if ( hours.toString().length < 2 ) then "0" + hours else hours.toString()
  running = remainder
  remainder = running % 60
  running = ( running - ( running % 60 ) )
  minutes = ( running / 60 ).toString()
  minutes = if ( minutes.length < 2 ) then "0" + minutes else minutes
  seconds = remainder.toString()
  seconds = if ( seconds.length < 2 ) then "0" + seconds else seconds
  [ hours, minutes, seconds ].join( ":" )


Meteor.startup( () ->
  if Meteor.isClient
    flyouts$ = $("#tldr-flyouts")
    right$ = $("#tldr-right")
    narrative_container$ = $("#tldr-narrative-container")
    narrative$ = $("#tldr-narrative")
    media$ = $("#tldr-media")
    media_container$ = $("#tldr-media-container")
    settings$ = $("#tldr-settings")
    settings_container$ = $("#tldr-settings-container")
    tightenUI = () ->
      max = right$.outerHeight() + "px"
      flyouts$.css( 'max-height',max )
      narrative_container$.css('max-height', max)
      narrative$.css( 'max-height', max)
      media$.css( 'max-height', max)
      media_container$.css('max-height', max)
      settings$.css( 'max-height', max)
      settings_container$.css('max-height', max)

    tightenUI()
    window.addEventListener 'resize', (e) -> tightenUI()

    Video = (obj) ->
      video = obj.video
      muted = obj.muted
      rate = obj.rate
      @onprogress = []
      @onplay = []
      @onpause = []
      @onstop = []
      if 'function' is typeof obj.progress then @onprogress.push obj.progress
      if 'function' is typeof obj.stop then @onstop.push obj.stop
      if 'function' is typeof obj.pause then @onpause.push obj.pause
      if 'function' is typeof obj.play then @onplay.push obj.play
      progress = obj.progress
      instance = @
      @video = video
      @video.defaultMuted = !!muted | false;
      @video.defaultPlaybackRate = if !!rate then rate else 1
      #posterframe
      #autoplay
      @video.addEventListener( 'progress', (e) ->
        el = e.srcElement
        duration = el.duration
        location = el.currentTime
        buffered = instance.buffered()
        seekable = instance.seekable()
        instance._callback( instance.onprogress, [
          duration: duration
          location: location
          timeline: instance._timeline( location, duration, buffered, seekable )
          buffered: buffered
          seekable: seekable
        ] )
      )
      @

    Video::play = () -> @video.play() && @_callback( @onplay )
    Video::pause = () -> @video.pause() && @_callback( @onpause )
    Video::stop = () -> @video.stop() && @_callback( @onstop )
    Video::skip = (percentage) -> @video.currentTime = @video.duration * percentage
    Video::faster = () -> ++@video.playbackRate
    Video::slower = () -> --@video.playbackRate
    Video::rate = (r) -> @video.playbackRate = r
    Video::mute = () -> @video.mute = true
    Video::unmute = () -> @video.mute = false
    Video::buffered = () ->
      @_iterateTimeRanges( @video.buffered )
    Video::seekable = () ->
      @_iterateTimeRanges( @video.seekable )
    Video::played = () ->
      @_iterateTimeRanges( @video.played )
    Video::_timeline = (location, duration, buffered, seekable) ->
      timeline = []
      last = null
      for i, range in buffered
        begin = range[ 0 ]
        end = range[ 1 ]
        if null isnt last then timeline.push [ begin - ( begin - last ), begin ]
        else
          timeline.push( range )
          last = end
        timeline
    Video::_callback = (stack, args) ->
      for fn in stack
        if 'function' is typeof fn then fn.apply(@,args)

    Video::_iterateTimeRanges = (obj) ->
      collection = []
      collection.push [ obj.start( i ), obj.end( i ) ] for _b, i in obj
      collection
    Video::media = () -> @video

    id = currentId()
    Session.setDefault('token', id );

    Meteor.subscribe( 'stories', () ->
      loadStory( id, (story) ->

        Session.setDefault('story', story );
        $( '.tldr-title' ).val( story.url );
        grid = createGrid( story.url )
        media = grid.sources()
        videos = media.videos
        that.video = new Video( {
          video: videos[ story.url ]
          play: () ->
            $('.tldr-button-play').hide()
            $('.tldr-button-pause').show()
          pause: () ->
            $('.tldr-button-play').hide()
            $('.tldr-button-pause').show()
          stop: () ->
            $('.tldr-button-play').show()
            $('.tldr-button-pause').hide()
          progress: (state) ->
              complete = state.location / state.duration
              console.log('progress',state,complete)
              ###
              total_width = $( "#tldr-scrubber" ).outerWidth()
              if false is isNaN complete
                width = Math.floor( complete * total_width )
                $( "#tldr-scrubber-bar-left-loaded" ).css( 'width', Math.floor( width ) + 'px' )
                try
                  end = video.buffered.end(0)
                  loaded_pixels = end - width
                  $("#tldr-scrubber-bar-right-loaded").width( loaded_pixels + 'px');
                catch error
                  #TODO: do something
                  #console.log( 'no buffering avail', error )
              ###
        } )
      )
      if true is isEditing()
        populateNarrative( id )
    )
  else if Meteor.isServer
    Meteor.publish( "stories", () ->
      Stories.find({}, {fields: { _id: 1, token: 1, modified: 1, narratives: 1, url: 'https://s3.amazonaws.com/hazy.co/sky.mov' }} )
    )
)

currentId = () ->
  document.location.pathname.replace(/^\//,'')

currentMode = () ->
  document.location.hash.replace(/^#/,'')

getStories = () ->
  Stories.find().fetch()

countStories = () ->
  Stories.find().fetch().length

loadStory = (id, fn) ->
  story = getStory(id)
  if null is story
    story = createStory(id)
  if 'function' is typeof fn then fn(story)
  story

getStory = (id) ->
  story = Stories.find( { token: id }).fetch()
  if 'undefined' is typeof story then story = null
  else if null isnt story then story = story[ 0 ] || null
  story

createStory = (id) ->
  story = Stories.insert(
    token: id
    modified: new Date()
    url: 'https://s3.amazonaws.com/hazy.co/sky.mov'
    narratives: []
  )
  if 'undefined' is typeof story then story = null
  else story = Stories.find( { token: id }).fetch()[ 0 ]
  story

populateNarrative = (id) ->
  #console.log('get narrative', id)

if Meteor.isClient

  isEditing = () ->
    'edit' is currentMode()

  createGrid = (url) ->

    hexgrid = new Hexgrid(
      id: "tldr-canvases"
      side: 10
      fill: "transparent"
      line:
        width: 1
        color: 'rgba(0,0,0,.05)'
      video:
        src: url
        x: 0
        y: 0

      onclick: (obj) ->

      onmouseout: (obj) ->

        api = obj.api
        hex = obj.data

      onmouseover: (obj) ->
        api = obj.api
        hex = obj.data

      ondrawn: (obj) ->
        api = obj.api
        hex = obj.data
    )
    hexgrid

  doAnim = (node, prop, fn) ->
      $( node ).animate prop,
        duration: 300,
        specialEasing:
          width: 'linear'
          height: 'easeOutBounce'
        complete: () ->
          fn() if 'function' is typeof fn

  # Panel

  hidePanel = () ->
    node = $("#tldr-panel-container")
    node.hide()
    doAnim( node,
      'margin-right': '-1000px'
    , () ->
      $( '.tldr-button-edit-cancel' ).addClass( 'tldr-button-edit' ).removeClass( 'tldr-button-edit-cancel').removeClass('ss-writingdisabled').addClass('ss-write')
    )

  showPanel = () ->
    node = $("#tldr-panel-container")
    node.show()
    doAnim( node,
      'margin-right': '0px'
    , () ->
      $( '.tldr-button-edit' ).removeClass( 'tldr-button-edit' ).addClass( 'tldr-button-edit-cancel').addClass('ss-writingdisabled').removeClass('ss-write')
    )

  # Narrative

  showNarrative = () ->
    node = $("#tldr-narrative-container")
    node.show()
    $("#tldr-panel-container").hide()
    doAnim( node,
      'margin-right': '0px'
    , () ->
      $( '.tldr-button-narrative' ).removeClass( 'tldr-button-narrative' ).addClass( 'tldr-button-narrative-cancel').text( 'notebook' )
    )

  hideNarrative = () ->
    node = $("#tldr-narrative-container")
    node.hide()
    doAnim( node,
      'margin-right': '-2000px'
    , () ->
      $( '.tldr-button-narrative-cancel' ).addClass( 'tldr-button-narrative' ).removeClass( 'tldr-button-narrative-cancel').text('openbook')
    )

  # Media

  showMedia = () ->
    node = $("#tldr-media-container")
    node.show()
    doAnim( node,
      'margin-right': '0px'
    , () ->
      $( '.tldr-button-media' ).removeClass( 'tldr-button-media' ).addClass( 'tldr-button-media-cancel').text( 'writingdisabled' )
    )

  hideMedia = () ->
    node = $("#tldr-media-container")
    node.hide()
    doAnim( node,
      'margin-right': '-2000px'
    , () ->
      $( '.tldr-button-media-cancel' ).addClass( 'tldr-button-media' ).removeClass( 'tldr-button-media-cancel').text( 'write' )
    )

  # Settings

  showSettings = () ->
    node = $("#tldr-settings-container")
    node.show()
    doAnim( node,
      'margin-right': '0px'
    , () ->
      $( '.tldr-button-settings' ).removeClass( 'tldr-button-settings' ).addClass( 'tldr-button-settings-cancel').text( 'checkmark' ).addClass( 'tldr-button-green')
      $("#tldr-middle-content-panel").fadeIn()
    )

  hideSettings = () ->
    node = $("#tldr-settings-container")
    node.hide()
    doAnim( node,
      'margin-right': '-3000px'
    , () ->
      $( '.tldr-button-settings-cancel' ).addClass( 'tldr-button-settings' ).removeClass( 'tldr-button-settings-cancel').text( 'settings' ).removeClass('tldr-button-green')
      $("#tldr-middle-content-panel").fadeOut()
    )
  if true is isEditing()

    Template.controls.events "click .tldr-button-edit": ( e ) ->
      showPanel()
      hideNarrative()
      hideMedia()
      hideSettings()

    Template.controls.events "click .tldr-button-edit-cancel": ( e ) ->
      hidePanel()

    Template.controls.events "click .tldr-button-narrative": ( e ) ->
      showNarrative()
      hidePanel()
      hideMedia()
      hideSettings()

    Template.controls.events "click .tldr-button-narrative-cancel": ( e ) ->
      hideNarrative()

    Template.controls.events "click .tldr-button-media": ( e ) ->
      showMedia()
      hideNarrative()
      hidePanel()
      hideSettings()

    Template.controls.events "click .tldr-button-media-cancel": ( e ) ->
      hideMedia()


    Template.controls.events "click .tldr-button-settings": ( e ) ->
      showSettings()
      hideNarrative()
      hideMedia()
      hidePanel()

    Template.controls.events "click .tldr-button-settings-cancel": ( e ) ->
      hideSettings()

    Template.toolbar.events "keydown .tldr-title": ( e ) ->
      story = Session.get('story')
      url = $( "#tldr-controls-spacer-title").val()
      story.url = url
      Stories.update( { _id: Session.get( 'story' )[ '_id' ] }, story )
      Session.set('story',story)
      regex = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi

      if null is url.match( regex )
        $( '.tldr-controls-spacer-title-icon').css('color', '#660000' )
        $( '#tldr-controls-spacer-title').css('color', '#660000' )
      else
        $( '.tldr-controls-spacer-title-icon').css('color', 'rgb(255, 255, 255)')
        $( '#tldr-controls-spacer-title').css('color', 'rgb(255, 255, 255)')

    Template.toolbar.events "focusin .tldr-title": ( e ) ->
      if ( 'rgb(204, 204, 204)' is $( '.tldr-controls-spacer-title-icon').css('color' ) )
        $( '.tldr-controls-spacer-title-icon').css('color', 'rgb(255, 255, 255)')
        $( '#tldr-controls-spacer-title').css('color', 'rgb(255, 255, 255)')

    Template.toolbar.events "focusout .tldr-title": ( e ) ->
      if ( 'rgb(255, 255, 255)' is $( '.tldr-controls-spacer-title-icon').css('color' ) )
        $( '.tldr-controls-spacer-title-icon').css('color', 'rgb(204, 204, 204)' )
        $( '#tldr-controls-spacer-title').css('color', 'rgb(204, 204, 204)' )

    Template.footer.events "click .tldr-button-bookmark": ( e ) ->
      video = that.video.media()
      bookmark =
        total: video.duration
        location: video.currentTime
        created: new Date().getTime()
        #data: document.getElementById( 'hexgrid-media' ).toDataURL('image/png')
      story = Session.get('story')
      story.narratives = story.narratives || []
      story.narratives.push( bookmark )
      Stories.update( { _id: story[ '_id' ] }, story )
      Session.set( 'story', story )

    Template.narrative.events "click .tldr-narrative-item": ( e ) ->
      el$ = $(e.target)
      if el$.hasClass 'tldr-narrative-text' or el$.hasClass 'tldr-narrative-icon'
        el$ = el$.parent()
      percentage = el$.data('percentage')
      that.video.skip(percentage, () ->
        console.log('skip complete', percentage)
      )

    Template.footer.events "click #tldr-scrubber": ( e ) ->
      offset = $( "#tldr-scrubber" ).offset()
      width = $( "#tldr-scrubber" ).outerWidth()
      pixels = e.clientX - offset.left
      percentage = pixels / width
      $( "#tldr-scrubber-bar-left" ).width( ( percentage * width ) - ( .5 * ( $( "#tldr-scrubber-knob-container" ).outerWidth() ) ) )
      that.video.skip(percentage)

    Template.narrative.pretty_timestamp = () -> timestampToPrettyDate( @location )

    Template.narrative.percentage = () -> @location/@total

    Template.narratives.narratives = () ->
      if ( 'undefined' isnt typeof Session.get('story') ) then Session.get('story')[ 'narratives' ] else []

    Template.scrubber.events "click .tldr-button-play": (e) ->
      that.video.play()

    Template.scrubber.events "click .tldr-button-pause": (e) ->
      that.video.pause()

    Template.scrubber.events "click .tldr-button-stop": (e) ->
      that.video.stop()
