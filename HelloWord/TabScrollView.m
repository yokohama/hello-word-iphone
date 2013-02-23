//
//  TabScrollView.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/15.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "TabScrollView.h"
#import "BookModel.h"

#define TAB_WIDTH_SIZE 80
#define TAB_SPACER_SIZE 2

@implementation TabScrollView

//@synthesize parentController;

- (id)initWithFrame:(CGRect)_frame
{
    self = [super initWithFrame:_frame];
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    NSMutableArray *books = [[[BookModel alloc]init] findAll];
    int scrollAreaWidth = _frame.size.width;
    int tabBarWidthSize = 0;
    if ([books count] != 0) {
        for (int i=0; i<[books count]; i++) {
            tabBarWidthSize += (TAB_WIDTH_SIZE + TAB_SPACER_SIZE);
        }
        scrollAreaWidth = tabBarWidthSize;
    }
    
    UIView *scrollArea = nil;
    if ([books count] == 0) {
        
    } else {
        scrollArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollAreaWidth, _frame.size.height)];
        for (int i=0; i<[books count]; i++) {
            NSString *labelText = [[NSString alloc] initWithFormat:@" %@", [books[i] title]];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((TAB_WIDTH_SIZE*i)+(TAB_SPACER_SIZE*i), 0, TAB_WIDTH_SIZE, 35)];
            label.text = labelText;
            label.layer.cornerRadius = 5;
            label.layer.shadowOpacity = 0.2;
            label.layer.shadowOffset = CGSizeMake(2.0, 4.0);
            label.userInteractionEnabled = YES;
            label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            label.tag = [books[i] recodeId];
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabBookTitle:)];
            [label addGestureRecognizer:tap];
            [scrollArea addSubview:label];
        }
    }
    [sv addSubview:scrollArea];
    sv.contentSize = scrollArea.bounds.size;
    sv.showsHorizontalScrollIndicator = NO;
    [self addSubview:sv];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, _frame.size.width, 5)];
    [line setBackgroundColor:[UIColor redColor]];
    [self addSubview:line];
    
    return self;
}

- (void)tabBookTitle: (UITapGestureRecognizer *)sender{
    UILabel *label = (UILabel *)sender.view;
    //parentController.bookId = label.tag;
    NSLog(@"=%d", label.tag);
}

@end
