# Description
#   Complete a task in teamworkpm
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_TEAMWORK_API_KEY
#   HUBOT_TEAMWORK_URL
#
# Commands:
#   hubot complete task <id> - completes the task and confirms the status
#
# Author:
#   ready4god2513

class Teamwork

  constructor: (@robot, @baseURL, @key) ->
    this.validateOptions()
    @auth = 'BASIC ' + new Buffer("#{@key}:xxx").toString('base64')

  completeTask: (id, cb) ->
    @robot.http("#{@baseURL}/tasks/#{id}/complete.json")
      .headers(Authorization: @auth)
      .put() (err, res, body) ->
        switch res.statusCode
          when 200
            cb "Great!  Task #{id} was marked complete"
          else
            cb body

  validateOptions: ->
    unless @key
      throw 'The HUBOT_TEAMWORK_API_KEY must be provided in order to complete teamwork tasks'
    unless @baseURL
      throw 'The HUBOT_TEAMWORK_URL must be provided in order to complete teamwork tasks'


module.exports = (robot) ->
  robot.respond /complete task ([0-9]+)/i, (msg) ->
    try
      teamwork = new Teamwork robot, process.env.HUBOT_TEAMWORK_URL, process.env.HUBOT_TEAMWORK_API_KEY
      teamwork.completeTask msg.match[1], (str) ->
        msg.send str
    catch e
      msg.send "Error: #{e}"