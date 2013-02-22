//
//  AccountConfigViewController.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/20.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountConfigViewController : UITableViewController <UITextFieldDelegate> {
    UITextField *emailTf;
    UITextField *passwordTf;
}

@end
