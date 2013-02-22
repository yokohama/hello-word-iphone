//
//  AccountConfigViewController.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/02/20.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "AccountConfigViewController.h"
#import "ConfigListViewController.h"
#import "ConfigModel.h"

@implementation AccountConfigViewController


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConfigModel *cm = [[ConfigModel alloc] init];
    if ([cm isRegisted]) {
        [cm unRegist];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    } else {
        if (indexPath.section == 1) {
            NSString *postData = [[NSString alloc] initWithFormat:@"user[email]=%@&user[password]=%@", emailTf.text, passwordTf.text];
            //NSString *urlstr = @"http://hello-word.herokuapp.com/api/users/sign_in_by_mobile";
            NSString *urlstr = @"http://localhost:3000/api/users/sign_in_by_mobile";
            NSURL *url = [NSURL URLWithString:urlstr];
            
            NSData *myRequestData = [postData dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
            [request setHTTPMethod: @"POST"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
            [request setHTTPBody: myRequestData];
            
            NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int result = nil;
    if (section == 0) {
        result = 2;
    } else if (section == 1) {
        result = 1;
    }
    return result;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        ConfigModel *cm = [[ConfigModel alloc] init];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"メールアドレス";
            cell.textLabel.font = [UIFont fontWithName:@"AppleGothic" size:12];
            emailTf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, cell.frame.size.height)];
            emailTf.textColor = [UIColor colorWithRed:59.0/255.0 green:85.0/255.0 blue:133.0/255.0 alpha:1.0];
            emailTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            emailTf.textAlignment = NSTextAlignmentLeft;
            emailTf.returnKeyType = UIReturnKeyDone;
            emailTf.clearButtonMode = UITextFieldViewModeUnlessEditing;
            emailTf.keyboardType = UIKeyboardTypeEmailAddress;
            emailTf.delegate = self;
            if ([cm isRegisted]) {
                emailTf.text = cm.email;
            }
            cell.accessoryView = emailTf;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"パスワード";
            cell.textLabel.font = [UIFont fontWithName:@"AppleGothic" size:12];
            passwordTf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, cell.frame.size.height)];
            passwordTf.textColor = [UIColor colorWithRed:59.0/255.0 green:85.0/255.0 blue:133.0/255.0 alpha:1.0];
            passwordTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            passwordTf.textAlignment = NSTextAlignmentLeft;
            passwordTf.returnKeyType = UIReturnKeyDone;
            passwordTf.clearButtonMode = UITextFieldViewModeUnlessEditing;
            passwordTf.secureTextEntry = YES;
            if ([cm isRegisted]) {
                passwordTf.text = cm.password;
            }
            passwordTf.delegate = self;
            cell.accessoryView = passwordTf;
        }
        
    } else if (indexPath.section == 1) {
        ConfigModel *cm = [[ConfigModel alloc] init];
        if ([cm isRegisted]) {
            cell.textLabel.text = @"解除";
        } else {
            cell.textLabel.text = @"ログイン";
        }
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//ヘッダーがかえって来た時の処理
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
	int statusCode = [res statusCode];
    
    if (statusCode == 200) {
        ConfigModel *cm = [[ConfigModel alloc] init];
        cm.email = emailTf.text;
        cm.password = passwordTf.text;
        [cm regist];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"認証に失敗しました。"
                 delegate:self
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil];
        [alert show];
    }
}

//ダウンロード中の処理
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"hoge2");
}

//ダウンロード完了時の処理
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"hoge3");
}

//通信エラー処理
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error"
                          message:@"認証に失敗しました。"
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

@end
