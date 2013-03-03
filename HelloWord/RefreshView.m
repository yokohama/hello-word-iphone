//
//  refreshView.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/03/03.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "RefreshView.h"

@implementation RefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        UIColor *pink = [UIColor colorWithRed:1.0 green:0.9 blue:1.0 alpha:1.0];
        self.backgroundColor = pink;
    }
    return self;
}

@end
