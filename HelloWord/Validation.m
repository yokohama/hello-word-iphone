//
//  Validation.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/03.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "Validation.h"

@implementation Validation

@synthesize property, errorMessage;

-(id)initWithValues:(NSString *)p error_msg:(NSString *)e{
    self = [super init];
    property = p;
    errorMessage = e;
    return self;
}

@end
