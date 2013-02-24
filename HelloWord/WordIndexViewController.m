//
//  SampleViewController.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/14.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "WordIndexViewController.h"

#import "ConfigListViewController.h"
#import "WordPlayViewController.h"
#import "WordAddViewController.h"
#import "WordShowViewController.h"
#import "ConfigModel.h"
#import "SBJson.h"
#import "BookModel.h"
#import <QuartzCore/QuartzCore.h>


#define REFRESH_VIEW_HEIGHT 200
#define HEADER_MARGIN_WIDTH 10
#define TAB_WIDTH_SIZE 80
#define TAB_SPACER_SIZE 2


@implementation WordIndexViewController

@synthesize records, index, bookId;

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
    
    //初回bookIdがセットされていない時はライブラリの1をセット
    if (bookId == 0) {
        bookId = 1;
    }
    
    CGRect r = [[UIScreen mainScreen] bounds];
    CGFloat w = r.size.width;

    tabBar = [self makeTabBarWithFrame:CGRectMake(0, 0, w, 35)];
    //tabBar.tag = @"tabBar";
    [self.view addSubview:tabBar];
    
    index = [[UITableView alloc] initWithFrame:CGRectMake(0, tabBar.frame.size.height, w, (self.view.frame.size.height - tabBar.frame.size.height))];
    index.delegate = self;
    index.dataSource = self;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 30)];
    count = [[UILabel alloc] initWithFrame:CGRectMake(HEADER_MARGIN_WIDTH, 0, header.frame.size.width-(HEADER_MARGIN_WIDTH*2), 30)];
    count.textAlignment = NSTextAlignmentCenter;
    [header addSubview:count];
    index.tableHeaderView = header;
    
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, (0- REFRESH_VIEW_HEIGHT), self.view.frame.size.width, REFRESH_VIEW_HEIGHT)];
    refreshView.backgroundColor = [UIColor purpleColor];
    
    [index addSubview:refreshView];
    [self.view addSubview:index];
    
    self.navigationController.toolbar.tintColor = [UIColor blackColor];
    
    //検索バー
    /*TODO:このヘッダー部分にBookのタブをつけるかも
     UISearchBar *sb = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
     sb.delegate = self;
     sb.showsCancelButton = YES;
     sb.placeholder = @"検索ワードを入力してください";
     sb.keyboardType = UIKeyboardTypeDefault;
     sb.barStyle = UIBarStyleBlack;
     self.tableView.tableHeaderView = sb;
     */
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                               target:nil action:nil];
    
    //UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    
    UIBarButtonItem *play = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play)];
    //TODO:設定(アカウント、再生秒、管理画面連携など)
    UIBarButtonItem *config = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(config)];
    //TODO:選択削除
    /*
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(play)];
    */
    
    NSArray *items =
    [NSArray arrayWithObjects:spacer, play, spacer, config, spacer, nil];
    self.toolbarItems = items;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    WordModel *wm = [[WordModel alloc] init];
    records = [wm findByBookId:bookId];
    
    count.text = count.text = [NSString stringWithFormat:@"%d 件", [records count]];
    
    [index reloadData];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:NO];
}

-(UIScrollView *)makeTabBarWithFrame:(CGRect)rect{
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:rect];
    sv.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *books = [[[BookModel alloc]init] findAll];
    int scrollAreaWidth = rect.size.width;
    int tabBarWidthSize = 0;
    if ([books count] != 0) {
        for (int i=0; i<[books count]; i++) {
            tabBarWidthSize += (TAB_WIDTH_SIZE + TAB_SPACER_SIZE);
        }
        scrollAreaWidth = tabBarWidthSize;
    }
    
    UIView *scrollArea = nil;
    if ([books count] == 0) {
        scrollArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        UILabel *noBook = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        noBook.text = @"下にスクロールしてデータを同期";
        noBook.backgroundColor = [UIColor whiteColor];
        noBook.font = [UIFont fontWithName:@"AppleGothic" size:10];
        noBook.textAlignment = NSTextAlignmentCenter;
        [scrollArea addSubview:noBook];
    } else {
        scrollArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollAreaWidth-2, rect.size.height)];
        for (int i=0; i<[books count]; i++) {
            NSString *labelText = [[NSString alloc] initWithFormat:@" %@", [books[i] title]];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((TAB_WIDTH_SIZE*i)+(TAB_SPACER_SIZE*i), 0, TAB_WIDTH_SIZE, 35)];
            label.text = labelText;
            label.layer.cornerRadius = 5;
            label.layer.shadowOpacity = 0.2;
            label.layer.shadowOffset = CGSizeMake(2.0, 4.0);
            label.userInteractionEnabled = YES;
            label.font = [UIFont fontWithName:@"AppleGothic" size:10];
            label.numberOfLines = 0;
            label.tag = [books[i] recodeId];
            //label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabBookTitle:)];
            [label addGestureRecognizer:tap];
            [scrollArea addSubview:label];
            if (selectedBookLabel == nil) {
                label.backgroundColor = [UIColor redColor];
                selectedBookLabel = label;
            } else {
                label.backgroundColor = [UIColor grayColor];
            }
        }
    }
    [sv addSubview:scrollArea];
    sv.contentSize = scrollArea.bounds.size;
    sv.showsHorizontalScrollIndicator = NO;
    sv.tag = @"tabBar";
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(-300, 30, scrollAreaWidth+500, 5)];
    [line setBackgroundColor:[UIColor redColor]];
    [sv addSubview:line];
    
    return sv;
}

