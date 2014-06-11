//
//  AppDelegate.m
//  WindowUITest
//
//  Created by Sean Seefried on 3/06/2014.
//  Copyright (c) 2014 SeefriedSoftware. All rights reserved.
//

#import "AppDelegate.h"
#import "ShadyFloatSlider.h"
#import "ShadyUIGen.h"

@implementation AppDelegate

  - (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSError *e = nil;
  self.theNewWindow = [ShadyUIGen uiFromSpec:@"[ { \"sort\": \"float_slider\", \"title\": \"Number of spikes\", \"glslUniform\": \"spikes\", \"min\": 1, \"max\": 10 }]" error:&e];
  if (e) {
    NSLog(@"ShadyUIGen errors %@", e);
  }

  
}

- (void)windowTest
{
  // Create a new dynamic window with a blue background
  NSLog(@"Creating new window");
  CGFloat width = 200, height = 200;
  NSRect frame = NSMakeRect(0, 0, width, height);
  NSWindow *window = [[NSWindow alloc] initWithContentRect:frame
                                                   styleMask:(NSTitledWindowMask |
                                                              NSClosableWindowMask |
                                                              NSResizableWindowMask)
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
  NSRect bounds = [[NSScreen mainScreen] frame];
  
  //  [window setBackgroundColor:[NSColor blueColor]];
  [window makeKeyAndOrderFront:NSApp];
  [window setFrameTopLeftPoint: NSMakePoint(100,bounds.size.height - 100)];
  
  
  
  ShadyFloatSlider *slider  = [[ShadyFloatSlider alloc] initWithUniform:@"Slider 1"
                                                             minValue:0
                                                             maxValue:10];
  ShadyFloatSlider *slider2 = [[ShadyFloatSlider alloc] initWithUniform:@"Slider 2"
                                                             minValue:10
                                                             maxValue:15];
  
  NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(slider, slider2);
  
  // -----------------------------------------------------------------------------
  NSArray *controls = [NSArray arrayWithObjects: slider, slider2, nil];
  
  NSView *view = [window contentView];
  
  for (id control in controls) {
    // For slider to dynamically size itself to the parent window this must be set to NO
    [control setTranslatesAutoresizingMaskIntoConstraints: NO];
    [view addSubview: control]; // FIXME: subsume this into addControl
  }
  
  // Constraint needs to be parsed after [slider] is added to superview.
  NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[slider(>=100)]-|"
                                                                 options: 0
                                                                 metrics:nil
                                                                   views:viewsDictionary];
  [view addConstraints:constraints];
  
  constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[slider2(>=100)]-|"
                                                        options: 0
                                                        metrics:nil
                                                          views:viewsDictionary];
  [view addConstraints:constraints];
  
  
  constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=20)-[slider]-[slider2]-|"
                                                        options: 0
                                                        metrics:nil
                                                          views:viewsDictionary];
  [view addConstraints:constraints];
}

@end
