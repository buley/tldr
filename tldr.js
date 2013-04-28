// Generated by CoffeeScript 1.4.0
(function() {
  var Stories, Users, countStories, createStory, currentId, currentMode, doAnim, getStories, getStory, hideMedia, hideNarrative, hidePanel, isEditing, loadStory, populateNarrative, showMedia, showNarrative, showPanel;

  Stories = new Meteor.Collection("stories");

  Users = new Meteor.Collection("users");

  Meteor.startup(function() {
    var id;
    if (Meteor.isClient) {
      id = currentId();
      Session.setDefault('token', id);
      return Meteor.subscribe('stories', function() {
        loadStory(id, function(story) {
          console.log('story loaded', story);
          Session.setDefault('story', story);
          return $('.tldr-title').text(story.title);
        });
        if (true === isEditing()) {
          return populateNarrative(id);
        }
      });
    } else if (Meteor.isServer) {
      return Meteor.publish("stories", function() {
        return Stories.find({}, {
          fields: {
            _id: 1,
            token: 1,
            modified: 1,
            narratives: 1,
            title: 'Story Title'
          }
        });
      });
    }
  });

  currentId = function() {
    return document.location.pathname.replace(/^\//, '');
  };

  currentMode = function() {
    return document.location.hash.replace(/^#/, '');
  };

  getStories = function() {
    return Stories.find().fetch();
  };

  countStories = function() {
    return Stories.find().fetch().length;
  };

  loadStory = function(id, fn) {
    var story;
    story = getStory(id);
    if (null === story) {
      story = createStory(id);
    }
    if ('function' === typeof fn) {
      fn(story);
    }
    return story;
  };

  getStory = function(id) {
    var story;
    story = Stories.find({
      token: id
    }).fetch();
    if ('undefined' === typeof story) {
      story = null;
    } else if (null !== story) {
      story = story[0] || null;
    }
    return story;
  };

  createStory = function(id) {
    var story;
    story = Stories.insert({
      token: id,
      modified: new Date(),
      title: '',
      narratives: []
    });
    if ('undefined' === typeof story) {
      story = null;
    } else {
      story = Stories.find({
        token: id
      }).fetch()[0];
    }
    return story;
  };

  populateNarrative = function(id) {
    return console.log('get narrative', id);
  };

  if (Meteor.isClient) {
    isEditing = function() {
      return 'edit' === currentMode();
    };
    doAnim = function(node, prop, fn) {
      return $(node).animate(prop, {
        duration: 300,
        specialEasing: {
          width: 'linear',
          height: 'easeOutBounce'
        },
        complete: function() {
          if ('function' === typeof fn) {
            return fn();
          }
        }
      });
    };
    hidePanel = function() {
      var node;
      node = $("#tldr-panel-container");
      node.hide();
      return doAnim(node, {
        'margin-right': '-1000px'
      }, function() {
        return $('.tldr-button-edit-cancel').addClass('tldr-button-edit').removeClass('tldr-button-edit-cancel').removeClass('ss-writingdisabled').addClass('ss-write');
      });
    };
    showPanel = function() {
      var node;
      node = $("#tldr-panel-container");
      node.show();
      return doAnim(node, {
        'margin-right': '0px'
      }, function() {
        return $('.tldr-button-edit').removeClass('tldr-button-edit').addClass('tldr-button-edit-cancel').addClass('ss-writingdisabled').removeClass('ss-write');
      });
    };
    showNarrative = function() {
      var node;
      node = $("#tldr-narrative-container");
      node.show();
      $("#tldr-panel-container").hide();
      return doAnim(node, {
        'margin-right': '0px'
      }, function() {
        return $('.tldr-button-narrative').removeClass('tldr-button-narrative').addClass('tldr-button-narrative-cancel').text('notebook');
      });
    };
    hideNarrative = function() {
      var node;
      node = $("#tldr-narrative-container");
      node.hide();
      return doAnim(node, {
        'margin-right': '-2000px'
      }, function() {
        return $('.tldr-button-narrative-cancel').addClass('tldr-button-narrative').removeClass('tldr-button-narrative-cancel').text('openbook');
      });
    };
    showMedia = function() {
      var node;
      node = $("#tldr-media-container");
      node.show();
      return doAnim(node, {
        'margin-right': '0px'
      }, function() {
        console.log('nasty');
        return $('.tldr-button-media').removeClass('tldr-button-media').addClass('tldr-button-media-cancel').text('eject');
      });
    };
    hideMedia = function() {
      var node;
      node = $("#tldr-media-container");
      node.hide();
      return doAnim(node, {
        'margin-right': '-2000px'
      }, function() {
        return $('.tldr-button-media-cancel').addClass('tldr-button-media').removeClass('tldr-button-media-cancel').text('images');
      });
    };
    if (true === isEditing()) {
      Template.controls.events({
        "click .tldr-button-edit": function(e) {
          showPanel();
          hideNarrative();
          return hideMedia();
        }
      });
      Template.controls.events({
        "click .tldr-button-edit-cancel": function(e) {
          return hidePanel();
        }
      });
      Template.controls.events({
        "click .tldr-button-narrative": function(e) {
          showNarrative();
          hidePanel();
          return hideMedia();
        }
      });
      Template.controls.events({
        "click .tldr-button-narrative-cancel": function(e) {
          return hideNarrative();
        }
      });
      Template.controls.events({
        "click .tldr-button-media": function(e) {
          showMedia();
          hideNarrative();
          return hidePanel();
        }
      });
      Template.controls.events({
        "click .tldr-button-media-cancel": function(e) {
          return hideMedia();
        }
      });
      Template.toolbar.events({
        "keydown .tldr-title": function(e) {
          var story;
          story = Session.get('story');
          story.title = e.srcElement.innerHTML;
          Stories.update({
            _id: Session.get('story')['_id']
          }, story);
          Session.set('story', story);
          console.log('udpated form', Session.get('story'), story);
          return Template.leaderboard.narratives = function() {
            return Session.get('story').narratives;
          };
        }
      });
    }
  }

}).call(this);
