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

- (id)initWithFrame:(CGRect)frame selectedLabel:(UILabel *)selectedLabel delegateController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        NSMutableArray *books = [[[BookModel alloc]init] findAll];
        int scrollAreaWidth = frame.size.width;
        int tabBarWidthSize = 0;
        if ([books count] != 0) {
            for (int i=0; i<[books count]; i++) {
                tabBarWidthSize += (TAB_WIDTH_SIZE + TAB_SPACER_SIZE);
            }
            scrollAreaWidth = tabBarWidthSize;
        }
        
        UIView *scrollArea = nil;
        if ([books count] == 0) {
            scrollArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            UILabel *noBook = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            noBook.text = @"下にスクロールしてデータを同期";
            noBook.backgroundColor = [UIColor whiteColor];
            noBook.font = [UIFont fontWithName:@"AppleGothic" size:10];
            noBook.textAlignment = NSTextAlignmentCenter;
            [scrollArea addSubview:noBook];
        } else {
            scrollArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollAreaWidth-2, frame.size.height)];
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
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:controller action:@selector(tabBookTitle:)];
                [label addGestureRecognizer:tap];
                [scrollArea addSubview:label];
                if (selectedLabel == nil) {
                    label.backgroundColor = [UIColor redColor];
                    selectedLabel = label;
                } else {
                    label.backgroundColor = [UIColor grayColor];
                }
            }
        }
        
        [self addSubview:scrollArea];
        self.contentSize = scrollArea.bounds.size;
        self.showsHorizontalScrollIndicator = NO;
        self.tag = @"tabBar";
        
        UILabel *line = nil;
        if (scrollAreaWidth < self.frame.size.width) {
            line = [[UILabel alloc] initWithFrame:CGRectMake(-300, 30, self.frame.size.width+500, 5)];
        } else {
            line = [[UILabel alloc] initWithFrame:CGRectMake(-300, 30, scrollAreaWidth+500, 5)];
        }
        [line setBackgroundColor:[UIColor redColor]];
        [self addSubview:line];
    }
    return self;
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
