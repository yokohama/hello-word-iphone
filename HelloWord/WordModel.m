//
//  WordModel.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/03.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "WordModel.h"

@implementation WordModel

@synthesize recode_id, word, answer;



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
            already.recode_id = result_id;
        }
        //NSLog(@"%d : %@", result_id , _word);
    }
    [db close];
    return already;
}

-(void)create{
    NSString *sql = [[NSString alloc] initWithFormat:@"INSERT INTO words VALUES(NULL, '%@', '%@');", word, answer];
    [db open];
    [db executeUpdate:sql];
    [db close];
    //NSLog(@"%@", sql);
}

-(void)update{
    NSString *sql = [[NSString alloc] initWithFormat:@"UPDATE words set word = '%@', answer ='%@' where id = %d;", word, answer, recode_id];
    [db open];
    [db executeUpdate:sql];
    [db close];
}

-(NSMutableArray *)findAll{
    WordModel *wm = nil;
    NSMutableArray *records = [[NSMutableArray alloc] init];
    NSString *sql= @"SELECT * FROM words;";
    [db open];
    FMResultSet *result = [db executeQuery:sql];
    while ([result next]) {
        int result_id = [result intForColumn:@"id"];
        NSString *_word = [result stringForColumn:@"word"];
        NSString *_answer = [result stringForColumn:@"answer"];
        wm = [[WordModel alloc] initWithValues:_word answer:_answer];
        wm.recode_id = result_id;
        [records addObject:wm];
    }
    [db close];
    
    return records;
}

-(void)destroy {
    NSString *sql = [[NSString alloc] initWithFormat:@"DELETE FROM words WHERE id = %d;", recode_id];
    [db open];
    [db executeUpdate:sql];
    [db close];
}

@end