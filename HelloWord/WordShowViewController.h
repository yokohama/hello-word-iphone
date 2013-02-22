//
//  ShowViewController.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/02.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "WordModel.h"

@interface WordShowViewController : UIViewController <UITabBarDelegate> {
    WordModel *wordModel;
    UILabel *word;
    UITextView *answer;
}

-(id)initWithWordModel:(WordModel *)w;

@property(nonatomic, strong, readwrite) UILabel *word;
@property(nonatomic, strong, readwrite) UITextView *answer;
@property(nonatomic, strong, readwrite) WordModel *wordModel;

@end
