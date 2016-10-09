//
//  TouchImageV.h
//  HomeFinder
//
//  Created by 蒋永昌 on 8/31/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchImageV : UIImageView
{
    id _target;
    SEL _action;
}


//-(void)MyTarget:(id)target Action:(SEL)action;
-(void)addImageVTarget:(id)target Action:(SEL)action;

@end
