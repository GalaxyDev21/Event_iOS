//
//  WebviewVC.m
//  Marlborough
//
//  Created by AAYUSHI on 17/03/18.
//  Copyright © 2018 Aayushi Batra. All rights reserved.
//

#import "WebviewVC.h"

@interface WebviewVC ()

@end

@implementation WebviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [SVProgressHUD show];
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:_urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [_webView loadRequest:requestObj];
}

- (IBAction)backBtn:(id)sender {
     [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:true];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
