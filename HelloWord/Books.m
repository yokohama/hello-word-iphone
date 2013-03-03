//
//  Books.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/03/03.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "Books.h"

@implementation Books

@synthesize items;

-(id)init{
    self = [super init];
    if (self) {
        items = [[[BookModel alloc] init] findAll];
    }
    return self;
}

-(BookModel *)find:(int)bookId {
    for (int i=0; i<[items count]; i++) {
        if (bookId == [items[i] recodeId]) {
            return items[i];
        }
    }
    return nil;
}

@end
