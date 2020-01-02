(function() {
  const storage = window.storage || chrome.storage;

  storage.local.get(['hideWikia'], (result) => {
    if (result && result.hideWikia) {
      const wikiaLinks = document.querySelectorAll('[href*="runescape.fandom"], [href*="runescape.wikia"]');

      // recursively go up through tree until getting relevant div to remove
      function getParent(element, maxDepth = 10) {
        if (element.parentElement) {
          if (element.className === 'g') {
            var removedElement = document.createElement("span");
            removedElement.classList.add("st");
            removedElement.innerHTML="RS Wikia search result removed by RS Wiki Redirector."
            removedElement.style.paddingBottom="1em";
            removedElement.style.display="inline-block";
            element.parentElement.appendChild(removedElement);
            element.remove();
          } else {
            getParent(element.parentElement, maxDepth - 1);
          }
        }
      }

      wikiaLinks.forEach((e) => getParent(e));
    }
  });
})();
