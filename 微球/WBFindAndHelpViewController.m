//
//  WBFindAndHelpViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/26.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBFindAndHelpViewController.h"

@interface WBFindAndHelpViewController ()
{
    UIView *_tip;//小红点

}
@end

@implementation WBFindAndHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavi];
    
}


-(void)createNavi{

    CGSize itemSize = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_mesg"]].frame.size;
    
    UIButton *leftBarButtonItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height)];
    [leftBarButtonItem setBackgroundImage:[UIImage imageWithOriginal:@"icon_webar"] forState:UIControlStateNormal];
    [leftBarButtonItem addTarget:self action:@selector(presentLeftMenuViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonItem];
    
    UIButton *rightBarButton = [[UIButton alloc] initWithFrame:(CGRect){0,0,itemSize}];
    [rightBarButton setImage:[UIImage imageWithOriginal:@"btn_mesg"] forState:UIControlStateNormal];
    _tip = [[UIView alloc] initWithFrame:CGRectMake(itemSize.width - 6, 0, 6, 6)];
    _tip.backgroundColor = [UIColor redColor];
    _tip.layer.masksToBounds = YES;
    _tip.layer.cornerRadius = 3;
    _tip.hidden = YES;
    [rightBarButton addSubview:_tip];
    [rightBarButton addTarget:self action:@selector(presentRightMenuViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];


}

- (void)presentLeftMenuViewController
{
    
    
    if ([WBUserDefaults userId]) {
        self.sideMenuViewController.isFindPage = YES;
        [self.sideMenuViewController presentLeftMenuViewController];
    }
}

- (void)presentRightMenuViewController
{
    self.sideMenuViewController.isFindPage = YES;
    [self.sideMenuViewController presentRightMenuViewController];
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
