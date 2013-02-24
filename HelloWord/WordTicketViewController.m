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
    //CGFloat w = r.size.width;
    CGFloat h = r.size.height;
    
    //int boardWidth = self.view.frame.size.width - 20;
    /*
    int boardHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 81;
    UIView *board = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, boardHeight)];
    board.backgroundColor = [UIColor whiteColor];
    board.layer.borderColor = [[UIColor alloc] initWithRed:0.3 green:0.3 blue:0.3 alpha:0.5].CGColor;
    board.layer.borderWidth = 1.0;
    board.layer.cornerRadius = 8;
    board.layer.shadowOpacity = 0.2;
    board.layer.shadowOffset = CGSizeMake(2.0, 4.0);
    [self.view addSubview:board];
     */
    
    /*
    UILabel *count = [[UILabel alloc] init];
    count.frame = CGRectMake(10, board.frame.size.height, w-20, 20);
    count.text = [[NSString alloc] initWithFormat:@"(%d/%d)", pageIndex, recordeCount];
    count.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:count];
     */
    
    UILabel *wl = [[UILabel alloc] init];
    wl.frame = CGRectMake(10, h/2-80, self.view.frame.size.width-10, 50);
    wl.text = word;
    wl.font =[UIFont systemFontOfSize:30.0];
    wl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:wl];
    
    al = [[UITextView alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-10, 50)];
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
