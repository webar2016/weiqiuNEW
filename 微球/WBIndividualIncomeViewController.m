//
//  WBIndividualIncomeViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/21.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBIndividualIncomeViewController.h"
#import <StoreKit/StoreKit.h>
#import "MyDownLoadManager.h"

@interface WBIndividualIncomeViewController ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>

{
    UILabel *_moneyLabel;
    UILabel *_scorelabel;
    UILabel *_withdrawMoneylabel;
    
}
@end

@implementation WBIndividualIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 监听购买结果
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    [self createNavi];
    [self createUI];
    [self loadData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)createNavi{
    self.navigationItem.title =@"我的收益";
    //设置标题
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    //设置返回按钮
    UIBarButtonItem *item = (UIBarButtonItem *)self.navigationController.navigationBar.topItem;
    item.title = @"返回";
    self.navigationController.navigationBar.tintColor = [UIColor initWithGreen];
}

-(void)createUI{
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 42+63+37+40+42+15+13+40)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-36, 42, 72, 63)];
    [headImageView setImage:[UIImage imageNamed:@"icon_coin.png"]];
    [self.view addSubview:headImageView];
    
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-150, 42+63+37, 300, 40)];
    _moneyLabel.font = [UIFont systemFontOfSize:36];
    _moneyLabel.textColor = [UIColor initWithGreen];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_moneyLabel];
    
    
    UILabel *scoreHeadLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 42+63+37+40+42, SCREENWIDTH/2, 15)];
    scoreHeadLabel.textAlignment = NSTextAlignmentCenter;
    scoreHeadLabel.text = @"球币";
    scoreHeadLabel.font = [UIFont systemFontOfSize:18];
    scoreHeadLabel.textColor = [UIColor initWithGreen];
    [self.view addSubview:scoreHeadLabel];
    
    UILabel *withdrawHeadLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 42+63+37+40+42, SCREENWIDTH/2, 15)];
    withdrawHeadLabel.textAlignment = NSTextAlignmentCenter;
    withdrawHeadLabel.text = @"可提现";
    withdrawHeadLabel.font = [UIFont systemFontOfSize:18];
    withdrawHeadLabel.textColor = [UIColor initWithGreen];
    [self.view addSubview:withdrawHeadLabel];
    
    _scorelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 42+63+37+40+42+15+13, SCREENWIDTH/2, 15)];
    _scorelabel.textColor = [UIColor initWithNormalGray];
    _scorelabel.font =[UIFont systemFontOfSize:18];
    _scorelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_scorelabel];
    
    _withdrawMoneylabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 42+63+37+40+42+15+13, SCREENWIDTH/2, 15)];
    _withdrawMoneylabel.textColor = [UIColor initWithNormalGray];
    _withdrawMoneylabel.textAlignment = NSTextAlignmentCenter;
    _withdrawMoneylabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_withdrawMoneylabel];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"bg.png"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 42+63+37+40+42+15+13+40, SCREENWIDTH/2, 50);
    [leftButton setImage:[UIImage imageNamed:@"icon_recharge.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"  充值" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"bg.png"] forState:UIControlStateNormal] ;
    rightButton.frame =CGRectMake(SCREENWIDTH/2, 42+63+37+40+42+15+13+40, SCREENWIDTH/2, 50);
    [rightButton setImage:[UIImage imageNamed:@"icon_withdraw.png"] forState:UIControlStateNormal];
    [rightButton setTitle:@"  提现" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    [self.view addSubview:rightButton];
    
    UILabel *tiplabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 42+63+37+40+42+15+13+100, SCREENWIDTH, 20)];
    tiplabel.text = @"微球提醒：球币大于10000时才可以提现哦！";
    tiplabel.textAlignment = NSTextAlignmentCenter;
    tiplabel.textColor = [UIColor initWithGreen];
    tiplabel.font = FONTSIZE12;
    [self.view addSubview: tiplabel];
}


-(void)leftBtnClicked{
    NSLog(@"1");
    if ([SKPaymentQueue canMakePayments]) {
        // 执行下面提到的第5步：
        [self getProductInfo];
    } else {
        NSLog(@"失败，用户禁止应用内付费购买.");
    }

}

-(void)rightBtnClicked{
    NSLog(@"2");



}


-(void)loadData{
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/integral/getUserIntegral?userId=%@",[WBUserDefaults userId]];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *userIntegral = result[@"userIntegral"];
        NSString *integral = [userIntegral objectForKey:@"integral"];
        
        _moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[integral floatValue]/100];
        _scorelabel.text =[NSString stringWithFormat:@"%.0f",[integral floatValue] ];
        _withdrawMoneylabel.text =[NSString stringWithFormat:@"¥%d",(int)[integral floatValue]/100];
        
    } andFailure:^(NSString *error) {
    }];
}



#pragma mark --------应用内支付------------
// 下面的ProductId应该是事先在itunesConnect中添加好的，已存在的付费项目。否则查询会失败。
- (void)getProductInfo {
    NSArray *product = [[NSArray alloc] initWithObjects:@"qiupiao_ID", nil];//qiupiao_ID
    NSSet *set = [NSSet setWithArray:product];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}
// 以上查询的回调函数
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        NSLog(@"无法获取产品信息，购买失败。");
        return;
    }
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"商品信息请求错误:%@", error);
    
    }

- (void)requestDidFinish:(SKRequest *)request {
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
    NSString * receipt = [transaction.transactionReceipt base64EncodedStringWithOptions:0];
    
    NSString *receiptData = [[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] base64EncodedStringWithOptions:0];

    
//    NSString * productIdentifier = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
//    NSString * receipt = [[productIdentifier dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    
    
    NSLog(@"receipt = %@",receipt);
    
    NSLog(@"receiptData = %@",receiptData);
    if ([productIdentifier length] > 0) {

        NSDictionary *dic = @{@"receipt":receipt,@"userId":[WBUserDefaults userId]};
        NSLog(@"dic = %@",dic);
                [MyDownLoadManager postUrl:@"http://192.168.1.135/mbapp/iv/IosVerify" withParameters:dic whenProgress:^(NSProgress *FieldDataBlock) {
                } andSuccess:^(id representData) {
                    NSLog(@"------success-----");
                } andFailure:^(NSString *error) {
                    NSLog(@"------failure-----");
                }];

        // 向自己的服务器验证购买凭证
        
    }
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"%@",transaction.error);
        NSLog(@"购买失败");
    } else {
        NSLog(@"用户取消交易");
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    // 对于已购商品，处理恢复购买的逻辑
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}



@end