/*
- (void)add{
    UIViewController *avc = [[WordAddViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:avc animated:YES];
}
 */

- (void)play{
    WordPlayViewController *pvc = [[WordPlayViewController alloc] initWithNibName:nil bundle:nil];
    pvc.records = records;
    [self.navigationController pushViewController:pvc animated:YES];
}

- (void)config{
    ConfigListViewController *cvc = [[ConfigListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:cvc animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    return;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    float y = scrollView.contentOffset.y;
    if (y < (-50.0)) {
        ConfigModel *cm = [[ConfigModel alloc]init];
        if ([cm isRegisted]) {
            NSString *postData = [[NSString alloc] initWithFormat:@"user[email]=%@&user[password]=%@", cm.email, cm.password];
            NSString *urlstr = @"http://localhost:3000/api/books";
            NSURL *url = [NSURL URLWithString:urlstr];
        
            NSData *myRequestData = [postData dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
            [request setHTTPMethod: @"POST"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
            [request setHTTPBody: myRequestData];
        
            //TODO:戻り値使わないのに、変数に格納しないとワーニング。どういうこと？
            [[NSURLConnection alloc] initWithRequest:request delegate:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"サーバーから単語帳を取得するには、設定から認証をおこなってください。"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    return;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WordShowViewController *next = [[WordShowViewController alloc] initWithWordModel:records[indexPath.row]];
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [records count];
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"単語帳%d (%d件)", section, [records count]];
}
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    WordModel *wm = records[indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", wm.word]];
    
    //[cell.textLabel setTextAlignment:UITextAlignmentLeft];
    return cell;
}

//ダウンロード完了時の処理
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *jsonDic = [parser objectWithData: data];
    //NSLog(@"JSON dictionary=%@", [jsonDic description]);
    NSMutableArray *books = [jsonDic objectForKey:@"books"];
    NSMutableArray *newBooks = [NSMutableArray array];
    for (int i=0; i<[books count]; i++) {
        BookModel *bm = [[BookModel alloc]init];
        bm.title = [books[i] objectForKey:@"title"];
        
        NSMutableArray *arrayWords = [books[i] objectForKey:@"words"];
        for (int iw=0; iw<[arrayWords count]; iw++) {
            NSDictionary *word = arrayWords[iw];
            WordModel *wm = [[WordModel alloc] initWithValues:[word objectForKey:@"word"] answer:[word objectForKey:@"answer"]];
            //NSLog(@"%@", wm.word);
            [bm.words addObject:wm];
        }
        [newBooks addObject:bm];
    }
    [[[BookModel alloc]init] rehash:newBooks];
    
    CGRect r = [[UIScreen mainScreen] bounds];
    CGFloat w = r.size.width;
    
    [[self.view viewWithTag:@"tabBar"] removeFromSuperview];

    tabBar = [self makeTabBarWithFrame:CGRectMake(0, 0, w, 35)];
    [self.view addSubview:tabBar];
    
    WordModel *wm = [[WordModel alloc] init];
    records = [wm findByBookId:bookId];
    [index reloadData];
}

//通信完了時の処理
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"hoge3");
}

//通信エラー処理
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error"
                          message:@"サーバーに接続ができませんでした。"
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

- (void)tabBookTitle: (UITapGestureRecognizer *)sender{
    UILabel *label = (UILabel *)sender.view;
    bookId = label.tag;
    WordModel *wm = [[WordModel alloc] init];
    records = [wm findByBookId:bookId];
    count.text = count.text = [NSString stringWithFormat:@"%d 件", [records count]];
    [index reloadData];
    
    label.backgroundColor = [UIColor redColor];
    selectedBookLabel.backgroundColor = [UIColor grayColor];
    selectedBookLabel = label;
}

@end

