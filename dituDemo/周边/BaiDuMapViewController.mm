//
//  BaiDuMapViewController.m
//  HOUNOLVJU
//
//  Created by 蒋永昌 on 8/31/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "BaiDuMapViewController.h"
#import "SearchLineController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "TouchImageV.h"
#import "FuncAnnotation.h"
#import "FuncAndAnimationView.h"
#import "funcButton.h"

#import "PopView.h"
#import "PoiView.h"
#import "BaiDuModel.h"

@interface BaiDuMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>

@property(nonatomic, strong) UIView *topView;
@property (nonatomic, strong) FuncAndAnimationView *animationView;

@property (nonatomic, strong)TouchImageV *animationBtn;

@property(nonatomic,strong)UIButton *locationBtn;
@property(nonatomic,strong)UIButton *lowerBtn;
@property(nonatomic,strong)PopView  *popView;
@property(nonatomic,strong)PoiView  *poiView;

@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong)BMKLocationService *locService;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) BMKPoiSearch *poiSearch;


//@property(nonatomic,strong)BMKUserLocation *nowLocation;

@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, strong) BaiduModel  *nowModel;


@property(nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic, assign) int media;

@property(nonatomic,strong)NSString *tel;
@property(nonatomic,strong)NSString *startStr;
@property(nonatomic,strong)NSString *toWhereStr;

@property(nonatomic,strong)NSString *cityName;

@property(nonatomic,assign)BOOL xuanz;


@end

@implementation BaiDuMapViewController

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locService.delegate = self;
    self.geoCodeSearch.delegate = self;
    self.poiSearch.delegate = self;

    [self locationNow];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    self.locService.delegate = nil;
    [_locService stopUserLocationService];
    self.geoCodeSearch.delegate = nil;
    self.poiSearch.delegate = nil;



}

- (void)back:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *nItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    self.navigationItem.leftBarButtonItem = nItem;

    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    
    [self.view addSubview:self.topView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kiOS10_64);
    }];
    
    self.locService = [[BMKLocationService alloc]init];
    
     self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, k_width, k_height-64)];
    [self.view addSubview: self.mapView];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.topView.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    //初始化poiSearch 对象
    self.poiSearch = [[BMKPoiSearch alloc] init];

    
    [self layoutSubViews];
    
//    [self locationNow];
    
    
}

#pragma mark----------布局--------------
- (void)layoutSubViews{
    
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.view).offset(-80);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        
    }];
    
    [self.lowerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.view).offset(-120);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);

    }];

    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-60);
        make.width.mas_equalTo(135);
        make.height.mas_equalTo(135);
        
    }];
    
    
    [self.animationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view).offset(-5);
        make.bottom.equalTo(self.view).offset(-55);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    

}

#pragma mark ------------请求数据-------------

