//
//  NSString+TimerForMatter.h
//  HomeFinder
//
//  Created by 冯璐 on 16/3/9.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimerForMatter)

- (float)getSecondsFormatByTimeString;

- (NSArray *)getFloatPriceByPriceString;

- (NSString *)getDateStringFromTime:(int)time;

@end
