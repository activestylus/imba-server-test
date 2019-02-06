# A placeholder tag for enabling the content mechanism.
tag content
  prop name
  prop parent
  
  # Gets the top most Imba tag housing this content slot.
  def ancestor node
    if node?.@context_ === 0
      return node
    ancestor node.@owner_
  
  # Hooks the content grand parent.
  def setup
    @parent = ancestor this
    data && name = data

# An extension to the base tag.
# Provides:
#  1. Access to yielded children through @children property.
#  2. Ability to specify css classes through the class attribute and/or the concise syntax.
#  3. Slot mechanism incl. named slots, through the <content> tag.
extend tag element
  prop for

  def setClass classes
    setAttribute('class', "{getAttribute('class') or ''} {classes}".trim)

  def class
    getAttribute('class')

  def setup
    @children = children
    self

  def end
    setup
    commit(0)
    fill # at this stage we have enough info.
    this:end = Imba.Tag:end
    self
  
  def fill slot, nodes
    unless slot and nodes
      # if this is a content tag, get children
      # associated with it and call this method
      # to fill with them.
      # enhancement: perhaps we could use props to check instead of css selector?
      if matches '._content'
        var nodes = this.@parent.@children
        if nodes.len > 0
          fill this, nodes
      return
    
    var name = slot.@name or ''
      
    for node in nodes
      var target = node.@for or ''
      
      if target is name
        slot.appendChild node

tag Layout
  def render
    <self>
      <head><title> "Imba - Server Rendering Test"
      <body>
        <h1> "Main Layout"
        <content['head']>
        
tag Hello
  def render
    <self>
      <Layout>
        <div for="head">
          <h2> "Hello Content!"
      

var app = require('fastify')({ logger: true, level: 'info'})

app.get '/' do |req, res|
  var html = <Hello>
  res.type('text/html').send html.toString
  
app.listen 3333 do |err|
  if err
    console.log err
  else
    console.log "server listening on { app:server.address():port }"