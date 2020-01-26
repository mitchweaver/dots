window.onload = function() {
    var isMac = navigator.platform.toUpperCase().indexOf('MAC')>=0;
    var shortcut_text = document.querySelector("#shortcut_text");
    if (isMac)
        shortcut_text.innerText = "Cmd+Shift+S";

    var shortcut_box = document.querySelector("#shortcut_box");
    chrome.storage.sync.get("shortcut_enabled", function(obj) {
        shortcut_box.checked = obj.shortcut_enabled;
        shortcut_box.onchange = function() {
            chrome.storage.sync.set({"shortcut_enabled":shortcut_box.checked});
        }
    })

    var twitter_box = document.querySelector("#twitter_box");
    chrome.storage.sync.get("twitter_enabled", function(obj) {
        twitter_box.checked = obj.twitter_enabled;
        twitter_box.onchange = function() {
            chrome.storage.sync.set({"twitter_enabled":twitter_box.checked});
        }
    })

    var reddit_box = document.querySelector("#reddit_box");
    chrome.storage.sync.get("reddit_enabled", function(obj) {
        reddit_box.checked = obj.reddit_enabled;
        reddit_box.onchange = function() {
            chrome.storage.sync.set({"reddit_enabled":reddit_box.checked});
        }
    })

    var usv_box = document.querySelector("#usv_box");
    chrome.storage.sync.get("usv_enabled", function(obj) {
        usv_box.checked = obj.usv_enabled;
        usv_box.onchange = function() {
            chrome.storage.sync.set({"usv_enabled":usv_box.checked});
        }
    })

    var hn_box = document.querySelector("#hn_box");
    chrome.storage.sync.get("hn_enabled", function(obj) {
        hn_box.checked = obj.hn_enabled;
        hn_box.onchange = function() {
            chrome.storage.sync.set({"hn_enabled":hn_box.checked});
        }
    })
}

