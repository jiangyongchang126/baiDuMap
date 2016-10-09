//
//  netoworkTool.h
//  houniaolvju
//
//  Created by 王梦飞 on 16/4/28.
//  Copyright © 2016年 www.houno.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//block 作为参数 (返回值为空 带一个类型为泛型的参数)
//typedef void(^resultBlock)(id);

@interface netoworkTool : NSObject

//@property (nonatomic,copy) resultBlock result;
@property(nonatomic,retain)AFHTTPSessionManager *manager;


+ (netoworkTool *)tool ;
//
//
//- (void)get:(NSString *)url parameters:(id)paramete result:(resultBlock)result;
//
//- (void)post:(NSString *)url parameters:(id)parameter result:(resultBlock)result;


#pragma mark --GET 请求--

+ (void)getWithURLString:(NSString * _Nonnull)URLString
              parameters:(nullable id)params
                progress:(nullable void (^)(double progress))Progress
                 success:(nullable void (^)(id _Nullable responseObject))success
                 failure:(nullable void (^)(NSError * _Nonnull error))failure
           fromClassName:(NSString * _Nonnull)className;


#pragma mark -- POST请求 --
+ (void)postWithURLString:(NSString * _Nonnull)URLString
               parameters:(nullable id)params
                 progress:(nullable void (^)(double progress))Progress
                  success:(nullable void (^)(id _Nullable responseObject))success
                  failure:(nullable void (^)(NSError * _Nonnull error))failure
            fromClassName:(NSString * _Nonnull)className;


@end
