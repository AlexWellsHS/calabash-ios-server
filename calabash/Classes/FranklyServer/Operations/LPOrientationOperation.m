#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

//
//  LPOrientationOperation.m
//  Calabash
//
//  Copyright (c) 2013 Xamarin. All rights reserved.
//

#import "LPOrientationOperation.h"
#import <UIKit/UIKit.h>
#import "LPCocoaLumberjack.h"

static NSString *const kDevice = @"device";
static NSString *const kStatusBar = @"status_bar";
static NSString *const kLeft = @"left";
static NSString *const kRight = @"right";
static NSString *const kUp = @"up";
static NSString *const kDown = @"down";
static NSString *const kUnknown = @"unknown";
static NSString *const kFaceDown = @"face down";
static NSString *const kFaceUp = @"face up";

@implementation LPOrientationOperation

+ (NSString *) deviceOrientation {

  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
  switch (orientation) {
    case UIDeviceOrientationUnknown: return kUnknown;
    case UIDeviceOrientationPortrait: return kDown;
    case UIDeviceOrientationPortraitUpsideDown: return kUp;
      /*** UNEXPECTED ***/
      /*
       confusing semantics

       the rotation methods in the gem orient by the position of the home button
       e.g. if the home is on the right we say "the device is in the right orientation"

       from the apple docs -

       UIDeviceOrientationLandscapeRight:  The device is in landscape mode,
       with the device held upright and the home button on the __left__ side.

       ===>  so we reverse left and right <===
       */
    case UIDeviceOrientationLandscapeLeft: return kRight;
    case UIDeviceOrientationLandscapeRight: return kLeft;
      /******************/
    case UIDeviceOrientationFaceDown: return kFaceDown;
    case UIDeviceOrientationFaceUp: return kFaceUp;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
    default: return kUnknown;
#pragma clang diagnostic pop
  }
}


+ (NSString *) statusBarOrientation {
  UIInterfaceOrientation orientation = [[UIApplication sharedApplication]
                                        statusBarOrientation];
  switch (orientation) {
    case UIInterfaceOrientationPortrait: return kDown;
    case UIInterfaceOrientationPortraitUpsideDown: return kUp;
      /*** UNEXPECTED ***/
      /*
       confusing semantics

       from the app docs -

       UIInterfaceOrientationLandscapeLeft: The device is in landscape mode,
       with the device held upright and the home button on the __left__ side.

       ==> no need to reverse left and right <==
       */
    case UIInterfaceOrientationLandscapeLeft: return kLeft;
    case UIInterfaceOrientationLandscapeRight: return kRight;
      /******************/

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
    default: return kDown;
#pragma clang diagnostic pop

  }
}


// _arguments ==> {'device' | 'status_bar'}
- (id) performWithTarget:(id) target error:(NSError *__autoreleasing*) error {

  NSArray *argument = self.arguments;

  NSUInteger argCount = [argument count];
  if (argCount == 0) {
    [self getError:error
      formatString:@"Requires exactly one argument: {'%@' | '%@'} found none",
     kDevice, kStatusBar];
    return nil;
  }

  if (argCount > 1) {
    [self getError:error
      formatString:@"Argument should be {'%@' | '%@'} - found '[%@']", kDevice,
     kStatusBar, [argument componentsJoinedByString:@", "]];
    return nil;
  }

  NSString *firstArg = argument[0];
  if (![@[kDevice, kStatusBar] containsObject:firstArg]) {
    [self getError:error
      formatString:@"Argument should be {'%@' | '%@'} - found '%@'",
     kDevice, kStatusBar, firstArg];
  }

  if ([kDevice isEqualToString:firstArg]) {
    return [LPOrientationOperation deviceOrientation];
  } else if ([kStatusBar isEqualToString:firstArg]) {
    return [LPOrientationOperation statusBarOrientation];
  } else {
    LPLogWarn(@"Fell through conditions for arguments: '[%@]'",
              [argument componentsJoinedByString:@", "]);
    return nil;
  }
}

@end
