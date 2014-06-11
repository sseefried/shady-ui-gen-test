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

  for (NSDictionary *uiElement in uiSpec) {
    NSControl *control = [ShadyUIGen controlFromUIElem: uiElement];
    NSLog(@"Control: %@", control);
    [view addSubview: control];
  }
  
//  ShadyFloatSlider *slider  = [[ShadyFloatSlider alloc] initWithFrame:NSMakeRect(0,30,50,20)
//                                                              uniform:@"Slider 1"
//                                                             minValue:0
//                                                             maxValue:10];
//  ShadyFloatSlider *slider2 = [[ShadyFloatSlider alloc] initWithFrame:NSMakeRect(0,0,50,20)
//                                                              uniform:@"Slider 2"
//                                                             minValue:10
//                                                             maxValue:15];
  
//  NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(slider, slider2);
  
  // -----------------------------------------------------------------------------
//  NSArray *controls = [NSArray arrayWithObjects: slider, slider2, nil];
//  

//  
//  for (id control in controls) {
//    // For slider to dynamically size itself to the parent window this must be set to NO
//    [control setTranslatesAutoresizingMaskIntoConstraints: NO];
//    [view addSubview: control]; // FIXME: subsume this into addControl
//  }
//  
//  // Constraint needs to be parsed after [slider] is added to superview.
//  NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[slider(>=100)]-|"
//                                                                 options: 0
//                                                                 metrics:nil
//                                                                   views:viewsDictionary];
//  [view addConstraints:constraints];
//  
//  constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[slider2(>=100)]-|"
//                                                        options: 0
//                                                        metrics:nil
//                                                          views:viewsDictionary];
//  [view addConstraints:constraints];
//  
//  
//  constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=20)-[slider]-[slider2]-|"
//                                                        options: 0
//                                                        metrics:nil
//                                                          views:viewsDictionary];
//  [view addConstraints:constraints];
  return window;
}

@end
