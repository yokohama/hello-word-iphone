//
//  PlayViewController.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/02.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "WordPlayViewController.h"
#import "WordModel.h"

@implementation WordPlayViewController 

@synthesize records;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    pageArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 80)];
    [self.view addSubview:pageArea];
    
    
    //ページめくり
    pageIndex = 1;
    pageMax = [records count];
    
    pageViewController = [[UIPageViewController alloc]
                          initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                          options:nil];
    
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    UIViewController *vc = [self setWordTicketViewController];
    
    NSArray *viewControllers = [NSArray arrayWithObject:vc];
    [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    
    [pageViewController setDoubleSided:NO];
    
    [self addChildViewController:pageViewController];
    
    //[self.navigationController setNavigationBarHidden:NO];
    //[self.navigationController setToolbarHidden:YES];
    
    [pageArea addSubview:pageViewController.view];
    
    playBarArea = [[UIView alloc] initWithFrame:CGRectMake(0, 420, self.view.frame.size.width, 40)];
    playBarArea.layer.shadowOpacity = 0.4;
    playBarArea.layer.shadowOffset = CGSizeMake(0.0, -2.0);
    UIImage *playAreaImage = [UIImage imageNamed:@"playarea.png"];
    playBarArea.backgroundColor = [UIColor colorWithPatternImage:playAreaImage];
    [self.view addSubview:playBarArea];
    
    //CGRect rect = CGRectMake(10, 8, 300, 0);
    slider = [[UISlider alloc]initWithFrame:CGRectMake(10, 12, 300, 10)];
    slider.minimumValue = 0;
    slider.maximumValue = pageMax-1;
    slider.value = 0;
    [slider addTarget:self action:@selector(sliderShift:) forControlEvents:UIControlEventValueChanged];
    [playBarArea addSubview:slider];
    
    UIImage *img = [UIImage imageNamed:@"close.png"];
    close = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-42, 10, 32, 32)];
    [close addTarget:self action:@selector(return:) forControlEvents:UIControlEventTouchDown];
    [close setBackgroundImage:img forState:UIControlStateNormal];
    [pageViewController.view addSubview:close];
}

-(void)viewWillAppear:(BOOL)animated{
    pageArea.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    int direction = self.interfaceOrientation;
    if(direction == UIInterfaceOrientationPortrait || direction == UIInterfaceOrientationPortraitUpsideDown){
        [self orientationFit:self.view.frame.size.width];
    } else {
        [self orientationFit:self.view.frame.size.width];
    }
}

- (WordTicketViewController *)setWordTicketViewController{
    WordTicketViewController *vc = [[WordTicketViewController alloc] init];
    vc.pageIndex = pageIndex;
    vc.recordeCount = [records count];
    WordModel *wc = records[pageIndex-1];
    vc.word = wc.word;
    vc.answer = wc.answer;
    return vc;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    pageIndex = [self getPageIndex:(WordTicketViewController *)viewController];
    if (1 == pageIndex) {
        return nil;
    }
    
    pageIndex--;
    
    return [self setWordTicketViewController];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
    viewControllerAfterViewController:(UIViewController *)viewController
{
    pageIndex = [self getPageIndex:(WordTicketViewController *)viewController];
    
    if (pageMax == pageIndex) {
        return nil;
    }
    
    pageIndex++;
    
    return [self setWordTicketViewController];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    //ページが最後までめくられたら、ページを再設定
    if (completed) {
        WordTicketViewController *vc = [previousViewControllers objectAtIndex:0];
        vc.pageIndex = pageIndex;
        slider.value = pageIndex-1;
    }
}

- (int)getPageIndex:(WordTicketViewController*)vc
{
    return vc.pageIndex;
}

-(void)return:(UIButton*)button{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)sliderShift :(id)sender{
    
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        pageArea.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
        [self orientationFit:pageArea.frame.size.width];
    } else {
        pageArea.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self orientationFit:pageArea.frame.size.width];
    }
}

- (void)orientationFit:(int)w {
    close.frame = CGRectMake(w-42, 10, 32, 32);
    playBarArea.frame = CGRectMake(0, pageArea.frame.size.height-40, w, 40);
    slider.frame = CGRectMake(10, 12, playBarArea.frame.size.width-20, 10);
}

@end
