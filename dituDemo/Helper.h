//
//  Helper.h
//  crc
//
//  Created by 全程恺 on 15/1/7.
//  Copyright (c) 2015年 Danfort. All rights reserved.
//  工具类

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>


@interface Helper : UIControl <UIAlertViewDelegate>

singleton_interface(Helper)

@property(nonatomic,strong)BMKUserLocation *nowLocation;

+ (id)getTargetClass:(Class)className fromObject:(id)obj;
+ (id)getTopViewController;
//+ (id)getRootViewController;
+ (id)getFirstResponderInView:(UIView *)view;
+ (BOOL)isConnectionAvailable;
//+ (void)tipMessage:(NSString *)title afterDelay:(NSTimeInterval)delay completion:(void (^)(void))completion;

+ (void)tipNoServer:(NSString *)serverName;
@end
