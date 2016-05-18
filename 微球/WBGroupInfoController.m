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
    UIScrollView    *_scrollView;
    
    UIButton        *_destinationButton;
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
    
    NSDate          *_beginDate;
    NSDate          *_endDate;
    
    NSMutableArray  *_tagArray;
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
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(lastStep)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _tagArray = [NSMutableArray array];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -64, SCREENWIDTH, SCREENHEIGHT + 64)];
    [self.view addSubview:_scrollView];
    
    [self setUpUI];
    
    [self setUpDatePicker];
}

#pragma mark - navigation button

-(void)lastStep{

    self.tabBarController.selectedIndex = _index;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextStep{
    if ([_destinationButton.titleLabel.text isEqualToString:@"请选择"]) {
        [self showHUDText:@"请选择你的目的地点"];
        return;
    }else{
        
    }
    
    if (_tagArray.count == 0) {
        [self showHUDText:@"请选择你的行程标签"];
        return;
    } else {
        NSString *tag = [[NSString alloc] init];
        for (int i = 0; i < _tagArray.count; i ++) {
            if (i == 0) {
                tag = [tag stringByAppendingString:[NSString stringWithFormat:@"%@",_tagArray[i]]];
            } else {
                tag = [tag stringByAppendingString:[NSString stringWithFormat:@"；%@",_tagArray[i]]];
            }
        }
        self.dataDic[@"groupSign"] = tag;
        NSLog(@"%@",self.dataDic[@"groupSign"]);
    }
    
    if (_beginDate && _endDate) {
        NSDate *earlierDate = [_beginDate earlierDate:_endDate];
        if (![earlierDate isEqualToDate:_beginDate]){
            [self showHUDText:@"结束时间不能早于开始时间"];
            return;
        }
    }
    
    WBGroupDetailController *groupDetailVC = [[WBGroupDetailController alloc] init];
    groupDetailVC.dataDic = self.dataDic;
    
    [self.navigationController pushViewController:groupDetailVC animated:YES];
}

#pragma mark - UI

-(void)setUpUI{
    UILabel *locateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH / 2 - 32, 108, 64, 16)];
    locateLabel.textAlignment = NSTextAlignmentCenter;
    locateLabel.textColor = [UIColor initWithNormalGray];
    locateLabel.font = FONTSIZE16;
    locateLabel.text = @"目的地点";
    [_scrollView addSubview:locateLabel];
    
    _destinationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _destinationButton.frame=CGRectMake(SCREENWIDTH / 2 - 145, 108+26, 290, 60);
    _destinationButton.backgroundColor = [UIColor whiteColor];
    [_destinationButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    _destinationButton.titleLabel.font = FONTSIZE16;
    [_destinationButton setTitle:@"请选择" forState:UIControlStateNormal];
    _destinationButton.tag = 150;
    [_destinationButton addTarget:self action:@selector(choosePlace:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_destinationButton];
    
    UIImageView *narrow1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_spread3"]];
    narrow1.center = CGPointMake(250, 30);
    [_destinationButton addSubview:narrow1];
    
    
    
    UILabel *tipChooseLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 32, 108+132, 64, 16)];
    tipChooseLabel.textAlignment = NSTextAlignmentCenter;
    tipChooseLabel.textColor = [UIColor initWithNormalGray];
    tipChooseLabel.font = FONTSIZE16;
    tipChooseLabel.text = @"行程标签";
    
    UIView *tipWraper = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 145, 144 +132, 290, 60)];
    
    NSArray *tipArray = @[@"美食",@"佳景",@"购物",@"艳遇",@"历史",@"科技",@"人文",@"其他"];
    for (int i = 0; i < 8; i ++) {
        UIButton *tipButton = [[UIButton alloc] init];
        tipButton.backgroundColor = [UIColor whiteColor];
        tipButton.titleLabel.font = MAINFONTSIZE;
        [tipButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
        [tipButton setTitle:tipArray[i] forState:UIControlStateNormal];
        tipButton.tag = 0;
        if (i < 4) {
            tipButton.frame = CGRectMake(73.5 * (i % 4), 0, 69.5, 28);
        } else {
            tipButton.frame = CGRectMake(73.5 * (i % 4), 32, 69.5, 28);
        }
        [tipButton addTarget:self action:@selector(chooseTip:) forControlEvents:UIControlEventTouchUpInside];
        [tipWraper addSubview:tipButton];
    }
    
    
    UILabel *startPlaceLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 32, 240+132, 64, 16)];
    startPlaceLable.textAlignment = NSTextAlignmentCenter;
    startPlaceLable.textColor = [UIColor initWithNormalGray];
    startPlaceLable.font = FONTSIZE16;
    startPlaceLable.text = @"始发地点";
    
    UILabel *tipOne = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 + 32, 244+132, 48, 12)];
    tipOne.textAlignment = NSTextAlignmentCenter;
    tipOne.textColor = [UIColor initWithNormalGray];
    tipOne.font = FONTSIZE12;
    tipOne.text = @"（选填）";
    
    UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 32, 372+132, 64, 16)];
    timeLable.textAlignment = NSTextAlignmentCenter;
    timeLable.textColor = [UIColor initWithNormalGray];
    timeLable.font = FONTSIZE16;
    timeLable.text = @"出游时间";
    
    UILabel *tipTwo = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 + 32, 376+132, 48, 12)];
    tipTwo.textAlignment = NSTextAlignmentCenter;
    tipTwo.textColor = [UIColor initWithNormalGray];
    tipTwo.font = FONTSIZE12;
    tipTwo.text = @"（选填）";
    
    _placeButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 145, 276+132, 290, 60)];
    _placeButton.backgroundColor = [UIColor whiteColor];
    [_placeButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    _placeButton.titleLabel.font = FONTSIZE16;
    [_placeButton setTitle:@"请选择" forState:UIControlStateNormal];
    _placeButton.tag = 151;
    [_placeButton addTarget:self action:@selector(choosePlace:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *narrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_spread3"]];
    narrow.center = CGPointMake(250, 30);
    [_placeButton addSubview:narrow];
    
    
    UILabel *timeChooseLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 145, 408+132, 290, 60)];
    timeChooseLabel.backgroundColor = [UIColor whiteColor];
    timeChooseLabel.textAlignment = NSTextAlignmentCenter;
    timeChooseLabel.textColor = [UIColor initWithNormalGray];
    timeChooseLabel.font = FONTSIZE16;
    timeChooseLabel.text = @"至";
    
    _beginButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 145, 408+132, 135, 60)];
    [_beginButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    _beginButton.titleLabel.font = FONTSIZE16;
    [_beginButton setTitle:@"请选择" forState:UIControlStateNormal];
    [_beginButton addTarget:self action:@selector(choosePlanBegin) forControlEvents:UIControlEventTouchUpInside];
    
    _endButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 + 10, 408+132, 135, 60)];
    [_endButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    _endButton.titleLabel.font = FONTSIZE16;
    [_endButton setTitle:@"请选择" forState:UIControlStateNormal];
    [_endButton addTarget:self action:@selector(choosePlanEnd) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:tipChooseLabel];
    [_scrollView addSubview:tipWraper];
    [_scrollView addSubview:startPlaceLable];
    [_scrollView addSubview:tipOne];
    [_scrollView addSubview:timeLable];
    [_scrollView addSubview:tipTwo];
    [_scrollView addSubview:_placeButton];
    [_scrollView addSubview:timeChooseLabel];
    [_scrollView addSubview:_beginButton];
    [_scrollView addSubview:_endButton];
    
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, 408 + 150 + 100);
}

