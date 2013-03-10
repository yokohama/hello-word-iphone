//
//  HeaderView.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/03/01.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

@interface HeaderView : UIView {
    UIView *imageArea;
    UILabel *titleArea;
    UIView *alpha;
    UIButton *playButton;
    
    UIViewController *invorkedController;
}

@property (nonatomic, strong, readwrite) UIView *imageArea;
@property (nonatomic, strong, readwrite) UILabel *titleArea;
@property (nonatomic, strong, readwrite) UIView *alpha;
@property (nonatomic, strong, readwrite) UIButton *playButton;

- (id)initWithFrame:(CGRect)frame invorked:(UIViewController *)controller;

@end
