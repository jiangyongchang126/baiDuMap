//
//  room.h
//  houniaolvju
//
//  Created by 王梦飞 on 16/4/29.
//  Copyright © 2016年 www.houno.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface room : NSObject

@property (nonatomic ,strong) NSString *ID;

@property (nonatomic ,strong) NSString *title;

@property (nonatomic ,strong) NSString *area;

@property (nonatomic ,strong) NSString *bed_num;

@property (nonatomic ,strong) NSString *people_num;

@property (nonatomic ,strong) NSString *roomtype;

@property (nonatomic ,strong) NSString *webprice;

@property (nonatomic ,strong) NSString *marketprice;

@property (nonatomic ,strong) NSString *row_number;

@property (nonatomic ,strong) NSString *start_time;

@property (nonatomic ,strong) NSString *end_time;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
