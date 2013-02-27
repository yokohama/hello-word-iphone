//
//  TabBar.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/26.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "TabBar.h"

#define TAB_WIDTH_SIZE 80
#define TAB_SPACER_SIZE 2

@implementation TabBar

@synthesize labels, currentLabel;

- (id)initWithFrame:(CGRect)frame delegateController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        labels = [NSMutableArray array];
        delegateController = controller;
        
        self.backgroundColor = [UIColor whiteColor];
        
        NSMutableArray *books = [[[BookModel alloc]init] findAll];
        [self makeTabs:books];
    }
    return self;
}

-(UILabel *)findByBookId:(int)_bookId {
    UILabel *result = nil;
    for (int i=0; i<[labels count]; i++) {
        if ([labels[i] tag] == _bookId) {
            result = labels[i];
        }
    }
    return result;
}

-(void)changeLabel :(UILabel *)label{
    if (self.currentLabel.tag != label.tag) {
        label.backgroundColor = [UIColor redColor];
        self.currentLabel.backgroundColor = [UIColor grayColor];
    }
    self.currentLabel = label;
    
    float zoom = 0;
    for (int i=0; i<[labels count]; i++) {
        UILabel *l = labels[i];
        zoom += (l.frame.size.width);
        if (l.tag == self.currentLabel.tag) {
            break;
        }
    }
    
    NSLog(@"%f", zoom);
    CGRect rect = CGRectMake(zoom+40, 0, 100, 100);
    [self scrollRectToVisible:rect animated:YES];
}

-(void)rehash:(NSMutableArray *)books {
    [self makeTabs:books];
    UILabel *current = labels[0];
    [self changeLabel:current];
}

-(void)makeTabs :(NSMutableArray *)books{
    
    [[self viewWithTag:@"scrollArea"] removeFromSuperview];
    
    int scrollAreaWidth = self.frame.size.width;
    int tabBarWidthSize = 0;
    if ([books count] != 0) {
        for (int i=0; i<[books count]; i++) {
            tabBarWidthSize += (TAB_WIDTH_SIZE + TAB_SPACER_SIZE);
        }
        scrollAreaWidth = tabBarWidthSize;
    }
    
    scrollArea = nil;
    if ([books count] == 0) {
        scrollArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        UILabel *noBook = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        noBook.text = @"下にスクロールしてデータを同期";
        noBook.backgroundColor = [UIColor whiteColor];
        noBook.font = [UIFont fontWithName:@"AppleGothic" size:10];
        noBook.textAlignment = NSTextAlignmentCenter;
        [scrollArea addSubview:noBook];
    } else {
        scrollArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollAreaWidth-2, self.frame.size.height)];
        for (int i=0; i<[books count]; i++) {
            NSString *labelText = [[NSString alloc] initWithFormat:@" %@", [books[i] title]];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((TAB_WIDTH_SIZE*i)+(TAB_SPACER_SIZE*i), 0, TAB_WIDTH_SIZE, 35)];
            label.text = labelText;
            label.layer.cornerRadius = 5;
            label.layer.shadowOpacity = 0.2;
            label.layer.shadowOffset = CGSizeMake(2.0, 4.0);
            label.userInteractionEnabled = YES;
            label.font = [UIFont fontWithName:@"AppleGothic" size:10];
            label.numberOfLines = 0;
            label.tag = [books[i] recodeId];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:delegateController action:@selector(tabBookTitle:)];
            [label addGestureRecognizer:tap];
            [scrollArea addSubview:label];
            if (self.currentLabel == nil) {
                label.backgroundColor = [UIColor redColor];
                self.currentLabel = label;
            } else {
                label.backgroundColor = [UIColor grayColor];
            }
            [labels addObject:label];
        }
    }
    scrollArea.tag = @"scrollArea";
    
    [self addSubview:scrollArea];
    self.contentSize = scrollArea.bounds.size;
    self.showsHorizontalScrollIndicator = NO;
    
    UILabel *line = nil;
    if (scrollAreaWidth < self.frame.size.width) {
        line = [[UILabel alloc] initWithFrame:CGRectMake(-300, 30, self.frame.size.width+500, 5)];
    } else {
        line = [[UILabel alloc] initWithFrame:CGRectMake(-300, 30, scrollAreaWidth+500, 5)];
    }
    [line setBackgroundColor:[UIColor redColor]];
    [self addSubview:line];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
