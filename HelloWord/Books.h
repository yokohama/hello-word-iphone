//
//  Books.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/03/03.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BookModel.h"

@interface Books : NSObject {
    NSMutableArray *items;
}

@property (nonatomic, strong, readwrite) NSMutableArray *items;

+ (Books *)factory;

-(BookModel *)find:(int)bookId;
-(void)rehash :(NSMutableArray *)newBooks;

@end


