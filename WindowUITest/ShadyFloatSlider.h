//
//  ShadySlider.h
//  WindowUITest
//
//  Created by Sean Seefried on 10/06/2014.
//  Copyright (c) 2014 SeefriedSoftware. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ShadyControl.h"

@interface ShadyFloatSlider : NSSlider <ShadyControl>

@property NSString *uniform;

- (id)initWithUniform:(NSString *)uniform minValue:(double)minValue maxValue:(double)maxValue;

@end
