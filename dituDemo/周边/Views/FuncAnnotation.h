//
//  FuncAnnotation.h
//  HOUNOLVJU
//
//  Created by 蒋永昌 on 9/9/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "BaiduModel.h"

@interface FuncAnnotation : BMKPointAnnotation

@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *addressStr;
@property (nonatomic, strong) NSString *telStr;
@property (nonatomic, strong) NSString *urlStr;

@property (nonatomic, assign) int degree;


@property (nonatomic, strong) BaiduModel *baiduModel;

@end
