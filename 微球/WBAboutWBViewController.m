//
//  WBAboutWBViewController.m
//  微球
//
//  Created by 徐亮 on 16/4/1.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBAboutWBViewController.h"
#import "NSString+string.h"
#import "UILabel+label.h"

@interface WBAboutWBViewController ()
@end

@implementation WBAboutWBViewController

-(instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor initWithBackgroundGray];
        self.navigationItem.title = @"关于微球";
        
        UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64)];
        [self.view addSubview:view];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app"]];
        icon.frame = CGRectMake(SCREENWIDTH / 2 - 30, 20, 60, 60);
        [view addSubview:icon];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 25)];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        title.text = [NSString stringWithFormat:@"微球  %@",version];
        title.textColor = [UIColor initWithNormalGray];
        title.font = [UIFont boldSystemFontOfSize:18];
        title.textAlignment = NSTextAlignmentCenter;
        [view addSubview:title];
        
        UILabel *introduction = [[UILabel alloc] initWithFrame:CGRectZero];
        introduction.text = @"    在这儿，你可以和你的朋友比比谁去过的地方更多，也可以看看别人都去过那些美丽的地方，还可以认识不停行走的可爱的人们。\n    微球的宗旨就是——即使宅在屋里，也能看遍大千世界；如果走出家门，你就是世界的焦点！\n    有任何关于【微球】的意见或建议，请在微球官方微信公众号（微信搜索【微球】或【webarz】即可）中反馈，同时公众号中也有更多福利等着大家！";
        [introduction setLineSpace:10 withContent:introduction.text];
        CGSize size = [introduction.text adjustSizeWithWidth:SCREENWIDTH - 40 andFont:BIGFONTSIZE];
        introduction.frame = (CGRect){{20, 110},{size.width,size.height + 100}};
        introduction.textColor = [UIColor initWithNormalGray];
        introduction.font = MAINFONTSIZE;
        introduction.numberOfLines = 0;
        [view addSubview:introduction];
        
        UILabel *bottom = [[UILabel alloc] initWithFrame:CGRectMake(0, size.height + 200, SCREENWIDTH, 40)];
        bottom.text = @"2014-2016 © 南京走马信息技术有限公司\nAll Rights Reserved.";
        bottom.textColor = [UIColor initWithNormalGray];
        [bottom setLineSpace:5 withContent:bottom.text];
        bottom.font = [UIFont systemFontOfSize:10];
        bottom.numberOfLines = 0;
        bottom.textAlignment = NSTextAlignmentCenter;
        [view addSubview:bottom];
        
        view.contentSize = CGSizeMake(SCREENWIDTH, size.height + 300);
        
    };
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//
//    self.iconImage.center = CGPointMake(SCREENWIDTH / 2, 20);
//    self.titleLabel.textColor = [UIColor initWithNormalGray];
//    self.titleLabel.center = CGPointMake(SCREENWIDTH / 2, 115);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
