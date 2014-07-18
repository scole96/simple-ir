@Things = new Meteor.Collection("things")

if Meteor.isClient
  @Subs = {}
  Deps.autorun () ->
    site_id = Session.get("site_id")
    console.log "site_id changed to #{site_id}"
    Subs['things'] = Meteor.subscribe("things", site_id)

  Router.route 'home',
    path: "/"

  Router.route 'things',
    path: "/things"
    waitOn: () ->
      console.log "things.waitOn"
      return Subs['things']
    data: ->
      console.log "things.data"
      things: Things.find()

  Template.home.events
    'click #site_one' : ->
      Session.set("site_id", 1)
      Router.go 'things'
    'click #site_two' : ->
      Session.set("site_id", 2)
      Router.go 'things'

if Meteor.isServer
  Meteor.startup () ->
    if Things.find().count() is 0
      Things.insert({site_id: 1, name: "thing one"})
      Things.insert({site_id: 1, name: "thing two"})
      Things.insert({site_id: 2, name: "other thing one"})
      Things.insert({site_id: 2, name: "other thing two"})


  Meteor.publish 'things', (site_id) ->
    console.log "Publish things for site_id: #{site_id}"
    Things.find({site_id: site_id})

