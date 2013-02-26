//
//  ScrollArea.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/26.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "TabScrollAreaView.h"

@implementation TabScrollAreaView

#define REFRESH_VIEW_HEIGHT 200
#define HEADER_MARGIN_WIDTH 10
#define TAB_WIDTH_SIZE 80
#define TAB_SPACER_SIZE 2

- (id)initWithFrame:(CGRect)frame :(NSMutableArray *)books
{
    self = [super initWithFrame:frame];
    if (self) {
        if ([books count] == 0) {
            UILabel *noBook = [[UILabel alloc]initWithFrame:frame];
            noBook.text = @"下にスクロールしてデータを同期";
            noBook.backgroundColor = [UIColor whiteColor];
            noBook.font = [UIFont fontWithName:@"AppleGothic" size:10];
            noBook.textAlignment = NSTextAlignmentCenter;
            [self addSubview:noBook];
        } else {
            for (int i=0; i<[books count]; i++) {
                BookModel *book = books[i];
                NSString *labelText = [[NSString alloc] initWithFormat:@" %@", [book title]];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((TAB_WIDTH_SIZE*i)+(TAB_SPACER_SIZE*i), 0, TAB_WIDTH_SIZE, 35)];
                label.text = labelText;
                label.layer.cornerRadius = 5;
                label.layer.shadowOpacity = 0.2;
                label.layer.shadowOffset = CGSizeMake(2.0, 4.0);
                label.userInteractionEnabled = YES;
                label.font = [UIFont fontWithName:@"AppleGothic" size:10];
                label.numberOfLines = 0;
                label.tag = [book recodeId];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabBookTitle:)];
                [label addGestureRecognizer:tap];
                [self addSubview:label];
                if (selectedBookLabel == nil) {
                    label.backgroundColor = [UIColor redColor];
                    selectedBookLabel = label;
                } else {
                    label.backgroundColor = [UIColor grayColor];
                }
            }
        }

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
