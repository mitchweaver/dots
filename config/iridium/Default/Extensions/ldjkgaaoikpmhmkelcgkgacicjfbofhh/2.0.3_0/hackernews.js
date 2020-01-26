function addInstapaperAction() {
    var titles = document.getElementsByClassName('title');
    for (var i = 0; i < titles.length; i++) {
        var links = titles[i].getElementsByTagName('A');
        var subtext_row = titles[i].parentNode.nextSibling;
        if (links.length &&
            subtext_row != null &&
            subtext_row != undefined) {
            var subtext = subtext_row.getElementsByClassName('subtext')[0];
            var instapaper_link = document.createElement('a');
            var instapaper_text = document.createTextNode('instapaper');
            instapaper_link.href = links[0].href;
            instapaper_link.onclick = function(e) {
                saveLink(e.target.href);
                return false;
            }
        
            instapaper_link.appendChild(instapaper_text);
            subtext.appendChild(document.createTextNode(' | '));
            subtext.appendChild(instapaper_link)
        }
    }
}

chrome.storage.sync.get("hn_enabled", function(obj) {
    if (obj.hn_enabled)
        addInstapaperAction();
})

