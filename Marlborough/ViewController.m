//
//  ViewController.m
//  Marlborough
//
//  Created by AAYUSHI on 10/03/18.
//  Copyright © 2018 Aayushi Batra. All rights reserved.
//

#import "ViewController.h"
#import "RegisterVC.h"
#import "ForgotPasswordVC.h"
#import "HomePageVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
     [self.navigationController setNavigationBarHidden:YES animated:true];
    
    _loginBtn.frame = CGRectMake(0, 5,([UIScreen mainScreen].bounds.size.width - 32)/2 - 5 , 47);
    
    _signupBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 32)/2 + 5, 5, ([UIScreen mainScreen].bounds.size.width - 32)/2 -5, 47);
    
    [self adMethod];
}

- (IBAction)signupbtn:(id)sender {
    
    RegisterVC *vc = [[self.storyboard init]instantiateViewControllerWithIdentifier:@"RegisterVC"];
    [self.navigationController pushViewController:vc animated:true];
    
}

- (IBAction)forgotbtn:(id)sender {
    
    ForgotPasswordVC *vc = [[self.storyboard init]instantiateViewControllerWithIdentifier:@"ForgotPasswordVC"];
    [self.navigationController pushViewController:vc animated:true];
}


- (IBAction)loginAction:(id)sender {
   
   
    
  
    if ([self checkForProviderBlankFields]) {

         if ([self checkEmailValidation:self.txtEmail.text]) {
        [SVProgressHUD show];
        self.view.userInteractionEnabled = false;
        [self  SignIn];
         }
        
        else
        {
            [self showAlert:@"Please enter valid email." title:@""];
            
        }
    }
    else {
        
    }
    
}


- (IBAction)adActn:(id)sender {
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:link];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SignIn
{
     [SVProgressHUD show];
    params = @{@"email":self.txtEmail.text,@"password":self.txtPassword.text,@"device_type":@"ios",@"device_token":@"8wy08y8y0wddd"};
    
    manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    manager.responseSerializer = responseSerializer;

    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // https://marlborough.greetingtoindia.com/api/v1/
    
  //  [manager POST:@"https://talkmia.com/dev/km_dev/api/v1/auth/login" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
    [manager POST:@"https://marlborough.greetingtoindia.com/api/v1/auth/login" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
    
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dict = [responseObject valueForKey:@"response"] ;
        
        str_status = [dict valueForKey:@"code"];
        
        if ([str_status intValue] == 200) {
            [SVProgressHUD dismiss];
            self.view.userInteractionEnabled = true;
            
            NSDictionary *dataDict = [dict valueForKey:@"data"];
            NSString *str_id = [dataDict valueForKey:@"id"];
            [[NSUserDefaults standardUserDefaults]setValue:str_id forKey:@"user_id"];

            
            [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"Login"];
            
            HomePageVC *vc = [[self.storyboard init]instantiateViewControllerWithIdentifier:@"HomePageVC"];
            [self.navigationController pushViewController:vc animated:true];
            
        }
        else if ([str_status intValue] == 203)
        {
            [SVProgressHUD dismiss];
            self.view.userInteractionEnabled = true;
            message = [dict valueForKey:@"messages"];
            [self showAlert:message title:@""];
        }
        else if ([str_status intValue] == 300)
        {
            [SVProgressHUD dismiss];
            self.view.userInteractionEnabled = true;
            message = [dict valueForKey:@"messages"];
            [self showAlert:message title:@""];
            
        }
        else
        {
            [SVProgressHUD dismiss];
            self.view.userInteractionEnabled = true;
        }
    }
          failure:^(NSURLSessionTask *operation, NSError *error) {
              [SVProgressHUD dismiss];
              self.view.userInteractionEnabled = true;
              [self showAlert:@"The request timed out." title:@""];
              NSLog(@"%@",error.description);
              
          }];
}

#pragma mark ad view

-(void)adMethod
{
     [SVProgressHUD show];
     self.view.userInteractionEnabled = false;
    
    
    manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    manager.responseSerializer = responseSerializer;
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
 //   [manager POST:@"https://talkmia.com/dev/km_dev/api/v1/advertise/show" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
    
     [manager POST:@"https://marlborough.greetingtoindia.com/api/v1/multiple/show" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
    
    //
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *dict = [responseObject valueForKey:@"response"] ;
         
         str_status = [dict valueForKey:@"code"];
         
         if ([str_status intValue] == 200) {
             [SVProgressHUD dismiss];
             self.view.userInteractionEnabled = true;
             
             NSArray * arr = [dict valueForKey:@"data"];
             
             for (int i = 0; i < arr.count ; i++)
             {
             
                 NSDictionary * adDict = [arr objectAtIndex:i];
                 
                 if ([[adDict valueForKey:@"identifier_name"] isEqualToString:@"login"])
                 {
                     NSArray *temparray = [adDict valueForKey:@"advertise"];
                     
                     if (temparray.count > 0){
                         
                         link = [[temparray objectAtIndex:0] valueForKey:@"link"];
                         
                         
                         NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[temparray objectAtIndex:0] valueForKey:@"generatedImageURL"]]];
                         NSData *data = [NSData dataWithContentsOfURL:url];
                         UIImage *img = [[UIImage alloc] initWithData:data];
                         
                         [_adBtn setBackgroundImage:img forState:UIControlStateNormal];
                     }
                     
                     break;
                     
                 }
                 
                 
             }
             
             
         }
         else if ([str_status intValue] == 203)
         {
             [SVProgressHUD dismiss];
             self.view.userInteractionEnabled = true;
             message = [dict valueForKey:@"messages"];
             [self showAlert:message title:@""];
         }
         else if ([str_status intValue] == 300)
         {
             [SVProgressHUD dismiss];
             self.view.userInteractionEnabled = true;
             message = [dict valueForKey:@"messages"];
             [self showAlert:message title:@""];
             
         }
         else
         {
             [SVProgressHUD dismiss];
             self.view.userInteractionEnabled = true;
         }
     }
          failure:^(NSURLSessionTask *operation, NSError *error) {
              [SVProgressHUD dismiss];
              self.view.userInteractionEnabled = true;
              [self showAlert:@"The request timed out." title:@""];
              NSLog(@"%@",error.description);
              
          }];
    
}




#pragma mark Check Methods


-(BOOL)checkEmailValidation:(NSString *)checkString {
    
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL) checkForProviderBlankFields {
    
    if ([self.txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        [self showAlert:@"Please enter the email address." title:@""];
        return NO;
    }
    else  if ([self.txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        [self showAlert:@"Please enter the password." title:@""];
        return NO;
        
    }
    else
        return YES;
}
#pragma mark - UIAlertView

-(void) showAlert:(NSString *) msg title:(NSString *) title{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
    [alert addAction:yesButton];
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = true;
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - touchbegan
//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
//    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//}

@end
