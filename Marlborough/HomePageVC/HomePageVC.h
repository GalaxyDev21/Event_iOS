//
//  HomePageVC.h
//  Marlborough
//
//  Created by AAYUSHI on 17/03/18.
//  Copyright © 2018 Aayushi Batra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFHTTPSessionManager.h>
#import "SVProgressHUD.h"


@interface HomePageVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{
    AFHTTPSessionManager *manager;
    NSDictionary *params,*data_dict;
    NSString *message,*device_id,*str_status,*user_id;
    BOOL state;
    
    NSString * link ;
    NSArray *TempArray;
    NSMutableArray * categoryArr;
    NSMutableArray * SubcategoryArr;
    IBOutlet UIView *MenuInfoBackVIew;
    
    IBOutlet UIView *MenuInfoview;
    
    
}
@property (strong, nonatomic) IBOutlet UIButton *MenuInfoButtonClick;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *adBtn;
- (IBAction)MenuInfoBtnEvent:(id)sender;
- (IBAction)LogoutbtnClick:(id)sender;

@end