- (void)getData{
    
    [KVNProgress showWithStatus:@"正在获取附近酒店..."];
    
    if (![Helper sharedHelper].nowLocation) {
        
        [KVNProgress showErrorWithStatus:@"尚未定位成功"];
    }
    
    BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    
    reverseGeoCodeOption.reverseGeoPoint = [Helper sharedHelper].nowLocation.location.coordinate;
    
    BOOL flag = [self.geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    if (flag) {
        DLog(@"反编码成功");
    }else{
        DLog(@"反编码失败");
    }

    
    NSDictionary *dict = @{@"lng":[NSString stringWithFormat:@"%f",[Helper sharedHelper].nowLocation.location.coordinate.longitude],
                           @"lat":[NSString stringWithFormat:@"%f",[Helper sharedHelper].nowLocation.location.coordinate.latitude]};
    
    [netoworkTool postWithURLString:KNeerByHotel parameters:dict progress:^(double progress) {
        
    } success:^(id  _Nullable responseObject) {
        
        
        if ([responseObject[@"status"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            
            NSMutableArray *dataA = [NSMutableArray array];
            NSArray *array = responseObject[@"data"];
            for (NSDictionary *dic in array) {
                
                BaiduModel *baiduModel = [[BaiduModel alloc]initWithDictionary:dic];
                
                [dataA addObject:baiduModel];
            }
            
            self.dataArray = dataA;
            
            DLog(@"self.dataArray:%@",self.dataArray);
            
            [self.mapView removeAnnotations:self.mapView.annotations];
            
            for (BaiduModel *baiduModel in self.dataArray) {
                
                [self showInMapWithMessageModel:baiduModel];
            }
            
            if (self.dataArray.count > 0) {
                
//                [SVProgressHUD showSuccessWithStatus:@"获取成功！"];
                [KVNProgress showSuccessWithStatus:@"获取成功"];
            }else{
                
                [KVNProgress showErrorWithStatus:@"附近没有酒店！"];
//                [SVProgressHUD showErrorWithStatus:@"附近没有酒店！"];

            }

            
        }else{
            
            [KVNProgress showErrorWithStatus:responseObject[@"msg"]];
//            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];


        }
        
        [KVNProgress dismiss];

        
    } failure:^(NSError * _Nonnull error) {
        
        DLog(@"error:%@",error);
//        [KVNProgress showErrorWithStatus:@"获取周边酒店失败！"];
        [SVProgressHUD showErrorWithStatus:@"获取周边酒店失败！"];
        [KVNProgress dismiss];

        
    } fromClassName:NSStringFromClass([self class])];
    
    
}


#pragma mark ----------大头针---------------

- (void)showInMapWithMessageModel:(BaiduModel *)baiduModel{
    
    CLLocationCoordinate2D coordinate2d;
    coordinate2d.latitude      = [baiduModel.lat floatValue];
    coordinate2d.longitude     = [baiduModel.lng floatValue];

    FuncAnnotation *annotation = [[FuncAnnotation alloc]init];
    annotation.type            = 4;
    annotation.title           = baiduModel.title;
    annotation.addressStr      = baiduModel.address;
    annotation.telStr          = baiduModel.telphone;
    annotation.urlStr          = baiduModel.wap_img;
    annotation.coordinate      = coordinate2d;
    annotation.baiduModel      = baiduModel;
    
    [self.mapView addAnnotation:annotation];
}

//地图上大头针点击事件
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    
    self.location = view.annotation.coordinate;
    if ([view.annotation isKindOfClass:[FuncAnnotation class]]) {
        
        self.nowModel = ((FuncAnnotation *)(view.annotation)).baiduModel;

    }
    self.tel      = ((FuncAnnotation *)(view.annotation)).telStr;
    self.toWhereStr = ((FuncAnnotation *)(view.annotation)).title;
    
    

    
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {

        return [self getDifferentAnnotationView:mapView viewForAnnotation:(FuncAnnotation *)annotation];
    }
    
    return nil;

}

- (BMKAnnotationView *)getDifferentAnnotationView:(BMKMapView *)mapview viewForAnnotation:(FuncAnnotation *)annotation {

    BMKAnnotationView *view = nil;
    
    
    double popViewH = 160;
    double popViewK = 270;
    
    //poi样式的大头针
    self.popView = [[PopView alloc] initWithFrame:CGRectMake(0, 0, popViewK, popViewH)];
    self.popView.backgroundColor = [UIColor whiteColor];
    self.popView.layer.masksToBounds = YES;
    self.popView.layer.cornerRadius = 10.0f;
    self.popView.alpha = 0.9f;
    self.popView.funcAnnotation = annotation;
//    [self.popView.XBtn addTarget:self action:@selector(XBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.popView.telBtn addLabelTarget:self Action:@selector(telBtnAction)];
//    self.tel = annotation.telStr;
//    [self.popView.reserBtn addTarget:self action:@selector(reserBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.popView.neerByBtn addTarget:self action:@selector(neerByBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView.wentThereBtn addTarget:self action:@selector(wentThereBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc] initWithCustomView:self.popView];
    
    
    //poi样式的大头针
    self.poiView = [[PoiView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width *.6f, 40)];
    self.poiView.backgroundColor = [UIColor whiteColor];
    self.poiView.layer.masksToBounds = YES;
    self.poiView.layer.cornerRadius = 10.0f;
    self.poiView.alpha = 0.9f;
    self.poiView.titleLabel.text = annotation.title;
    [self.poiView.button addTarget:self action:@selector(wentThereBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    BMKActionPaopaoView *aView = [[BMKActionPaopaoView alloc] initWithCustomView:self.poiView];
    
    
//    switch (annotation.type) {
//        case 0:
//            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"jiudian"];
//            if (!view) {
//                view = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"jiudian"];
//                view.image = [UIImage imageNamed:@"house"];
//                
//                ((BMKPinAnnotationView *)view).paopaoView = pView;
//                
//            }
//            view.annotation = annotation;
//
//            
//            break;
//            
//        default:
//            break;
//    }
//    
//    
//    return view;
    
    
    
    switch (annotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"xuexiao"];
            if (!view) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"xuexiao"];
                view.image = [UIImage imageNamed:@"xuexiao2"];
                
                ((BMKPinAnnotationView *)view).paopaoView = aView;
                
            }
            view.annotation = annotation;
            
        }
            break;
            
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"chaoshi"];
            if (!view) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"chaoshi"];
                view.image = [UIImage imageNamed:@"chaoshi2"];
                
                ((BMKPinAnnotationView *)view).paopaoView = aView;
                
            }
            view.annotation = annotation;
        }
            break;
            
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"yiyuan"];
            if (!view) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"yiyuan"];
                view.image = [UIImage imageNamed:@"yiyuan2"];
                
                ((BMKPinAnnotationView *)view).paopaoView = aView;
                
            }
            view.annotation = annotation;
        }
            break;
            
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"gongjiao"];
            if (!view) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"gongjiao"];
                view.image = [UIImage imageNamed:@"gongjiao2"];
                
                ((BMKPinAnnotationView *)view).paopaoView = aView;
                
            }
            view.annotation = annotation;
        }
            break;
            
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"jiudian"];
            if (!view) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"jiudian"];
                view.image = [UIImage imageNamed:@"house"];
                
                ((BMKPinAnnotationView *)view).paopaoView = pView;
                
            }
            view.annotation = annotation;
        }
            break;
            
        default:
            break;
    }
    
    return view;


}

