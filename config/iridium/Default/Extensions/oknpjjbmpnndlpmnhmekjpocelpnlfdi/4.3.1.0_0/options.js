// options.js

// NOTE: compat mode is disabled in 4.2.3.0
// ***

const OPTIONS = {
  KINDLE_EMAIL: 'kindleEmail',
};

const mercuryKindleEmail = document.querySelector('.mercury-kindle-email');
const kindleEmailInput = document.querySelector('.kindle-email-input');

// set checked from persisted value
chrome.storage.sync.get(null, (opts) => {
  kindleEmailInput.value = opts.kindleEmail || '';
});

kindleEmailInput.addEventListener('keyup', (e) => {
  chrome.runtime.sendMessage({
    optionsKey: OPTIONS.KINDLE_EMAIL,
    type: 'setOptions',
    value: e.target.value,
  });
});

// selects the whole email address when it's clicked
mercuryKindleEmail.addEventListener('click', (e) => {
  const selection = window.getSelection();
  const range = document.createRange();
  range.selectNodeContents(e.target);
  selection.removeAllRanges();
  selection.addRange(range);
});
