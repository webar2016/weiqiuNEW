

#import "AddressChoicePickerView.h"

@interface AddressChoicePickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHegithCons;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (strong, nonatomic) AreaObject *locate;
//区域 数组
@property (strong, nonatomic) NSArray *areaArr;
//国家
@property (strong, nonatomic) NSArray *countryArr;
//省 数组
@property (strong, nonatomic) NSArray *provinceArr;
//城市 数组
@property (strong, nonatomic) NSArray *cityArr;




@end
@implementation AddressChoicePickerView

- (instancetype)initWithPlaceStyle:(PlaceStyle)style{
    
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"AddressChoicePickerView" owner:nil options:nil]firstObject];
        self.frame = [UIScreen mainScreen].bounds;
        self.pickView.delegate = self;
        self.pickView.dataSource = self;
        if (style == 0) {
            self.areaArr = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Localtion.plist" ofType:nil]];
        }else{
            self.areaArr = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Localtion.plist" ofType:nil]];
        }
        
        self.countryArr = self.areaArr[0][@"countrys"];
        self.provinceArr = self.countryArr[0][@"provinces"];
        self.cityArr = self.provinceArr[0][@"citys"];
        self.locate.area =self.areaArr[0][@"areaName"];
        self.locate.country =self.countryArr[0][@"country"];
        self.locate.province =self.provinceArr[0][@"provinceName"];
        self.locate.city =self.cityArr[0][@"cityName"];
   
        [self customView];
    }
    return self;
}

- (void)customView{
    self.contentViewHegithCons.constant = 0;
    [self layoutIfNeeded];
}

#pragma mark - setter && getter

- (AreaObject *)locate{
    if (!_locate) {
        _locate = [[AreaObject alloc]init];
    }
    return _locate;
}

#pragma mark - action

//选择完成
- (IBAction)finishBtnPress:(UIButton *)sender {
    if (self.block) {
        self.block(self,sender,self.locate,YES);
    }
    [self hide];
}

//隐藏
- (IBAction)dissmissBtnPress:(UIButton *)sender {
    if (self.block) {
        self.block(self,sender,self.locate,NO);
    }
    [self hide];
}

#pragma  mark - function

- (void)show{
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = [win.subviews firstObject];
    [topView addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentViewHegithCons.constant = 250;
        [self layoutIfNeeded];
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.contentViewHegithCons.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.areaArr.count;
            break;
        case 1:
            return self.countryArr.count;
            break;
        case 2:
            return self.provinceArr.count;
            break;
        case 3:
            return self.cityArr.count;
        default:
            return 0;
            break;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [[self.areaArr objectAtIndex:row] objectForKey:@"areaName"];
            break;
        case 1:
            return [[self.countryArr objectAtIndex:row] objectForKey:@"country"];
            break;
        case 2:
            return [[self.provinceArr objectAtIndex:row] objectForKey:@"provinceName"];
            break;
        case 3:
            return [[self.cityArr objectAtIndex:row] objectForKey:@"cityName"];
            break;
        default:
            return  @"";
            break;
    }
}
#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 8.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    switch (component) {
        case 0:{
            self.countryArr = self.areaArr[row][@"countrys"];
            [self.pickView reloadComponent:1];
            [self.pickView selectRow:0 inComponent:1 animated:YES];
            
            
            self.provinceArr = [[self.countryArr objectAtIndex:0] objectForKey:@"provinces"];
            [self.pickView reloadComponent:2];
            [self.pickView selectRow:0 inComponent:2 animated:YES];
            
            
            self.cityArr = [[self.provinceArr objectAtIndex:0] objectForKey:@"citys"];
            [self.pickView reloadComponent:3];
            [self.pickView selectRow:0 inComponent:3 animated:YES];
            
            self.locate.area = self.areaArr[row][@"areaName"];
            self.locate.areaId = self.areaArr[row][@"areaId"];
            
            self.locate.country = self.countryArr[0][@"country"];
            self.locate.countryId = self.countryArr[0][@"id"];
            
            if (self.provinceArr.count) {
                self.locate.province = self.provinceArr[0][@"provinceName"];
                self.locate.provinceId = self.provinceArr[0][@"provinceId"];
                
                if (self.areaArr.count) {
                    self.locate.city = self.cityArr[0][@"cityName"];
                    self.locate.cityId = self.cityArr[0][@"cityId"];
                }else{
                    self.locate.city = @"";
                }
            }else{
                self.locate.province = @"";
                self.locate.city = @"";
            }
            NSLog(@"%@",self.locate);
            
            break;
        }
        case 1:
        {
            self.provinceArr = [[self.countryArr objectAtIndex:row] objectForKey:@"provinces"];
            [self.pickView reloadComponent:2];
            [self.pickView selectRow:0 inComponent:2 animated:YES];
            
            
            self.cityArr = [[self.provinceArr objectAtIndex:0] objectForKey:@"citys"];
            [self.pickView reloadComponent:3];
            [self.pickView selectRow:0 inComponent:3 animated:YES];
            
            
            self.locate.country = self.countryArr[row][@"country"];
            self.locate.countryId = self.countryArr[row][@"id"];
            
            if (self.provinceArr.count) {
                self.locate.province = self.provinceArr[0][@"provinceName"];
                self.locate.provinceId = self.provinceArr[0][@"provinceId"];
                if (self.areaArr.count) {
                    self.locate.city = self.cityArr[0][@"cityName"];
                    self.locate.cityId = self.cityArr[0][@"cityId"];
                }else{
                    self.locate.city = @"";
                }
                
            }else{
                self.locate.province = @"";
                self.locate.city = @"";
            }
            
            
            

            break;
        }
        case 2:{
            self.cityArr = [[self.provinceArr objectAtIndex:row] objectForKey:@"citys"];
            [self.pickView reloadComponent:3];
            [self.pickView selectRow:0 inComponent:3 animated:YES];
            
            if (self.provinceArr.count) {
                self.locate.province = self.provinceArr[row][@"provinceName"];
                self.locate.provinceId = self.provinceArr[row][@"provinceId"];
                if (self.areaArr.count) {
                    self.locate.city = self.cityArr[0][@"cityName"];
                    self.locate.cityId = self.cityArr[0][@"cityId"];
                }else{
                    self.locate.city = @"";
                }
                
            }else{
                self.locate.province = @"";
                self.locate.city = @"";
            }
            
            
            


            break;
        }
        case 3:{
            
            if (self.areaArr.count) {
                self.locate.city = self.cityArr[row][@"cityName"];
                self.locate.cityId = self.cityArr[row][@"cityId"];
            }else{
                self.locate.city = @"";
            }


            break;
        }
        default:
            break;
    }
}


@end
