var saving = false;
var parser_xpaths = {}
var autodetect_next_page_url = false
var ipPageBodies = [];
var ipPageURLs = [];
var ipSinglePageCrawled = 0;
var showsFolderDropdown = false;
var removeOverlayTimer = undefined;
var body, _greader, btxTitle = '', cancel = 0, frameDidLoad = 0, _ipDidSend = 0;

window.onload = function() {
    document.body.onkeydown = document.body.onkeyup = function(e) {
        if ((e.ctrlKey || e.metaKey) &&
            e.shiftKey &&
            e.keyCode == 83 &&
            !saving) {
            chrome.storage.sync.get("shortcut_enabled", function(obj) {
                if (obj.shortcut_enabled) {
                    _rl();
                }
            });
        }
    }
}

var SimpleParser = (function() {
    var scrubTitle = function(title) {
        return title.substring(0, 12) == '(Saving...) ' ? title.substring(12) : title;
    };

    var getContentFromTag = function(tag, attribute, value, useHTML) {
        var tags = document.getElementsByTagName(tag),
            i, obj;
        for (i = 0; i < tags.length; i += 1) {
            obj = tags[i];
            if (obj.getAttribute &&
                obj.getAttribute(attribute) === value) {
                return obj.getAttribute('content') ||
                       obj.getAttribute('value') ||
                       (useHTML ? obj.innerHTML : null);
            }
        }
        return null;
    };

    var getContentUsingXPaths = function(xpaths) {
        var result, i;
        for (i in xpaths) {
            try {
                result = document.evaluate(xpaths[i], document, null, XPathResult.FIRST_ORDERED_NODE_TYPE);
                if (result.singleNodeValue) {
                    return result.singleNodeValue.textContent;
                }
            } catch(e) { }
        }
    };

    return {
        getBasicPageInfo: function() {
            var canonical_url,
                links = document.getElementsByTagName('link'),
                params = {url: document.URL},
                i, title,
                // XPaths
                titleXPaths;

            // Attempt to get the canonical url
            canonical_url = getContentFromTag('meta', 'property', 'og:url');
            if (canonical_url) {
                params.canonical_url = canonical_url;
            } else {
                for (i = 0; i < links.length; i++) {
                    if (links[i].getAttribute('rel') === 'canonical') {
                        params.canonical_url = links[i].getAttribute('href');
                        break;
                    }
                }
            }

            // Think about only grabbing the title if its canonical or parsed
            title = getContentFromTag('meta', 'property', 'og:title');
            if (parser_xpaths['title']) {
                var xpathTitle = getContentUsingXPaths(parser_xpaths['title'])
                if (xpathTitle) {
                    title = xpathTitle
                }
            }
            
            if (!title) {
                title = document.title;
            }
            params.title = scrubTitle(title);
            
            thumbnail = getContentFromTag('meta', 'property', 'og:image');
            if (thumbnail) {
                params.thumbnail = thumbnail;
            }
            else {
                params.thumbnail = ''
            }
            return params;
        }
    }
})();

if (document.title.substring(0, 12) == '(Saving...) ') document.title = document.title.substring(12);

function jbs(html)
{
    if (html.length > 768000) return html; /* too big to deflate quickly */
    return '<' + '![D[' + jbs_deflate(html);
}

function btx_singlePageURL(bodyNode)
{
    var singlePageXPs = (parser_xpaths['single_page'])? parser_xpaths['single_page']: new Array();
    for (var i = 0; i < singlePageXPs.length; i++) {
        try {
            var result = document.evaluate(singlePageXPs[i], bodyNode, null, XPathResult.FIRST_ORDERED_NODE_TYPE);
            if (result.singleNodeValue) {
                return (
                    result.singleNodeValue.nodeType == 1 && result.singleNodeValue.nodeName.toLowerCase() == 'a' ?
                    result.singleNodeValue.getAttribute('href') : result.singleNodeValue.textContent
                );
            }
        } catch(e){ }
    }

    return false;
}

