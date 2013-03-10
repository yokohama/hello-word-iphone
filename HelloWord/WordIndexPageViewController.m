//
//  WordIndexPageController.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/26.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "WordIndexPageViewController.h"

@implementation WordIndexPageViewController

- (id)initWithBookId :(int)_bookId {
    self = [super init];
    if (self) {
        bookId = _bookId;
        books = [Books factory];
    }
    
    //TODO:テーブル初期化（どこかに移動）
    [[[BookModel alloc] init] dropTable];
    [[[WordModel alloc] init] dropTable];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    tabBar = [[TabBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35) delegateController:self];
    [self.view addSubview:tabBar];
    
    header = [[UIView alloc] initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, 60)];
    header.backgroundColor = [UIColor redColor];
    header.layer.shadowOpacity = 0.4;
    header.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    
    alpha = [[UIView alloc] initWithFrame:CGRectMake(0, 60, header.frame.size.width, 5)];
    alpha.backgroundColor = [UIColor redColor];
    alpha.layer.shadowOpacity = 1.0;
    alpha.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    [header addSubview:alpha];
    
    UIView *imageArea = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    UIImage *image = [UIImage imageNamed:@"library.png"];
    imageArea.backgroundColor = [UIColor colorWithPatternImage:image];
    imageArea.layer.borderColor = [[UIColor alloc] initWithRed:0.3 green:0.3 blue:0.3 alpha:0.5].CGColor;
    imageArea.layer.borderWidth = 1.0;
    imageArea.layer.shadowOpacity = 0.2;
    imageArea.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    [header addSubview:imageArea];
    
    titleArea = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 190, 50)];
    titleArea.backgroundColor = [UIColor redColor];
    titleArea.font = [UIFont fontWithName:@"AppleGothic" size:16];
    titleArea.numberOfLines = 0;
    [header addSubview:titleArea];
    
    UIImage *playImage = [UIImage imageNamed:@"play.png"];
    playButton = [[UIButton alloc] initWithFrame:CGRectMake(265, 5, 50, 50)];
    [playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchDown];
    [playButton setBackgroundImage:playImage forState:UIControlStateNormal];
    [header addSubview:playButton];
    
    [self.view addSubview:header];

    pageArea = [[UIScrollView alloc] initWithFrame:CGRectMake(0, tabBar.frame.size.height+header.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [self makePageView:CGRectMake(0, 0, pageArea.frame.size.width, pageArea.frame.size.height)];
    [pageArea addSubview:pageViewController.view];
    [self.view addSubview:pageArea];
    
    toolArea = [[UIView alloc] initWithFrame:CGRectMake(0, 420, self.view.frame.size.width, 40)];
    toolArea.layer.shadowOpacity = 0.4;
    toolArea.layer.shadowOffset = CGSizeMake(0.0, -2.0);
    UIImage *toolAreaImage = [UIImage imageNamed:@"playarea.png"];
    toolArea.backgroundColor = [UIColor colorWithPatternImage:toolAreaImage];
    [self.view addSubview:toolArea];
    [self.view addSubview:toolArea];
    
    UIImage *configImage = [UIImage imageNamed:@"config2.png"];
    UIButton *configButton = [[UIButton alloc] initWithFrame:CGRectMake(toolArea.frame.size.width-26, 12, 20, 20)];
    [configButton addTarget:self action:@selector(config:) forControlEvents:UIControlEventTouchDown];
    [configButton setBackgroundImage:configImage forState:UIControlStateNormal];
    [toolArea addSubview:configButton];
}

-(void)makePageView :(CGRect)rect{
    [pageViewController removeFromParentViewController];
    
    //ページめくり
    BookModel *bm = [books find:bookId];
    pageMax = [books.items count];
    
    for (int i=0; i<[books.items count]; i++) {
        if ([books.items[i] recodeId] == bookId) {
            pageIndex = i+1;
        }
    }
     
    [self setWordListViewController:bm.recodeId];
    NSArray *viewControllers = [NSArray arrayWithObject:wordListViewController];
    
    pageViewController = [[UIPageViewController alloc]
                          initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                          options:nil];
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    pageViewController.view.frame = rect;
    pageViewController.view.backgroundColor = [UIColor whiteColor];
    [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    [pageViewController setDoubleSided:NO];
    [self addChildViewController:pageViewController];
}

-(void)viewWillAppear:(BOOL)animated{
    int direction = self.interfaceOrientation;
    if(direction == UIInterfaceOrientationPortrait || direction == UIInterfaceOrientationPortraitUpsideDown){
        [self orientationFit:self.view.frame.size.width];
    } else {
        [self orientationFit:self.view.frame.size.width];
    }
}

- (void)setWordListViewController:(int)_bookId{
    wordListViewController = [[WordListViewController alloc] initWithBookId:_bookId invorked:self titleArea:titleArea];
    wordListViewController.pageIndex = pageIndex;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    pageIndex = [self getPageIndex:(WordListViewController *)viewController];
    if (1 == pageIndex || [books.items count] == 0) {
        return nil;
    }
    pageIndex--;

    BookModel *bm = books.items[pageIndex-1];
    bookId = bm.recodeId;
    
    [self setWordListViewController:bm.recodeId];
    return wordListViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    pageIndex = [self getPageIndex:(WordListViewController *)viewController];
    if (pageMax == pageIndex || [books.items count] == 0) {
        return nil;
    }
    
    pageIndex++;
    
    BookModel *bm = books.items[pageIndex-1];
    bookId = bm.recodeId;
    
    [self setWordListViewController:bm.recodeId];
    return wordListViewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed) {
        if ([books.items count] > 0) {
            BookModel *bm = books.items[pageIndex-1];
            [self setWordListViewController:bm.recodeId];
            wordListViewController = [previousViewControllers objectAtIndex:0];
            wordListViewController.pageIndex = pageIndex;
            page.text = [[NSString alloc] initWithFormat:@"%d", pageIndex];
            for (int i=0; i<[tabBar.labels count]; i++) {
                UILabel *label = tabBar.labels[i];
                if (label.tag == bm.recodeId) {
                    [tabBar changeLabel:tabBar.labels[i]];
                }
            }
        }
    }
}

- (int)getPageIndex:(WordListViewController*)vc
{
    return vc.pageIndex;
}

-(void)config:(UIButton*)button{
    ConfigListViewController *cvc = [[ConfigListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:cvc];
    [self presentViewController: naviController animated:YES completion: nil];
}

- (void)tabBookTitle: (UITapGestureRecognizer *)sender{
    UILabel *label = (UILabel *)sender.view;
    bookId = label.tag;
    [self makePageView:CGRectMake(0, 0, pageArea.frame.size.width, pageArea.frame.size.height)];
    [pageArea addSubview:pageViewController.view];
    [tabBar changeLabel:label];
}

- (void)rehash {
    if ([books.items count] > 0) {
        [tabBar rehash];
        UILabel *label = tabBar.labels[0];
        bookId = label.tag;
        [self makePageView:CGRectMake(0, 0, pageArea.frame.size.width, pageArea.frame.size.height)];
        [pageArea addSubview:pageViewController.view];
        [tabBar changeLabel:label];
    }
}

-(void)play:(UIButton*)button{
    //TODO ここでボタンをハイライト
    /*
    [header.playButton removeFromSuperview];
    UIImage *playImage = [UIImage imageNamed:@"config.png"];
    header.playButton = [[UIButton alloc] initWithFrame:CGRectMake(265, 5, 50, 50)];
    [header.playButton setBackgroundImage:playImage forState:UIControlStateNormal];
    [header addSubview:header.playButton];
    */
    
    BookModel *bm = [books find:bookId];
    if ([bm.words count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"再生する単語がありません。下にスクロールしてデータを更新してください。"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    } else {
        WordPlayViewController *pvc = [[WordPlayViewController alloc] initWithNibName:nil bundle:nil];
        pvc.records = bm.words;
        [self presentViewController: pvc animated:YES completion: nil];
    }
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        [self orientationFit:self.view.frame.size.height];
    } else {
        [self orientationFit:self.view.frame.size.width];
    }
}

-(void)orientationFit :(int)w{
    tabBar.frame = CGRectMake(0, 0, w, 35);
    tabBar.noBook.frame = CGRectMake(tabBar.frame.origin.x, tabBar.frame.origin.y, tabBar.frame.size.width, tabBar.frame.size.height);
    header.frame = CGRectMake(0, tabBar.frame.size.height, w, 60);
    alpha.frame = CGRectMake(0, 60, header.frame.size.width, 5);
    playButton.frame = CGRectMake(w-55, 5, 50, 50);
    titleArea.frame =CGRectMake(60, 5, header.frame.size.width-120, 50);
    pageArea.frame = CGRectMake(0, tabBar.frame.size.height+header.frame.size.height, w, self.view.frame.size.height);
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
 */

@end

