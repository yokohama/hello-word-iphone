//
//  WordListViewController.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/26.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SBJsonParser.h"

#import "WordModel.h"
#import "BookModel.h"
#import "ConfigModel.h"
#import "WordShowViewController.h"
#import "TabBar.h"

@interface WordListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    UIViewController *invorkedController;
    
    NSMutableArray *records;
    int bookId;
    UILabel *count;
    
    int pageIndex;
    int recordeCount;
}

@property int pageIndex;
@property (nonatomic, strong, readwrite) UILabel *count;
@property (nonatomic, strong, readwrite) NSMutableArray *records;
@property int bookId;

-(id)initWithBookId: (int)_bookId invorked:(UIViewController *)controller;

@end
