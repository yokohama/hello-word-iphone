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
    
    CGRect r = [[UIScreen mainScreen] bounds];
    CGFloat w = r.size.width;
    
    tabBar = [[TabBar alloc] initWithFrame:CGRectMake(0, 0, w, 35) delegateController:self];
    //tabBar.tag = @"tabBar";
    
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
    
    UIView *pageArea = [[UIView alloc] initWithFrame:CGRectMake(0, tabBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 80)];
    [self.view addSubview:pageArea];
    pageArea.backgroundColor = [UIColor yellowColor];
    
    //ページめくり
    BookModel *bm = [[BookModel alloc] init];
    bm = [bm find:bookId];
    pageMax = [books count];
    
    pageIndex = 1;
    for (int i=0; i<[books count]; i++) {
        BookModel *b = books[i];
        if (b.recodeId == bookId) {
            pageIndex = i+1;
        }
    }
    
    pageViewController = [[UIPageViewController alloc]
                          initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                          options:nil];
    
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    pageViewController.view.frame = CGRectMake(0, 0, pageArea.frame.size.width, pageArea.frame.size.height);
    pageViewController.view.backgroundColor = [UIColor whiteColor];

    [self setWordListViewController:bm.recodeId];
    NSArray *viewControllers = [NSArray arrayWithObject:wordListViewController];
    [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    
    [pageViewController setDoubleSided:NO];
    
    [self addChildViewController:pageViewController];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
    
    [pageArea addSubview:pageViewController.view];
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
    
    //ページが最後までめくられたら、ページを再設定
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
    WordModel *wm = [[WordModel alloc] init];
    wordListViewController.records = [wm findByBookId:bookId];
    wordListViewController.count.text = [NSString stringWithFormat:@"%d 件", [wordListViewController.records count]];
    for (int i=0; i<[books count]; i++) {
        if (label.tag == [books[i] recodeId]) {
            pageIndex = i+1;
            wordListViewController.pageIndex = pageIndex;
        }
    }
    [wordListViewController.tableView reloadData];
    
    [tabBar changeLabel:label];
    
}


@end

