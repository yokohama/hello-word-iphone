//
//  Validation.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/03.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validation : NSObject{
    NSString *property;
    NSString *errorMessage;
}

@property(nonatomic, strong, readwrite) NSString *property, *errorMessage;

-(id)initWithValues:(NSString *)p error_msg:(NSString *)e;

@end
