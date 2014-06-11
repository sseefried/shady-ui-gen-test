//
//  ShadyUIGen.m
//  WindowUITest
//
//  Created by Sean Seefried on 11/06/2014.
//  Copyright (c) 2014 SeefriedSoftware. All rights reserved.
//

#import "ShadyUIGen.h"
#import "ShadyFloatSlider.h"

@implementation ShadyUIGen

+ (NSWindow *)uiFromSpec:(NSString *)uiSpecString error:(NSError **)error
{
  NSArray *uiSpec = [ShadyUIGen parseJSONSpec:uiSpecString error:error];
  if (!*error) {
    return [ShadyUIGen windowFromUISpec:uiSpec];
  }
  return nil;
}

+ (NSArray *)parseJSONSpec:(NSString *)uiSpecString error:(NSError **)error
{
  NSString *errorDomain = @"ShadyUIGenError";
  NSData *data = [NSData dataWithBytes:[uiSpecString cStringUsingEncoding:NSASCIIStringEncoding]
                                length: uiSpecString.length];
  NSError *jsonError = nil;
  NSArray *uiSpec =
  [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
  if (!jsonError) {
    if (![uiSpec isKindOfClass:[NSArray class]]) {
      *error = [NSError errorWithDomain:errorDomain code:2 userInfo: @{NSLocalizedDescriptionKey : @"Shady UI Specification must be a JSON Array"}];
      return nil;
    }
    
    for (id maybeJSONObject in uiSpec) {
      if (![maybeJSONObject isKindOfClass:[NSDictionary class]]) {
        *error = [NSError errorWithDomain:errorDomain code:3
                                 userInfo: @{NSLocalizedDescriptionKey : [NSString stringWithFormat: @"Shady UI Specification must be a JSON Array of JSON Objects. Instead found '%@'", maybeJSONObject]}];
        return nil;
      }
      NSDictionary *jsonDict = (NSDictionary *)maybeJSONObject;
      NSString *sort = [jsonDict valueForKey:@"sort"];
      if (!sort) {
        *error = [NSError errorWithDomain:errorDomain
                                     code:4
                                 userInfo: @{NSLocalizedDescriptionKey : [NSString stringWithFormat: @"JSON Object %@ does not contain \"sort\" key", maybeJSONObject]}];
        return nil;
      }
      if ([sort isEqualToString:@"float_slider"]) {
        // FIXME: Some more boring error work
      } else if ([sort isEqualToString:@"int_slider"]) {
        // FIXME: Some more boring error work
      } else if ([sort isEqualToString:@"time"]) {
        // FIXME: Some more boring error work
      } else {
        *error = [NSError errorWithDomain:errorDomain
                                     code:5
                                 userInfo: @{NSLocalizedDescriptionKey : [NSString stringWithFormat: @"Invalid sort for Shady UI element: \"%@\"", sort]}];
        return nil;
      }
    }
    
  } else {
    *error = [NSError errorWithDomain:errorDomain code:1 userInfo:[jsonError userInfo]];
    return nil;
  }
  return uiSpec;
}

+ (NSControl *)controlFromUIElem:(NSDictionary *)uiElement
{
  NSString *sort = [uiElement valueForKey:@"sort"];
  NSSlider *slider = nil;
  if ([sort isEqualToString:@"float_slider"]) {
    NSString *uniform = [uiElement valueForKey:@"glslUniform"];
    NSNumber *minValue = [uiElement valueForKey:@"min"];
    NSNumber *maxValue = [uiElement valueForKey:@"max"];
    slider = [[ShadyFloatSlider alloc] initWithUniform:uniform minValue:[minValue doubleValue] maxValue:[maxValue doubleValue]];
  }
  return slider;
}

+ (NSWindow *)windowFromUISpec:(NSArray *)uiSpec
{
  // Create a new dynamic window with a blue background
  NSLog(@"Creating new window");
  CGFloat width = 200, height = 200;
  NSRect frame = NSMakeRect(0, 0, width, height);
  NSWindow *window  = [[NSWindow alloc] initWithContentRect:frame
                                                   styleMask:(NSTitledWindowMask |
                                                              NSClosableWindowMask |
                                                              NSResizableWindowMask)
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
  NSRect bounds = [[NSScreen mainScreen] frame];
  
  //  [window setBackgroundColor:[NSColor blueColor]];
  [window makeKeyAndOrderFront:NSApp];
  [window setFrameTopLeftPoint: NSMakePoint(100,bounds.size.height - 100)];
  
  NSView *view = [window contentView];


  NSControl *lastControl = nil;
  for (NSDictionary *uiElement in uiSpec) {
    NSControl *control = [ShadyUIGen controlFromUIElem: uiElement];
    [control setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [view addSubview: control];
    NSDictionary *viewsDictionary;
    if (lastControl) {
      viewsDictionary = @{ @"current": control, @"last": lastControl };
    } else {
      viewsDictionary = @{ @"current": control };
    }

    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[current(>=100)]-|"
                                               options: 0
                                               metrics:nil
                                               views:viewsDictionary];
    [view addConstraints:constraints];
    if (lastControl) {

      constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=20)-[current(>=20)]-[last(>=20)]-|"
                                        options: 0
                                        metrics:nil
                                        views:viewsDictionary];
      [view addConstraints: constraints];

    }
    lastControl = control;
  }
  return window;
}

@end
