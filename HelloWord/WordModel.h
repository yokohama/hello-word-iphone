//
//  WordModel.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/03.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Validation.h"
#import "Db.h"

@interface WordModel : Db{
    int recode_id;
    NSString *word, *answer;
}

#define WORD_CREATE_SQL @"CREATE TABLE IF NOT EXISTS words (id INTEGER PRIMARY KEY, word TEXT, answer TEXT);"

@property(readwrite) int recode_id;
@property(nonatomic, strong, readwrite) NSString *word, *answer;

-(id)init;
-(id)initWithValues: (NSString *)_word answer:(NSString *)_answer;

-(NSArray *)validate;
-(NSString *)errorMessages;
-(WordModel *)isAlready;
-(void)create;
-(void)update;
-(NSMutableArray *)findAll;
-(void)destroy;

@end