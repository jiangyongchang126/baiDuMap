//
//  PoiView.m
//  HOUNOLVJU
//
//  Created by 蒋永昌 on 9/12/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "PoiView.h"

@implementation PoiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addAllSubViews];
    }
    return self;
}

- (void)addAllSubViews {
    
    //自定义气泡内容,添加子控件在popView上
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:13];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width *.6f - 40);
        make.height.mas_equalTo(30);
        
    }];
    
    
    _button = [[UIButton alloc] init];
    _button.backgroundColor = [UIColor redColor];
    _button.layer.masksToBounds = YES;
    _button.layer.cornerRadius = 5.0f;
    [_button setImage:[UIImage imageNamed:@"destination"] forState:(UIControlStateNormal)];
    [self addSubview:_button];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self).offset(-5);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        
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