- (void)XBtnAction{
    
    DLog(@"点击了X");
}

- (void)telBtnAction{
    
    DLog(@"打电话");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"拨打电话" message:self.tel preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIApplication *app = [UIApplication sharedApplication];
        
        NSString *strUrl = [NSString stringWithFormat:@"tel://%@",self.tel];
        
        NSURL *url = [NSURL URLWithString:strUrl];
        
        [app openURL:url ];

        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)reserBtnAction{
    
    DLog(@"购");
}

- (void)neerByBtnAction:(UIButton *)sender{
    
    DLog(@"点击了立即订购");
    [SVProgressHUD showSuccessWithStatus:@"点击了立即订购"];
//    ApartmentDetailViewController *apartmentDetailVC = [[ApartmentDetailViewController alloc]init];
//    apartmentDetailVC.hotelDetailFromType = HotelDetailFromMapView;
//    apartmentDetailVC.baiduModel = self.nowModel;
//    
//    self.hidesBottomBarWhenPushed = YES;
//
//    [self.navigationController pushViewController:apartmentDetailVC animated:YES];
    
}

- (void)wentThereBtnAction{
    
    DLog(@"点击了到这里去");
    
    SearchLineController *searchLC = [[SearchLineController alloc]init];
    searchLC.fromCoordinate = [Helper sharedHelper].nowLocation.location.coordinate;
    searchLC.toCoordinate   = self.location;
    searchLC.startStr       = self.startStr;
    searchLC.toWhereStr     = self.toWhereStr;
    searchLC.cityName       = self.cityName;
    
    self.hidesBottomBarWhenPushed = YES;
    
//    [self.navigationController presentViewController:searchLC animated:YES completion:^{
//        
//    }];
    [self.navigationController pushViewController:searchLC animated:YES];
}

