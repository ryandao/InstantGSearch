# InstantGSearch

This little Mac application/hack helps you instantly search Google for the currently highlighted text by hitting the hotkey **Option+G**.

## How to use
---------------
Download and run the application: http://ryandao.net/files/InstantGSearch.zip. It's a background app so you won't see anything. Confirm whether it works by highlighting some text and hit the magical hotkey **Option+G**.

It's better to run the app on startup by adding it to the Login items at System Preferences > Users and Groups > Login Items

## Build from Xcode
---------------
Clone the repo, open the project file with Xcode. Go to Product > Archieve > Distribute > Export as Application to build the application from source code.

## How it works
---------------
The app simulates the Copy action whenever the hotkey is pressed and grab the text by polling Pasteboard. It then opens Google search for the keyword in your default browser.
