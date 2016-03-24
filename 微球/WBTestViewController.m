//
//  WBTestViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/11.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBTestViewController.h"

@interface WBTestViewController ()

@end

@implementation WBTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"TEST";
    WBBig_AreaModel *model = [[WBBig_AreaModel alloc]init];
    
    
    
    model.areaId = 5;
    model.areaName = @"jiayubin";
    model.isCountry = 1;
    [[DBManager sharedInstance] addCollect:model];
    
    NSArray *array = [[DBManager sharedInstance] searchAllFavoriteApps];
    NSLog(@"%@",array);
   
    [[DBManager sharedInstance] deleteAllData];
     NSArray *array1 = [[DBManager sharedInstance] searchAllFavoriteApps];
    NSLog(@"%@",array1);
    
    
    MyDBmanager *manager = [[MyDBmanager alloc]initWithStyle:Big_area];
   
    [manager  addItem:model];
    
     NSLog(@"%@",[manager searchAllItems]);
   // [manager cl]
    [manager closeFBDM];
    
    
    WBTbl_Unlock_City *model1 = [[WBTbl_Unlock_City alloc]init];
    model1.cityId = 1;
    model1.userId = 12213;
    model1.cityId = 2323;
    model1.unlockDate = [NSDate date];
    model1.areaId = 1;
    model1.marked = 5;
    
    MyDBmanager *manager1 = [[MyDBmanager alloc]initWithStyle:Tbl_unlock_city];
    [manager1 addItem:model1];
    NSLog(@"Tbl_unlock_city = %@",[manager1 searchAllItems]);
    [manager1 closeFBDM];
    
    
    MyDBmanager *manager3 = [[MyDBmanager alloc]initWithStyle:Help_group_sign];
    WBHelp_Group_Sign *model3 = [[WBHelp_Group_Sign alloc]init];
    model3.sign_id = 123;
    model3.sign = @"dsadsa";
    model3.sign_describe = @"dsadsa";
    model3.type_flag = @"q";
    [manager3 addItem:model3];
    
    NSLog(@"Tbl_unlock_city = %@",[manager3 searchAllItems]);
   // [manager3 ]
    
    
    
    
    
    
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