function btx_nextPageURL(bodyNode, currentURL)
{
    if (currentURL.indexOf('#') >= 0) currentURL = currentURL.substr(0, currentURL.indexOf('#'));
    var nextPageXPs = (parser_xpaths['next_page'])? parser_xpaths['next_page']: new Array();
    for (var i = 0; i < nextPageXPs.length; i++) {
        try {
            var result = document.evaluate(nextPageXPs[i], bodyNode, null, XPathResult.FIRST_ORDERED_NODE_TYPE);
            if (result.singleNodeValue) {
                var candidate = (
                    result.singleNodeValue.nodeType == 1 && result.singleNodeValue.nodeName.toLowerCase() == 'a' ?
                    result.singleNodeValue.getAttribute('href') : result.singleNodeValue.textContent
                );

                if (candidate.indexOf('#') >= 0) candidate = candidate.substr(0, candidate.indexOf('#'));
                if (candidate != currentURL) return candidate;
            }
        } catch(e){ }
    }

    if (autodetect_next_page_url) {
        var autoNextPageXPs = parser_xpaths['auto_next_page']
        for (var i = 0; i < autoNextPageXPs.length; i++) {
            try {
                var result = document.evaluate(autoNextPageXPs[i], bodyNode, null, XPathResult.FIRST_ORDERED_NODE_TYPE);
                if (result.singleNodeValue) {
                    var newURL = result.singleNodeValue.href;
                      /* resolve relative URL */
                      var a = document.createElement('a'); a.href = newURL; newURL = a.href;

                      /* a URL that only differs by anchor cannot be auto-next-page */
                      var poundPos = newURL.indexOf('#');
                      if (poundPos >= 0) newURL = newURL.substr(0, poundPos);
                      if (newURL == currentURL) continue;

                      /* a URL with a 5+ digit number NOT contained in current URL cannot be auto-next-page */
                      var longNum = /[0-9]{5,}/.exec(newURL);
                      if (longNum && currentURL.indexOf(longNum) == -1) continue;

                      var c, maxLen = Math.max(newURL.length, currentURL.length);
                      for (c = 0; c < maxLen; c++) {
                          if (newURL.length < c || currentURL.length < c || newURL.charAt(c) != currentURL.charAt(c)) break;
                      }
                      if (maxLen - c < 20 || c / maxLen > 0.8) return newURL;
                  }
              } catch(e){ }
        }
    }

    return false;
}

function stripCommentsAndHiddenElements(node)
{
    if (node.nodeType == 8 /* comment */) node.parentNode.removeChild(node);
    else if (node.nodeType == 1 /* element */) {
        if (node.style.display == 'none' || node.style.visibility == 'hidden') node.parentNode.removeChild(node);
        else {
            for (var c = 0; c < node.childNodes.length; c++) stripCommentsAndHiddenElements(node.childNodes[c]);
        }
    }
}

function addClass(el, className)
{
    if (el.getAttribute('class')) el.setAttribute(el.getAttribute('class') + ' ' + className);
    else el.setAttribute('class', className);
}

function btx_body(bodyNode)
{
    try {
        bodyNode = bodyNode.cloneNode(true);
        var o;
        if ( (o = bodyNode.getElementById('ov')) ) o.parentNode.removeChild(o);

        var stripElements = [
            'iframe', 'script', 'style', 'canvas', 'noscript', 'head',
            'input', 'textarea', 'select', 'button'
        ];
        for (var i in stripElements) {
            var els = [], ns = bodyNode.getElementsByTagName(stripElements[i]);
            for (var j = 0; j < ns.length; j++) els[els.length] = ns[j];
            for (var j = 0; j < els.length; j++) {
                els[j].parentNode.removeChild(els[j]);
            }
        }
        stripCommentsAndHiddenElements(bodyNode);
    } catch(e){ }

    return bodyNode;
}

function _viewportWidth() {
    var w = window,
        d = document,
        e = d.documentElement,
        g = d.getElementsByTagName('body')[0];
    return w.innerWidth || e.clientWidth || g.clientWidth;
}

function _folderRow(folder_data) {
    folder = document.createElement('div');
    folder.setAttribute('class', 'folder_row');
    folder.setAttribute('data-folder-id', '' + folder_data.id);
    folderIcon = document.createElement('div');
    folderIcon.setAttribute('class', 'folder_row_img');
    folder.appendChild(folderIcon);
    folder.appendChild(document.createTextNode(folder_data.name));
    folder.onclick = function(e) {
        var bookmark_id = document.getElementById('obid');
        var folder_id = e.target.getAttribute('data-folder-id');
        setTimeout(function() {
            document.getElementById('ofd').style.visibility = 'hidden';
            setTimeout(removeOverlay, 250);
        }, 1);
        chrome.runtime.sendMessage({'message': 'bookmark_move', 'bookmark_id': bookmark_id.value, 'folder_id': folder_id});
    }
    return folder;
}

