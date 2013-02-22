//
//  EditViewController.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/07.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WordModel.h"

@interface WordEditViewController : UIViewController <UITextFieldDelegate>{
    UITextField *wordTf, *answerTf;
    WordModel *wordModel;
}

@property(nonatomic, strong, readwrite) UITextField *wordTf, *answerTf;
@property(nonatomic, strong, readwrite) WordModel *wordModel;

-(id)initWithWordModel:(WordModel *)wm;

@end
