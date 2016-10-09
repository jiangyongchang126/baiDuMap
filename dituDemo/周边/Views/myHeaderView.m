//
//  myHeaderView.m
//  HomeFinder
//
//  Created by 冯璐 on 16/3/8.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import "myHeaderView.h"
#import <Masonry.h>

@interface myHeaderView ()


@end

@implementation myHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubViews];
    }
    return self;
}


- (void)addSubViews {
    
    self.layer.cornerRadius = 20.0f;
    self.startImg = [[UIImageView alloc] init];
    [self addSubview:self.startImg];
    [self.startImg mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.top.equalTo(self).offset(20);
        make.width.and.height.mas_equalTo(40);
        
    }];
    
    self.startLabel = [[UILabel alloc] init];
    self.startLabel.backgroundColor = [UIColor lightTextColor];
    [self addSubview:self.startLabel];
    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(60);
        make.bottom.and.right.equalTo(self).offset(-20);
        make.height.equalTo(self.startImg);
        
    }];
}

@end