function _createDropdown(responseText) {
    try {
        var scale = window.innerWidth / screen.availWidth || 1;
        if (scale < 1)
            scale = 1
        json = JSON.parse(responseText);
        if (json.bookmark_id && json.folders && json.folders.length && scale == 1) {
            folder_dropdown = document.getElementById('ofl');
            b_id = document.createElement('input');
            b_id.setAttribute('id', 'obid');
            b_id.setAttribute('type', 'hidden');
            b_id.setAttribute('value', json.bookmark_id);
            folder_dropdown.appendChild(b_id);
            for (var i = 0; i < json.folders.length; i++) {
                folder_dropdown.appendChild(_folderRow(json.folders[i]));
            }

            showsFolderDropdown = true;
            setTimeout(function () {
                folderDropdown = document.getElementById('of');
                if (_viewportWidth() < 768) {
                    cancelButton = document.getElementById('oc');
                    cancelButton.style.display = 'none';
                    folderDropdown.style.right = '20';
                }
                
                folderDropdown.style.visibility = 'visible';
                folderDropdown.style.opacity = '1';
            }, 1);
        }
    }
    catch(e) {
        //console.log('Dropdown error: ' + e);
    }
}

function _ipSend(href, title, from_greader)
{
    if (cancel || _ipDidSend) return;
    _ipDidSend = 1;

    var tzd = '';
    var thumbnail = '';
    if (!from_greader) {
        var pageInfo = SimpleParser.getBasicPageInfo(),
            canonical_url = pageInfo.canonical_url,
            url = pageInfo.url;
        title = pageInfo.title;
        thumbnail = pageInfo.thumbnail;
    } else {
        url = href;
    }


    var d = document,
        l = d.location,
        e = window.getSelection,
        k = d.getSelection,
        x = d.selection,
        s = String(e ? e() : (k ? k() : (x ? x.createRange().text : ''))),
        e = encodeURIComponent,
        z = d.createElement('scr'+'ipt'),

        p = (from_greader ? 'gr=1&' : '') +
            '&u=' + e(url) + '&t=' + e(title) +
            '&can_url=' + (canonical_url ? e(canonical_url) : '') +
            '&s=' + e(s.length >= 20 && s.length < 10240 ? s : '') +
            '&tzd=' + e(tzd) +
            '&i=' + e(thumbnail);

    var b = _greader ? '' : jbs(body);
    if (b.length > 512000) b = '';

    postbody = p + "&b=" + e(b);
    chrome.runtime.sendMessage({'message': 'bookmarklet_upload', 'postbody': postbody})
}

function unauthRedirect() {
    var d = document,
        l = d.location,
        t = window.getSelection,
        k = d.getSelection,
        x = d.selection,
        s = String(t ? t(): (k)? k(): (x ? x.createRange().text : '')),
        e = encodeURIComponent;
    window.location.href = (
        "https://www.instapaper.com/hello2" +
        "?u=" + e(l.href) + '&t=' + e(d.title) + '&s=' + e(s) + "&cookie_notice=1"
    );
}

chrome.runtime.onMessage.addListener(
    function(request, sender, sendResponse) {
        if (request.message == 'saveLink' && !saving) {
            saveLink(request.url);
        }
        if (request.message == 'bookmarklet' && !saving) {
            _rl();
        }
        else if (request.message == 'bookmarklet_status') {
            if (request.status == 'success') {
                _createDropdown(request.response);
                _cl_close();
            }
            else if (request.status == 'failure' && request.code == 403) {
                unauthRedirect();
            }
            else {
                overlayDone('Save Failed', '');
            }
        }
        else if (request.message == 'bookmarklet_xpath_status') {
            if (request.status == 'success') {
                parser_xpaths = request.xpaths
            }
            else if (request.status == 'failure' && request.code == 403) {
                unauthRedirect();
                return;
            }

            ipPageBodies[0] = btx_body(document.body).innerHTML;
            ipPageURLs[0] = document.location.href;
            ipFetchNextPage(document.body, document.location.href); 
        }
    }
)

