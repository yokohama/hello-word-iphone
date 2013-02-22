//
//  BookModel.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/22.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel

@synthesize recodeId, title;

-(id)init{
    self = [super initWithCreateSql:BOOK_CREATE_SQL];
    return self;
}

-(BookModel *)find:(int)recordId{
    [db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM books WHERE id = %d", recordId];
    FMResultSet *result = [db executeQuery:sql];
    if ([result next]) {
        recordId = [result intForColumn:@"id"];
        title = [result stringForColumn:@"title"];
    }
    [db close];
    return self;
}

-(NSMutableArray *)findAll{
    NSMutableArray *records = [[NSMutableArray alloc] init];
    NSString *sql= @"SELECT * FROM books;";
    [db open];
    FMResultSet *result = [db executeQuery:sql];
    while ([result next]) {
        int _resultId = [result intForColumn:@"id"];
        NSString *_title = [result stringForColumn:@"title"];
        BookModel *bm = [[BookModel alloc] init];
        bm.recodeId = _resultId;
        bm.title = _title;
        [records addObject:bm];
    }
    [db close];
    
    return records;
}

-(void)destroy{
    NSString *sql = [[NSString alloc] initWithFormat:@"DELETE FROM books WHERE id = %d;", recodeId];
    [db open];
    [db executeUpdate:sql];
    [db close];
}

-(void)create{
    NSString *sql = [[NSString alloc] initWithFormat:@"INSERT INTO books VALUES(NULL, '%@');", title];
    [db open];
    [db executeUpdate:sql];
    [db close];
}

-(void)rehash:(NSMutableArray *)books{
    NSMutableArray *_books = [[[BookModel alloc]init] findAll];
    for (int i=0; i<[_books count]; i++){
        BookModel *book = (BookModel *)_books[i];
        [book destroy];
    }
    for (int i=0; i<[books count]; i++){
        [books[i] create];
    }
}

@end
