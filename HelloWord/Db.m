//
//  Db.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/21.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "Db.h"

@implementation Db

-(id)initWithCreateSql:(NSString *)sql{
    self = [super init];
    [self db_connect:sql];
    return self;
}

-(void)db_connect :(NSString *)sql{
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    dir   = [paths objectAtIndex:0];
    db_path  = [dir stringByAppendingPathComponent:@"hello_word.db"];
    //NSLog(@"%@", db_path);
    db = [FMDatabase databaseWithPath:db_path];
    
    [db open];
    [db executeUpdate:sql];
    [db close];
}

@end
