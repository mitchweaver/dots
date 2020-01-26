function parentWithClassName(el, className) {
    while ((el = el.parentNode) && !el.classList.contains(className));
    return el;
}

function addInstapaperAction() {
    var tweet_links = document.getElementsByClassName('twitter-timeline-link');
    for (var i = 0; i < tweet_links.length; i++) {
        var tweet_content = parentWithClassName(tweet_links[i], 'tweet');
        var tweet_actions = tweet_content.getElementsByClassName('js-actions')[0];

        if (tweet_actions &&
            tweet_actions.getElementsByClassName('action-instapaper').length == 0) {
            var instapaper_element = document.createElement('div');
            var instapaper_link = document.createElement('a');
            instapaper_link.className = 'js-tooltip';
            instapaper_link.setAttribute('data-original-title', 'Instapaper');
            instapaper_link.href = tweet_links[i].href;
            instapaper_link.onclick = function(e) {
                var link = e.target;
                while (link && link.nodeName != "A")
                    link = link.parentNode;
                if (link && link.href)
                    saveLink(link.href);
                return false;
            }
            instapaper_element.appendChild(instapaper_link);
            instapaper_element.className = 'ProfileTweet-action action-instapaper';
            tweet_actions.appendChild(instapaper_element);
        }
    }

    setTimeout(addInstapaperAction, 1000);
}

chrome.storage.sync.get("twitter_enabled", function(obj) {
    if (obj.twitter_enabled)
        addInstapaperAction();
})