function updateOverlaySize()
{
    var o = document.getElementById('ov');
    if (! o) return;
    var tablet = _viewportWidth() <= 768;
    var scale = window.innerWidth / screen.availWidth || 1;
    if (scale < 1)
        scale = 1;

    document.getElementById('ov_logo').style.clip = tablet? "rect(0px, 10px, 26px, 0px)": "initial";
    document.getElementById('ov_logoContainer').style.marginTop = tablet? "9px": "8px";
    document.getElementById('ov_logoContainer').style.marginLeft = tablet? "20px": "30px";
    document.getElementById('ov_logoContainer').style.position = tablet? "absolute": "relative";
    document.getElementById('oc').style.display = tablet && showsFolderDropdown? "none": "block";
    document.getElementById('of').style.marginRight = tablet? "0px": "30px";
    document.getElementById('oc').style.marginRight = tablet? "0px": "30px";
    document.getElementById('of').style.right = tablet? "20px": "0px";
    document.getElementById('oc').style.right = tablet? "20px": "0px";
    if (scale > 1) {
        o.style.padding = 10 * scale + 'px 0px';
        document.getElementById('ov_logoContainer').style.display = 'none';
        document.getElementById('oc').style.display = 'none';
        document.getElementById('of').style.display = 'none';
        document.getElementById('om').style.fontSize = (16 * scale) + 'px';
        document.getElementById('om').style.marginTop = '0px';
    }
}

function updateOverlayText(message, subtitle)
{
    var om = document.getElementById('om');
    if (! om) return;
    om.innerHTML = message + ' ' + subtitle;    
}

function overlayDone(message, subtitle)
{
    var o = document.getElementById('ov');
    if (! o) return;
    var d1 = document.getElementById('od1');
    var d2 = document.getElementById('od2');
    var d3 = document.getElementById('od3');
    if (d1) d1.parentNode.removeChild(d1);
    if (d2) d2.parentNode.removeChild(d2);
    if (d3) d3.parentNode.removeChild(d3);
    updateOverlayText(message, subtitle);
    removeOverlayTimer = setTimeout(removeOverlay, 3000);
}

function removeOverlay()
{
    var o = document.getElementById('ov');
    if (o) {
        setTimeout(function() {
            document.getElementById('ov').classList.remove('showing');
        }, 1);
        setTimeout(function() {
            saving = false;
            document.getElementById('ov').parentNode.removeChild(document.getElementById('ov'));
        }, 500);
    }
}

var overlayAnimFrame = 0;
function animateOverlay()
{
    var d1 = document.getElementById('od1');
    var d2 = document.getElementById('od2');
    var d3 = document.getElementById('od3');
    if (! d1 || ! d2 || ! d3) return;
    d1.style.color = 'rgb(60,60,60)';
    d2.style.color = 'rgb(60,60,60)';
    d3.style.color = 'rgb(60,60,60)';

    overlayAnimFrame = (overlayAnimFrame + 1) % 4;
    if (overlayAnimFrame == 1) d1.style.color = 'rgb(150,150,150)';
    else if (overlayAnimFrame == 2) d2.style.color = 'rgb(150,150,150)';
    else if (overlayAnimFrame == 3) d3.style.color = 'rgb(150,150,150)';
    setTimeout(animateOverlay, 250);
}

function _folderDropdownVisibleToggle(e) {
    var folderDropdown = document.getElementById('ofd');
    if (folderDropdown.style.visibility == 'hidden') {
        clearTimeout(removeOverlayTimer);
        folderDropdown.style.visibility = 'visible';
    }
    else {
        folderDropdown.style.visibility = 'hidden';
        removeOverlayTimer = setTimeout(removeOverlay, 2000);
    }

    if (!e)
        e = window.event;
    if (e.stopPropagation)
        e.stopPropagation();
    else
        e.cancelBubble = true;
    return false;
}

function _folderDropdownHide() {
    var folderDropdown = document.getElementById('ofd');
    if (folderDropdown.style.visibility != 'hidden') {
        folderDropdown.style.visibility = 'hidden';
        removeOverlayTimer = setTimeout(removeOverlay, 2000);    
    }
}

function _folderDropdown() {
    o1 = document.createElement('div');
    o1.setAttribute('id', 'of');
    oi = document.createElement('div');
    oi.setAttribute('id', 'ofi');
    oi.onclick = _folderDropdownVisibleToggle;
    o1.appendChild(oi);

    od = document.createElement('div');
    od.setAttribute('id', 'ofd');
    od.setAttribute('style', 'visibility: hidden;');
    oa = document.createElement('div');
    oa.setAttribute('id', 'ofa');
    oaa = document.createElement('div');
    oaa.setAttribute('id', 'ofai');
    oa.appendChild(oaa);
    od.appendChild(oa);

    of = document.createElement('div');
    of.setAttribute('id', 'ofl');
    oft = document.createElement('div');
    oft.setAttribute('id', 'oft');
    oft.appendChild(document.createTextNode('MOVE'));
    of.appendChild(oft);
    od.appendChild(of);
    o1.appendChild(od);
    return o1;
}

