//
//  Config.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/21.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "ConfigModel.h"

@implementation ConfigModel

@synthesize email, password, recodeId;

-(id)init{
    self = [super initWithCreateSql:CONFIG_CREATE_SQL];
    
    [db open];
    FMResultSet *result = [db executeQuery:@"SELECT * FROM configs WHERE id = 1;"];
    
    if ([result next]) {
        recodeId = [result intForColumn:@"id"];
        email = [result stringForColumn:@"email"];
        password = [result stringForColumn:@"password"];
    }
    
    [db close];
    return self;
}

-(void)regist{
    [db open];
    if ([self isExist]) {
        NSString *sql = [[NSString alloc] initWithFormat:@"UPDATE configs set email = '%@', password = '%@' WHERE id = 1;", email, password];
        [db executeUpdate:sql];
    } else {
        NSString *sql = [[NSString alloc] initWithFormat:@"INSERT INTO configs VALUES(NULL, '%@', '%@');", email, password];
        [db executeUpdate:sql];
    }
    [db close];
}

-(void)unRegist{
    [db open];
    NSString *sql = [[NSString alloc] initWithFormat:@"UPDATE configs set email = NULL, password = NULL WHERE id = 1;"];
    [db executeUpdate:sql];
    [db close];
}

-(BOOL)isRegisted{
    [db open];
    FMResultSet *result = [db executeQuery:@"SELECT * FROM configs WHERE id = 1;"];
    BOOL b = NO;
    if ([result next]) {
        email = [result stringForColumn:@"email"];
        password = [result stringForColumn:@"password"];
        if (email != nil && password != nil) {
            b = YES;
        }
    }
    
    [db close];
    return b;
}

-(BOOL)isExist{
    if (recodeId == 1) {
        return YES;
    } else {
        return NO;
    }
}

@end
