//
//  AppDelegate.m
//  Yaosuda
//
//  Created by oracle on 15/11/30.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"
#import "yonghuziliao.h"
#import "ChaxunViewController.h"
#import "PassTrendValueDelegate.h"

@interface AppDelegate ()
@property (retain , nonatomic) id<PassTrendValueDelegate>trendDelegate;
@end

@implementation AppDelegate
/**
 *  注意～   本版本为iOS 9.1   所以极光推送的时候 要在可选设置里  勾选 
 *            content-available 否则 接受不到
 */ 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
//如果是使用 iOS 7 的 Remote Notification 特性那么处理函数需要使用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"收到通知:shangshangshang－－－－%@", userInfo);
    
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    //进入前台清空角标
    if (application.applicationState == UIApplicationStateActive) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    //设置应用内的小红点
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"dian"];
}
//如果 App状态为正在前台或者后台运行，那么此函数将被调用，并且可通过AppDelegate的applicationState是否为UIApplicationStateActive判断程序是否在前台运行。此种情况在此函数中处理：
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"收到通知:xiaxiaxia－－－－%@", userInfo);
    
    [APService handleRemoteNotification:userInfo];
    //进入前台清空角标
    /**
     *  UIApplicationStateActive 为 当前在应用界面
     *  UIApplicationStateInactive 后台进入前台时
     *
     */
    if (application.applicationState == UIApplicationStateActive) {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    //设置应用内的小红点
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"dian"];
    ChaxunViewController*memeda=[[ChaxunViewController alloc] init];
    self.trendDelegate= memeda;
    [self.trendDelegate passTrendValue:nil];

}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"deviceToken-----%@",deviceToken);
    [APService registerDeviceToken:deviceToken];
   
    NSString* alias=[[yonghuziliao getUserInfo] objectForKey:@"id"];
    NSLog(@"别名为：－－－－－－%@",alias);
    [APService setAlias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
     NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    
//    //用于极光单推的方式2 别名： alias
//    [[NSUserDefaults standardUserDefaults] setObject:alias forKey:@"alias"];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//
@end
