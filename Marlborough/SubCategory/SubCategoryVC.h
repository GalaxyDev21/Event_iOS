//
//  SubCategoryVC.h
//  Marlborough
//
//  Created by Sumit Parmar on 26/03/18.
//  Copyright © 2018 Aayushi Batra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFHTTPSessionManager.h>
#import "SVProgressHUD.h"


@interface SubCategoryVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{
    AFHTTPSessionManager *manager;
    NSDictionary *params,*data_dict;
    NSString *message,*device_id,*str_status,*user_id;
    BOOL state;
    
    
    NSString * link;
    
}

@property (strong, nonatomic) IBOutlet UICollectionView *SubCatCollectionView;
@property (strong,nonatomic) NSMutableArray *SubCatArray;
@property (strong,nonatomic) NSString *selectedCatId;
@property (weak, nonatomic) IBOutlet UIButton *advBtn;
@end
