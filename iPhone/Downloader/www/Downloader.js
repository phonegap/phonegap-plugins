(function() {
  var DownloadTask, Downloader, debug, getId, joinUrls, root, unique,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = this;

  unique = 0;

  debug = function() {
    return;
    return console.log(arguments);
  };

  getId = function() {
    return unique++;
  };

  joinUrls = function(u1, u2) {
    var l1, l2;
    l1 = u1.length - 1;
    l2 = u2.length - 1;
    if (u1[l1] === '/') u1 = u1.substr(0, l1);
    if (u2[l2] === '/') u2 = u2.substr(0, l2);
    return u1 + '/' + u2;
  };

  DownloadTask = (function() {

    function DownloadTask(url, params, win, fail) {
      this.url = url;
      this.params = params;
      this.win = win;
      this.fail = fail;
      this.callback = __bind(this.callback, this);
      this.start = __bind(this.start, this);
      this.path = joinUrls(this.params.dirName, this.params.fileName);
      this.id = getId();
    }

    DownloadTask.prototype.start = function() {
      var options;
      options = {
        url: this.url,
        path: this.path,
        taskId: this.id,
        timeout: this.params.timeout
      };
      return PhoneGap.exec("Downloader.downloadFile", options);
    };

    DownloadTask.prototype.callback = function(e, progress, finish) {
      debug(this.id + ' received callback');
      if (e) {
        debug('fail');
        this.fail(e);
        return;
      }
      return this.win(progress, finish);
    };

    return DownloadTask;

  })();

  Downloader = (function() {

    function Downloader() {
      this.handleCallback = __bind(this.handleCallback, this);
      this.downloadFile = __bind(this.downloadFile, this);
      this.removeTask = __bind(this.removeTask, this);
      this.getTask = __bind(this.getTask, this);
      this.addTask = __bind(this.addTask, this);      this.tasks = {};
    }

    Downloader.prototype.addTask = function(task) {
      return this.tasks[task.id] = task;
    };

    Downloader.prototype.getTask = function(id) {
      return this.tasks[id];
    };

    Downloader.prototype.removeTask = function(task) {
      return this.tasks[task.id] = null;
    };

    Downloader.prototype.downloadFile = function(url, params, fail, win) {
      var task;
      task = new DownloadTask(url, params, win, fail);
      this.addTask(task);
      return task.start();
    };

    Downloader.prototype.handleCallback = function(id, e, progress, finish) {
      var task;
      debug('handling callback of ' + id);
      task = this.getTask(id);
      if (!task) debug('Downloader: FAILURE');
      if (e === 'false') e = false;
      if (progress === 'false') progress = false;
      if (finish === 'false') finish = false;
      task.callback(e, progress, finish);
      if (e) removeTask(task);
      if (finish) return removeTask(task);
    };

    return Downloader;

  })();

  PhoneGap.addConstructor(function() {
    var downloader;
    downloader = new Downloader();
    return navigator.downloader = downloader;
  });

}).call(this);
