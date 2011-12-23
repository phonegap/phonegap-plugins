root = this

unique = 0

debug = () ->
  return
  console.log arguments

getId = () ->
  return unique++;

joinUrls = (u1, u2) ->
  l1 = u1.length - 1
  l2 = u2.length - 1 
  if u1[l1] == '/'
    u1 = u1.substr 0, l1
  if u2[l2] == '/'
    u2 = u2.substr 0, l2
  return u1 + '/' + u2


class DownloadTask
  constructor: (@url, @params, @win, @fail) ->
    @path = joinUrls @params.dirName, @params.fileName
    @id = getId()

  start: () =>
    options = 
      url: @url
      path: @path
      taskId: @id
      timeout: @params.timeout

    PhoneGap.exec "Downloader.downloadFile", options

  callback: (e, progress, finish) =>
    debug @id + ' received callback'
    
    if e
      debug 'fail'
      @fail e
      return

    @win progress, finish
    
    # dispatch to win and fail to behave just like android version


class Downloader
  constructor: () ->
    @tasks = {}

  addTask: (task) =>
    @tasks[task.id] = task

  getTask: (id) =>
    return @tasks[id]

  removeTask: (task) =>
    @tasks[task.id] = null

  # Entry function for user
  downloadFile: (url, params, fail, win) =>
    # params are 
    # - fileName
    # - dirName
    # - overwrite (ignored, always overwrite)
    task = new DownloadTask url, params, win, fail
    @addTask task
    task.start()

  handleCallback: (id, e, progress, finish) =>
    debug 'handling callback of ' + id
    task = @getTask id
    if not task
      debug 'Downloader: FAILURE'
      
    # convert params to boolean, because phonegap sends strings
    
    if e == 'false'
      e = false
        
    if progress == 'false'
      progress = false
        
    if finish == 'false'
      finish = false
    
    task.callback e, progress, finish

    if e
      removeTask task
    if finish
      removeTask task

PhoneGap.addConstructor () ->
  downloader = new Downloader()
  navigator.downloader = downloader

# root.Downloader = new Downloader()

