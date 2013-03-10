//
//  WordListViewController.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/26.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

#import "SBJsonParser.h"

#import "Books.h"
#import "ConfigModel.h"
#import "WordShowViewController.h"
#import "WordPlayViewController.h"
#import "TabBar.h"
#import "HeaderView.h"
#import "RefreshView.h"

@interface WordListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    UIViewController *invorkedController;
    
    Books *books;
    NSMutableArray *records;
    int bookId;
    NSMutableArray *newBooks;
    TabBar *tabBar;
    HeaderView *header;
    RefreshView *refreshView;
    
    int pageIndex;
    int recordeCount;
    
    NSMutableData *responseData;
}

@property int pageIndex;
@property (nonatomic, strong, readwrite) UILabel *Areacount;
@property (nonatomic, strong, readwrite) NSMutableArray *records;
@property (nonatomic, strong, readonly) TabBar *tabBar;
@property int bookId;
@property (nonatomic, strong, readwrite) RefreshView *refreshView;

//-(id)initWithBookId: (int)_bookId invorked:(UIViewController *)controller;
-(id)initWithBookId :(int)_bookId invorked:(UIViewController *)controller tabBar:(TabBar *)_tabBar header:(HeaderView *)_header;

@end
