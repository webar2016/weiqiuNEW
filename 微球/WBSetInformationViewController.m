//
//  WBSetInformationViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/28.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBSetInformationViewController.h"

@interface WBSetInformationViewController ()
{
    UIImagePickerController *_imagePicker;
    UIView *_datePickerView;
    UIDatePicker    *_datePicker;
    BOOL            _datePickerIsHide;
}
@end

@implementation WBSetInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    [self setUpDatePicker];
}

-(void)createUI{
    
    _headImageView.tag = 100;

    _sexLabel.font = MAINFONTSIZE;
    _sexLabel.textColor = [UIColor initWithLightGray];
    
    
    _sexManBtn.titleLabel.font = MAINFONTSIZE;
    _sexManBtn.layer.masksToBounds = YES;
    _sexManBtn.layer.cornerRadius = 15;
    _sexManBtn.backgroundColor = [UIColor initWithGreen];
    [_sexManBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sexManBtn.tag = 200;
    
    _sexWomenBtn.titleLabel.font = MAINFONTSIZE;
    _sexWomenBtn.layer.masksToBounds = YES;
    _sexWomenBtn.layer.cornerRadius = 15;
    [_sexWomenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_sexWomenBtn setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
    _sexWomenBtn.tag = 201;
    
   
    _birthdayLabel.font = MAINFONTSIZE;
    _birthdayLabel.textColor = [UIColor initWithLightGray];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    _birthdayPickLabel.text = dateTime;
    _birthdayPickLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_birthdayPickLabel addGestureRecognizer:tap];
    _birthdayPickLabel.font = MAINFONTSIZE;
    _birthdayPickLabel.textColor = [UIColor initWithLightGray];
    _birthdayPickLabel.tag = 300;
    
    
    _positionLabel.font = MAINFONTSIZE;
    _positionLabel.textColor = [UIColor initWithLightGray];
    
    _positionBtn.titleLabel.textColor = [UIColor initWithLightGray];
    _positionBtn.titleLabel.font = MAINFONTSIZE;
    
    

    _confirmBtn.tag = 500;
    _confirmBtn.backgroundColor = [UIColor initWithBackgroundGray];
    _confirmBtn.titleLabel.font = MAINFONTSIZE;
    _confirmBtn.layer.cornerRadius = 3;
    _confirmBtn.frame = CGRectMake(0, 0, 200, 43);
    
    

}

-(void)setUpDatePicker{
    _datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0,3*SCREENHEIGHT/4 , SCREENWIDTH, SCREENHEIGHT / 4)];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT / 4 - 40)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor whiteColor];
    
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
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示3
    _datePicker.locale = locale;
}
#pragma mark -----点击事件-----

-(void)tapClick:(UITapGestureRecognizer *)tap{


    [self showDatePicker];

}

- (IBAction)btnClicked:(id)sender {
    if (((UIButton *)sender).tag == 200) {
        _sexManBtn.backgroundColor = [UIColor initWithGreen];
        [_sexManBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sexWomenBtn.backgroundColor = [UIColor whiteColor];
        [_sexWomenBtn setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
    }else if (((UIButton *)sender).tag == 201){
        _sexWomenBtn.backgroundColor = [UIColor initWithGreen];
        [_sexWomenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sexManBtn.backgroundColor = [UIColor whiteColor];
        [_sexManBtn setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];

    
    }else if (((UIButton *)sender).tag == 307){
        [self showDatePicker];
    
    
    }
    
    
    
    else if (((UIButton *)sender).tag ==500){
    
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }
    
    
    
}

#pragma mark ---- datapicker ----
-(void)ensureDatePicker{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateformatter stringFromDate:_datePicker.date];
    ((UILabel *)[self.view viewWithTag:300]).text = date;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
