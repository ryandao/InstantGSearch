//
//  AppDelegate.m
//  InstantGSearch
//
//  Created by Ryan Dao on 10/31/12.
//  Copyright (c) 2012 Ryan Dao. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  
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
  NSURL *searchURL = [self buildGoogleSearchURL:selectedText];

  [[NSWorkspace sharedWorkspace] openURL:searchURL];
}

- (NSURL *)buildGoogleSearchURL:(NSString *)searchStr {
  NSString *urlString;

  if ([self validateUrl:searchStr]) {
    // If the search string is already an url, open it directly
		urlString = searchStr;
  } else if (! searchStr) {
    // If the string is empty or nil, open Google
    urlString = @"http://www.google.com";
  } else {
    // Search Google for any valid search string
    NSString *escapedStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
      NULL,
      (__bridge CFStringRef) searchStr,
      NULL,
      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
      kCFStringEncodingUTF8));
    
  	urlString = [@"http://www.google.com/search?q=" stringByAppendingString:escapedStr];
  }
  
  return [NSURL URLWithString:urlString];
}

- (NSString *)getSelectedText {
  NSPasteboard *pb = [NSPasteboard generalPasteboard];
  
  // TODO: Take out the current PasteBoard element and put it back after done
  
  // Simulate the copy action
  NSInteger currentChangeCount = [pb changeCount];
  [self simulateCopy];
  
  // Poll the pasteboard and get the selected text
  // TODO: while loop vs NSTimer?
  NSDate *startTime = [NSDate date];
  while (true) {
    if (currentChangeCount != [pb changeCount]) {
      while (true) {
        // Another polling since the text might not be written in Pasteboard yet
        NSString *selectedText = [pb stringForType:NSStringPboardType];
        if (selectedText != nil) {
          return selectedText;
        }
      }
    } else {
      NSDate *endTime = [NSDate date];
      if ([endTime timeIntervalSinceDate:startTime] - 0.1 > 0) {
        return nil;
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

- (BOOL) validateUrl: (NSString *) candidate {
  NSString *urlRegEx =
  @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
  NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
  return [urlTest evaluateWithObject:candidate];
}

@end
