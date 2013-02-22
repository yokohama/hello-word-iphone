//
//  TextFieldManager.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/08.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "TextFieldFactory.h"

@implementation TextFieldManager

+(UITextField *)fact:(CGRect)rect string:(NSString *)placeText {
    UITextField *tf = [[UITextField alloc] initWithFrame:rect];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.placeholder = placeText;
    tf.clearButtonMode = UITextFieldViewModeAlways;
    tf.keyboardAppearance = UIKeyboardAppearanceAlert;
    tf.returnKeyType = UIReturnKeyDone;
    return tf;
}

@end
