function addInstapaperAction() {
    var usv_hot_new_feed = document.getElementsByClassName('hot-newest-feed')[0];
    var usv_feed = usv_hot_new_feed.getElementsByClassName('feed')[0];
    var usv_items = usv_feed.getElementsByTagName('li');
    console.log(usv_feed)
    console.log(usv_items.length);
    for (var i = 0; i < usv_items.length; i++) {
        var usv_meta = usv_items[i].getElementsByClassName('meta')[0];
        var usv_link = usv_items[i].getElementsByClassName('title')[0];
        var instapaper_element = document.createElement('span');
        var instapaper_icon = document.createElement('i');
        var instapaper_link = document.createElement('a');
        var instapaper_text = document.createTextNode('Instapaper');

        instapaper_link.href = usv_link.href;
        instapaper_link.onclick = function(e) {
            saveLink(e.target.href);
            return false;
        }
        
        instapaper_link.appendChild(instapaper_text);
        instapaper_element.appendChild(instapaper_icon);
        instapaper_element.appendChild(instapaper_link);
        instapaper_element.className = 'action-instapaper';
        usv_meta.appendChild(instapaper_element);
    }
}

chrome.storage.sync.get("usv_enabled", function(obj) {
    if (obj.usv_enabled)
        addInstapaperAction();
})

