//
//  LPScrollToMarkOperation.h
//  calabash
//
//  Created by Julien Curro on 18/02/14.
//  Copyright (c) 2014 Xamarin. All rights reserved.
//

#import "LPOperation.h"

@class UIView;

@interface LPScrollToMarkOperation : LPOperation

- (BOOL) view:(UIView *) aView hasMark:(NSString *) aMark;
- (BOOL) view:(UIView *) aView hasSubviewWithMark:(NSString *) aMark;

@end
