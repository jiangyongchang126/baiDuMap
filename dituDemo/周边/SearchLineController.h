//
//  SearchLineController.h
//  HOUNOLVJU
//
//  Created by 蒋永昌 on 9/10/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchLineController : UIViewController

@property(nonatomic)CLLocationCoordinate2D fromCoordinate;
@property(nonatomic)CLLocationCoordinate2D toCoordinate;

@property(nonatomic,strong)NSString *startStr;
@property(nonatomic,strong)NSString *toWhereStr;

@property(nonatomic,strong)NSString *cityName;

@end
