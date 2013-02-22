//
//  Config.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/21.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Db.h"

@interface ConfigModel : Db{
    int recordId;
    NSString *email;
    NSString *password;
}

#define CONFIG_CREATE_SQL @"CREATE TABLE IF NOT EXISTS configs (id INTEGER PRIMARY KEY, email TEXT, password TEXT);"

@property(readwrite) int recodeId;
@property(nonatomic, strong, readwrite) NSString *email, *password;

-(id)init;

-(void)regist;
-(void)unRegist;
-(BOOL)isRegisted;

@end