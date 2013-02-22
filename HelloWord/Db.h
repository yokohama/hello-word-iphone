//
//  Db.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/21.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface Db : NSObject{
    NSArray *paths;
    NSString *dir;
    NSString *db_path;
    FMDatabase *db;
}

-(id)initWithCreateSql :(NSString *)sql;

@end
