//
//  ViewController.h
//  Marlborough
//
//  Created by AAYUSHI on 10/03/18.
//  Copyright © 2018 Aayushi Batra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFHTTPSessionManager.h>
#import "SVProgressHUD.h"

@interface ViewController : UIViewController<UITextFieldDelegate>
{
    AFHTTPSessionManager *manager;
    NSDictionary *params,*data_dict;
    NSString *message,*device_id,*str_status,*user_id;
    BOOL state;
    
     NSString * link ;
  
}

@property (weak, nonatomic) IBOutlet UIView *loginSignUpVW;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UIButton *adBtn;


@end

