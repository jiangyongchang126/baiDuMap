//
//  NSString+TimerForMatter.m
//  HomeFinder
//
//  Created by 冯璐 on 16/3/9.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import "NSString+TimerForMatter.h"

@implementation NSString (TimerForMatter)


- (float)getSecondsFormatByTimeString {
    
    NSArray *tempArr = [self componentsSeparatedByString:@":"];
    return [[tempArr firstObject] integerValue]* 3600.0 + [tempArr[1] integerValue] * 60.0 + [[tempArr lastObject] integerValue] ;

}

- (NSArray *)getFloatPriceByPriceString {

    NSArray *tempArr = [self componentsSeparatedByString:@"-"];
    
    return tempArr;
}

- (NSString *)getDateStringFromTime:(int)time{
    
//    904365
//    60*60*24   一天86400s
    int day = time/86400;
    
    int hour = (time%86400)/3600;
    
    int minitus = ((time%86400)%3600)/60;
    
    int second = ((time%86400)%3600)%60;
    
    NSString *timeString = [NSString stringWithFormat:@"%@-%@-%@-%@",
                      [self getStringFromtime:day],
                      [self getStringFromtime:hour],
                      [self getStringFromtime:minitus],
                      [self getStringFromtime:second]
                      ];
    
    
    return timeString;
    
}

- (NSString *)getStringFromtime:(int )time{
    
    NSString *timeStr = [NSString stringWithFormat:@"%d",time];
    
    if (timeStr.length == 1) {
        
        return [NSString stringWithFormat:@"0%d",time];
    }
    
    return timeStr;
}

@end
