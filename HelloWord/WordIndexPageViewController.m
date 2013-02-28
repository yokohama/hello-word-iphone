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
        BookModel *bm = [[BookModel alloc]init];
        books = [bm findAll];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.toolbar.tintColor = [UIColor blackColor];
    
    tabBar = [[TabBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35) delegateController:self];
    [self.view addSubview:tabBar];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                               target:nil action:nil];
    //UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    UIBarButtonItem *play = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play)];
    UIBarButtonItem *config = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(config)];
    NSArray *items =
    [NSArray arrayWithObjects:spacer, play, spacer, config, spacer, nil];
    self.toolbarItems = items;
    
    
    pageArea = [[UIScrollView alloc] initWithFrame:CGRectMake(0, tabBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 80)];
    [self makePageView:CGRectMake(0, 0, pageArea.frame.size.width, pageArea.frame.size.height)];
    [pageArea addSubview:pageViewController.view];
    
    //UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, (0- 200), pageArea.frame.size.width, 200)];
    //refreshView.backgroundColor = [UIColor purpleColor];
    //[pageArea addSubview:refreshView];
    
    [self.view addSubview:pageArea];
}

-(void)makePageView :(CGRect)rect{
    [pageViewController removeFromParentViewController];
    
    //ページめくり
    BookModel *bm = [[[BookModel alloc] init] find:bookId];
    pageMax = [books count];
    
    for (int i=0; i<[books count]; i++) {
        if ([books[i] recodeId] == bookId) {pageIndex = i+1;}
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
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:NO];
}

- (void)setWordListViewController:(int)_bookId{
    wordListViewController = [[WordListViewController alloc] initWithBookId:_bookId invorked:self tabBar:tabBar];
    wordListViewController.pageIndex = pageIndex;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    pageIndex = [self getPageIndex:(WordListViewController *)viewController];
    if (1 == pageIndex) {
        return nil;
    }
    
    pageIndex--;
    
    BookModel *bm = books[pageIndex-1];
    bookId = bm.recodeId;
    
    [self setWordListViewController:bm.recodeId];
    return wordListViewController;

}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    pageIndex = [self getPageIndex:(WordListViewController *)viewController];
    if (pageMax == pageIndex) {
        return nil;
    }
    
    pageIndex++;
    
    BookModel *bm = books[pageIndex-1];
    bookId = bm.recodeId;
    
    [self setWordListViewController:bm.recodeId];
    return wordListViewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed) {
        BookModel *bm = books[pageIndex-1];
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

- (int)getPageIndex:(WordListViewController*)vc
{
    return vc.pageIndex;
}

- (void)play{
    BookModel *bm = [[BookModel alloc] init];
    bm = [bm find:bookId];
    WordModel *wm = [[WordModel alloc] init];
    NSMutableArray *words = [wm findByBookId:bm.recodeId];
    if ([words count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"再生する単語がありません。下にスクロールしてデータを更新してください。"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    } else {
        WordPlayViewController *pvc = [[WordPlayViewController alloc] initWithNibName:nil bundle:nil];
        pvc.records = words;
        [self.navigationController pushViewController:pvc animated:YES];
    }
}

- (void)config{
    ConfigListViewController *cvc = [[ConfigListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)tabBookTitle: (UITapGestureRecognizer *)sender{
    UILabel *label = (UILabel *)sender.view;
    bookId = label.tag;
    [self makePageView:CGRectMake(0, 0, pageArea.frame.size.width, pageArea.frame.size.height)];
    [pageArea addSubview:pageViewController.view];
    [tabBar changeLabel:label];
}

- (void)rehash {
    NSMutableArray *newBookRecords = [[[BookModel alloc]init] findAll];
    [tabBar rehash:newBookRecords];
    UILabel *label = tabBar.labels[0];
    bookId = label.tag;
    [self makePageView:CGRectMake(0, 0, pageArea.frame.size.width, pageArea.frame.size.height)];
    [pageArea addSubview:pageViewController.view];
    [tabBar changeLabel:label];
}

@end

