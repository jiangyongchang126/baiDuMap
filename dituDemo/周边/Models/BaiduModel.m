//
//  BaiduModel.m
//  HOUNOLVJU
//
//  Created by 蒋永昌 on 9/9/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "BaiduModel.h"

@implementation BaiduModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    
    if ([key isEqualToString:@"roomInfo"]) {
        self.room = [[room alloc] initWithDictionary:value];
    }
}

@end
