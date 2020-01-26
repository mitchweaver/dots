//<script>

function searchGoodreads(info)
{
 var searchString = info.selectionText;
 var goodReads = "http://www.goodreads.com/search?utf8=%E2%9C%93&query=" + searchString;
 chrome.tabs.getSelected(null, function(tab){
										index = tab.index + 1;
										chrome.tabs.create({"url":goodReads, "index":index, "active": false});
										});
   
}

chrome.contextMenus.create({title: "Search Goodreads", contexts:["selection"], onclick: searchGoodreads});

//</script>