//
//  WordTicketViewController.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/07.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "WordTicketViewController.h"


@implementation WordTicketViewController

@synthesize recordeCount, pageIndex, pageLabel, word, answer, isSurface;

- (id)init{
    self = [super init];
    isSurface = YES;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    CGRect r = [[UIScreen mainScreen] bounds];
    CGFloat h = r.size.height;
    
    UILabel *wl = [[UILabel alloc] init];
    wl.frame = CGRectMake(10, h/2-80, self.view.frame.size.width-10, 80);
    wl.text = word;
    wl.font =[UIFont systemFontOfSize:30.0];
    wl.textAlignment = NSTextAlignmentCenter;
    wl.numberOfLines = 0;
    [self.view addSubview:wl];
    
    al = [[UITextView alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-10, 400)];
    al.editable = NO;
    al.font =[UIFont systemFontOfSize:16.0];
    al.text = answer;
    al.hidden = YES;
    [self.view addSubview:al];
    
    //シングルタップ
    UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerDTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//現在のページを保持させる
- (void)setIndex:(int)index{
    pageIndex = index;
}

- (void)handleSingleTap:(UIGestureRecognizer *)sender {
    if (isSurface) {
        al.hidden = NO;
        self.isSurface = NO;
    } else {
        al.hidden = YES;
        self.isSurface = YES;
    }
}

@end
