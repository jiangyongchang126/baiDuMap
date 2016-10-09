//
//  RouteFootView.m
//  HOUNOLVJU
//
//  Created by 蒋永昌 on 9/24/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "RouteFootView.h"

@implementation RouteFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addsubViews];
    }
    return self;
}

- (void)addsubViews{
    
    UIImageView *addressImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addresshow"]];
    
    [self addSubview:addressImageV];
    [addressImageV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(32, 26));
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    
    
    self.rootsLabel = [UILabel new];
    self.rootsLabel.font = [UIFont systemFontOfSize:15];
    self.rootsLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:self.rootsLabel];
    [self.rootsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(addressImageV.mas_right).offset(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(125);
        make.centerY.equalTo(self);
    }];
    
    
    
    UIImageView *timeImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timeshow"]];
    
    [self addSubview:timeImageV];
    [timeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.left.equalTo(self.rootsLabel.mas_right).offset(10);
        make.centerY.equalTo(self);
    }];

    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    self.timeLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(timeImageV.mas_right).offset(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
        make.centerY.equalTo(self);
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
