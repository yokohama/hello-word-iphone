//
//  TabBar.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/26.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "TabBar.h"

/*BUG:yokohama
１）タブの一番最後のタブを選択する。
２）ブラウザから一番最後の選択されているタブを削除する
３）iPhoneでリフレッシュする
＝＞削除されたはずのタブがnullで残っている。落ちはしない。
*/

#define TAB_WIDTH_SIZE 80
#define TAB_SPACER_SIZE 0

@implementation TabBar

@synthesize labels, currentLabel;

- (id)initWithFrame:(CGRect)frame delegateController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        labels = [NSMutableArray array];
        
        delegateController = controller;
        
        UIImage *tabBackgroundImage = [UIImage imageNamed:@"playarea.png"];
        self.backgroundColor = [UIColor colorWithPatternImage:tabBackgroundImage];
        
        //NSMutableArray *books = [[[BookModel alloc]init] findAll];
        books = [Books factory];
        [self makeTabs];
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
    int newLabelIndex = 0;
    for (int i=0; i<[labels count]; i++) {
        if ([labels[i] tag] == label.tag) {newLabelIndex = i;}
    }
    int oldLabelIndex = 0;
    for (int i=0; i<[labels count]; i++) {
        if ([labels[i] tag] == currentLabel.tag) {oldLabelIndex = i;}
    }
    
    BookModel *newBook = [books find:label.tag];
    BookModel *oldBook = [books find:currentLabel.tag];
    
    UILabel *newLabel = [self makeTab:newBook :CGRectMake(label.frame.origin.x, 0, TAB_WIDTH_SIZE, 45)];
    newLabel.backgroundColor = [UIColor redColor];
    labels[newLabelIndex] = newLabel;
    UILabel *oldLabel = [self makeTab:oldBook :CGRectMake(currentLabel.frame.origin.x, 4, TAB_WIDTH_SIZE, 40)];
    UIColor *pink = [UIColor colorWithRed:1.0 green:0.9 blue:1.0 alpha:1.0];
    oldLabel.backgroundColor = pink;
    labels[oldLabelIndex] = oldLabel;
    
    [label removeFromSuperview];
    [currentLabel removeFromSuperview];
        
    [scrollArea addSubview:newLabel];
    if (self.currentLabel.tag != label.tag) {
        [scrollArea addSubview:oldLabel];
    }

    [self scroll:newLabel];
    currentLabel = newLabel;
}

-(void)scroll :(UILabel *)label {
    CGRect rect = CGRectMake(0, 0, 0, 0);
    int currentIndex = 0;
    int labelIndex = 0;
    for (int i=0; i<[labels count]; i++) {
        if ([labels[i] tag] == currentLabel.tag) {
            currentIndex = i;
            break;
        }
    }
    for (int i=0; i<[labels count]; i++) {
        if ([labels[i] tag] == label.tag) {
            labelIndex = i;
            break;
        }
    }
    
    //TODO:微妙に動いていないので修正
    //CGPoint offset = self.contentOffset;
    //float f = label.frame.origin.x - offset.x;
    //NSLog(@"%f", offset.x);
    
    float center = self.frame.size.width / 2;
    if (currentIndex < labelIndex) {
        int last = [labels count] - 1;
        if (label.tag == [labels[last] tag]) {
            rect = CGRectMake(label.frame.origin.x, 0, TAB_WIDTH_SIZE, 100);
        } else {
            rect = CGRectMake((label.frame.origin.x + TAB_WIDTH_SIZE + 80), 0, 40, 100);
        }
    } else {
        if (label.frame.origin.x < center) {
            rect = CGRectMake(0, 0, TAB_WIDTH_SIZE, 100);
        } else {
            rect = CGRectMake(label.frame.origin.x-120, 0, 40, 100);
        }
    }
    [self scrollRectToVisible:rect animated:YES];
}

-(void)rehash{
    labels = [NSMutableArray array];
    [self makeTabs];
    [self changeLabel:labels[0]];
}

-(void)makeTabs{
    [scrollArea removeFromSuperview];
    
    int scrollAreaWidth = self.frame.size.width;
    int tabBarWidthSize = 0;
    if ([books.items count] != 0) {
        for (int i=0; i<[books.items count]; i++) {
            tabBarWidthSize += (TAB_WIDTH_SIZE + TAB_SPACER_SIZE);
        }
        scrollAreaWidth = tabBarWidthSize;
    }
    
    scrollArea = nil;
    if ([books.items count] == 0) {
        scrollArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        UILabel *noBook = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        noBook.text = @"下にスクロールしてデータを同期";
        noBook.backgroundColor = [UIColor whiteColor];
        noBook.font = [UIFont fontWithName:@"AppleGothic" size:10];
        noBook.textAlignment = NSTextAlignmentCenter;
        UIColor *pink = [UIColor colorWithRed:1.0 green:0.9 blue:1.0 alpha:1.0];
        noBook.backgroundColor = pink;
        [scrollArea addSubview:noBook];
    } else {
        scrollArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollAreaWidth-2, self.frame.size.height)];
        for (int i=0; i<[books.items count]; i++) {
            UILabel *label = nil;
            if (self.currentLabel == nil) {
                label = [self makeTab:books.items[i] :CGRectMake((TAB_WIDTH_SIZE*i)+(TAB_SPACER_SIZE*i), 0, TAB_WIDTH_SIZE, 45)];
                label.backgroundColor = [UIColor redColor];
                self.currentLabel = label;
            } else {
                label = [self makeTab:books.items[i] :CGRectMake((TAB_WIDTH_SIZE*i)+(TAB_SPACER_SIZE*i), 4, TAB_WIDTH_SIZE, 40)];
                //label.backgroundColor = [UIColor grayColor];
                UIColor *pink = [UIColor colorWithRed:1.0 green:0.9 blue:1.0 alpha:1.0];
                label.backgroundColor = pink;
            }
            [scrollArea addSubview:label];
            [labels addObject:label];
        }
    }
    
    [self addSubview:scrollArea];
    self.contentSize = scrollArea.bounds.size;
    self.showsHorizontalScrollIndicator = NO;
    
    UIView *line = nil;
    if (scrollAreaWidth < self.frame.size.width) {
        line = [[UILabel alloc] initWithFrame:CGRectMake(-300, 30, self.frame.size.width+500, 5)];
    } else {
        line = [[UILabel alloc] initWithFrame:CGRectMake(-300, 30, scrollAreaWidth+500, 5)];
    }
    [line setBackgroundColor:[UIColor redColor]];
    
    //TODO:影が反映しない
    //line.layer.shadowOpacity = 1.0;
    //line.layer.shadowOffset = CGSizeMake(0.0, 5.0);
    //[self addSubview:line];
}

- (UILabel *)makeTab :(BookModel *)book :(CGRect)rect {
    NSString *labelText = [[NSString alloc] initWithFormat:@" %@", [book title]];
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = labelText;
    label.layer.cornerRadius = 5;
    label.layer.shadowOpacity = 0.2;
    label.layer.shadowOffset = CGSizeMake(2.0, 4.0);
    label.layer.borderWidth = 0.2;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    label.userInteractionEnabled = YES;
    label.font = [UIFont fontWithName:@"AppleGothic" size:12];
    label.numberOfLines = 0;
    label.tag = [book recodeId];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:delegateController action:@selector(tabBookTitle:)];
    [label addGestureRecognizer:tap];
    return label;
}

- (int)getLabelIndex:(UILabel *)label {
    int *result = nil;
    for (int i=0; i<[labels count]; i++) {
        if (label.tag == [labels[i] tag]) {
            result = i+1;
        }
    }
    return result;
}

@end