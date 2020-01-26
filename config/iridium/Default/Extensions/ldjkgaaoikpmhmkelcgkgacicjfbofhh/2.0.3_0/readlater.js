function initialize_defaults() {
    chrome.storage.sync.get("defaults_initialized", function(obj) {
        if (obj.defaults_initialized)
            return;

        chrome.storage.sync.set({"twitter_enabled":true,
                                 "reddit_enabled":true,
                                 "usv_enabled":true,
                                 "hn_enabled":true,
                                 "shortcut_enabled":true,
                                 "defaults_initialized":true});
    })
}

initialize_defaults();

chrome.browserAction.onClicked.addListener(function(tab) {
    //Called when the user clicks on the browser action.
    bookmarklet();
});

function bookmarklet() {
    chrome.tabs.query({active: true, currentWindow: true}, function(tabs){
        chrome.tabs.sendMessage(tabs[0].id, {'message': 'bookmarklet'});
    });
}

function onContextClick(info, tab) {
    if (info.linkUrl) {
        chrome.tabs.sendMessage(tab.id, {'message': 'saveLink', 'url': info.linkUrl});
    }
    else {
        bookmarklet()
    }
}

chrome.contextMenus.create({
    "title":"Save to Instapaper",
    "contexts":["page", "selection", "link"],
    "onclick": onContextClick
});

chrome.runtime.onMessage.addListener(
    function(request, sender, sendResponse) {
        if (request.message == 'bookmarklet_upload') {
            try {
                var x = new XMLHttpRequest();
                x.open('POST', 'https://www.instapaper.com/bookmarklet/post_v5', true);
                x.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
                x.onreadystatechange = function(){
                    try {
                        if (x.readyState != 4) return;
                        if (x.status != 200)
                            chrome.tabs.sendMessage(sender.tab.id, {'message': 'bookmarklet_status', 'status': 'failure', 'code': x.status});
                        else
                            chrome.tabs.sendMessage(sender.tab.id, {'message': 'bookmarklet_status', 'status': 'success', 'response': x.responseText});
                    } catch (e) {
                        chrome.tabs.sendMessage(sender.tab.id, {'message': 'bookmarklet_status', 'status': 'exception'});
                    }
                }
                x.send(request.postbody);
            } catch (e) {
                chrome.tabs.sendMessage(sender.tab.id, {'message': 'bookmarklet_status', 'status': 'exception'})
            }
        }
        else if (request.message == 'bookmarklet_xpaths') {
            console.log('XPath request with URL: ' + request.url)
            var x = new XMLHttpRequest();
            x.open('GET', 'https://www.instapaper.com/bookmarklet/xpaths?url=' + encodeURIComponent(request.url));
            x.onreadystatechange = function() {
                console.log(x.readyState + ' ' + x.status)
                if (x.readyState != 4) return;
                if (x.status != 200)
                    chrome.tabs.sendMessage(sender.tab.id, {'message': 'bookmarklet_xpath_status', 'status': 'failure', 'code': x.status})
                else {
                    try {
                        response_dict = JSON.parse(x.responseText)
                        chrome.tabs.sendMessage(sender.tab.id, {'message': 'bookmarklet_xpath_status', 'status': 'success', 'xpaths': response_dict['xpaths']})
                    }
                    catch(e) {
                        chrome.tabs.sendMessage(sender.tab.id, {'message': 'bookmarklet_xpath_status', 'status': 'exception'})
                    }
                }
            }
            x.send()
        }
        else if (request.message == 'bookmark_move') {
            var x = new XMLHttpRequest();
            x.open('POST', 'https://www.instapaper.com/move/' + request.bookmark_id + '/to/' + request.folder_id);
            x.send();
        }
    }
)

