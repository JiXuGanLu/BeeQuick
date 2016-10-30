//
//  AppDelegate.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/19.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "AppDelegate.h"
#import "YBZYNewVersionController.h"
#import "YBZYTabBarController.h"

static NSString *YBZYVersionKey = @"YBZYVersionKey";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRootViewController) name:YBZYSwitchRootViewControllerNotification object:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = YBZYCommonBackgroundColor;
    
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    NSString *lastLanchVersion = [[NSUserDefaults standardUserDefaults] objectForKey:YBZYVersionKey];
    
    if ([currentVersion isEqualToString:lastLanchVersion]) {
        YBZYTabBarController *tabBarVC = [[YBZYTabBarController alloc] init];
        self.window.rootViewController = tabBarVC;
    } else {
        YBZYNewVersionController *newVersionVC = [[YBZYNewVersionController alloc] init];
        self.window.rootViewController = newVersionVC;
        
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:YBZYVersionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)switchRootViewController {
    YBZYTabBarController *rootVC = [[YBZYTabBarController alloc] init];
    self.window.rootViewController = rootVC;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:YBZYIsNewLaunchNotification object:nil];
    });
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
