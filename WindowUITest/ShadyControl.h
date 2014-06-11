//
//  ShadyControl.h
//  WindowUITest
//
//  Created by Sean Seefried on 10/06/2014.
//  Copyright (c) 2014 SeefriedSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShadyControl <NSObject>

@property NSString* uniform;

- (void)handleShadyControl; // FIXME: Terrible name. Improve. Calls into Haskell land

@end
