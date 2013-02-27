//
//  WordModel.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/03.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "WordModel.h"

@implementation WordModel

@synthesize recodeId, bookId, word, answer;

-(id)init{
    self = [super initWithCreateSql:WORD_CREATE_SQL];
    return self;
}

-(id)initWithValues:(NSString *)_word answer:(NSString *)_answer{
    self = [super initWithCreateSql:WORD_CREATE_SQL];
    word = _word;
    answer = _answer;
    return self;
}

-(NSArray *)validate{
    NSMutableArray *errors = [[NSMutableArray alloc] init];
    if (word == nil || [word isEqualToString:@""]){
        Validation *v = [[Validation alloc] initWithValues:@"word" error_msg:@"「word」を入力してください。"];
        [errors addObject:v];
    }
    if (answer == nil || [word isEqualToString:@""]){
        Validation *v = [[Validation alloc] initWithValues:@"答え" error_msg:@"「答え」を入力してください。"];
        [errors addObject:v];
    }
    return errors;
}

-(NSString *)errorMessages{
    NSArray *validations = [self validate];
    NSString *errorMsg = @"";
    for (int i = 0; i < [validations count]; i++) {
        NSLog(@"%@", errorMsg);
        errorMsg = [errorMsg stringByAppendingString:[validations[i] errorMessage]];
        errorMsg = [errorMsg stringByAppendingString:@"\n"];
    }
    return errorMsg;
}

-(WordModel *)isAlready{
    WordModel *already = nil;
    NSString *sql= @"SELECT * FROM words;";
    [db open];
    FMResultSet *result = [db executeQuery:sql];
    while ([result next]) {
        int result_id = [result intForColumn:@"id"];
        NSString *_word = [result stringForColumn:@"word"];
        NSString *_answer = [result stringForColumn:@"answer"];
        if ([word isEqualToString:_word]) {
            already = [[WordModel alloc] initWithValues:_word answer:_answer];
            already.recodeId = result_id;
        }
        //NSLog(@"%d : %@", result_id , _word);
    }
    [db close];
    return already;
}

-(void)create{
    NSString *sql = [[NSString alloc] initWithFormat:@"INSERT INTO words ('id', 'book_id', 'word', 'answer') VALUES(NULL, '%d', '%@', '%@');",  bookId, word, answer];
    //NSLog(sql);
    [db open];
    [db executeUpdate:sql];
    //int createRowId = [db lastInsertRowId];
    //NSLog(@"%@", sql);
    //NSLog(@"%d", createRowId);
    [db close];
}

-(void)update{
    NSString *sql = [[NSString alloc] initWithFormat:@"UPDATE words set word = '%@', answer ='%@' where id = %d;", word, answer, recodeId];
    [db open];
    [db executeUpdate:sql];
    [db close];
}

-(WordModel *)find :(int)_recodeId{
    WordModel *wm = nil;
    NSString *sql= [[NSString alloc] initWithFormat:@"SELECT * FROM words WHERE id = %d;", _recodeId];
    [db open];
    FMResultSet *result = [db executeQuery:sql];
    if ([result next]) {
        int result_id = [result intForColumn:@"id"];
        int book_id = [result intForColumn:@"book_id"];
        NSString *_word = [result stringForColumn:@"word"];
        NSString *_answer = [result stringForColumn:@"answer"];
        wm = [[WordModel alloc] initWithValues:_word answer:_answer];
        wm.recodeId = result_id;
        wm.bookId = book_id;
    }
    [db close];
    return wm;
}

-(NSMutableArray *)findAll{
    WordModel *wm = nil;
    NSMutableArray *records = [[NSMutableArray alloc] init];
    NSString *sql= @"SELECT * FROM words;";
    [db open];
    FMResultSet *result = [db executeQuery:sql];
    while ([result next]) {
        int result_id = [result intForColumn:@"id"];
        int book_id = [result intForColumn:@"book_id"];
        NSString *_word = [result stringForColumn:@"word"];
        NSString *_answer = [result stringForColumn:@"answer"];
        wm = [[WordModel alloc] initWithValues:_word answer:_answer];
        wm.recodeId = result_id;
        wm.bookId = book_id;
        [records addObject:wm];
    }
    [db close];
    
    return records;
}

-(NSMutableArray *)findByBookId:(int)_bookId{
    WordModel *wm = nil;
    NSMutableArray *records = [[NSMutableArray alloc] init];
    NSString *sql= [[NSString alloc] initWithFormat:@"SELECT * FROM words WHERE book_id = %d;", _bookId];
    [db open];
    FMResultSet *result = [db executeQuery:sql];
    while ([result next]) {
        int result_id = [result intForColumn:@"id"];
        NSString *_word = [result stringForColumn:@"word"];
        NSString *_answer = [result stringForColumn:@"answer"];
        wm = [[WordModel alloc] initWithValues:_word answer:_answer];
        wm.recodeId = result_id;
        wm.bookId = _bookId;
        [records addObject:wm];
    }
    [db close];
    
    return records;
}

-(void)destroy {
    NSString *sql = [[NSString alloc] initWithFormat:@"DELETE FROM words WHERE id = %d;", recodeId];
    [db open];
    [db executeUpdate:sql];
    [db close];
}

@end