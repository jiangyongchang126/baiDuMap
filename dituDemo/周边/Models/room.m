//
//  room.m
//  houniaolvju
//
//  Created by 王梦飞 on 16/4/29.
//  Copyright © 2016年 www.houno.com. All rights reserved.
//

#import "room.h"

@implementation room

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        NSLog(@"%@",value);
        self.ID = value;
    }
    
}
@end
