# InstantGSearch

This little Mac application/hack helps you instantly search Google for the currently highlighted text by hitting the hotkey **Option+G**

## How it works
---------------
It's a very simple and dirty hack. Basically I just simulate the Copy action whenever the hotkey is pressed and grab the text from Pasteboard. I thought about getting the selected text by doing UI inspection using either Applescript, Accessibility API or whatever, but sometimes the dirty solution works the best. 