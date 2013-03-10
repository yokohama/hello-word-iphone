//
//  WordTicketViewController.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/07.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface WordTicketViewController : UIViewController{
    BOOL isSurface;
    UITextView *al;
    
    UILabel *wl;
}

@property int pageIndex, recordeCount;
@property (retain, nonatomic) IBOutlet UILabel *pageLabel; 

@property NSString *word, *answer;
@property BOOL isSurface;

- (void)setIndex:(int)index;

@end
