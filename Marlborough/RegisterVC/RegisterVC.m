//
//  RegisterVC.m
//  Marlborough
//
//  Created by AAYUSHI on 11/03/18.
//  Copyright © 2018 Aayushi Batra. All rights reserved.
//

#import "RegisterVC.h"
#import "HomePageVC.h"

@interface RegisterVC ()

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self adMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backbtn:(id)sender {
  [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)registerAction:(id)sender {
    
    if ([self checkForProviderBlankFields]) {
        
        if ([self checkEmailValidation:self.txtemail.text]) {
            [SVProgressHUD show];
            self.view.userInteractionEnabled = false;
            [self  registerapi];
        }
        
        else
        {
            [self showAlert:@"Please enter valid email." title:@""];
            
        }
    }
    else {
        
    }
    
    
}




-(void)registerapi
{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = false;
    params = @{@"name":_txtname.text ,@"email":_txtemail.text,@"phone":_txtphone.text,@"password":_txtpassword.text,@"device_type":@"ios",@"device_token":@"12353535345"};
    
    manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    manager.responseSerializer = responseSerializer;
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
//    [manager POST:@"https://talkmia.com/dev/km_dev/api/v1/auth/register" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
     [manager POST:@"https://marlborough.greetingtoindia.com/api/v1/auth/register" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
    
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dict = [responseObject valueForKey:@"response"] ;
        
        str_status = [dict valueForKey:@"code"];
        
        if ([str_status intValue] == 200) {
            [SVProgressHUD dismiss];
            self.view.userInteractionEnabled = true;
            
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

- (IBAction)adBtnActn:(id)sender {
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:link];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}


-(void)adMethod
{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = false;
    manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    manager.responseSerializer = responseSerializer;
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // advertise/show
    
//    [manager POST:@"https://talkmia.com/dev/km_dev/api/v1/advertise/show" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
     [manager POST:@"https://marlborough.greetingtoindia.com/api/v1/multiple/show" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
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
                 
                 if ([[adDict valueForKey:@"identifier_name"] isEqualToString:@"register"])
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


#pragma mark TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (textField == self.txtname)
    {
        [textField resignFirstResponder];
        [self.txtemail becomeFirstResponder];
        
    }
    if (textField == self.txtemail)
    {
        [textField resignFirstResponder];
        [self.txtphone becomeFirstResponder];
        
    }
    if (textField == self.txtphone)
    {
        [textField resignFirstResponder];
        [self.txtpassword becomeFirstResponder];
        
    }
    if (textField == self.txtpassword) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
      //  self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    }
return YES;
    
}
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (textField == self.txtname)
//    {
//        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//
//    }
//    else if (textField == self.txtemail)
//    {
//        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//
//    }
//    else if (textField == self.txtphone)
//    {
//        self.view.frame = CGRectMake(0, -90, self.view.frame.size.width, self.view.frame.size.height);
//
//    }
//    else if (textField == self.txtpassword)
//    {
//        self.view.frame = CGRectMake(0, -160, self.view.frame.size.width, self.view.frame.size.height);
//    }
//
//}

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
    
    if ([self.txtname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        [self showAlert:@"Please enter name." title:@""];
        return NO;
    }
    else  if ([self.txtemail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        [self showAlert:@"Please enter the email address." title:@""];
        return NO;
    }
    else  if ([self.txtpassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
