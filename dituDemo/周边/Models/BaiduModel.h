//
//  BaiduModel.h
//  HOUNOLVJU
//
//  Created by 蒋永昌 on 9/9/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "room.h"

@interface BaiduModel : NSObject


@property (nonatomic, copy) NSString *ID;


@property (nonatomic, copy) NSString *title;


@property (nonatomic, copy) NSString *img;


@property (nonatomic, copy) NSString *cate_id;


@property (nonatomic, copy) NSString *city;


@property (nonatomic, copy) NSString *scenic;


@property (nonatomic, copy) NSString *hits;


@property (nonatomic, copy) NSString *address;


@property (nonatomic, copy) NSString *sell;

@property (nonatomic, copy) NSString *lat;

@property (nonatomic, copy) NSString *lng;

@property (nonatomic, copy) NSString *telphone;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *wap_img;

@property (nonatomic, copy) NSString *row_number;


@property (nonatomic, copy) NSString *cate_name;


@property (nonatomic, strong) room *room;


-(instancetype)initWithDictionary:(NSDictionary *)dic;


@end
