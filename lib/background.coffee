chrome.browserAction.onClicked.addListener (tab) ->
  chrome.tabs.executeScript(null, {file: "vendor/jquery-1.7.2.min.js"})
  chrome.tabs.executeScript(null, {file: "vendor/color-0.4.1.js"})
  chrome.tabs.executeScript(null, {file: "vendor/farbtastic.js"})
  chrome.tabs.insertCSS(null, {file: "vendor/farbtastic.css"})
  chrome.tabs.executeScript(null, {file: "jsColorUnblinder.js"})
