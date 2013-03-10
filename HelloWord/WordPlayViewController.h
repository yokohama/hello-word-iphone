//
//  PlayViewController.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/02.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WordTicketViewController.h"

@interface WordPlayViewController : UIViewController <UIPageViewControllerDelegate,UIPageViewControllerDataSource>{
    
    UIPageViewController *pageViewController;
    int pageIndex;
    int pageMax;
    UISlider *slider;
    
    UIButton *close;
    NSArray *records;
    
    UIView *pageArea;
    UIView *playBarArea;
    UILabel *point;
}

@property (nonatomic, strong, readwrite) NSArray *records;

- (WordTicketViewController *)setWordTicketViewController;
- (int)getPageIndex:(WordTicketViewController *)tvc;

@end