#pragma mark------------定位按钮---------------

- (void)locationNow{

        [self.locService startUserLocationService];
        //    self.locService.delegate = self;
        
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
            
//            
//        }];

//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"点击右上角图标查看附近酒店！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        
//        [alert addAction:action2];
//        [self presentViewController:alert animated:YES completion:nil];
    


}

- (void)lowerBtnAction{
    
    self.mapView.zoomLevel = 15;

}

- (void)locationBtnAction{
    
    if (![Helper sharedHelper].nowLocation) {

        [self.locService startUserLocationService];
        //    self.locService.delegate = self;
        
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
            
    }
    
//    [_mapView updateLocationData:[Helper sharedHelper].nowLocation];

    [_mapView setCenterCoordinate:[Helper sharedHelper].nowLocation.location.coordinate animated:YES];
    
    
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];

    [_mapView updateLocationData:userLocation];
    [Helper sharedHelper].nowLocation = userLocation;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self getData];
    });
    
//    [self getData];

//    [_locService stopUserLocationService];

    
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


// ========== poi 城市内检索 周边搜索 ===============
- (void)clickToSearchSchoolWithButton:(funcButton *)button {
    
    [_animationView setSubViewsFrameInHome];
    
    // "+" 旋转
    [UIView animateWithDuration:0.15f animations:^{
        self.animationBtn.transform = CGAffineTransformRotate(self.animationBtn.transform,  M_PI/4.0);
    }];
    
    self.xuanz = YES;

    
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc] init];
    option.pageIndex = arc4random()%10;
    option.pageCapacity = 12;
    option.location = self.mapView.centerCoordinate; //设置检索的中心点
//    option.location = CLLocationCoordinate2DMake(39.916, 116.404);
    
    
    option.radius = 2000.0f;
    option.keyword = button.titleLabel.text;
//    option.keyword = @"公交";
    _media = button.funType;
    
    BOOL flag = [_poiSearch poiSearchNearBy:option];
    
    if (flag) {
        NSLog(@"周边检索发送成功");
        
    }else {
        NSLog(@"周边检索发送失败");
        
    }
    
}

- (void)animationBtnAction{
    
    self.animationView.alpha = 1;
    
    if (self.xuanz) {
        
        // "+" 旋转
        [UIView animateWithDuration:0.15f animations:^{
            self.animationBtn.transform = CGAffineTransformRotate(self.animationBtn.transform, - M_PI/4.0);
        }];
        
        self.xuanz = NO;
 
    }else{
        
        // "+" 旋转
        [UIView animateWithDuration:0.15f animations:^{
            self.animationBtn.transform = CGAffineTransformRotate(self.animationBtn.transform,  M_PI/4.0);
        }];
        
        self.xuanz = YES;

    }
    [self.animationView tapToSeeMore];
}

#pragma mark ------ BMKPoiSearchDelegate 代理方法 --------

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    
    
    NSMutableArray *otherAnnotation = [NSMutableArray array];
    
    for (FuncAnnotation *annotation in self.mapView.annotations) {
        
        if (annotation.type != 4) {
            
            [otherAnnotation addObject:annotation];
            
        }
    }
    
    [self.mapView removeAnnotations:otherAnnotation];
    
    if (errorCode == BMK_SEARCH_NO_ERROR) { //返回正常结果
        
        for (int i = 0; i < poiResult.poiInfoList.count; i++) {
            
            
            BMKPoiInfo* poi = [poiResult.poiInfoList objectAtIndex:i];
            
            FuncAnnotation *item = [[FuncAnnotation alloc] init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            item.type = _media;
            
            [self.mapView addAnnotation:item];
            
            self.location = poi.pt;
            
        }
        
    }else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
        
        DLog(@"检索词有歧义");
        [KVNProgress showErrorWithStatus:@"检索词有歧义"];
        
    }else{
        [KVNProgress showErrorWithStatus:@"抱歉,未找到结果"];

        DLog(@"抱歉,未找到结果");
    }
    
}


