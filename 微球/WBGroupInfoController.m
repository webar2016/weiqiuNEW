//
//  WBGroupInfoController.m
//  微球
//
//  Created by 徐亮 on 16/3/12.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBGroupInfoController.h"
#import "CreateHelpGroupViewController.h"
#import "WBGroupDetailController.h"

#import "WBPositionList.h"

@interface WBGroupInfoController () {
    UIButton        *_placeButton;
    UIButton        *_beginButton;
    UIButton        *_endButton;
    UIDatePicker    *_datePicker;
    UIView          *_datePickerView;
    
    NSString        *_startPlace;
    NSString        *_planBegin;
    NSString        *_planEnd;
    
    BOOL            _choosePlanBegin;
    BOOL            _datePickerIsHide;
}

@end

@implementation WBGroupInfoController

-(NSMutableDictionary *)dataDic{
    if (_dataDic) {
        return _dataDic;
    }
    _dataDic = [NSMutableDictionary dictionary];
    return _dataDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeStartPlace:)
                                                 name:@"choosePlace"
                                               object:nil];
    
    self.navigationItem.title = @"行程信息";
    
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:self action:@selector(lastStep)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self setUpUI];
    
    [self setUpDatePicker];
}

#pragma mark - navigation button

-(void)lastStep{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextStep{
    WBGroupDetailController *groupDetailVC = [[WBGroupDetailController alloc] init];
    groupDetailVC.dataDic = self.dataDic;
    
    [self.navigationController pushViewController:groupDetailVC animated:YES];
}

#pragma mark - UI

-(void)setUpUI{
    UILabel *startPlaceLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 32, 108, 64, 16)];
    startPlaceLable.textAlignment = NSTextAlignmentCenter;
    startPlaceLable.textColor = [UIColor initWithNormalGray];
    startPlaceLable.font = FONTSIZE16;
    startPlaceLable.text = @"始发地点";
    
    UILabel *tipOne = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 + 32, 112, 48, 12)];
    tipOne.textAlignment = NSTextAlignmentCenter;
    tipOne.textColor = [UIColor initWithNormalGray];
    tipOne.font = FONTSIZE12;
    tipOne.text = @"（选填）";
    
    UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 32, 240, 64, 16)];
    timeLable.textAlignment = NSTextAlignmentCenter;
    timeLable.textColor = [UIColor initWithNormalGray];
    timeLable.font = FONTSIZE16;
    timeLable.text = @"出游时间";
    
    UILabel *tipTwo = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 + 32, 244, 48, 12)];
    tipTwo.textAlignment = NSTextAlignmentCenter;
    tipTwo.textColor = [UIColor initWithNormalGray];
    tipTwo.font = FONTSIZE12;
    tipTwo.text = @"（选填）";
    
    _placeButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 145, 144, 290, 60)];
    _placeButton.backgroundColor = [UIColor whiteColor];
    [_placeButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    _placeButton.titleLabel.font = FONTSIZE16;
    [_placeButton setTitle:@"请选择" forState:UIControlStateNormal];
    [_placeButton addTarget:self action:@selector(choosePlace) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *narrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_spread3"]];
    narrow.center = CGPointMake(250, 30);
    [_placeButton addSubview:narrow];
    
    
    UILabel *timeChooseLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 145, 276, 290, 60)];
    timeChooseLabel.backgroundColor = [UIColor whiteColor];
    timeChooseLabel.textAlignment = NSTextAlignmentCenter;
    timeChooseLabel.textColor = [UIColor initWithNormalGray];
    timeChooseLabel.font = FONTSIZE16;
    timeChooseLabel.text = @"至";
    
    _beginButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 145, 276, 135, 60)];
    [_beginButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    _beginButton.titleLabel.font = FONTSIZE16;
    [_beginButton setTitle:@"请选择" forState:UIControlStateNormal];
    [_beginButton addTarget:self action:@selector(choosePlanBegin) forControlEvents:UIControlEventTouchUpInside];
    
    _endButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 + 10, 276, 135, 60)];
    [_endButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    _endButton.titleLabel.font = FONTSIZE16;
    [_endButton setTitle:@"请选择" forState:UIControlStateNormal];
    [_endButton addTarget:self action:@selector(choosePlanEnd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:startPlaceLable];
    [self.view addSubview:tipOne];
    [self.view addSubview:timeLable];
    [self.view addSubview:tipTwo];
    [self.view addSubview:_placeButton];
    [self.view addSubview:timeChooseLabel];
    [self.view addSubview:_beginButton];
    [self.view addSubview:_endButton];
}

-(void)setUpDatePicker{
    _datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT / 3 * 2, SCREENWIDTH, SCREENHEIGHT / 3)];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT / 3 - 40)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.minimumDate = [[NSDate alloc] init];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    toolBar.backgroundColor = [UIColor initWithLightGray];
    UIBarButtonItem *ensureButton = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(ensureDatePicker)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelDatePicker)];
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    ensureButton.tintColor = [UIColor whiteColor];
    toolBar.items = @[flexibleButton,cancelButton,ensureButton];
    _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 7);
    _datePickerIsHide = YES;
    [_datePickerView addSubview:toolBar];
    [_datePickerView addSubview:_datePicker];
    [self.view addSubview:_datePickerView];
}

#pragma mark - operations

-(void)changeStartPlace:(NSNotification*)sender{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showSearchResultView" object:nil];
    WBPositionList *list = [[WBPositionList alloc] init];
    [_placeButton setTitle:[list cityNameWithCityId:[NSNumber numberWithInt:[sender.userInfo[@"startPlaceId"] intValue]]] forState:UIControlStateNormal];
    self.dataDic[@"startPlaceId"] = sender.userInfo[@"startPlaceId"];
}

-(void)choosePlace{
    CreateHelpGroupViewController *createVC = [[CreateHelpGroupViewController alloc] init];
    createVC.fromNextPage = YES;
    UINavigationController *createNavVC = [[UINavigationController alloc] initWithRootViewController:createVC];
    [self presentViewController:createNavVC animated:YES completion:nil];
}

-(void)choosePlanBegin{
    _choosePlanBegin = YES;
    [self showDatePicker];
    
}

-(void)choosePlanEnd{
    _choosePlanBegin = NO;
    [self showDatePicker];
}

-(void)ensureDatePicker{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateformatter stringFromDate:_datePicker.date];
    if (_choosePlanBegin) {
        [_beginButton setTitle:date forState:UIControlStateNormal];
        self.dataDic[@"planBegin"] = date;
    }else{
        [_endButton setTitle:date forState:UIControlStateNormal];
        self.dataDic[@"planEnd"] = date;
    }
    [self cancelDatePicker];
}

-(void)cancelDatePicker{
    [UIView animateWithDuration:0.3 animations:^{
        _datePickerIsHide = YES;
        _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 7);
    }];
}

-(void)showDatePicker{
    if (_datePickerIsHide) {
        [UIView animateWithDuration:0.3 animations:^{
            _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 5);
        }];
    }else{
        [UIView animateWithDuration:0.15 animations:^{
            _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 7);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                _datePickerView.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 6 * 5);
            }];
        }];
    }
    _datePickerIsHide = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
