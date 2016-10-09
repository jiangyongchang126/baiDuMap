//
//  RootLineCell.h
//  IphoneMapSdkDemo
//
//  Created by 蒋永昌 on 9/13/16.
//  Copyright © 2016 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rootText;
@property (weak, nonatomic) IBOutlet UILabel *nationNum;
@property (weak, nonatomic) IBOutlet UILabel *walkMeter;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageV;


@end
