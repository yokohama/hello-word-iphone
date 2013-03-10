//
//  WordIndexPageController.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/26.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

#import "WordListViewController.h"
#import "TabBar.h"
#import "ConfigListViewController.h"
#import "Books.h"


@interface WordIndexPageViewController : UIViewController <UIPageViewControllerDelegate,UIPageViewControllerDataSource>{
    UIScrollView *pageArea;
    UIPageViewController *pageViewController;
    WordListViewController *wordListViewController;
    
    TabBar *tabBar;
    int bookId;
    Books *books;
    
    UIView *header;
    UILabel *titleArea;
    UIView *alpha;
    UIButton *playButton;
    
    UIView *toolArea;
    
    int pageIndex;
    int pageMax;
    UILabel *page;
}

- (id)initWithBookId :(int)_bookId;

- (void)setWordListViewController :(int)_bookId;

- (void)rehash;

@end
