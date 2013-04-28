# Stories
Stories = new Meteor.Collection("stories");
Users = new Meteor.Collection("users");

Meteor.startup( () ->
  if Meteor.isClient
    id = currentId()
    Session.setDefault('token', id );

    Meteor.subscribe( 'stories', () ->
      loadStory( id, (story) ->
        console.log('story loaded',story.url)
        Session.setDefault('story', story );
        $( '.tldr-title' ).val( story.url );
        createGrid( story.url )
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
  console.log('get narrative', id)

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
        color: 'rgba(0,0,0,.1)'
      video:
        src: url
        x: 0
        y: 0

      onclick: (obj) ->

      onmouseout: (obj) ->

        api = obj.api
        hex = obj.data

      onmouseover: (obj) ->
        console.log "mouseover", obj
        api = obj.api
        hex = obj.data

      ondrawn: (obj) ->
        api = obj.api
        hex = obj.data
    )


  #

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
      console.log('nasty')
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

  if true is isEditing()

    Template.controls.events "click .tldr-button-edit": ( e ) ->
      showPanel()
      hideNarrative()
      hideMedia()

    Template.controls.events "click .tldr-button-edit-cancel": ( e ) ->
      hidePanel()

    Template.controls.events "click .tldr-button-narrative": ( e ) ->
      showNarrative()
      hidePanel()
      hideMedia()

    Template.controls.events "click .tldr-button-narrative-cancel": ( e ) ->
      hideNarrative()
    Template.controls.events "click .tldr-button-media": ( e ) ->
      showMedia()
      hideNarrative()
      hidePanel()

    Template.controls.events "click .tldr-button-media-cancel": ( e ) ->
      hideMedia()

    Template.toolbar.events "keydown .tldr-title": ( e ) ->
      story = Session.get('story')
      url = $( "#tldr-controls-spacer-title").val()
      story.url = url
      Stories.update( { _id: Session.get( 'story' )[ '_id' ] }, story )
      Session.set('story',story)
      regex = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi
      console.log('keydown: ' + url,url.match(regex))

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

    Template.narratives.narratives = () ->
      if ( 'undefined' isnt typeof Session.get('story') ) then Session.get('story')[ 'narratives' ] else []
