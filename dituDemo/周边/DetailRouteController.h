//
//  DetailRouteController.h
//  HOUNOLVJU
//
//  Created by 蒋永昌 on 9/13/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface DetailRouteController : BaseViewController

@property (nonatomic, strong) NSMutableArray *routeStepArray;
@property (nonatomic, strong) NSString *terminal;
@property (nonatomic, assign) CLLocationCoordinate2D myLocation;

@property (nonatomic, strong) NSString *myPlace;
@property (nonatomic, strong)BMKWalkingRouteLine *walkRouteLine;


@end
