//
//  FuncAndAnimationView.m
//  HomeFinder
//
//  Created by 冯璐 on 16/2/29.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import "FuncAndAnimationView.h"
#import <Masonry.h>


#define kWidth self.bounds.size.width
#define kHegih self.bounds.size.height


@interface FuncAndAnimationView ()

@property (nonatomic, strong) UIImageView *moreImg;

@property (nonatomic, strong) CABasicAnimation *basicAnimation;


@end

@implementation FuncAndAnimationView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubviews];
        
        _flag = YES;
    
    }
    return self;
}

- (void)addSubviews {
    
    self.moreImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"morePic"]];
    self.moreImg.backgroundColor = [UIColor colorWithRed:0.957 green:0.596 blue:0.071 alpha:1.000];
    self.moreImg.layer.cornerRadius = 22.5f;
    self.moreImg.userInteractionEnabled = YES;

    
    UITapGestureRecognizer *moreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToSeeMore)];
    [self.moreImg addGestureRecognizer:moreTap];
    
    [self addSubview:self.moreImg];
    
    [self.moreImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self).offset(50);
        make.centerY.equalTo(self).offset(50);
        make.width.and.height.mas_equalTo(45);
        
    }];
    
    
    self.schoolBtn = [funcButton buttonWithType:(UIButtonTypeCustom)];
    [self.schoolBtn setImage:[UIImage imageNamed:@"xuexiao"] forState:(UIControlStateNormal)];
    self.schoolBtn.titleLabel.text = @"学校";
    self.schoolBtn.tag = 101;
    self.schoolBtn.backgroundColor = [UIColor colorWithRed:0.957 green:0.596 blue:0.071 alpha:1.000];
    self.schoolBtn.layer.cornerRadius = 17.5;
    self.schoolBtn.layer.masksToBounds = YES;
    
    [self addSubview:self.schoolBtn];
    
    [self.schoolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.and.centerY.equalTo(self.moreImg);
        make.width.and.height.mas_equalTo(35);
        
    }];
    
    
    self.martBtn = [funcButton buttonWithType:(UIButtonTypeCustom)];
    [self.martBtn setImage:[UIImage imageNamed:@"chaoshi"] forState:(UIControlStateNormal)];
    self.martBtn.titleLabel.text = @"超市";
    self.martBtn.tag = 102;
    self.martBtn.backgroundColor = [UIColor colorWithRed:0.957 green:0.596 blue:0.071 alpha:1.000];
    self.martBtn.layer.cornerRadius = 17.5;
    self.martBtn.userInteractionEnabled = YES;

    [self addSubview:self.martBtn];
    
    [self.martBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.and.centerY.equalTo(self.moreImg);
        make.width.and.height.mas_equalTo(35);
        
    }];

    
    self.hospitalBtn = [funcButton buttonWithType:(UIButtonTypeCustom)];
    [self.hospitalBtn setImage:[UIImage imageNamed:@"yiyuan"] forState:(UIControlStateNormal)];
    self.hospitalBtn.titleLabel.text = @"医院";
    self.hospitalBtn.tag = 103;
    self.hospitalBtn.backgroundColor = [UIColor colorWithRed:0.957 green:0.596 blue:0.071 alpha:1.000];
    self.hospitalBtn.layer.cornerRadius = 17.5;
    
    
    [self addSubview:self.hospitalBtn];
    
    [self.hospitalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.and.centerY.equalTo(self.moreImg);
        make.width.and.height.mas_equalTo(35);
        
    }];

    
    self.busBtn = [funcButton buttonWithType:(UIButtonTypeCustom)];
    [self.busBtn setImage:[UIImage imageNamed:@"gongjiao"] forState:(UIControlStateNormal)];
    self.busBtn.titleLabel.text = @"公交";
    self.busBtn.tag = 104;
    self.busBtn.backgroundColor = [UIColor colorWithRed:0.957 green:0.596 blue:0.071 alpha:1.000];
    self.busBtn.layer.cornerRadius = 17.5;
    
    [self addSubview:self.busBtn];
    
    [self.busBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.and.centerY.equalTo(self.moreImg);
        make.width.and.height.mas_equalTo(35);
        
    }];

    
    [self bringSubviewToFront:self.moreImg];
    
}


- (void)tapToSeeMore {
    
    
    if (_flag) {
    
        _flag = NO;
        
        // "+" 旋转
        [UIView animateWithDuration:0.15f animations:^{
            self.moreImg.transform = CGAffineTransformRotate(self.moreImg.transform, - M_PI/4.0);
        }];
 
        
        [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
           
            self.schoolBtn.center = CGPointMake(kWidth * 0.5 + 50, kHegih * 0.5 - 50);
            
        } completion:nil];
        
        [self.schoolBtn.layer addAnimation:self.basicAnimation forKey:@"rotation"];
        

        
        [UIView animateWithDuration:0.15f delay:0.1f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.martBtn.center = CGPointMake(kWidth * 0.5 + 7, kHegih * 0.5 - 27);
            
        } completion:nil];
        
        [self.martBtn.layer addAnimation:self.basicAnimation forKey:@"rotation"];
        
        
        
        [UIView animateWithDuration:0.15f delay:0.2f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.hospitalBtn.center = CGPointMake(kWidth * 0.5 - 28, kHegih * 0.5 + 8);
            
        } completion:nil];
        
        [self.hospitalBtn.layer addAnimation:self.basicAnimation forKey:@"rotation"];
        
        
        
        [UIView animateWithDuration:0.15f delay:0.3f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.busBtn.center = CGPointMake(kWidth * 0.5 - 50 , kHegih * 0.5 + 50);
            
        } completion:nil];
        
        [self.busBtn.layer addAnimation:self.basicAnimation forKey:@"rotation"];
        
    } else {
    
        [self setSubViewsFrameInHome];
    }
}

- (void)setSubViewsFrameInHome {
    
    _flag = YES;
    
    [UIView animateWithDuration:0.15f animations:^{
        self.moreImg.transform = CGAffineTransformRotate(self.moreImg.transform, M_PI/4.0);
    }];
    
    [UIView animateWithDuration:0.15f delay:0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        
        self.schoolBtn.center = self.moreImg.center;
        
    } completion:nil];
    
    [self.schoolBtn.layer addAnimation:self.basicAnimation forKey:@"rotation"];
    
    
    [UIView animateWithDuration:0.15f delay:0.1f options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        
        self.martBtn.center = self.moreImg.center;
        
    } completion:nil];
    
    [self.martBtn.layer addAnimation:self.basicAnimation forKey:@"rotation"];
    
    
    [UIView animateWithDuration:0.15f delay:0.2f options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        
        self.hospitalBtn.center = self.moreImg.center;
        
    } completion:nil];
    
    [self.hospitalBtn.layer addAnimation:self.basicAnimation forKey:@"rotation"];
    
    
    [UIView animateWithDuration:0.15f delay:0.3f options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        
        self.busBtn.center = self.moreImg.center;
        
    } completion:^(BOOL finished) {
        
        self.alpha = 0;
    }];
    
    [self.busBtn.layer addAnimation:self.basicAnimation forKey:@"rotation"];
    
}




- (CABasicAnimation *)basicAnimation {
    
    if (!_basicAnimation) {
        _basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        
        _basicAnimation.fromValue = @0;
        _basicAnimation.toValue = @720;
        _basicAnimation.duration = 0.5f;

    }
    
    return _basicAnimation;
}

@end
