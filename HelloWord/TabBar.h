//
//  TabBar.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/26.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

#import "BookModel.h"
#import "WordModel.h"

@interface TabBar : UIScrollView {
    NSMutableArray *labels;
    UILabel *currentLabel;
    UIViewController *delegateController;
    UIView *scrollArea;
}

@property (nonatomic, strong, readwrite) NSMutableArray *labels;
@property (nonatomic, strong, readwrite) UILabel *currentLabel;

- (id)initWithFrame:(CGRect)frame delegateController:(UIViewController *)controller;
- (UILabel *)findByBookId:(int)_bookId;
- (void)changeLabel :(UILabel *)label;
- (void)rehash :(NSMutableArray *)books;

@end
