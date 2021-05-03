//
//  WebviewVC.h
//  Marlborough
//
//  Created by AAYUSHI on 17/03/18.
//  Copyright © 2018 Aayushi Batra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

@interface WebviewVC : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong,nonatomic) NSString * urlAddress;

@end
