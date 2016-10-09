//
//  PopView.m
//  HOUNOLVJU
//
//  Created by 蒋永昌 on 9/9/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "PopView.h"

@implementation PopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addsubViews];
    }
    return self;
}


- (void)addsubViews{
    
    //自定义气泡内容,添加子控件在popView上
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(kWidth - 35);
        make.height.mas_equalTo(25);
        
    }];
    
//    self.XBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _XBtn.backgroundColor = [UIColor redColor];
//    [_XBtn setLayer:3.0];
//    [_XBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [self addSubview:_XBtn];
//    
//    [_XBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self).offset(0);
//        make.right.equalTo(self).offset(-5);
//        make.height.mas_equalTo(25);
//        make.width.mas_equalTo(30);
//    }];
    
    self.line1 = [UIView new];
    _line1.backgroundColor = RGBCOLOR(163, 163, 163);
    [self addSubview:_line1];
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_titleLabel.mas_bottom).offset(2);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.mas_equalTo(1);
    }];
    
    self.addressLabel = [UILabel new];
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.font = [UIFont systemFontOfSize:13];
    _addressLabel.textAlignment = NSTextAlignmentLeft;
    _addressLabel.numberOfLines = 0;
    [self addSubview:_addressLabel];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_line1.mas_bottom).offset(2);
        make.left.equalTo(self).offset(5);
        make.width.mas_equalTo(165);
        make.height.mas_equalTo(50);
    }];
    
    
    self.picImageV = [[UIImageView alloc]init];
    _picImageV.layer.cornerRadius = 5.0;
    _picImageV.layer.masksToBounds = YES;
    [self addSubview:_picImageV];
    
    [_picImageV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_line1.mas_bottom).offset(2);
        make.left.equalTo(_addressLabel.mas_right).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.mas_equalTo(90);
    }];
    
    self.telBtn = [[TouchLable alloc]init];
    self.telBtn.userInteractionEnabled = YES;
    _telBtn.backgroundColor = [UIColor clearColor];
    _telBtn.font = [UIFont systemFontOfSize:13];
    _telBtn.textAlignment = NSTextAlignmentLeft;
    _telBtn.numberOfLines = 0;
    [self addSubview:_telBtn];
    
    [_telBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_addressLabel.mas_bottom).offset(5);
        make.left.equalTo(self).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(165);
    }];
    
//    self.reserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _reserBtn.backgroundColor = RGBCOLOR(255, 102, 1);
//    [_reserBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_reserBtn setTitle:@"立即预定" forState:UIControlStateNormal];
//    [_reserBtn setLayer:3.0];
//    
//    [self addSubview:_reserBtn];
//    [_reserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.top.equalTo(_telBtn.mas_bottom).offset(2);
//        make.height.mas_equalTo(28);
//        make.width.mas_equalTo(80);
//        make.left.equalTo(self).offset(40);
//    }];
    
    self.line2 = [UIView new];
    _line2.backgroundColor = RGBCOLOR(163, 163, 163);
    [self addSubview:_line2];
    
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_picImageV.mas_bottom).offset(4);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.mas_equalTo(1);
    }];
    
    self.neerByBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _neerByBtn.backgroundColor = RGBCOLOR(255, 102, 1);
    [_neerByBtn setTitle:@"立即预定" forState:UIControlStateNormal];
    _neerByBtn.layer.cornerRadius = 3.0;
    _neerByBtn.layer.masksToBounds = YES;

    [self addSubview:_neerByBtn];
    [_neerByBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(120);
        make.top.equalTo(_line2.mas_bottom).offset(5);
    }];
    
    self.wentThereBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _wentThereBtn.backgroundColor = [UIColor redColor];
    [_wentThereBtn setTitle:@"到这里去" forState:UIControlStateNormal];
    _wentThereBtn.layer.cornerRadius = 3.0;
    _wentThereBtn.layer.masksToBounds = YES;
    
    [self addSubview:_wentThereBtn];
    [_wentThereBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(120);
        make.top.equalTo(_line2.mas_bottom).offset(5);
    }];

    
    

}

-(void)setFuncAnnotation:(FuncAnnotation *)funcAnnotation{
    
    self.titleLabel.text = funcAnnotation.title;
    self.addressLabel.text =[NSString stringWithFormat:@"地址：%@", funcAnnotation.addressStr];
    self.telBtn.text = [NSString stringWithFormat:@"电话：%@",funcAnnotation.telStr];
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:funcAnnotation.urlStr]];

    
    CGRect rect = [self.addressLabel.text boundingRectWithSize:CGSizeMake(165, 8000)  options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.5]}//传人的字体字典
                                       context:nil];
    
    [_addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(rect.size.height);
    }];
    
    CGRect rec = [self.telBtn.text boundingRectWithSize:CGSizeMake(165, 8000)  options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.5]}//传人的字体字典
                                                       context:nil];
    
    [_telBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(rec.size.height);
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
