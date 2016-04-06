//
//  AppDelegate.m
//  微球
//
//  Created by 徐亮 on 16/2/24.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "AppDelegate.h"
#import "WBLeftViewController.h"
#import "WBRightViewController.h"
#import "WBMainTabBarController.h"
#import "WBPrivateViewController.h"

#import "MyDownLoadManager.h"
#import "MJExtension.h"
#import "WBUserInfosModel.h"
#import "WBSystemMessage.h"
#import "WBUnlockMessage.h"
#import "WBFollowMessage.h"
#import "WBCommentMessage.h"

#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RCIMClient.h>
#import <RongIMLib/RCUserInfo.h>
#import <AudioToolbox/AudioToolbox.h>
#import <ALBBQuPaiPlugin/ALBBQuPaiPlugin.h>

#define SELECTED_INDEX ((UITabBarController *)self.window.rootViewController.childViewControllers.lastObject).selectedIndex

@interface AppDelegate () <RCIMUserInfoDataSource,RCIMGroupInfoDataSource> {
    BOOL    _tokenOutOfTime;
}

@property (strong,nonatomic) WBLeftViewController *leftViewController;
@property (strong,nonatomic) WBRightViewController *rightViewController;
@property (strong,nonatomic) WBMainTabBarController *mainTabBarController;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setPushMessageWith:(UIApplication *)application];
    
    [self setRongCloud];
    
    _tokenOutOfTime = NO;
    
    if ([WBUserDefaults userId]) {
        [self getRCToken];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getRCToken)
                                                     name:@"getRCToken"
                                                   object:nil];
    }
    
    [self setRootView];
    
    [self showRemotePushMessageWithOptions:launchOptions];
    
    [self setAVOSCloud];
    
    [self shareSDK];
    
    [self qupaiSDK];
    
//    NSArray *array = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation].allKeys;
//    
//    for (NSString *str in array) {
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:str];
//    }
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    return YES;
}

#pragma mark - 设置根窗口

-(void)setRootView{
    self.window= [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor initWithDarkGray];
    self.mainTabBarController = [[WBMainTabBarController alloc] init];
    self.leftViewController = [[WBLeftViewController alloc]init];
    self.rightViewController = [[WBRightViewController alloc]initWithDisplayConversationTypes:@[@(ConversationType_PRIVATE)] collectionConversationType:nil];
    
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:self.mainTabBarController
                                                                    leftMenuViewController:self.leftViewController
                                                                   rightMenuViewController:self.rightViewController];
    sideMenuViewController.contentViewShadowEnabled = YES;
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(4, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.4f;
    sideMenuViewController.contentViewShadowRadius = 5.0f;
    sideMenuViewController.panGestureEnabled = NO;
    sideMenuViewController.contentViewInPortraitOffsetCenterX = 120;
    self.window.rootViewController = sideMenuViewController;
    [self.window makeKeyAndVisible];
}

#pragma mark - 推送处理

-(void)setPushMessageWith:application{
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    

}

/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

/**
 * 推送处理3
 */

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

//系统冻结时捕获消息
-(void)showRemotePushMessageWithOptions:(NSDictionary *)launchOptions{
    // 远程推送的内容
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"%@",remoteNotificationUserInfo);
}

//系统未冻结时捕获消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // userInfo为远程推送的内容
    NSLog(@"%@",userInfo);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    /**
     * 统计推送打开率3
     */
    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];

//    震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
    NSString *type = notification.userInfo[@"rc"][@"cType"];

//    私聊
    if ([type isEqualToString:@"PR"]) {
        if (SELECTED_INDEX == 0) {
            ((RESideMenu *)self.window.rootViewController).isFindPage = YES;
        }else{
            SELECTED_INDEX = 2;
            ((RESideMenu *)self.window.rootViewController).isFindPage = NO;
        }
        [(RESideMenu *)self.window.rootViewController presentRightMenuViewController];
    }

//    群聊
    if ([type isEqualToString:@"GRP"]) {
        SELECTED_INDEX = 2;
    }

}

#pragma mark - 实时通讯相关操作

-(void)setRongCloud{
    [[RCIM sharedRCIM] initWithAppKey:@"z3v5yqkbvtkt0"];
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    
    //设置未注册消息显示方式
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    //开启输入监听，已读回执
    [RCIM sharedRCIM].enableTypingStatus=YES;
    [RCIM sharedRCIM].enableReadReceipt = YES;
    //用户、群组信息源
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    //注册自定义消息
    [[RCIM sharedRCIM] registerMessageType:[WBSystemMessage class]];
    [[RCIM sharedRCIM] registerMessageType:[WBUnlockMessage class]];
    [[RCIM sharedRCIM] registerMessageType:[WBFollowMessage class]];
    [[RCIM sharedRCIM] registerMessageType:[WBCommentMessage class]];
    
 //   [[RCIMClient sharedRCIMClient] clearConversations:@[@(ConversationType_PRIVATE),@(ConversationType_APPSERVICE),@(ConversationType_SYSTEM),@(ConversationType_GROUP)]];
}

