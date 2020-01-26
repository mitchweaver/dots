const handleClickCancel = () => {
  chrome.runtime.sendMessage({ type: 'removeRootUrlWarning' });
};

const handleClickRender = () => {
  chrome.runtime.sendMessage({ type: 'browserAction', force: true });
};

const cancelButton = document.getElementById('mercury-warning-cancel-button');
cancelButton.addEventListener('click', handleClickCancel);

const renderButton = document.getElementById('mercury-warning-render-button');
renderButton.addEventListener('click', handleClickRender);
