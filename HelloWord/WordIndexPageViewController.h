//
//  WordIndexPageController.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/26.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WordListViewController.h"
#import "TabBar.h"
#import "ConfigListViewController.h"
#import "WordPlayViewController.h"

@interface WordIndexPageViewController : UIViewController <UIPageViewControllerDelegate,UIPageViewControllerDataSource>{
    UIPageViewController *pageViewController;
    WordListViewController *wordListViewController;
    
    UIScrollView *tabBar;
    int bookId;
    NSMutableArray *books;
    
    int pageIndex;
    int pageMax;
    UILabel *page;
    
    UILabel *selectedLabel;

}

- (id)initWithBookId :(int)_bookId;
- (void)setWordListViewController :(int)_bookId;

@end
