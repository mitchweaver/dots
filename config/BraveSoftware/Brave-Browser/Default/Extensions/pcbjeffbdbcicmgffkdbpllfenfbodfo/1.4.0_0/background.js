// Simple extension to redirect all requests to RS Wikia to RS Wiki
(function(){
  'use strict';
  let isPluginDisabled = false;
  let storage = window.storage || chrome.storage;

  const RSWIKIA_REGEX = /^(runescape|oldschoolrunescape)\.(wikia|fandom)\.com$/i;

  chrome.webNavigation.onBeforeNavigate.addListener(
    function(info) {
      if(isPluginDisabled) {
        console.log("RSWikia intercepted, ignoring because plugin is disabled.");
        return;
      }

      const url = new URL(info.url);

      const isWikia = RSWIKIA_REGEX.test(url.host); // is this necessary? we already filter by URL
      // If domain isn't subdomain of wikia.com, ignore, also if it's not in the redirect filter
      if (!isWikia) return;

      // Generate new url
      const host = url.host.includes('oldschool') ? 'oldschool.runescape' : 'runescape'
      const redirectUrl = `https://${host}.wiki${url.pathname.replace(/^\/wiki\//i,"/w/")}`;
      console.log(`RSWikia intercepted:  ${info.url}\nRedirecting to ${redirectUrl}`);
      // Redirect the old wikia request to new wiki
      chrome.tabs.update(info.tabId,{url:redirectUrl});
    });

  function updateIcon(){
    chrome.browserAction.setIcon({ path: isPluginDisabled?"icon32_black.png":"icon32.png"  });
  }

  storage.local.get(['isDisabled'],(result)=>{
      isPluginDisabled= result ? result.isDisabled : false;
      updateIcon();
  });

  storage.onChanged.addListener(
      function(changes, areaName) {
        // If isDisabled changed, update isPluginDisabled
        if(changes["isDisabled"]!==undefined && changes["isDisabled"].newValue!=changes["isDisabled"].oldValue) {
          console.log(`RS Wiki Redirector is now ${changes["isDisabled"].newValue?'disabled':'enabled'}`);
          isPluginDisabled=changes["isDisabled"].newValue;
          updateIcon();
        }
      }
    );
})();
