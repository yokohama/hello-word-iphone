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

@synthesize pageIndex, records, count, bookId;

-(id)initWithBookId: (int)_bookId invorked:(UIViewController *)controller {
    self = [super init];
    invorkedController = controller;
    bookId = _bookId;
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
    
    CGRect r = [[UIScreen mainScreen] bounds];
    CGFloat w = r.size.width;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 30)];
    count = [[UILabel alloc] initWithFrame:CGRectMake(HEADER_MARGIN_WIDTH, 0, header.frame.size.width-(HEADER_MARGIN_WIDTH*2), 30)];
    count.textAlignment = NSTextAlignmentCenter;
    [header addSubview:count];
    self.tableView.tableHeaderView = header;
    
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, (0- REFRESH_VIEW_HEIGHT), self.view.frame.size.width, REFRESH_VIEW_HEIGHT)];
    refreshView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:refreshView];
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
    
    [self.tableView reloadData];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:NO];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WordShowViewController *next = [[WordShowViewController alloc] initWithWordModel:records[indexPath.row]];
    [invorkedController.navigationController pushViewController:next animated:YES];
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
        ConfigModel *cm = [[ConfigModel alloc]init];
        if ([cm isRegisted]) {
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
            NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:path];
            NSString *urlstr = [[NSString alloc] initWithFormat:@"%@/api/books", [plist objectForKey:@"API URL"]];
            
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
     
     if ([newBooks count] > 0) {
     [[[BookModel alloc]init] rehash:newBooks];
     
     CGRect r = [[UIScreen mainScreen] bounds];
     CGFloat w = r.size.width;
     
     [[invorkedController.view viewWithTag:@"tabBar"] removeFromSuperview];
     
         /*
     TabBar *tabBar = [[TabBar alloc] initWithFrame:CGRectMake(0, 0, w, 35) selectedLabel:selectedLabe delegateController:self];
     [invorkedController.view addSubview:tabBar];
     */
     WordModel *wm = [[WordModel alloc] init];
     records = [wm findByBookId:bookId];
     [self.tableView reloadData];
     }
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

@end

