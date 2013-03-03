//
//  AppDelegate.h
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/02.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Books.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    //Books *books;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

//@property (nonatomic, strong, readwrite) Books *books;

@end
