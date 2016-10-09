//
//  TouchLable.m
//  HomeFinder
//
//  Created by 蒋永昌 on 8/31/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "TouchLable.h"

@implementation TouchLable

//-(void)MyTarget:(id)target Action:(SEL)action{
//    
//    _target = target;
//    _action  = action;
//    
//}

-(void)addLabelTarget:(id)target Action:(SEL)action{
    
    _target = target;
    _action  = action;
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if ([_target respondsToSelector:_action]) {
        
//        [_target performSelector:_action withObject:self];
        [_target performSelector:_action withObject:self afterDelay:0.2];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
