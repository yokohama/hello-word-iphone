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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    tabBar = [[TabBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35) delegateController:self];
    [self.view addSubview:tabBar];
    
    header = [[HeaderView alloc] initWithFrame:CGRectMake(0, tabBar.frame.size.height, self.view.frame.size.width, 60) invorked:self];
    [self.view addSubview:header];
    
    pageArea = [[UIScrollView alloc] initWithFrame:CGRectMake(0, tabBar.frame.size.height+header.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [self makePageView:CGRectMake(0, 0, pageArea.frame.size.width, pageArea.frame.size.height)];
    [pageArea addSubview:pageViewController.view];
    
    [self.view addSubview:pageArea];
    
    UIView *toolArea = [[UIView alloc] initWithFrame:CGRectMake(0, 420, self.view.frame.size.width, 40)];
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
            //NSLog(@"bookId=%d recodeId=%d", bookId, [books.items[i] recodeId]);
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
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:NO];
}

- (void)setWordListViewController:(int)_bookId{
    wordListViewController = [[WordListViewController alloc] initWithBookId:_bookId invorked:self tabBar:tabBar header:header];
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
        //[self.navigationController pushViewController:pvc animated:YES];
        [self presentViewController: pvc animated:YES completion: nil];
    }
}

@end

