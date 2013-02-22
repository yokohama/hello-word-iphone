//
//  BookModel.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/22.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "Db.h"

@interface BookModel : Db{
    int recodeId;
    NSString *title;
}

#define BOOK_CREATE_SQL @"CREATE TABLE IF NOT EXISTS books (id INTEGER PRIMARY KEY, title TEXT);"

@property(readwrite) int recodeId;
@property(nonatomic, strong, readwrite) NSString *title;

-(id)init;
-(BookModel *)find :(int)recordId;
-(NSMutableArray *)findAll;
-(void)destroy;
-(void)create;
-(void)rehash :(NSMutableArray *)books;

@end
