//
//  WordListViewController.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/26.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "WordListViewController.h"

#define HEADER_MARGIN_WIDTH 10
#define REFRESH_VIEW_HEIGHT 200

@implementation WordListViewController

@synthesize pageIndex, records, bookId, tabBar;

-(id)initWithBookId:(int)_bookId invorked:(UIViewController *)controller tabBar:(TabBar *)_tabBar header:(HeaderView *)_header
{
    self = [super init];
    invorkedController = controller;
    bookId = _bookId;
    tabBar = _tabBar;
    header = _header;
    responseData = [[NSMutableData alloc] init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初回bookIdがセットされていない時はライブラリの1をセット
    if (bookId == 0) {
        bookId = 1;
    }
    records = [[[WordModel alloc] init] findByBookId:bookId];
    
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, (0- REFRESH_VIEW_HEIGHT), self.view.frame.size.width, REFRESH_VIEW_HEIGHT)];
    UIColor *pink = [UIColor colorWithRed:1.0 green:0.9 blue:1.0 alpha:1.0];
    refreshView.backgroundColor = pink;
    [self.view addSubview:refreshView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    WordModel *wm = [[WordModel alloc] init];
    
    records = [wm findByBookId:bookId];
    
    BookModel *bm = [[[BookModel alloc] init] find:bookId];
    header.titleArea.text = [NSString stringWithFormat:@"%@(%d)", bm.title, [records count]];
    //header.countArea.text = [NSString stringWithFormat:@"%d 件", [records count]];
    
    [self.tableView reloadData];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:NO];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"hgoe4 %@", records[indexPath.row]);
    WordShowViewController *next = [[WordShowViewController alloc] initWithWordModel:records[indexPath.row]];
    [self presentViewController: next animated:YES completion: nil];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    WordModel *wm = records[indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", wm.word]];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    return;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    float y = scrollView.contentOffset.y;
    if (y < (-50.0)) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        ConfigModel *cm = [[ConfigModel alloc]init];
        if ([cm isRegisted]) {
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
            NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:path];
            NSString *urlstr = [[NSString alloc] initWithFormat:@"%@/api/books", [plist objectForKey:@"API URL"]];
            
            //TODO:plistが更新されないのでハードコーディング
            //urlstr = @"http://localhost:3000/api/books";
            
            NSString *postData = [[NSString alloc] initWithFormat:@"user[email]=%@&user[password]=%@", cm.email, cm.password];
            NSURL *url = [NSURL URLWithString:urlstr];
            NSLog(@"%@", urlstr);
            
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

//データ取得の都度実行（進捗把握につかえる）
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"===");
    [responseData appendData:data];
}

//通信完了時の処理
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"hoge3");
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *jsonDic = [parser objectWithData: responseData];
    NSLog(@"JSON dictionary=%@", [jsonDic description]);
    NSMutableArray *books = [jsonDic objectForKey:@"books"];
    newBooks = [NSMutableArray array];
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
    
    if ([newBooks count] > 0) {
        [[[BookModel alloc]init] rehash:newBooks];
        
        WordModel *wm = [[WordModel alloc] init];
        records = [wm findByBookId:bookId];
        [self.tableView reloadData];
        
        if ([invorkedController respondsToSelector:@selector(rehash)]) {
            [invorkedController performSelector:@selector(rehash)];
        }
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//通信エラー処理
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error"
                          message:@"サーバーに接続ができませんでした。"
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

@end

