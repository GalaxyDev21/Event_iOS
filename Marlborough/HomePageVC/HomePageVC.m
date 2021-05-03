//
//  HomePageVC.m
//  Marlborough
//
//  Created by AAYUSHI on 17/03/18.
//  Copyright © 2018 Aayushi Batra. All rights reserved.
//

#import "HomePageVC.h"
#import "HomePageCell.h"
#import "WebviewVC.h"
#import "SubCategoryVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TAPageControl.h"
#import "ContactUsVC.h"

@interface HomePageVC () <UIScrollViewDelegate, TAPageControlDelegate>
{
    NSTimer *timer;
    NSInteger index;
}
@property (strong, nonatomic) TAPageControl *customPageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (strong, nonatomic) NSArray *imagesData;
@property (strong, nonatomic) NSArray *AdData;
@property (strong, nonatomic) NSArray *AdvertiseArray;
@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  //  self.imagesData = @[@"placeholder", @"placeholder", @"placeholder"];
    self.AdData = @[@"image1.jpg", @"image2.jpg", @"image3.jpg"];
    

    //--------------
    [self.navigationController setNavigationBarHidden:YES animated:true];

    MenuInfoBackVIew.hidden = YES;
    MenuInfoview.hidden = YES;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [MenuInfoBackVIew addGestureRecognizer:singleFingerTap];
    
    [self adMethod];
    [self CollectionViewMethod];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    // CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    MenuInfoBackVIew.hidden = YES;
    MenuInfoview.hidden = YES;
    
}

-(void)CollectionViewMethod
{
    [SVProgressHUD show];
    manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    manager.responseSerializer = responseSerializer;
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //
//    [manager POST:@"https://talkmia.com/dev/km_dev/api/v1/category/show" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
//    {
    [manager POST:@"https://marlborough.greetingtoindia.com/api/v1/category/show" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
    {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dict = [responseObject valueForKey:@"response"] ;
        
        str_status = [dict valueForKey:@"code"];
        
        if ([str_status intValue] == 200) {
            [SVProgressHUD dismiss];
            self.view.userInteractionEnabled = true;
            
            
            TempArray = [dict valueForKey:@"data"];
            categoryArr = [[NSMutableArray alloc]init];
            for (int i = 0; i < TempArray.count; i++) {
                if ([[[TempArray objectAtIndex:i] objectForKey:@"parentcatid"] isEqualToString:@"0"]){
                   [categoryArr addObject:[TempArray objectAtIndex:i]];
                    
                }
            }
            NSMutableDictionary *datadic = [[NSMutableDictionary alloc]init];
            [datadic setValue:@"custom" forKey:@"id"];
            [datadic setValue:@"CONTACT US" forKey:@"name"];
         //   [datadic setValue:@"https://marlborough.greetingtoindia.com/uploads/category_images/1m4r08EcJU64.png" forKey:@"Image_url"];
            [categoryArr addObject:datadic];
            
             [_collectionView reloadData];
            
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




#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return categoryArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"HomePageIdentifier";
    
    HomePageCell *cell = (HomePageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSDictionary * dict = [categoryArr objectAtIndex:indexPath.row];
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"Image_url"]]];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    UIImage *img = [[UIImage alloc] initWithData:data];
//
//  cell.cellImg.image = img;
    
   // cell.cellImg.layer.cornerRadius = cell.cellImg.frame.size.height / 2;
 //   cell.cellImg.layer.masksToBounds = true;
    
    if ([[dict objectForKey:@"id"] isEqualToString:@"custom"]){
        cell.cellImg.image = [UIImage imageNamed:@"1m4r08EcJU64.png"];
    }else{
        [cell.cellImg sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"Image_url"]]
                        placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    
    cell.CellTxt.text = [dict valueForKey:@"name"];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dict = [categoryArr objectAtIndex:indexPath.row];
    
    SubcategoryArr = [[NSMutableArray alloc]init];
    
    if ([[[categoryArr objectAtIndex:indexPath.row] objectForKey:@"id"] isEqualToString:@"custom"]){
        NSLog(@"click on contct us cat");
        
        ContactUsVC *vc = [[self.storyboard init]instantiateViewControllerWithIdentifier:@"ContactUsVC"];
        [self.navigationController pushViewController:vc animated:true];
        
    }else{
        for (NSUInteger i = 0 ; i < TempArray.count; i++) {
            
            if ([[TempArray[i] valueForKey:@"parentcatid"] isEqualToString:[dict valueForKey:@"id"]]){
                NSLog(@"u r in dude");
                [SubcategoryArr addObject: TempArray[i]];
            }
        }
        //  [SubcategoryArr addObject:@"sumit"];
        if (SubcategoryArr.count > 0){
            SubCategoryVC *ResutVc = [[self.storyboard init]instantiateViewControllerWithIdentifier:@"SubCategoryVC"];
            [ResutVc setSubCatArray: SubcategoryArr];
            [ResutVc setSelectedCatId:[dict valueForKey:@"id"]];
            [self.navigationController pushViewController:ResutVc animated:true];
        }else{
            WebviewVC *vc = [[self.storyboard init]instantiateViewControllerWithIdentifier:@"WebviewVC"];
            vc.urlAddress = [NSString stringWithFormat:@"%@",[dict valueForKey:@"link"]];
            [self.navigationController pushViewController:vc animated:true];
        }
        
        
    }
}

#pragma mark - ad view

- (IBAction)adBtnActn:(id)sender {
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:link];
    if (@available(iOS 10.0, *)) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Opened url");
            }
        }];
    } else {
        // Fallback on earlier versions
    }
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
    //
