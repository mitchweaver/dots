(function() {
  var handlers, requestID,
    slice = [].slice;

  requestID = 0;

  chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
    var id;
    id = requestID;
    requestID++;
    sendResponse(id);
    return handlers[request.type](request, function(response) {
      return chrome.tabs.sendMessage(sender.tab.id, {
        id: id,
        data: response
      });
    });
  });

  handlers = {
    permission: function(request, cb) {
      var origins;
      origins = request.origins || ['*://*/'];
      return chrome.permissions.contains({
        origins: origins
      }, function(result) {
        if (result) {
          return cb(result);
        } else {
          return chrome.permissions.request({
            origins: origins
          }, function(result) {
            if (chrome.runtime.lastError) {
              return cb(false);
            } else {
              return cb(result);
            }
          });
        }
      });
    },
    ajax: function(request, cb) {
      var key, ref, value, xhr;
      xhr = new XMLHttpRequest();
      xhr.open('GET', request.url, true);
      xhr.responseType = request.responseType;
      xhr.timeout = request.timeout;
      ref = request.headers || {};
      for (key in ref) {
        value = ref[key];
        xhr.setRequestHeader(key, value);
      }
      xhr.addEventListener('load', function() {
        var ref1, response, responseHeaderString, status, statusText;
        ref1 = this, status = ref1.status, statusText = ref1.statusText, response = ref1.response;
        responseHeaderString = this.getAllResponseHeaders();
        if (response && request.responseType === 'arraybuffer') {
          response = slice.call(new Uint8Array(response));
        }
        return cb({
          status: status,
          statusText: statusText,
          response: response,
          responseHeaderString: responseHeaderString
        });
      }, false);
      xhr.addEventListener('error', function() {
        return cb({
          error: true
        });
      }, false);
      xhr.addEventListener('abort', function() {
        return cb({
          error: true
        });
      }, false);
      xhr.addEventListener('timeout', function() {
        return cb({
          error: true
        });
      }, false);
      return xhr.send();
    }
  };

}).call(this);
