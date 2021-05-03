//
//  RegisterVC.h
//  Marlborough
//
//  Created by AAYUSHI on 11/03/18.
//  Copyright © 2018 Aayushi Batra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFHTTPSessionManager.h>
#import "SVProgressHUD.h"


@interface RegisterVC : UIViewController<UITextFieldDelegate>
{
    AFHTTPSessionManager *manager;
    NSDictionary *params,*data_dict;
    NSString *message,*device_id,*str_status,*user_id;
    BOOL state;
    
    NSString * link ;
    
}

@property (weak, nonatomic) IBOutlet UITextField *txtemail;
@property (weak, nonatomic) IBOutlet UITextField *txtname;
@property (weak, nonatomic) IBOutlet UITextField *txtphone;
@property (weak, nonatomic) IBOutlet UITextField *txtpassword;


@property (weak, nonatomic) IBOutlet UIButton *adBtn;
@end
