//
//  ShadySlider.m
//  WindowUITest
//
//  Created by Sean Seefried on 10/06/2014.
//  Copyright (c) 2014 SeefriedSoftware. All rights reserved.
//

#import "ShadyFloatSlider.h"

@implementation ShadyFloatSlider

- (id)initWithUniform:(NSString*)uniform minValue:(double)minValue maxValue:(double)maxValue
{
    self = [super initWithFrame:NSMakeRect(0,0,1000,20)];
    if (self) {
      self.uniform = uniform;
      [self setMinValue:minValue];
      [self setMaxValue:maxValue];
      [self setTarget:self];
      [self setAction:@selector(handleShadyControl)];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)handleShadyControl
{
  NSLog(@"ShadyFloatSlider \"%@\" changed to value %f", self.uniform, [self doubleValue]);
}



@end
