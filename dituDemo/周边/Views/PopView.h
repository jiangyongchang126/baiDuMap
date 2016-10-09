//
//  PopView.h
//  HOUNOLVJU
//
//  Created by 蒋永昌 on 9/9/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchLable.h"
#import "FuncAnnotation.h"

@interface PopView : UIView

@property(nonatomic,strong)UILabel     *titleLabel;
//@property(nonatomic,strong)UIButton    *XBtn;
@property(nonatomic,strong)UIView      *line1;
@property(nonatomic,strong)UILabel     *addressLabel;
@property(nonatomic,strong)TouchLable  *telBtn;
@property(nonatomic,strong)UIButton    *reserBtn;
@property(nonatomic,strong)UIImageView *picImageV;
@property(nonatomic,strong)UIView      *line2;
@property(nonatomic,strong)UIButton    *wentThereBtn;
@property(nonatomic,strong)UIButton    *neerByBtn;

@property(nonatomic,strong)FuncAnnotation *funcAnnotation;

@end
