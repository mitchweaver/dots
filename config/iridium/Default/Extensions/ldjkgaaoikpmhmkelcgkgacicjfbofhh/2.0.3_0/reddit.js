function addInstapaperAction() {
    var reddit_things = document.getElementsByClassName('thing');
    for (var i = 0; i < reddit_things.length; i++) {
        var buttons = reddit_things[i].getElementsByClassName('flat-list')[0];
        var titles = reddit_things[i].getElementsByClassName('title');
        var title = undefined;
        for (var j = 0; j < titles.length; j++) {
            console.log(titles[j].tagName)
            if (titles[j].tagName.toLowerCase() == 'a')
                title = titles[j]
        }

        if (title != undefined) {
            var instapaper_element = document.createElement('li');
            var instapaper_link = document.createElement('a');
            var instapaper_text = document.createTextNode('instapaper');
            instapaper_link.href = title.href;
            instapaper_link.onclick = function(e) {
                saveLink(e.target.href);
                return false;
            }

            instapaper_link.appendChild(instapaper_text);
            instapaper_element.appendChild(instapaper_link);
            buttons.appendChild(instapaper_element);    
        }
            
    }
}

chrome.storage.sync.get("reddit_enabled", function(obj) {
    if (obj.reddit_enabled)
        addInstapaperAction();
})

