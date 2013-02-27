//
//  BookModel.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/22.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "BookModel.h"
#import "WordModel.h"

@implementation BookModel

@synthesize recodeId, title, words;

-(id)init{
    self = [super initWithCreateSql:BOOK_CREATE_SQL];
    words = [NSMutableArray array];
    return self;
}

-(id)initWithBookId:(int)bookId {
    self = [super initWithCreateSql:BOOK_CREATE_SQL];
    words = [NSMutableArray array];
    return [self find:bookId];
}

-(BookModel *)find:(int)recordId{
    [db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM books WHERE id = %d", recordId];
    FMResultSet *result = [db executeQuery:sql];
    if ([result next]) {
        recordId = [result intForColumn:@"id"];
        if (recordId == 0) {
            recodeId = 1;
        } else {
            recodeId = recordId;
        }
        title = [result stringForColumn:@"title"];
    }
    [db close];
    
    self.words = [[[WordModel alloc] init] findByBookId:recodeId];
    
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

-(int)create{
    NSString *sql = [[NSString alloc] initWithFormat:@"INSERT INTO books ('id', 'title') VALUES(NULL, '%@');", title];
    [db open];
    [db executeUpdate:sql];
    int createRowId = [db lastInsertRowId];
    [db close];
    
    return createRowId;
}

-(void)rehash:(NSMutableArray *)books{
    //現在のものを削除
    NSMutableArray *_books = [[[BookModel alloc]init] findAll];
    for (int i=0; i<[_books count]; i++){
        BookModel *oldBook = (BookModel *)_books[i];
        [oldBook destroy];
    }
    NSMutableArray *_words = [[[WordModel alloc]init] findAll];
    for (int i=0; i<[_words count]; i++){
        WordModel *oldWm = (WordModel *)_words[i];
        [oldWm destroy];
    }
    
    for (int i=0; i<[books count]; i++){
        BookModel *book = (BookModel *)books[i];
        int bookId = [book create];
        for (int iw=0; iw<[book.words count]; iw++) {
            WordModel *wm = book.words[iw];
            wm.bookId = bookId;
            [wm create];
        }
    }
}

@end
