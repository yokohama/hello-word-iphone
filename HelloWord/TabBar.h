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
#import "Books.h"

@interface TabBar : UIScrollView {
    NSMutableArray *labels;
    UIView *currentLabel;
    UIViewController *delegateController;
    UIView *scrollArea;
    Books *books;
    UILabel *noBook;
    UIColor *pink;
}

@property (nonatomic, strong, readwrite) NSMutableArray *labels;
@property (nonatomic, strong, readwrite) UIView *currentLabel;
@property (nonatomic, strong, readwrite) UILabel *noBook;

- (id)initWithFrame:(CGRect)frame delegateController:(UIViewController *)controller;
- (UIView *)findByBookId:(int)_bookId;
- (void)changeLabel :(UIView *)label;
- (void)rehash;
- (int)getLabelIndex :(UIView *)label;

@end
