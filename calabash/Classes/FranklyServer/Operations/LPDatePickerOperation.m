#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LPDatePickerOperation.h"
#import <UIKit/UIKit.h>
#import "LPCocoaLumberjack.h"

@implementation LPDatePickerOperation

/*
 args << options[:is_timer] || false
 args << options[:notify_targets] || true
 args << options[:animate] || true
 */


//                        required =========> |     optional
// _arguments ==> [target date str, format str, notify targets, animated]
- (id) performWithTarget:(id) target error:(NSError *__autoreleasing*) error {
  if (![target isKindOfClass:[UIDatePicker class]]) {
    [self getError:error
      formatString:@"View: %@ should be a date picker", target];
    return nil;
  }

  NSArray *arguments = self.arguments;

  UIDatePicker *picker = (UIDatePicker *) target;

  NSString *dateStr = arguments[0];
  if (dateStr == nil || [dateStr length] == 0) {
    [self getError:error
      formatString:@"Date str: '%@' should be non-nil and non-empty", dateStr];
    return nil;
  }

  NSUInteger argCount = [arguments count];

  NSString *dateFormat = nil;
  if (argCount > 1) {
    dateFormat = arguments[1];
  } else {
    [self getError:error
      formatString:@"Date format is required as the second argument"];
    return nil;
  }


  BOOL notifyTargets = YES;
  if (argCount > 2) {
    notifyTargets = [arguments[2] boolValue];
  }

  BOOL animate = YES;
  if (argCount > 3) {
    animate = [arguments[3] boolValue];
  }

  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:dateFormat];
  NSDate *date = [formatter dateFromString:dateStr];
  if (!date) {
    [self getError:error
      formatString:@"Could not create date from '%@' and format '%@'",
     dateStr, dateFormat];
    return nil;
  }

  NSDate *minDate = picker.minimumDate;
  if (minDate && [date compare:minDate] == NSOrderedAscending) {
    [self getError:error
      formatString:@"Could not set the date to '%@' because is earlier than "
     "the minimum date '%@'",
     date,
     [minDate descriptionWithLocale:[NSLocale autoupdatingCurrentLocale]]];
    return nil;
  }

  NSDate *maxDate = picker.maximumDate;
  if (maxDate && [date compare:maxDate] == NSOrderedDescending) {
    [self getError:error
      formatString:@"Could not set the date to '%@' because is later than "
     "the maximum date '%@'",
     date,
     [maxDate descriptionWithLocale:[NSLocale autoupdatingCurrentLocale]]];
    return nil;
  }

  [picker setDate:date animated:animate];

  if (notifyTargets) {
    UIControlEvents events = [picker allControlEvents];
    [picker sendActionsForControlEvents:events];
  }

  return target;
}

@end
