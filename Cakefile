{spawn, exec} = require 'child_process'

runCommand = (cmd) ->
  child = exec(cmd, (error, stdout, stderr) ->
    if error != null
      console.log "exec error: #{error}"
  )

test = (msg, name, args...) ->
  res = false
  proc = spawn name, args
  proc.stderr.on 'data', (buffer) -> console.log buffer.toString()
  
  proc.stdout.on 'data', (buffer) ->
    res = true if buffer.toString() != ""
  
  proc.on 'exit', (status) ->
    console.log msg unless res
    process.exit(1) if status isnt 0

# ====================================
#              TASKS
# ====================================    
task 'build', 'Generate JS from Coffeescript', (options) ->
  invoke 'deps'
  runCommand 'coffee -c -o lib src/*.coffee'
  console.log "JS Compiled to lib folder"

task 'clean', 'Remove js output', (options) ->
  runCommand 'rm -rf lib/*.js'
  console.log "compiled js in lib folder deleted"
  
task 'deps', 'Check dependencies', (options) ->
  test 'You need to have CoffeeScript in your PATH.\nPlease install it using `brew install coffee-script` or `npm install coffee-script`.', 'which' , 'coffee'  
  
task 'publish', 'Publish NPM Package', (options) ->
  invoke 'build'
  test 'You need npm to do npm publish... makes sense?', 'which', 'npm'
  runCommand 'sudo npm publish'
  invoke 'clean'
  console.log "Module published"

task 'link', 'Link ', (options) ->
  invoke 'build'
  test 'You need npm to do npm publish... makes sense?', 'which', 'npm'
  runCommand 'npm link'
  invoke 'clean'
  console.log "Module linked"