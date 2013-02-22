//
//  ViewController.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/02.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "WordAddViewController.h"

#import "WordIndexViewController.h"
#import "WordModel.h"
#import "TextFieldFactory.h"

#define ORIENTATION [[UIDevice currentDevice] orientation]
 
@implementation WordAddViewController

@synthesize wordTf, answerTf, already;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect r = [[UIScreen mainScreen] bounds];
    CGFloat w = r.size.width;
    
    wordTf = [TextFieldManager fact:CGRectMake(10, 30, w-20, 30) string:@"word"];
    wordTf.delegate = self;
    [self.view addSubview:wordTf];
    
    //TODO:ワードを入れたらデータベースを参照して、答えに補完するようにする。（未来）。利用者は補完された答えを使うか、自分で入力するかを選択できる。自分で入力した場合は、ローカルデータベースに補完される。
    
    UILabel *description = [[UILabel alloc] init];
    description.frame = CGRectMake(10, 70, 100, 50);
    description.text = @"<意味>";
    [self.view addSubview:description];
    
    answerTf = [TextFieldManager fact:CGRectMake(10, 110, w-20, 30) string:@"答え"];
    answerTf.delegate = self;
    [self.view addSubview:wordTf];
    [self.view addSubview:answerTf];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10, 150, 100, 30);
    [btn setTitle:@"Add" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
}

-(void)viewWillAppear:(BOOL)animated{
    [wordTf setText:nil];
    [answerTf setText:nil];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)add:(UIButton*)button{
    WordModel *wordModel = [[WordModel alloc] initWithValues:wordTf.text answer:answerTf.text];
    
    [wordTf resignFirstResponder];
    [answerTf resignFirstResponder];
    
    if ([[wordModel validate] count] > 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:[wordModel errorMessages]
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }else {
        already = [wordModel isAlready];
        if (already){
            UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"既に登録されています。上書きしますか？"
                              message:already.answer
                              delegate:self
                              cancelButtonTitle:@"NO"
                              otherButtonTitles:@"YES", nil];
            [alert show];
        }else{
            [wordModel create];
            /*
            [self.tabBarController.view.subviews objectAtIndex:self.tabBarController.selectedIndex--];
            */
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [already setAnswer:answerTf.text];
            [already update];
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end