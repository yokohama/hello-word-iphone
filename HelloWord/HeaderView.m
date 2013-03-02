//
//  HeaderView.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/03/01.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

@synthesize imageArea, titleArea, playButton;

- (id)initWithFrame:(CGRect)frame invorked:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        invorkedController = controller;
        
        self.backgroundColor = [UIColor redColor];
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        
        UIView *alpha = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 400, 5)];
        alpha.backgroundColor = [UIColor redColor];
        alpha.layer.shadowOpacity = 1.0;
        alpha.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        [self addSubview:alpha];
        
        imageArea = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        UIImage *image = [UIImage imageNamed:@"library.png"];
        imageArea.backgroundColor = [UIColor colorWithPatternImage:image];
        imageArea.layer.borderColor = [[UIColor alloc] initWithRed:0.3 green:0.3 blue:0.3 alpha:0.5].CGColor;
        imageArea.layer.borderWidth = 1.0;
        imageArea.layer.shadowOpacity = 0.2;
        imageArea.layer.shadowOffset = CGSizeMake(2.0, 2.0);
        [self addSubview:imageArea];
        
        titleArea = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 190, 50)];
        titleArea.backgroundColor = [UIColor redColor];
        titleArea.font = [UIFont fontWithName:@"AppleGothic" size:16];
        titleArea.numberOfLines = 0;
        [self addSubview:titleArea];
        /*
        countArea = [[UILabel alloc] initWithFrame:CGRectMake(70, 35, 190, 20)];
        countArea.backgroundColor = [UIColor redColor];
        countArea.font = [UIFont fontWithName:@"AppleGothic" size:12];
        [self addSubview:countArea];
        */
        UIImage *playImage = [UIImage imageNamed:@"play.png"];
        playButton = [[UIButton alloc] initWithFrame:CGRectMake(265, 5, 50, 50)];
        [playButton addTarget:invorkedController action:@selector(play:) forControlEvents:UIControlEventTouchDown];
        [playButton setBackgroundImage:playImage forState:UIControlStateNormal];
        [self addSubview:playButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