-(void)getRCToken{
    if ([WBUserDefaults token] && !_tokenOutOfTime) {
        [self loginRongCloudWithToken:[WBUserDefaults token]];
    } else {
        [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/ry/getToken?userId=%@",[WBUserDefaults userId]] whenSuccess:^(id representData) {
            
            id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
            
            if ([result isKindOfClass:[NSDictionary class]]){
                NSDictionary *token = [NSDictionary dictionaryWithDictionary:result];
                [WBUserDefaults setToken:token[@"token"]];
                _tokenOutOfTime = NO;
                [self loginRongCloudWithToken:token[@"token"]];
            }
        } andFailure:^(NSString *error) {
            NSLog(@"获取token错误");
        }];
    }
}

-(void)loginRongCloudWithToken:(NSString *)token{
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        [self getUnreadMsgNumber];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setGroupPage" object:self];
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        _tokenOutOfTime = YES;
        [self getRCToken];
        NSLog(@"token错误，重新获取");
    }];
}

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion{
    //更新icon badge value
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_APPSERVICE),@(ConversationType_SYSTEM),@(ConversationType_GROUP)]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
    
//    if ([userId isEqualToString:[WBUserDefaults userId]]) {
//        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:[WBUserDefaults nickname] portrait:[WBUserDefaults dir]];
//        return completion(userInfo);
//    }
    
    if ([userId isEqualToString:@"weiqiu"]) {
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:@"weiqiu" name:@"微球小助手" portrait:@"http://microball.oss-cn-hangzhou.aliyuncs.com/845777126469043105.jpg"];
        return completion(userInfo);

    }
    
    if ([userId isEqualToString:@"unlock_notice"]) {
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:@"unlock_notice" name:@"解锁提示" portrait:@"http://microball.oss-cn-hangzhou.aliyuncs.com/icon_unclockmesg%403x.png"];
        return completion(userInfo);
        
    }
    
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/ry/userInfo?userId=%@",userId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]){
            WBUserInfosModel *model = [WBUserInfosModel mj_objectWithKeyValues:result[@"user"]];
            RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:[NSString stringWithFormat:@"%ld",(long)model.userId] name:model.nickname portrait:[model.dir absoluteString]];
            return completion(userInfo);
        }
    } andFailure:^(NSString *error) {
        NSLog(@"用户信息加载失败");
        return;
    }];
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion{
    //更新icon badge value
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_APPSERVICE),@(ConversationType_SYSTEM),@(ConversationType_GROUP)]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
    
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/hg/getHgStr?groupId=%@",groupId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            RCGroup *groupInfo = [[RCGroup alloc] initWithGroupId:groupId groupName:[result[@"helpGroup"] componentsSeparatedByString:@";"].firstObject portraitUri:[result[@"helpGroup"] componentsSeparatedByString:@";"].lastObject];
            return completion(groupInfo);
        }
        
    } andFailure:^(NSString *error) {
        NSLog(@"群组信息加载失败");
    }];
}

-(void)getUnreadMsgNumber{
    NSNumber *unRead = [NSNumber numberWithInt: [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]]];
    NSNumber *unReadGroup = [NSNumber numberWithInt: [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_GROUP)]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unReadTip" object:self userInfo:@{@"unRead":[NSString stringWithFormat:@"%@",unRead]}];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unReadTipGroup" object:self userInfo:@{@"unReadGroup":[NSString stringWithFormat:@"%@",unReadGroup]}];
}

#pragma mark - 短信验证码

-(void)setAVOSCloud{
    [AVOSCloud setApplicationId:@"sIlqbrQJ9bJYs40UYF6MjOUG"
                      clientKey:@"EmA5l51bsV67447EHbr6BYGw"];
}

#pragma nark - 趣拍sdk

-(void)qupaiSDK{
    [[QupaiSDK shared] registerAppWithKey:@"206ab04f6e94b74" secret:@"068e513360e04f1bad5694e507c32a12" space:[WBUserDefaults userId] success:^(NSString *accessToken) {
        NSLog(@"%@",accessToken);
    } failure:^(NSError *error) {
        NSLog(@"初始化失败");
    }];
}

#pragma mark - 分享设置

-(void)shareSDK{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    
    [ShareSDK registerApp:@"10d26d341cf86"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat)
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
                 
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2242391106"
                                           appSecret:@"81f549b888d2c040e648399023fd74df"
                                         redirectUri:@"http://sns.whalecloud.com/sina2/callback"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:                 
                 [appInfo SSDKSetupWeChatByAppId:@"wx09e38bd96e4f93f4"
                                       appSecret:@"19f3d6fd17d39ce771d37cc4ef26a098"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_APPSERVICE),@(ConversationType_SYSTEM),@(ConversationType_GROUP)]];
    application.applicationIconBadgeNumber = unreadMsgCount;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "webarComapny.weiqiu2016" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"weiqiu2016" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"weiqiu2016.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
