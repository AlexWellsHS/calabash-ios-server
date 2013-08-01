//
//  QueryOperation.m
//  Created by Karl Krukow on 10/09/11.
//  Copyright (c) 2011 Xamarin. All rights reserved.
//

#import "LPQueryOperation.h"
#import "LPJSONUtils.h"
#import "LPTouchUtils.h"


@implementation LPQueryOperation
- (NSString *) description {
	return [NSString stringWithFormat:@"Query: %@",_arguments];
}


- (id) performWithTarget:(UIView*)_view error:(NSError **)error {
    return [super performWithTarget:_view error:error];
}            
                 
@end
