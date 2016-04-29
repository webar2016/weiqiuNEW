//
//  WBReChargeViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/4/8.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBReChargeViewController.h"
#import "MyDownLoadManager.h"
#import "NSString+string.h"

@interface WBReChargeViewController ()<SKProductsRequestDelegate,SKPaymentTransactionObserver> {
    
    UIButton *_rightBtton;
    UIImageView *_selectedImage;
    NSString *_moneyString;

}

@end

@implementation WBReChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    [self createNavi];
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 监听购买结果
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];

}

- (void)viewDidUnload {
    [super viewDidUnload];
    
}

-(void)createNavi{
    self.navigationItem.title =@"充值";
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
    
    _rightBtton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtton.frame = CGRectMake(0, 0, 48, 22) ;
    _rightBtton.backgroundColor = [UIColor initWithGreen];
    _rightBtton.titleLabel.font = MAINFONTSIZE;
    _rightBtton.layer.cornerRadius = 5;
    [_rightBtton setTitle:@"确认" forState:UIControlStateNormal];
    [_rightBtton addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:_rightBtton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createUI{
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipLabel.font = FONTSIZE12;
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = [UIColor initWithLightGray];
    NSString *text = @"如遇充值相关问题，请前往【微球】微信公众号咨询客服，感谢您的支持！";
    CGFloat height = [text adjustSizeWithWidth:SCREENWIDTH - 20 andFont:FONTSIZE12].height;
    tipLabel.frame = CGRectMake(10, 0, SCREENWIDTH - 20, height + 10);
    tipLabel.text = text;
    [self.view addSubview: tipLabel];
    
    _selectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_markcross"]];
    _selectedImage.center = CGPointMake(SCREENWIDTH - 20, 30);
    
    for (int i = 0; i < 5; i ++) {
        UIButton *productBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, i * 61 + height + 10, SCREENWIDTH, 61)];
        productBtn.backgroundColor = [UIColor whiteColor];
        productBtn.tag = i+1;
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_qiupiao2"]];
        icon.center = CGPointMake(20, 30);
        [productBtn addSubview:icon];
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREENWIDTH / 2, 60)];
        numberLabel.text = [NSString stringWithFormat:@"%d个球币",420*(i+1)];
        numberLabel.textColor = [UIColor initWithLightGray];
        numberLabel.font = MAINFONTSIZE;
        [productBtn addSubview:numberLabel];
        
        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        moneyLabel.center = CGPointMake(SCREENWIDTH - 60, 30);
        moneyLabel.layer.borderColor = [[UIColor initWithBackgroundGray] CGColor];
        moneyLabel.layer.borderWidth = 1;
        moneyLabel.layer.masksToBounds = YES;
        moneyLabel.layer.cornerRadius = 3;
        moneyLabel.textColor = [UIColor initWithGreen];
        moneyLabel.text = [NSString stringWithFormat:@"¥%d",6*(i+1)];
        moneyLabel.font = MAINFONTSIZE;
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        [productBtn addSubview:moneyLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREENWIDTH, 1)];
        line.backgroundColor = [UIColor initWithBackgroundGray];
        [productBtn addSubview:line];
        
        [productBtn addTarget:self action:@selector(moneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:productBtn];
    }
}

- (IBAction)moneyBtnClick:(UIButton *)sender {
    
    [_selectedImage removeFromSuperview];
    [sender addSubview:_selectedImage];
    
    switch (sender.tag) {
        case 1:
            _moneyString = @"420个球币";
            break;
        case 2:
            _moneyString = @"840个球币";
            break;
        case 3:
            _moneyString = @"1260个球币";
            break;
        case 4:
            _moneyString = @"1680个球币";
            break;
        case 5:
            _moneyString = @"2100个球币";
            break;
    }
    
}


