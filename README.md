# InstantGSearch

This little Mac application/hack helps you instantly search Google for the currently highlighted text by hitting the hotkey **Option+G**.

## How to use
---------------
Download and run the application: https://github.com/downloads/ryandao/InstantGSearch/InstantGSearch.zip. It's a background app so you won't see anything. Confirm whether it works by highlighting some text and hit the magical hotkey **Option+G**.

It's better to run the app on startup by adding it to the Login items at System Preferences > Users and Groups > Login Items

## How it works
---------------
It's a very simple and dirty hack. Basically I just simulate the Copy action whenever the hotkey is pressed and grab the text from Pasteboard. I thought about getting the selected text by doing UI inspection using either Applescript, Accessibility API or whatever, but sometimes the dirty solution works the best. 