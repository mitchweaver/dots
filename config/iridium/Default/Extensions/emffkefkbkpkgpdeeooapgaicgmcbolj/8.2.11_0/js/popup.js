function saveOptions() {
	chrome.storage.sync.set({
		ocdShowInWikiwand: document.getElementById('ocdShowInWikiwand').checked,
		ocdShowInWebsites: document.getElementById('ocdShowInWebsites').checked
	}, function() {
		chrome.runtime.sendMessage({command: 'analytics',category:'hovercard',action:'settings',label:'wikiwand_'+document.getElementById('ocdShowInWikiwand').checked});
		chrome.runtime.sendMessage({command: 'analytics',category:'hovercard',action:'settings',label:'all_websites_'+document.getElementById('ocdShowInWebsites').checked});
		chrome.tabs.query({active: true, currentWindow: true}, function(tabs){
			chrome.tabs.sendMessage(tabs[0].id, {command: 'settings-changed'}, function(response) {});
		});
	});
}

function restoreOptions() {
	chrome.storage.sync.get({
		ocdShowInWikiwand: true,
		ocdShowInWebsites: true
	}, function(options) {
		document.getElementById('ocdShowInWikiwand').checked = options.ocdShowInWikiwand;
		document.getElementById('ocdShowInWebsites').checked = options.ocdShowInWebsites;
	});
}
document.addEventListener('DOMContentLoaded', restoreOptions);

var elms = document.getElementsByClassName('saveOnClick');
var i;
for (i = 0; i < elms.length; i++) {
	elms[i].addEventListener('click', saveOptions);
}

