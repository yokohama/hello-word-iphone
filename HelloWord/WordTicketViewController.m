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

    CGRect r = [[UIScreen mainScreen] bounds];
    CGFloat w = r.size.width;
    CGFloat h = r.size.height;
    
    UILabel *count = [[UILabel alloc] init];
    count.frame = CGRectMake(10, 5, w-20, 20);
    count.text = [[NSString alloc] initWithFormat:@"(%d/%d)", pageIndex, recordeCount];

    count.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:count];
    
    UILabel *wl = [[UILabel alloc] init];
    wl.frame = CGRectMake(10, h/2-80, w-20, 50);
    wl.text = word;
    wl.font =[UIFont systemFontOfSize:30.0];
    wl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:wl];
    
    al = [[UITextView alloc] initWithFrame:CGRectMake(10, 30, w-20, 50)];
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
    // Dispose of any resources that can be recreated.
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
