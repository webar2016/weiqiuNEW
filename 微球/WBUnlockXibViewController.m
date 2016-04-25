//
//  WBUnlockXibViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/4/23.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBUnlockXibViewController.h"

@interface WBUnlockXibViewController ()


@end

@implementation WBUnlockXibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc]initWithPlaceStyle:SinglePlaceChoice];
    addressPickerView.block = ^(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate,BOOL isSelected){
        
        if (isSelected) {
            
            [_positonBtn setTitle:[NSString stringWithFormat:@"%@",locate] forState:UIControlStateNormal];
            
            
        }
        
        
    };
    
    
    [addressPickerView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonClicked:(id)sender {
    
    AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc]initWithPlaceStyle:SinglePlaceChoice];
    addressPickerView.block = ^(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate,BOOL isSelected){
        if (isSelected) {
            
            [_positonBtn setTitle:[NSString stringWithFormat:@"%@",locate] forState:UIControlStateNormal];
            
            
            
        }
    };
    
    
    [addressPickerView show];
    
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
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
