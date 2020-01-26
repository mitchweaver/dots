function addInstapaperAction() {
    var articles = document.getElementsByTagName('article');
    for (var i = 0; i < articles.length; i++) {
        var link = articles[i].getElementsByClassName('story-title-link')[0];
        var share = articles[i].getElementsByClassName('tooltip-story-share')[0];
        var share_actions = share.getElementsByClassName('plain-list')[0];
        var instapaper_element = document.createElement('li');
        var instapaper_icon = document.createElement('i');
        var instapaper_link = document.createElement('a');
        var instapaper_text = document.createTextNode('Save to Instapaper');
        instapaper_link.href = link.href;
        instapaper_link.onclick = function(e) {
            saveLink(e.target.href);
            return false;
        }
        
        instapaper_icon.className = 'story-share-instapaper-icon';
        instapaper_link.className = 'story-share-instapaper';
        instapaper_link.style.cssText = 'background-image:none !important; padding:0 !important; display:inline-block;';
        instapaper_link.appendChild(instapaper_text);
        instapaper_element.appendChild(instapaper_icon);
        instapaper_element.appendChild(instapaper_link);
        share_actions.appendChild(instapaper_element);
    }
}

addInstapaperAction();