#pragma mark ------ BMKGeoCodeSearchDelegate 协议方法 ------

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    if (error == 0) {
        
        self.startStr = [NSString stringWithFormat:@"%@",result.address];

        BMKAddressComponent *addressCom = result.addressDetail;
        self.cityName = addressCom.city;
        
    }
    
}


#pragma mark-------------get方法----------------
-(UIView *)topView{
    
    if (!_topView) {
        
        UIView *topView = [UIView new];
        
        //加入右上角信封显示
        UIImage *messageImg = [UIImage imageNamed:@"back"];
        UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [messageBtn setImage:messageImg forState:UIControlStateNormal];
        [messageBtn setImage:messageImg forState:UIControlStateSelected];
        //        [messageBtn addTarget:self action:@selector(backToPop) forControlEvents:UIControlEventTouchUpInside];
        //        messageBtn.backgroundColor = [UIColor cla];
        [topView addSubview:messageBtn];
        
        
        [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(messageImg.size.width + 16, messageImg.size.height + 12));
            make.bottom.equalTo(topView);
            make.left.equalTo(topView).offset(10);
        }];

        UILabel *_titleLB = [UILabel new];
        _titleLB.font = [UIFont boldSystemFontOfSize:20];
        _titleLB.backgroundColor = [UIColor clearColor];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.text = @"附近酒店";
        _titleLB.textColor = [UIColor whiteColor];
        _titleLB.userInteractionEnabled = YES;
        [topView addSubview:_titleLB];
        topView.backgroundColor = RGBACOLOR(68, 193, 94, 1);
        
        
        [topView addSubview:_titleLB];
        
        [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //            make.edges.equalTo(topView);
            make.top.equalTo(topView).offset(20);
            make.bottom.equalTo(topView).offset(0);
            make.left.equalTo(topView).offset(50);
            make.right.equalTo(topView).offset(-50);
        }];
        

        
        _topView = topView;
    }
    
    return _topView;
    
}

-(UIButton *)locationBtn{
    
    if (!_locationBtn) {
        _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationBtn setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
        [self.view addSubview:_locationBtn];
        
        [_locationBtn addTarget:self action:@selector(locationBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _locationBtn;
}

-(UIButton *)lowerBtn{
    
    if (!_lowerBtn) {
        _lowerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lowerBtn setImage:[UIImage imageNamed:@"fangda"] forState:UIControlStateNormal];
        [self.view addSubview:_lowerBtn];
        
        [_lowerBtn addTarget:self action:@selector(lowerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _lowerBtn;

}


//加载动画页面
- (FuncAndAnimationView *)animationView {
    
    if (!_animationView) {
        
        _animationView = [[FuncAndAnimationView alloc] init];
        _animationView.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_animationView];
        _animationView.alpha = 0;
        for (int i = 101; i < 105; i++) {
            
            funcButton *button = (funcButton *)[_animationView viewWithTag:i];
            button.funType = i - 101;
            
            [button addTarget:self action:@selector(clickToSearchSchoolWithButton:) forControlEvents:(UIControlEventTouchUpInside)];
            
            
        }
    }
    
    return _animationView;
}

- (TouchImageV *)animationBtn{
    
    if (!_animationBtn) {
        self.xuanz = YES;
        _animationBtn = [[TouchImageV alloc]initWithImage:[UIImage imageNamed:@"morePic"]];
        _animationBtn.backgroundColor = [UIColor colorWithRed:0.957 green:0.596 blue:0.071 alpha:1.000];
        _animationBtn.userInteractionEnabled = YES;
        
        [self.view addSubview:_animationBtn];
        _animationBtn.layer.cornerRadius = 22.5f;
//        [_animationBtn addTarget:self action:@selector(animationBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_animationBtn addImageVTarget:self Action:@selector(animationBtnAction)];
    }
    
    return _animationBtn;
    
 
}


//创建地理编码对象
- (BMKGeoCodeSearch *)geoCodeSearch {
    
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    }
    return _geoCodeSearch;
}


- (void)backToDismiss{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
