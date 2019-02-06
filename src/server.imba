import content from './content'

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