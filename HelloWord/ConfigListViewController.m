//
//  ConfigViewController.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/14.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "ConfigListViewController.h"
#import "ConfigModel.h"

@implementation ConfigListViewController

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
    
    //navibar
    //TODO:タイトルをセットする。戻るボタンではなく完了ボタンにする。黒くする。
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    ConfigModel *cm = [[ConfigModel alloc] init];
    if ([cm isRegisted]) {
        registedLabel = @"登録済";
    } else {
        registedLabel = @"未登録";
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountConfigViewController *next = [[AccountConfigViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 0) {
      title = @"アカウント";
    }
    return title;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *CellIdentifier = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"パスワード認証";
    cell.detailTextLabel.text = registedLabel;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}


@end
