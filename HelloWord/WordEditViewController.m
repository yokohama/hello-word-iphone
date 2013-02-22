//
//  EditViewController.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/07.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "WordEditViewController.h"
#import "WordShowViewController.h"
#import "TextFieldFactory.h"

@implementation WordEditViewController

@synthesize wordModel, wordTf, answerTf;

-(id)initWithWordModel:(WordModel *)wm{
    self = [super init];
    wordModel = wm;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect r = [[UIScreen mainScreen] bounds];
    CGFloat w = r.size.width;
    
    wordTf = [TextFieldManager fact:CGRectMake(10, 30, w-20, 30) string:nil];
    wordTf.delegate = self;
    [self.view addSubview:wordTf];
    
    UILabel *description = [[UILabel alloc] init];
    description.frame = CGRectMake(10, 70, 100, 50);
    description.text = @"<意味>";
    [self.view addSubview:description];
    
    answerTf = [TextFieldManager fact:CGRectMake(10, 110, w-20, 30) string:nil];
    answerTf.delegate = self;
    [self.view addSubview:answerTf];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10, 150, 100, 30);
    [btn setTitle:@"Update" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(update:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
}

-(void)viewWillAppear:(BOOL)animated{
    [wordTf setText:wordModel.word];
    [answerTf setText:wordModel.answer];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)update:(UIButton*)button{
    //WordModel *wm = [[WordModel alloc] initWithClone:wordModel.recode_id word:wordTf.text answer:answerTf.text];
    WordModel *wm = [[WordModel alloc] initWithValues:wordTf.text answer:answerTf.text];
    wm.recodeId = wordModel.recodeId;
    
    if ([[wm validate] count] > 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:[wm errorMessages]
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }else {
        [wm update];
        NSArray *allControllers = self.navigationController.viewControllers;
        NSInteger target = [allControllers count] - 2;
        WordShowViewController *parent = [allControllers objectAtIndex:target];
        [parent setWordModel:wm];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [wordTf resignFirstResponder];
    [answerTf resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



@end