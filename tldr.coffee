doAnim = (node, prop, fn) ->
    $( node ).animate prop,
      duration: 300,
      specialEasing:
        width: 'linear'
        height: 'easeOutBounce'
      complete: () ->
        fn() if 'function' is typeof fn

if Meteor.isClient

  template.controls.events "click .tldr-button-edit": ( e ) ->
    doanim( $("#tldr-panel-container"),
      'margin-right': '0px'
    , () ->
      $( e.srcelement ).removeclass( 'tldr-button-edit' ).addclass( 'tldr-button-edit-cancel').addclass('ss-writingdisabled').removeclass('ss-write')
    )

  template.controls.events "click .tldr-button-edit-cancel": ( e ) ->
    doanim( $("#tldr-panel-container"),
      'margin-right': '-1000px'
    , () ->
      $( e.srcelement ).addclass( 'tldr-button-edit' ).removeclass( 'tldr-button-edit-cancel').removeclass('ss-writingdisabled').addclass('ss-write')
    )

  template.controls.events "click .tldr-button-narrative": ( e ) ->
    console.log('donarr')
    doanim( $("#tldr-narrative-container"),
      'margin-right': '0px'
    , () ->
      $( e.srcelement ).removeclass( 'tldr-button-narrative' ).addclass( 'tldr-button-narative-cancel').addclass('ss-columns').removeclass('ss-rows')
    )

  template.controls.events "click .tldr-button-narrative-cancel": ( e ) ->
    console.log('ybdonarr')
    doanim( $("#tldr-narrative-container"),
      'margin-right': '-1000px'
    , () ->
      $( e.srcelement ).addclass( 'tldr-button-edit' ).removeclass( 'tldr-button-edit-cancel').removeclass('ss-columns').addclass('ss-rows')
    )

if Meteor.isServer
  Meteor.startup ->
    console.log("Restart > " + new Date().getTime() )