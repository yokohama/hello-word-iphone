//
//  ViewController.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/02.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordModel.h"

@interface WordAddViewController : UIViewController <UITextFieldDelegate>{
    UITextField *wordTf, *answerTf;
    WordModel *already;
}

@property(nonatomic, strong, readwrite) UITextField *wordTf, *answerTf;
@property(nonatomic, strong, readwrite) WordModel *already;

@end
