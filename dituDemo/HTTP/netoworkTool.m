//
//  netoworkTool.m
//  houniaolvju
//
//  Created by 王梦飞 on 16/4/28.
//  Copyright © 2016年 www.houno.com. All rights reserved.
//

#import "netoworkTool.h"

//block 作为参数 (返回值为空 带一个类型为泛型的参数)

typedef void(^resultBlock)(id data);

@implementation netoworkTool

+ (netoworkTool *)tool {
    static netoworkTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc] init];
        if (!tool.manager) {
            tool.manager = [AFHTTPSessionManager manager];
            tool.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //            tool.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/html", @"multipart/form-data", @"application/x-www-form-urlencoded",nil];
    
    //            tool.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //            [tool.manager.requestSerializer setValue:@"artemisToken_isvalid" forHTTPHeaderField:@"artemisToken"];
    
    //            tool.manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    //            tool.manager.securityPolicy.allowInvalidCertificates = YES;
            
            tool.manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/plain"];
            tool.manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
            tool.manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
            tool.manager.securityPolicy.validatesDomainName = NO;//是否验证域名
            
        }
    });
    return tool;
}

//- (void)get:(NSString *)url parameters:(id)paramete result:(resultBlock)result{
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/plain"];
//    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
//    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
//    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
//
//    [manager GET:url parameters:paramete progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
////        if ([responseObject[@"status"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
//        
//            result(responseObject);
//
////        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//    
//}
//
//- (void)post:(NSString *)url parameters:(id)parameter result:(resultBlock)result{
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    [manager POST:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        
//            result(responseObject);
//            
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//    
//}

+ (void)postWithURLString:(NSString * _Nonnull)URLString
               parameters:(nullable id)params
                 progress:(nullable void (^)(double progress))Progress
                  success:(nullable void (^)(id _Nullable responseObject))success
                  failure:(nullable void (^)(NSError * _Nonnull error))failure
            fromClassName:(NSString * _Nonnull)className{
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //    NSError *error = nil;
    //    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    //    NSString *str = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];  // 传参

    NSError *error = nil;
    NSData *jsondata = nil;
    NSString *str = nil;
    if (params) {
        
        jsondata = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
        str = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];  // 传参
        
    }
    
    
    [[netoworkTool tool].manager POST:URLString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        CGFloat progress = (float)uploadProgress.fractionCompleted;
        
        Progress(progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if (![netoworkTool tool].manager.operationQueue.operationCount) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        NSLog(@"%@请求链接：%@\n传参：%@\n", className, URLString, str);
        
        NSError *error = nil;
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        DLog(@"responseDict:%@",responseDict);
        
        success(responseDict);
            
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (![netoworkTool tool].manager.operationQueue.operationCount) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        
        NSLog(@"%@，请求链接：%@\n传参：%@", [error localizedDescription], URLString, str);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}


//+ (void)getWithURLString:(NSString *)URLString
//              parameters:(nullable id)params
//                progress:(void (^)(double progress))Progress
//                 success:(void (^)(id responseObject))success
//                 failure:(void (^)(NSError *error))failure
//           fromClassName:(NSString *)className{
+ (void)getWithURLString:(NSString *)URLString
              parameters:(nullable id)params
                progress:(nullable void (^)(double progress))Progress
                 success:(nullable void (^)(id _Nullable responseObject))success
                 failure:(nullable void (^)(NSError * _Nonnull error))failure
           fromClassName:(NSString * _Nonnull)className{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSError *error = nil;
    NSData *jsondata = nil;
    NSString *str = nil;
    if (params) {
        
        jsondata = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
        str = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];  // 传参
        
    }
    //    [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    //    str = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];  // 传参
    
    [[netoworkTool tool].manager GET:URLString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        CGFloat progress = (float)downloadProgress.fractionCompleted;
        
        Progress(progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![netoworkTool tool].manager.operationQueue.operationCount) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        NSLog(@"%@请求链接：%@\n传参：%@\n", className, URLString, str);
        
        NSError *error = nil;
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        DLog(@"responseDict:%@",responseDict);
        
        success(responseDict);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (![netoworkTool tool].manager.operationQueue.operationCount) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        
        NSLog(@"%@，请求链接：%@\n传参：%@", [error localizedDescription], URLString, str);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}


@end
