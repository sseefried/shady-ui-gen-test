//
//  ShadySlider.m
//  WindowUITest
//
//  Created by Sean Seefried on 10/06/2014.
//  Copyright (c) 2014 SeefriedSoftware. All rights reserved.
//

#import "ShadyFloatSlider.h"

@implementation ShadyFloatSlider

- (id)initWithUniform:(NSString*)uniform title:(NSString *)title minValue:(double)minValue maxValue:(double)maxValue
{
    self = [super initWithFrame:NSMakeRect(0,0,100,100)];
    if (self) {
      self.uniform = uniform;
      self.titleLabel = [[NSTextField alloc] init];
      self.minLabel   = [[NSTextField alloc] init];
      self.maxLabel   = [[NSTextField alloc] init];

      self.titleLabel.stringValue = title;
      self.minLabel.stringValue = [NSString stringWithFormat:@"%.4f", minValue];
      self.maxLabel.stringValue = [NSString stringWithFormat:@"%.4f", maxValue];
      
      for (NSTextField *tf in @[self.titleLabel, self.minLabel, self.maxLabel]) {
        [self addSubview: tf];
        tf.translatesAutoresizingMaskIntoConstraints = NO;
        tf.editable = NO;
        tf.drawsBackground = NO;
        tf.bezeled = NO;
      }
      
      self.slider = [[NSSlider alloc] init];
      [self addSubview:self.slider];
      [self.slider setMinValue:minValue];
      [self.slider setMaxValue:maxValue];
      [self.slider setTarget:self];
      [self.slider setAction:@selector(handleShadyControl)];
      [self.slider setTranslatesAutoresizingMaskIntoConstraints:NO];




      NSDictionary *viewsDictionary = @{@"slider": self.slider, @"title": self.titleLabel, @"min": self.minLabel, @"max": self.maxLabel };
      NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[title]-[min]-[slider]-[max]|"
                                                                     options: 0
                                                                     metrics:nil
                                                                     views:viewsDictionary];
      [self addConstraints:constraints];
    
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
  NSLog(@"ShadyFloatSlider \"%@\" changed to value %f", self.uniform, [self.slider doubleValue]);
}



@end
