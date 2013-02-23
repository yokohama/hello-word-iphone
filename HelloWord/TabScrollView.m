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

- (id)initWithFrame:(CGRect)_frame
{
    self = [super initWithFrame:_frame];
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.bounds];
    //sv.bounces = NO;
    
    NSMutableArray *books = [[[BookModel alloc]init] findAll];
    int tabBarWidthSize = TAB_SPACER_SIZE;
    for (int i=0; i<[books count]; i++) {
        NSString *labelText = [[NSString alloc] initWithFormat:@" %@", [books[i] title]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((TAB_WIDTH_SIZE*i)+(TAB_SPACER_SIZE*i), 0, TAB_WIDTH_SIZE, 35)];
        label.text = labelText;
        //[label setBackgroundColor:[UIColor redColor]];
        label.layer.cornerRadius = 5;
        label.layer.shadowOpacity = 0.2;
        label.layer.shadowOffset = CGSizeMake(2.0, 4.0);
        label.userInteractionEnabled = YES;
        label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        label.tag = [books[i] recodeId];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moge:)];
        [label addGestureRecognizer:tap];
        //NSLog(@"==========%@", NSStringFromClass([tap.state class]));
        
        //[label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hoge:)]];
         
        [sv addSubview:label];
        
        tabBarWidthSize += (TAB_WIDTH_SIZE + TAB_SPACER_SIZE);
        
    }
    
    UIView *uv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tabBarWidthSize-4, _frame.size.height)];
    [sv addSubview:uv];
    sv.contentSize = uv.bounds.size;
    sv.showsHorizontalScrollIndicator = NO;
    [self addSubview:sv];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, _frame.size.width, 5)];
    [line setBackgroundColor:[UIColor redColor]];
    [self addSubview:line];
    
    return self;
}


- (void)hoge: (UITapGestureRecognizer *)sender{
    //UILabel *label = (UILabel *)sender.view;
    NSLog(@"===========");
}

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"hoge");
}
 */

@end
