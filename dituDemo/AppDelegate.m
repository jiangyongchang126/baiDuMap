//
//  AppDelegate.m
//  dituDemo
//
//  Created by 蒋永昌 on 04/10/2016.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MainNavigationController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import "BNCoreServices.h"

@interface AppDelegate ()
{
    BMKMapManager* _mapManager;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"C3tEcbqK1FKOt7PGbMVPKznUEStGHDiI" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [BNCoreServices_Instance initServices:@"C3tEcbqK1FKOt7PGbMVPKznUEStGHDiI"];
    [BNCoreServices_Instance startServicesAsyn:nil fail:nil];
    

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    ViewController *leftVC = [[ViewController alloc]init];
    MainNavigationController *leftNC = [[MainNavigationController alloc]initWithRootViewController:leftVC];
    
    self.window.rootViewController = leftNC;
    [self.window makeKeyAndVisible];
    

    return YES;
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


@end
