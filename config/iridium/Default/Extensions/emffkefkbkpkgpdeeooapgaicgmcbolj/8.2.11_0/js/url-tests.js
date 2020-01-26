

var match = null;
var wikiOptions="(wiki|zh|zh\\-tw|zh\\-hk|zh\\-mo|zh\\-sg|zh\\-cn|zh\\-hant|zh\\-hans)";
var wikiString='';
function getFullHostName() {
	return 'www.wikiwand.com';
}

// Compute the required redirect page
function getRedirectUrl(requestedURL) {
	var returnVal = {};
	var lang = null;
	var page = null;

	// -------------------------------------------------------------
	// REDIRECTING FROM WIKIPEDIA -> TO WIKIWAND
	// -------------------------------------------------------------
	// Test for flag get parameter not to redirect
	var wikipediaDontRedirectRegExp = new RegExp("^https?://([a-zA-Z0-9\\-_]+)\\.(?:m\\.)?wikipedia\\.(?:com|org)/"+wikiOptions+"/(.*)(?:\\?oldformat=true|\\?previous=yes)", "i");
	match = requestedURL.match(wikipediaDontRedirectRegExp);
	if (match && match.length === 4) {
		lang = match[1];
		wikiString=match[2];
		page = match[3];
		returnVal.redirectURL = 'https://' + getFullHostName() + '/' + lang + '/' + page;
		returnVal.domain = 'wikipedia';
		returnVal.autoRedirect = false;
		returnVal.lang = lang;
		return returnVal;
	}

	// Wikipedia root home page (not per language) -> redirect to our WikiWand homepage
	var wikipediaRootRegExp = new RegExp("^https?://(www)?\\.wikipedia\\.(com|org)/?$", "i");
	var match = requestedURL.match(wikipediaRootRegExp);
	if (match) {
		returnVal.redirectURL = "https://" + getFullHostName();
		returnVal.domain = 'wikipedia'; // source domain
		returnVal.autoRedirect = false;
		returnVal.lang = 'en';
		return returnVal;
	}



	//  Wikipedia article page with ?title=....
	var wikipediaLangHomeRegExp = new RegExp("^https?://([a-zA-Z0-9\\-_]+)\\.(?:m\\.)?wikipedia\\.org/\\?title=(.*)$", "i");
	match = requestedURL.match(wikipediaLangHomeRegExp);
	if (match && match.length === 3) {
		lang = match[1];
		page = match[2];
		returnVal.redirectURL = 'https://' + getFullHostName() + '/' + lang + '/' + page;
		returnVal.domain = 'wikipedia'; // source domain
		returnVal.lang = lang;
		returnVal.autoRedirect = true;
		return returnVal;
	}

	//  Wikipedia article/home page -> redirect to the apropriate page on WikiWand
	var wikipediaLangHomeRegExp = new RegExp("^https?://([a-zA-Z0-9\\-_]+)\\.(?:m\\.)?wikipedia\\.org/"+wikiOptions+"/(.*)$", "i");
	match = requestedURL.match(wikipediaLangHomeRegExp);
	if (match && match.length === 4) {
		lang = match[1];
		wikiString=match[2];
		if (wikiString!='wiki'){
			lang=wikiString;
		}
		page = match[3];
		try{
			decodeURI(page);
		}catch(e){
			returnVal.redirectURL = 'https://' + getFullHostName() + '/' + lang + '/' + page;
			returnVal.domain = 'wikipedia'; // source domain
			returnVal.lang = lang;
			returnVal.autoRedirect = true;
			return returnVal;
		}

		// Detect homepage:
		// Go through all of the namespaces in all languages. For each language we have a field called 'homepage'.
		// we need to match this with the current "page", if it is indeed the homepage for this language, redirect to
		// the wikiwand homepage for that language.
		if (namespecesDict[lang]) {
			var element = namespecesDict[lang];
			if (decodeURI(page) === element['homepage']) {
				returnVal.redirectURL = "https://" + getFullHostName() + "/" + lang + "/";
				returnVal.domain = 'wikipedia'; // source domain
				returnVal.autoRedirect = false;
				returnVal.lang = lang;
				return returnVal;
			}
		}

		// Wikipedia special pages in namespaces (e.g. Talk, Portal) -> don't redirect
		var specialPagesRegexp = new RegExp("^https?://([a-zA-Z0-9\\-_]+)\\.(?:m\\.)?wikipedia\\.org/"+wikiOptions+"/([^:]*):(.*)$", "i");
		var match2 = requestedURL.match(specialPagesRegexp);
		if (match2 && match2.length === 5) {
			lang = match2[1];
			wikiString=match[2];
			var ns = decodeURI(match2[3]);
			if (namespecesDict[lang]) {
				var element = namespecesDict[lang];
				var namespacesForLang = element['namespaces'];
				for (index in namespacesForLang) {
					if (namespacesForLang[index].replace(' ','_') === ns) {
						returnVal.redirectURL = null;
						returnVal.domain = 'wikipedia'; // source domain
						returnVal.autoRedirect = false;
						returnVal.lang = lang;
						return returnVal;
					}
				}


				var element = namespecesDict['cross-lang'];
				var namespacesForLang = element['namespaces'];
				for (index in namespacesForLang) {
					if (namespacesForLang[index].replace(' ','_') === ns) {
						returnVal.redirectURL = null;
						returnVal.domain = 'wikipedia'; // source domain
						returnVal.autoRedirect = false;
						returnVal.lang = lang;
						return returnVal;
					}
				}
			}
		}



		// A page on Wikipedia but still not a homepage? -> redirect it to a WikiWand Page
		returnVal.redirectURL = 'https://' + getFullHostName() + '/' + lang + '/' + page;
		returnVal.domain = 'wikipedia'; // source domain
		returnVal.lang = lang;
		returnVal.autoRedirect = true;
		return returnVal;
	}

	// -------------------------------------------------------------
	// DEFAULT: UNRECOGNIZED URL -> DON'T REDIRECT
	// -------------------------------------------------------------
	returnVal.redirectURL = null;
	returnVal.domain = null;
	returnVal.autoRedirect = false;
	returnVal.lang = null;
	return returnVal;
}


// This function does the same as getRedirectUrl, only it adds a few exceptions like home page
function testAutoRedirect(requestedURL) {
	var returnVal = getRedirectUrl(requestedURL);
	if (returnVal.autoRedirect === false) {
		returnVal.redirectURL = null;
	}
	return returnVal;
}
