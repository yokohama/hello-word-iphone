//
//  ScrollArea.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/26.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BookModel.h"
#import "WordModel.h"

@interface TabScrollAreaView : UIView{
    UILabel *selectedBookLabel;
}

- (id)initWithFrame:(CGRect)frame :(NSMutableArray *)books;

@end
