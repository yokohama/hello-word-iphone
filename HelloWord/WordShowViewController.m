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

@synthesize wordModel, word, answer;


- (id)initWithWordModel:(WordModel *)w {
    self = [super init];
    wordModel = w;
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
    
    int boardWidth = self.view.frame.size.width - 20;
    //int boardHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.navigationController.toolbar.frame.size.height - 40;
    int boardHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20;
    
    UIView *board = [[UIView alloc] initWithFrame:CGRectMake(10, 10, boardWidth, boardHeight)];
    board.backgroundColor = [UIColor whiteColor];
    board.layer.borderColor = [[UIColor alloc] initWithRed:0.3 green:0.3 blue:0.3 alpha:0.5].CGColor;
    board.layer.borderWidth = 1.0;
    board.layer.cornerRadius = 8;
    board.layer.shadowOpacity = 0.2;
    board.layer.shadowOffset = CGSizeMake(2.0, 4.0);
    [self.view addSubview:board];
    
    word = [[UILabel alloc] init];
    word.frame = CGRectMake(10, 10, boardWidth-20, 50);
    [board addSubview:word];
    
    UILabel *description = [[UILabel alloc] init];
    description.frame = CGRectMake(10, 70, boardWidth-20, 50);
    description.text = @" <意味>";
    
    //TODO:タブのラベルに影をつける練習をここでやっている
    description.layer.shadowColor = [UIColor blackColor].CGColor;
    description.layer.shadowOpacity = 0.2; // 濃さを指定
    description.layer.shadowOffset = CGSizeMake(10.0, 10.0);
    //TODO:ここまで
    
    [board addSubview:description];
    
    CGRect rect = CGRectMake(10, 110, boardWidth-20, 200);
    answer = [[UITextView alloc] initWithFrame:rect];
    answer.editable = NO;
    answer.font =[UIFont systemFontOfSize:16.0];
    [board addSubview:answer];
    
    //シングルタップ
    //TODO:上から下へのスクロールにする
    UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerDTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    word.text = wordModel.word;
    answer.text = wordModel.answer;
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

@end
