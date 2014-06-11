//
//  ShadySlider.h
//  WindowUITest
//
//  Created by Sean Seefried on 10/06/2014.
//  Copyright (c) 2014 SeefriedSoftware. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ShadyControl.h"

@interface ShadyFloatSlider : NSView <ShadyControl>

@property NSSlider    *slider;
@property NSTextField *titleLabel;
@property NSTextField *minLabel;
@property NSTextField *maxLabel;
@property NSString    *uniform;

- (id)initWithUniform:(NSString *)uniform title:(NSString *)title minValue:(double)minValue maxValue:(double)maxValue;

@end