function _logo() {
    var imgDiv = document.createElement('div');
    imgDiv.setAttribute('id', 'ov_logoContainer');
    var img = document.createElement('div');
    img.setAttribute('id', 'ov_logo');
    imgDiv.appendChild(img);
    return imgDiv;
}

function _cancelButton() {
    o1 = document.createElement('div');
    o1.setAttribute('id', 'oc');
    o1.onclick = function() {
        cancel = 1;
        document.getElementById('ofd').style.visibility = 'hidden';
        _cl_close(true);
        removeOverlay();
    }
    return o1;
}

function _statusTitle() {
    var o1 = document.createElement('div');
    o1.setAttribute('id', 'om');
    o1.appendChild(document.createTextNode("Saving"));
    od1 = document.createElement('span');
    od1.setAttribute('id', 'od1');
    od1.appendChild(document.createTextNode('.'));
    o1.appendChild(od1);
    od2 = document.createElement('span');
    od2.setAttribute('id', 'od2');
    od2.appendChild(document.createTextNode('.'));
    o1.appendChild(od2);
    od3 = document.createElement('span');
    od3.setAttribute('id', 'od3');
    od3.appendChild(document.createTextNode('.'));
    o1.appendChild(od3);
    return o1;
}

function _overlay() {
    var o=document.createElement('div');
    o.setAttribute('id', 'ov');
    o.setAttribute('class', 'instapaper_overlay instapaper_ignore');
    o.appendChild(_logo());
    o.appendChild(_cancelButton());
    o.appendChild(_folderDropdown());
    o.appendChild(_statusTitle());
    return o;
}


function ipMultiPageFetchCompleted()
{
    if (cancel) return;
    //console.log("Got " + ipPageBodies.length + " pages");

    if (ipPageBodies.length > 1) {
        var jsonEsc = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g;
        function jsonQuote(string) {
            var subs = {
                '\b': '\\b',
                '\t': '\\t',
                '\n': '\\n',
                '\f': '\\f',
                '\r': '\\r',
                '"' : '\\"',
                '\\': '\\\\'
            };
            jsonEsc.lastIndex = 0;
            return jsonEsc.test(string) ?
                '"' + string.replace(jsonEsc, function (a){
                    var c = subs[a];
                    return typeof c === 'string'
                     ? c
                     : '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
                }) + '"' :
                '"' + string + '"'
            ;
        }

        body = 'multipage:[';
        for (var i = 0; i < ipPageBodies.length; i++) {
            body +=
                (i == 0 ? '' : ',') +
                '[' + jsonQuote(ipPageURLs[i]) + ',' + jsonQuote('<div>' + ipPageBodies[i] + '</div>') + ']'
            ;
        }
        body += ']';
    } else if (ipSinglePageCrawled) {
        body = 'singlepage:' + ipPageBodies[0];
    } else {
        body = ipPageBodies[0];
    }
    //console.log('Final body: ' + Math.floor(body.length / 1024) + ' KB');
    _ipSend(document.location.href, btxTitle.length ? btxTitle : document.title, false);
}

