//
//  Helper.m
//  crc
//
//  Created by 全程恺 on 15/1/7.
//  Copyright (c) 2015年 Danfort. All rights reserved.
//

#import "Helper.h"

@implementation Helper

singleton_implementation(Helper)

+ (id)getTargetClass:(Class)className fromObject:(id)obj
{
    UIResponder *next = [obj nextResponder];
    do {
        if ([next isKindOfClass:[className class]]) {
            
            return next;
        }
        next =[next nextResponder];
    }
    while (next != nil);
    
    return nil;
}

+ (id)getFirstResponderInView:(UIView *)view
{
    UIResponder *responder;
    for (UIView *child in view.subviews) {
        
        if ([child isFirstResponder]) {
            
            responder = child;
        }
        else if(!responder) {
            
            //搜索里面的文本框
            responder = [Helper getFirstResponderInView:child];
        }
    }
    
    return responder;
}

+ (id)getTopViewController
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIViewController *appRootViewController = window.rootViewController;
    
    UIViewController *topViewController = appRootViewController;
    while (topViewController.presentedViewController != nil)
    {
        topViewController = topViewController.presentedViewController;
    }
    
    return topViewController;
}

//+ (void)tipMessage:(NSString *)title afterDelay:(NSTimeInterval)delay completion:(void (^)(void))completion
//{
//    for (MBProgressHUD *hud in [MBProgressHUD allHUDsForView:[UIApplication sharedApplication].keyWindow]) {
//        
//        [hud hide:NO];
//    }
//    
//    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    HUD.mode = MBProgressHUDModeText;
//    HUD.removeFromSuperViewOnHide = YES;
//    HUD.detailsLabelText = title;
//    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:14];
//    HUD.userInteractionEnabled = NO;
//    [HUD hide:YES afterDelay:delay];
//    HUD.completionBlock = completion;
//}

//+ (void)tipNoServer:(NSString *)serverName
//{
//    [Helper tipMessage:[NSString stringWithFormat:@"没有%@的接口", serverName] afterDelay:1.5 completion:^{
//        
//    }];
//}

//+ (BOOL)isConnectionAvailable {
//    
//    BOOL isExistenceNetwork = YES;
//    AFNetworkReachabilityManager *reach = [AFNetworkReachabilityManager managerForAddress:@"www.baidu.com"];
//    switch ([reach currentReachabilityStatus]) {
//        case NotReachable:
//            isExistenceNetwork = NO;
//            break;
//        case ReachableViaWiFi:
//            isExistenceNetwork = YES;
//            break;
//        case ReachableViaWWAN:
//            isExistenceNetwork = YES;
//            break;
//    }
//    return isExistenceNetwork;
//}

@end