-(void)chooseTip:(UIButton *)sender{
    
    NSString *chooseTip = sender.currentTitle;
    if (sender.tag == 0 && _tagArray.count < 3) {
        sender.backgroundColor = [UIColor initWithGreen];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tagArray addObject:chooseTip];
        sender.tag = 1;
    } else {
        sender.backgroundColor = [UIColor whiteColor];
        [sender setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
        [_tagArray removeObject:chooseTip];
        sender.tag = 0;
    }
    
}

-(void)setUpDatePicker{
    _datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT / 3 * 2, SCREENWIDTH, SCREENHEIGHT / 3)];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT / 3 - 40)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.minimumDate = [[NSDate alloc] init];
    _datePicker.maximumDate = [_datePicker.minimumDate dateByAddingTimeInterval:365 * 24 * 60 * 60 * 2];
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

-(void)choosePlace:(UIButton *)button{
    
    
    
    AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc]initWithPlaceStyle:SinglePlaceChoice];
    addressPickerView.block = ^(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate,BOOL isSelected){
        if (isSelected) {
            if (button.tag ==150) {
                [button setTitle:[NSString stringWithFormat:@"%@",locate] forState:UIControlStateNormal];
                
                
                if ([locate.cityId isEqual:@""]) {
                    self.dataDic[@"destinationId"] = [NSString stringWithFormat:@"%@",locate.countryId];
                }else{
                    self.dataDic[@"destinationId"] = [NSString stringWithFormat:@"%@",locate.cityId];
                }
                
                
                
                
            }else{
                [button setTitle:[NSString stringWithFormat:@"%@",locate] forState:UIControlStateNormal];
               
                
                if ([locate.cityId isEqual:@""]) {
                    self.dataDic[@"startPlaceId"] = [NSString stringWithFormat:@"%@",locate.countryId];
                }else{
                    self.dataDic[@"startPlaceId"] = [NSString stringWithFormat:@"%@",locate.cityId];
                }
                
                
                
                
            }
            
        }
    };
    [addressPickerView show];

    
    
    
    

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
        _beginDate = _datePicker.date;
        [_beginButton setTitle:date forState:UIControlStateNormal];
        self.dataDic[@"planBegin"] = date;
    }else{
        _endDate = _datePicker.date;
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
