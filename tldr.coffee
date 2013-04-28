
if Meteor.isClient

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
      $( '.tldr-button-media' ).removeClass( 'tldr-button-media' ).addClass( 'tldr-button-media-cancel').text( 'eject' )
    )

  hideMedia = () ->
    node = $("#tldr-media-container")
    node.hide()
    doAnim( node,
      'margin-right': '-2000px'
    , () ->
      $( '.tldr-button-media-cancel' ).addClass( 'tldr-button-media' ).removeClass( 'tldr-button-media-cancel').text( 'images' )
    )

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

if Meteor.isServer
  Meteor.startup ->
    console.log("Restart > " + new Date().getTime() )