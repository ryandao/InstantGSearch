//
//  AppDelegate.m
//  InstantGSearch
//
//  Created by Ryan Dao on 10/31/12.
//  Copyright (c) 2012 Ryan Dao. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize isSearchText;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  isSearchText = NO;
  
	// Register our magical hotkey
  DDHotKeyCenter *hkCenter = [[DDHotKeyCenter alloc] init];
  
  if ([hkCenter registerHotKeyWithKeyCode:5
                            modifierFlags:NSAlternateKeyMask
                                   target:self
                                   action:@selector(searchGoogle:)
                                   object:nil]) {
    NSLog(@"Successfully registered hotkey");
		NSLog(@"%@", [NSString stringWithFormat:@"Registered: %@", [hkCenter registeredHotKeys]]);
  } else {
    NSLog(@"Unable to register hotkey");
  }
}

- (void)searchGoogle:(NSEvent *) hkEvent {
  NSString *selectedText = [self getSelectedText];
  NSString *searchURL = [self buildGoogleSearchURL:selectedText];
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:searchURL]];
}

- (NSString *)buildGoogleSearchURL:(NSString *)searchStr {
  NSString *searchQuery = [searchStr stringByReplacingOccurrencesOfString:@" " withString:@"+"];
  return [@"http://www.google.com/search?q=" stringByAppendingString:searchQuery];
}

- (NSString *)getSelectedText {
  NSPasteboard *pb = [NSPasteboard generalPasteboard];
  
  // TODO: Take out the current PasteBoard element and put it back after done
  
  // Simulate the copy action
  NSInteger currentChangeCount = [pb changeCount];
  [self simulateCopy];
  
  // Poll the pasteboard for whether our text has been put to the pasteboard
  // TODO: while loop vs NSTimer?
  // TODO: Use isSearchText to insure the text in Pasteboard is ours
  while (true) {
    if (currentChangeCount != [pb changeCount]) {
			while (true) {
        // Another polling since the text might not be written in Pasteboard yet
				NSString *selectedText = [pb stringForType:NSStringPboardType];
        if (selectedText != nil) {
          return selectedText;
        }
      }
    }
  }
}

- (void)simulateCopy {
  CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
  CGEventRef copyCommandDown = CGEventCreateKeyboardEvent(source, (CGKeyCode)8, YES);
  CGEventSetFlags(copyCommandDown, kCGEventFlagMaskCommand);
  CGEventRef copyCommandUp = CGEventCreateKeyboardEvent(source, (CGKeyCode)8, NO);
  
  CGEventPost(kCGAnnotatedSessionEventTap, copyCommandDown);
  CGEventPost(kCGAnnotatedSessionEventTap, copyCommandUp);
  
  CFRelease(copyCommandUp);
  CFRelease(copyCommandDown);
  CFRelease(source);
}

@end
