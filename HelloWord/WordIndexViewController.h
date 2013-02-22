//
//  SampleViewController.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/14.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordIndexViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *records;
    BOOL isDragging;
    UITableView *index;
    UILabel *count;
    UIView *tabBar;
}

@property(nonatomic, strong, readwrite) NSMutableArray *records;
@property(nonatomic, strong, readwrite) UITableView *index;

@end
