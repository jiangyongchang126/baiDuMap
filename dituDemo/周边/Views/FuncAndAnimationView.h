//
//  FuncAndAnimationView.h
//  HomeFinder
//
//  Created by 冯璐 on 16/2/29.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "funcButton.h"

@interface FuncAndAnimationView : UIView

@property (nonatomic, strong) funcButton *schoolBtn;
@property (nonatomic, strong) funcButton *martBtn;
@property (nonatomic, strong) funcButton *busBtn;
@property (nonatomic, strong) funcButton *hospitalBtn;

@property (nonatomic, assign) BOOL flag;


- (void)setSubViewsFrameInHome;
- (void)tapToSeeMore;

@end
