//
//  ContactUsVC.m
//  Marlborough
//
//  Created by Sumit Parmar on 09/04/18.
//  Copyright © 2018 Aayushi Batra. All rights reserved.
//

#import "ContactUsVC.h"
#import <MessageUI/MessageUI.h>

@interface ContactUsVC () <UITextViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *NameTextField;
@property (strong, nonatomic) IBOutlet UITextField *PhoneNumberTxt;
@property (strong, nonatomic) IBOutlet UITextField *EmailTxt;
@property (strong, nonatomic) IBOutlet UITextView *MessageTextField;

@end

@implementation ContactUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.navigationController setNavigationBarHidden:YES animated:true];
    
    [self TextFieldROundCornerAndBorderColoer:_NameTextField];
    [self TextFieldROundCornerAndBorderColoer:_PhoneNumberTxt];
    [self TextFieldROundCornerAndBorderColoer:_EmailTxt];
   // [self TextFieldROundCornerAndBorderColoer:_MessageTextField];
    
    
    [_MessageTextField.layer setBorderColor:[UIColor colorWithRed:62.0/255.0 green:20.0/255.0 blue:43.0/255.0 alpha:1].CGColor];
    [_MessageTextField.layer setBorderWidth:2.0];
    //The rounded corner part, where you specify your view's corner radius:
    _MessageTextField.layer.cornerRadius = 5;
    _MessageTextField.clipsToBounds = YES;
   // _MessageTextField.textColor = CFBridgingRelease([UIColor colorWithRed:62.0/255.0 green:20.0/255.0 blue:43.0/255.0 alpha:1].CGColor);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)TextFieldROundCornerAndBorderColoer:(UITextField *)MyTextField{
    [MyTextField.layer setBorderColor:[UIColor colorWithRed:62.0/255.0 green:20.0/255.0 blue:43.0/255.0 alpha:1].CGColor];
    
    [MyTextField.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    MyTextField.layer.cornerRadius = 5;
    MyTextField.clipsToBounds = YES;
    
}
- (IBAction)BackButtonClick:(id)sender {
  [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)SubmitButtonClick:(id)sender {
       if (_NameTextField.text.length == 0) {
            [self DisplayAlertMessage:@"Please Enter Your Name"];
             return;
        }
        if (_PhoneNumberTxt.text.length == 0) {
            [self DisplayAlertMessage:@"Please Enter Your Phone Number"];
            return;
        }
    
        if (_EmailTxt.text.length == 0) {
            [self DisplayAlertMessage:@"Please Enter Your Email"];
            return;
        }
    
        if ([self IsValidEmail:_EmailTxt.text]!=true)
        {
            [self DisplayAlertMessage:@"Please enter valid email address"];
    
            return;
        }
    
        if (_MessageTextField.text.length == 0) {
            [self DisplayAlertMessage:@"Please Enter Your Meessage"];
            return;
        }
    
        if ([_MessageTextField.text isEqualToString:@"Type Your Message Here"]) {
            [self DisplayAlertMessage:@"Please Enter Your Meessage"];
            return;
        }
    
        if ([MFMailComposeViewController canSendMail]) {
            NSString *emailTitle = @"Support";
            // Email Content
    
            NSString *messageBody = [NSString stringWithFormat:@"Name : %@ \n \n Phone Number : %@ \n \n Email : %@ \n \n Message : %@ \n \n ",_NameTextField.text, _PhoneNumberTxt.text,_EmailTxt.text,_MessageTextField.text];
    
            // To address
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    
            NSArray *toRecipents = [NSArray arrayWithObject:@"kaikouraapps@gmail.com"];
            //  NSArray *toRecipents = [NSArray arrayWithObject:@"princeofdance111@gmail.com"];
    
            mc.mailComposeDelegate = self;
            [mc setSubject:emailTitle];
            [mc setMessageBody:messageBody isHTML:NO];
            [mc setToRecipients:toRecipents];
    
           [self presentViewController:mc animated:YES completion:NULL];
    
        }else{
            [self DisplayAlertMessage:@"Email Service is not available on your device"];
            return;
        }
    
    }

    -(BOOL)IsValidEmail:(NSString *)checkString
    {
        BOOL stricterFilter = NO;
        NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
        NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:checkString];
    }


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
    {
        switch (result)
        {
            case MFMailComposeResultCancelled:
                NSLog(@"Mail cancelled");
                break;
            case MFMailComposeResultSaved:
                NSLog(@"Mail saved");
                break;
            case MFMailComposeResultSent:
                NSLog(@"Mail sent");
                _PhoneNumberTxt.text =@"";
                _EmailTxt.text = @"";
                _MessageTextField.text = @"";
                [self dismissViewControllerAnimated:YES completion:NULL];
    
                [self DisplayAlertMessage:@"Mail Sent Sucessfully."];
            
                break;
            case MFMailComposeResultFailed:
                NSLog(@"Mail sent failure: %@", [error localizedDescription]);
                break;
            default:
                break;
        }
    
        // Close the Mail Interface
        [self dismissViewControllerAnimated:YES completion:NULL];
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField ==  _PhoneNumberTxt) {
        NSLog(@"Range: %@", NSStringFromRange(range));
        return ( range.location < 20 );
    }
    return  YES;
}

#pragma mark UITextField Delegate Method.

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark UITextView Delegate Method.

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    _MessageTextField.text = @"";
    _MessageTextField.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(_MessageTextField.text.length == 0){
        
        _MessageTextField.text = @"Type Your Message Here";
        [_MessageTextField resignFirstResponder];
    }
}

-(void) DisplayAlertMessage:(NSString *)Message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Marlborough" message:Message preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alertController dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    });
    
    // return;
}
@end
