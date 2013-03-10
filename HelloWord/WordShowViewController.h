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

@interface WordShowViewController : UIViewController {
    WordModel *wordModel;
    UIScrollView *show;
    UILabel *word;
    UILabel *answer;
    UILabel *spacer;
    UILabel *line;
}

-(id)initWithWordModel:(WordModel *)w;

@property(nonatomic, strong, readwrite) WordModel *wordModel;

@end