- (void)confirmBtnClick{
    
    
    NSArray *product;//qiubi_ID
    if ([_moneyString isEqualToString:@"420个球币"]) {
        product = [[NSArray alloc] initWithObjects:@"qiubi_1", nil];//qiubi_ID
        
    }else if ([_moneyString isEqualToString:@"840个球币"]){
        product = [[NSArray alloc] initWithObjects:@"qiubi_2", nil];//qiubi_ID
    
    }else if ([_moneyString isEqualToString:@"1260个球币"]){
        product = [[NSArray alloc] initWithObjects:@"qiubi_3", nil];//qiubi_ID
        
    }else if ([_moneyString isEqualToString:@"1680个球币"]){
        product = [[NSArray alloc] initWithObjects:@"qiubi_4", nil];//qiubi_ID
        
    }else if ([_moneyString isEqualToString:@"2100个球币"]){
        product = [[NSArray alloc] initWithObjects:@"qiubi_5", nil];//qiubi_ID
        
    } else {
        [self showHUDText:@"请选择你要充值的金额"];
        return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self showHUD:@"正在连接" isDim:YES];
    [self getProductInfo:product];
    //[self showHUD:@"正在请求中，请稍后" isDim:YES];
    [_rightBtton setEnabled:NO];
    [_rightBtton setBackgroundColor:[UIColor initWithBackgroundGray]];
}





#pragma mark --------应用内支付------------
// 下面的ProductId应该是事先在itunesConnect中添加好的，已存在的付费项目。否则查询会失败。
- (void)getProductInfo:(NSArray *)product{
    NSSet *set = [NSSet setWithArray:product];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}
// 以上查询的回调函数
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
       // [self showHUDText:@"无法获取购买信息，请稍后重试"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        NSLog(@"无法获取产品信息，购买失败。");
        [self showHUDComplete:@"无法获取产品信息，购买失败。"];
        [_rightBtton setEnabled:YES];
        [_rightBtton setBackgroundColor:[UIColor initWithGreen]];
        return;
    }
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [self hideHUD];
    [self showHUDText:@"连接错误，请稍后重试"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    NSLog(@"商品信息请求错误:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request {
    [self hideHUD];
    NSLog(@"请求结束");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------------ 当用户购买的操作有结果时，就会触发下面的回调函数，相应进行处理即可----------
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
}
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    // Your application should implement these two methods.
    NSString * productIdentifier = transaction.payment.productIdentifier;
  //  NSString * receipt = [transaction.transactionReceipt base64EncodedStringWithOptions:0];
    
    NSString *receiptData = [[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] base64EncodedStringWithOptions:0];
    

    
    //    NSString * productIdentifier = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    //    NSString * receipt = [[productIdentifier dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    
    
   // NSLog(@"receipt = %@",receipt);
   // NSLog(@"receiptData = %@",receiptData);
    if ([productIdentifier length] > 0) {
        
        NSDictionary *dic = @{@"receipt":receiptData,@"userId":[WBUserDefaults userId]};
       // NSLog(@"dic = %@",dic);
        
        [MyDownLoadManager postUrl:[NSString stringWithFormat:@"%@/iv/IosVerify",WEBAR_IP] withParameters:dic whenProgress:^(NSProgress *FieldDataBlock) {
        } andSuccess:^(id representData) {
            [self showHUDText:@"购买成功"];
            [_rightBtton setEnabled:YES];
            [_rightBtton setBackgroundColor:[UIColor initWithGreen]];
           
            self.reloadDataBlock();

            NSLog(@"%@",representData);
        } andFailure:^(NSString *error) {
            [self showHUDText:@"购买失败"];
            [_rightBtton setEnabled:YES];
            [_rightBtton setBackgroundColor:[UIColor initWithGreen]];

            NSLog(@"------failure-----");
        }];
        // 向自己的服务器验证购买凭证
    }else{
    [self showHUDText:@"购买失败"];
    [_rightBtton setEnabled:YES];
    [_rightBtton setBackgroundColor:[UIColor initWithGreen]];

    }
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"%@",transaction.error);
        [self showHUDText:@"充值失败，请稍后重试"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        NSLog(@"购买失败");
              [_rightBtton setEnabled:YES];
        [_rightBtton setBackgroundColor:[UIColor initWithGreen]];

    } else {
        [self showHUDText:@"您已取消充值，感谢您的支持"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        NSLog(@"用户取消交易");
        [_rightBtton setEnabled:YES];
        [_rightBtton setBackgroundColor:[UIColor initWithGreen]];

    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    // 对于已购商品，处理恢复购买的逻辑
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

@end