function ipFetchNextPage(bodyNode, bodyURL)
{
    if (cancel) return;
    (function(DOMParser){"use strict";var DOMParser_proto=DOMParser.prototype,real_parseFromString=DOMParser_proto.parseFromString;try{if((new DOMParser).parseFromString("","text/html")){return;}}catch(ex){}DOMParser_proto.parseFromString=function(markup,type){if(/^\s*text\/html\s*(?:;|$)/i.test(type)){var doc=document.implementation.createHTMLDocument(""),doc_elt=doc.documentElement,first_elt;doc_elt.innerHTML=markup;first_elt=doc_elt.firstElementChild;if(doc_elt.childElementCount===1&&first_elt.localName.toLowerCase()==="html"){doc.replaceChild(first_elt,doc_elt);}return doc;}else{return real_parseFromString.apply(this,arguments);}};}(DOMParser));

    var x, p, singlePageURL = (ipPageBodies.length == 1 ? btx_singlePageURL(bodyNode) : 0), nextPageURL = (singlePageURL ? 0 : btx_nextPageURL(bodyNode, bodyURL));
    if (ipPageBodies.length < 30 &&
        (singlePageURL || nextPageURL) &&
        (x=window.XMLHttpRequest?new XMLHttpRequest():(window.ActiveXObject?new ActiveXObject('Microsoft.XMLHTTP'):0))
    ) {
        try {
            if (nextPageURL && ipPageURLs.indexOf(nextPageURL) != -1) throw(0);
            //console.log('crawling ' + (singlePageURL ? 'single-page' : 'next-page') + ' url: ' + (singlePageURL ? singlePageURL : nextPageURL));
            updateOverlayText("Saving", singlePageURL ? 'All Pages\u2026' : 'Page ' + (ipPageBodies.length + 1));
            x.open('GET', singlePageURL ? singlePageURL : nextPageURL, true);
            x.onreadystatechange = function(){
                try {
                    if (x.readyState == 4) {
                        if (x.status == 200) {
                            var nextPageDoc = new DOMParser().parseFromString(x.responseText, 'text/html');
                            var nextPageBody = btx_body(nextPageDoc.body).innerHTML;
                            if (singlePageURL) ipSinglePageCrawled = 1;
                            ipPageBodies[singlePageURL ? 0 : ipPageBodies.length] = nextPageBody;
                            ipPageURLs[singlePageURL ? 0 : ipPageURLs.length] = nextPageURL;
                            if (singlePageURL) throw(0); else ipFetchNextPage(nextPageDoc.body, nextPageURL);
                        } else throw(0);
                    }
                } catch (e) { ipMultiPageFetchCompleted(); }
            }
            x.send();
        } catch(e) {
            ipMultiPageFetchCompleted();
        }
    } else {
        ipMultiPageFetchCompleted();
    }
}

function initializeVariables() {
    parser_xpaths = {}
    autodetect_next_page_url = false
    ipPageBodies = [];
    ipPageURLs = [];
    ipSinglePageCrawled = 0;
    showsFolderDropdown = false;
    removeOverlayTimer = undefined;
    body = undefined;
    _greader = false;
    btxTitle = '';
    cancel = 0;
    frameDidLoad = 0;
    _ipDidSend = 0;
}

function saveLink(url) {
    initializeVariables();
    saving = true;
    _greader = true;

    document.body.appendChild(_overlay());

    setTimeout(function() {
        document.getElementById('ov').classList.add('showing');
    }, 250);

    updateOverlaySize();
    animateOverlay();
    window.addEventListener("resize", updateOverlaySize, false);
    if ("onorientationchange" in window) window.addEventListener("orientationchange", updateOverlaySize, false);
    document.body.addEventListener('click', _folderDropdownHide, false);

    _ipSend(url, '', true);
}

function _rl(){
    if (!document.body) {
        alert('Please wait until the page has loaded.');
        return;
    }

    initializeVariables();    
    saving = true;
    _greader = false;

    var title,d=document,l=d.location,href=l.href;
    if (typeof NEWSBLUR != 'undefined') {
        _greader = true;
        if (
            typeof NEWSBLUR.reader != 'undefined' &&
            typeof NEWSBLUR.reader.active_story != 'undefined' &&
             NEWSBLUR.reader.active_story
        ) {
            href = NEWSBLUR.reader.active_story.story_permalink;
            title = NEWSBLUR.reader.active_story.story_title;
        } else {
            alert('Select a story to save before using the Save to Instapaper bookmark.');
            throw(0);
        }
    }

    document.body.appendChild(_overlay());

    setTimeout(function() {
        document.getElementById('ov').classList.add('showing');
    }, 250);

    updateOverlaySize();
    animateOverlay();
    window.addEventListener("resize", updateOverlaySize, false);
    if ("onorientationchange" in window) window.addEventListener("orientationchange", updateOverlaySize, false);
    document.body.addEventListener('click', _folderDropdownHide, false);

    if (_greader) {
        updateOverlayText("Saving", title);
        _ipSend(href, title, true);
    } else {
        chrome.runtime.sendMessage({'message': 'bookmarklet_xpaths', 'url': document.location.href})
    }
}

function _cl_close(cancel)
{
    var f = document.getElementById('{{ id }}');
    if (f) {
        f.style.display = 'none';
        f.parentNode.removeChild(f);
    }

    if (! cancel) overlayDone("Saved", btxTitle);
}