//    [manager POST:@"https://talkmia.com/dev/km_dev/api/v1/advertise/show" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
//     {
    [manager POST:@"https://marlborough.greetingtoindia.com/api/v1/multiple/show" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject){
    
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
                 
                 if ([[adDict valueForKey:@"identifier_name"] isEqualToString:@"homepage"])
                 {
//                     link = [adDict valueForKey:@"link"];
//
//
//                     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[adDict valueForKey:@"Image_url"]]];
//                     NSData *data = [NSData dataWithContentsOfURL:url];
//                     UIImage *img = [[UIImage alloc] initWithData:data];
//
//                     [_adBtn setBackgroundImage:img forState:UIControlStateNormal];
                     self.AdvertiseArray = [adDict valueForKey:@"advertise"];
                     if (self.AdvertiseArray.count > 0) {
                         [self AdvertiseSliderFunction:self.AdvertiseArray];
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


- (IBAction)MenuInfoBtnEvent:(id)sender {
    MenuInfoBackVIew.hidden = NO;
    MenuInfoview.hidden = NO;
}

- (IBAction)LogoutbtnClick:(id)sender {
    MenuInfoBackVIew.hidden = YES;
    MenuInfoview.hidden = YES;
    
    UIViewController *viewController =  [[self.storyboard init]instantiateViewControllerWithIdentifier:@"ViewController"];
    [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"Login"];
    [self.navigationController pushViewController:viewController animated:true];
    
    
}

-(void)AdvertiseSliderFunction:(NSArray*)imagesData{
   
    for(int i=0; i<imagesData.count;i++){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * i, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.scrollView.frame))];
        imageView.contentMode = UIViewContentModeScaleToFill;
        //UIViewContentModeScaleAspectFill;
        //imageView.layer.masksToBounds = YES;
       // imageView.image = [UIImage imageNamed:[imagesData objectAtIndex:i]];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString: [[imagesData objectAtIndex:i] objectForKey:@"generatedImageURL"]]
                        placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
       
        
        
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
        imageView.tag = i;
        [imageView addGestureRecognizer:letterTapRecognizer];
        
        
        
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.delegate = self;
    index=0;
    
    
    // Progammatically init a TAPageControl with a custom dot view.
   //CGRectMake(0, CGRectGetMaxY(self.scrollView.frame) - 100, CGRectGetWidth(self.scrollView.frame), 40)
    
    // self.customPageControl.center = self.view.center;
    
    // Example for touch bullet event
   
    
    
    // ------------ customPage configuration
    self.customPageControl.hidden = YES;
    
    if (imagesData.count > 1) {
        
       self.customPageControl = [[TAPageControl alloc] initWithFrame:CGRectMake(self.scrollView.center.x - 110,self.scrollView.frame.origin.y+self.scrollView.frame.size.height-30,self.scrollView.frame.size.width,40)];
        
        self.customPageControl.center = [self.scrollView convertPoint:self.scrollView.center fromView:self.scrollView.superview];
       
        CGRect r = [self.customPageControl frame];
        r.origin.y = self.scrollView.frame.origin.y+self.scrollView.frame.size.height-30;
        [self.customPageControl setFrame:r];
        
        self.customPageControl.delegate      = self;
        self.customPageControl.numberOfPages = imagesData.count;
        self.customPageControl.dotSize       = CGSizeMake(0, 0);
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * imagesData.count, CGRectGetHeight(self.scrollView.frame));
        [self.view addSubview:self.customPageControl];
        
        
        timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(runImages) userInfo:nil repeats:YES];
    }
    
    
}

- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    UIView *view = sender.view;
    NSLog(@"%ld", (long)view.tag);//By tag, you can find out where you had tapped.
    NSString *adlink = [[self.AdvertiseArray objectAtIndex:view.tag] objectForKey:@"link"];
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:adlink];
    if (@available(iOS 10.0, *)) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Opened url");
            }
        }];
    } else {
        // Fallback on earlier versions
    }
    
}


-(void)viewDidAppear:(BOOL)animated{
    if (self.AdvertiseArray.count > 1) {
        timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(runImages) userInfo:nil repeats:YES];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    if (timer) {
        [timer invalidate];
        timer=nil;
    }
}

-(void)runImages{
    self.customPageControl.currentPage=index;
    if (index==self.AdvertiseArray.count-1) {
        index=0;
    }else{
        index++;
    }
    [self TAPageControl:self.customPageControl didSelectPageAtIndex:index];
}



#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    self.customPageControl.currentPage = pageIndex;
    index=pageIndex;
}
// Example of use of delegate for second scroll view to respond to bullet touch event
- (void)TAPageControl:(TAPageControl *)pageControl didSelectPageAtIndex:(NSInteger)currentIndex
{
    index=currentIndex;
    [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.view.frame) * currentIndex, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.scrollView.frame)) animated:YES];
}


@end
