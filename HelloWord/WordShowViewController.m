//
//  ShowViewController.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/02.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "WordShowViewController.h"
#import "WordEditViewController.h"


@implementation WordShowViewController

@synthesize wordModel;


- (id)initWithWordModel:(WordModel *)w {
    self = [super init];
    if (self) {
        wordModel = w;
        word = [[UILabel alloc]init];
        answer = [[UILabel alloc]init];
        spacer = [[UILabel alloc]init];
        line = [[UILabel alloc]init];
    }
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
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    show = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    //シングルタップ
    //TODO:上から下へのスクロールにする
    UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerDTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    show.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    int direction = self.interfaceOrientation;
    if(direction == UIInterfaceOrientationPortrait || direction == UIInterfaceOrientationPortraitUpsideDown){
        [self orientationFit:self.view.frame.size.width];
    } else {
        [self orientationFit:self.view.frame.size.width];
    }
}

- (void)orientationFit:(int)w{
    word.frame = CGRectMake(20, 20, w-30, 20);
    word.text = wordModel.word;
    [word setNumberOfLines:0];
    [word sizeToFit];
    
    line.frame = CGRectMake(10, 20, 4, word.frame.size.height);
    line.backgroundColor = [UIColor redColor];
    
    spacer.frame = CGRectMake(0, word.frame.origin.y+word.frame.size.height, w, 20);
    
    answer.frame = CGRectMake(10, spacer.frame.origin.y+spacer.frame.size.height, w-20, 20);
    answer.text = wordModel.answer;
    [answer setNumberOfLines:0];
    [answer sizeToFit];
    
    //BUG:yokohama 長い文字列の場合、横にしたときに、サイズがあわない。
    CGSize size = CGSizeMake(w, word.frame.origin.y+word.frame.size.height+spacer.frame.size.height+answer.frame.size.height);
    
    show.contentSize = size;
    [self.view addSubview:show];
    
    [show addSubview:word];
    [show addSubview:line];
    [show addSubview:spacer];
    [show addSubview:answer];
}

- (void)edit{
    UIViewController *evc = [[WordEditViewController alloc] initWithWordModel:wordModel];
    [self.navigationController pushViewController:evc animated:YES];
}

//TODO:ゴミ箱アニメーション
- (void)destroy{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"削除してもよろしいですか？"
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"NO"
                          otherButtonTitles:@"YES", nil];
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [wordModel destroy];
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}

- (void)handleSingleTap:(UIGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        show.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.height);
        [self orientationFit:show.frame.size.height];
    } else {
        show.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self orientationFit:show.frame.size.width];
    }
}

@end
