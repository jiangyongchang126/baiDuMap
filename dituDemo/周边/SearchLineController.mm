//
//  SearchLineController.m
//  HOUNOLVJU
//
//  Created by 蒋永昌 on 9/10/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "SearchLineController.h"
#import "DetailRouteController.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>


#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"

#import "FuncAnnotation.h"
#import "UIImage+Rotate.h"
#import "NSString+TimerForMatter.h"
#import "RootLineCell.h"

#define KFrame CGRectMake(0, 0, 240, 40)
#define KCenter CGPointMake(self.view.frame.size.width * .5f, self.hiddenView.frame.size.height * .5f)


@interface SearchLineController ()<BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate,BMKMapViewDelegate,BMKRouteSearchDelegate,BMKLocationServiceDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *rightView;
@property(nonatomic,strong)UIView *hiddenView;

@property (nonatomic, strong) BMKMapView        *baiduMapView;
@property (nonatomic, strong) BNRoutePlanNode   *startNode;
@property (nonatomic, strong) BNRoutePlanNode   *endNode;
@property (nonatomic, strong) BMKRouteSearch    *routeSearcher;

@property (nonatomic, strong) BMKWalkingRouteLine *walkRouteLine;

@property (nonatomic, strong) BMKLocationService *locService;

//@property (nonatomic, strong) UISegmentedControl *lineSegment;
@property (nonatomic, strong) UIButton *routeButton;
@property (nonatomic, strong) UIButton *naviButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) NSMutableArray *walkStepArray;
@property (nonatomic, assign) int allTime;
@property (nonatomic, assign) int allDistance;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation SearchLineController

//视图即将出现 -- 设置代理
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.baiduMapView.delegate = self;
    self.routeSearcher.delegate = self;
//    self.geoCodeSearch.delegate = self;
    
    self.locService.delegate = self;

    [self locationNow];
    
}

//视图即将消失 -- 撤销所有代理
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.baiduMapView.delegate = nil;
    self.routeSearcher.delegate = nil;
//    self.geoCodeSearch.delegate = nil;
    
    self.locService.delegate = nil;
    [_locService stopUserLocationService];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.routeSearcher = [[BMKRouteSearch alloc] init];
    
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *nItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    self.navigationItem.leftBarButtonItem = nItem;
    

    
    self.baiduMapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, k_width, k_height)];
    [self.view addSubview: self.baiduMapView];
    
//    [self.baiduMapView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.view).offset(0);
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//    }];
    
    [self.baiduMapView addSubview:self.topView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kiOS10_64);
    }];
    
    [self.baiduMapView addSubview:self.rightView];
    
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_topView.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-15);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(20+44*3);
    }];

    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [_baiduMapView addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(k_height);
        make.left.right.equalTo(self.view).offset(0);
    }];
    
    self.tableView.alpha = 1;

    
    self.hiddenView = [[UIView alloc] init];
    _hiddenView.backgroundColor = [UIColor whiteColor];
    _hiddenView.frame.size = CGSizeMake(k_width, 50);
    [self.baiduMapView addSubview:_hiddenView];
    
    
    [self.hiddenView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        
    }];
    
    
    [self.baiduMapView setCenterCoordinate:self.toCoordinate];
    [self.baiduMapView setZoomLevel:13];
    
    //当前位置标注和地图的比例
    BMKCoordinateRegion region;
    region.center.latitude = self.toCoordinate.latitude;
    region.center.longitude = self.toCoordinate.longitude;
    
    BMKCoordinateSpan spans;
    spans.latitudeDelta = 0.6;
    spans.longitudeDelta = 0.6;
    region.span = spans;
    
    self.baiduMapView.region = region;


//    UIButton *btn = [self.rightView viewWithTag:1001];
    [self performSelector:@selector(carBtnAction) withObject:nil afterDelay:0.5];
    
//    [self startNavi];
    
    
    self.locService = [[BMKLocationService alloc]init];
    

}

- (void)locationNow{
    
    [self.locService startUserLocationService];
    //    self.locService.delegate = self;
    
    _baiduMapView.showsUserLocation = NO;//先关闭显示的定位图层
    _baiduMapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _baiduMapView.showsUserLocation = YES;//显示定位图层
    

}

- (void)back:(UIBarButtonItem *)sender{
 
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark --------------btn点击事件-------------

- (void)removeSubViews{
    
    for(UIView *view in [self.hiddenView subviews])
    {
        [view removeFromSuperview];
    }
}


- (void)carBtnAction{
    
//    [WSProgressHUD showWithStatus:@"正在规划路线..."];
    [KVNProgress showWithStatus:@"正在规划开车路线..."];
//    [SVProgressHUD showWithStatus:@"正在规划开车路线..."];
    [self removeSubViews];
    
    [self.hiddenView addSubview:self.naviButton];
    self.hiddenView.alpha = 1;

    ((UIButton *)[self.rightView viewWithTag:1001]).selected = YES;

    ((UIButton *)[self.rightView viewWithTag:1002]).selected = NO;
    ((UIButton *)[self.rightView viewWithTag:1003]).selected = NO;

    
    BMKPlanNode *startPlanNode = [[BMKPlanNode alloc] init];
    startPlanNode.pt = self.fromCoordinate;
    BMKPlanNode *endPlanNode = [[BMKPlanNode alloc] init];
    endPlanNode.pt = self.toCoordinate;
    
    // 1> 开启算路
    BMKDrivingRoutePlanOption *drivingRoutePlanOption = [[BMKDrivingRoutePlanOption alloc] init];
    drivingRoutePlanOption.from = startPlanNode;
    drivingRoutePlanOption.to = endPlanNode;
    drivingRoutePlanOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;
    
    BOOL flag = [self.routeSearcher drivingSearch:drivingRoutePlanOption];
    if (flag) {
//        [KVNProgress showSuccessWithStatus:@"car检索路线成功"];
        DLog(@"检索路线成功");
    }else {
//        [KVNProgress showErrorWithStatus:@"car检索路线失败"];

        DLog(@"检索路线失败");
        [SVProgressHUD showErrorWithStatus:@"检索路线失败"];

        [KVNProgress dismiss];

    }
    

}

- (void)busBtnAction{
//    [WSProgressHUD showWithStatus:@"正在规划路线..."];
    [KVNProgress showWithStatus:@"正在规划公交路线..."];

    [self removeSubViews];

    [self.hiddenView addSubview:self.moreButton];
    self.hiddenView.alpha = 1;

    ((UIButton *)[self.rightView viewWithTag:1002]).selected = YES;
    ((UIButton *)[self.rightView viewWithTag:1001]).selected = NO;
    ((UIButton *)[self.rightView viewWithTag:1003]).selected = NO;

//    
    BMKPlanNode *startPlanNode = [[BMKPlanNode alloc] init];
    startPlanNode.pt = self.fromCoordinate;
//    startPlanNode.pt = CLLocationCoordinate2DMake(39.89, 116.32);
    BMKPlanNode *endPlanNode = [[BMKPlanNode alloc] init];
    endPlanNode.pt = self.toCoordinate;
//    endPlanNode.pt = CLLocationCoordinate2DMake(39.87, 116.38);

    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc] init];
    transitRouteSearchOption.city = self.cityName;
    transitRouteSearchOption.from = startPlanNode;
    transitRouteSearchOption.to = endPlanNode;
    
//    BMKPlanNode* start = [[BMKPlanNode alloc]init];
//    start.name = @"北京西站";
//    BMKPlanNode* end = [[BMKPlanNode alloc]init];
//    end.name = @"北京南站";
//    
//    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
//    transitRouteSearchOption.city= @"北京市";
//    transitRouteSearchOption.from = start;
//    transitRouteSearchOption.to = end;
    
    BOOL flag = [self.routeSearcher transitSearch:transitRouteSearchOption];
    if (flag) {
        DLog(@"检索路线成功");
    }else {
        DLog(@"检索路线失败");
        [SVProgressHUD showErrorWithStatus:@"检索路线失败"];
        [KVNProgress dismiss];
    }
    


}

- (void)walkBtnAction{
//    [WSProgressHUD showWithStatus:@"正在规划路线..."];
    [KVNProgress showWithStatus:@"正在规划步行路线..."];

    [self removeSubViews];

    [self.hiddenView addSubview:self.routeButton];

    self.hiddenView.alpha = 1;

    ((UIButton *)[self.rightView viewWithTag:1003]).selected = YES;
    ((UIButton *)[self.rightView viewWithTag:1001]).selected = NO;
    ((UIButton *)[self.rightView viewWithTag:1002]).selected = NO;

    
    BMKPlanNode *startPlanNode = [[BMKPlanNode alloc] init];
    startPlanNode.pt = self.fromCoordinate;
    BMKPlanNode *endPlanNode = [[BMKPlanNode alloc] init];
    endPlanNode.pt = self.toCoordinate;

    BMKWalkingRoutePlanOption *walkPlanOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkPlanOption.from = startPlanNode;
    walkPlanOption.to   = endPlanNode;
    
    BOOL flag = [self.routeSearcher walkingSearch:walkPlanOption];
    
    if (flag) {
        
        DLog(@"检索路线成功");
    }else {
        
        DLog(@"检索路线失败");
        [SVProgressHUD showErrorWithStatus:@"检索路线失败"];

        [KVNProgress dismiss];

    }

}



#pragma mark ---------- BMKRouteSearchDelegate 协议方法 ----------

// 打车路线规划代理方法
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_baiduMapView.annotations];
    [_baiduMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_baiduMapView.overlays];
    [_baiduMapView removeOverlays:array];
    
//    BMK_SEARCH_NO_ERROR = 0,///<检索结果正常返回
//    BMK_SEARCH_AMBIGUOUS_KEYWORD,///<检索词有岐义
//    BMK_SEARCH_AMBIGUOUS_ROURE_ADDR,///<检索地址有岐义
//    BMK_SEARCH_NOT_SUPPORT_BUS,///<该城市不支持公交搜索
//    BMK_SEARCH_NOT_SUPPORT_BUS_2CITY,///<不支持跨城市公交
//    BMK_SEARCH_RESULT_NOT_FOUND,///<没有找到检索结果
//    BMK_SEARCH_ST_EN_TOO_NEAR,///<起终点太近
//    BMK_SEARCH_KEY_ERROR,///<key错误
//    BMK_SEARCH_NETWOKR_ERROR,///网络连接错误
//    BMK_SEARCH_NETWOKR_TIMEOUT,///网络连接超时
//    BMK_SEARCH_PERMISSION_UNFINISHED,///还未完成鉴权，请在鉴权通过后重试
//    BMK_SEARCH_INDOOR_ID_ERROR,///室内图ID错误
//    BMK_SEARCH_FLOOR_ERROR,///室内图检索楼层错误
    
//    switch (error) {
//        case BMK_SEARCH_AMBIGUOUS_KEYWORD:
//            [KVNProgress showErrorWithStatus:@"检索词有岐义"];
//            break;
//        case BMK_SEARCH_AMBIGUOUS_ROURE_ADDR:
//            [KVNProgress showErrorWithStatus:@"检索地址有岐义"];
//            break;
//            
//        case BMK_SEARCH_NOT_SUPPORT_BUS:
//            [KVNProgress showErrorWithStatus:@"该城市不支持公交搜索"];
//            break;
//            
//        case BMK_SEARCH_NOT_SUPPORT_BUS_2CITY:
//            [KVNProgress showErrorWithStatus:@"不支持跨城市公交"];
//            break;
//            
//        case BMK_SEARCH_ST_EN_TOO_NEAR:
//            [KVNProgress showErrorWithStatus:@"起终点太近"];
//            break;
//            
//        case BMK_SEARCH_KEY_ERROR:
//            [KVNProgress showErrorWithStatus:@"key错误"];
//            break;
//            
//        case BMK_SEARCH_NETWOKR_ERROR:
//            [KVNProgress showErrorWithStatus:@"网络连接错误"];
//            break;
//            
//        case BMK_SEARCH_NETWOKR_TIMEOUT:
//            [KVNProgress showErrorWithStatus:@"网络连接超时"];
//            break;
//            
//        case BMK_SEARCH_RESULT_NOT_FOUND:
//            [KVNProgress showErrorWithStatus:@"没有找到检索结果！"];
//            [KVNProgress dismiss];
//            break;
//      
//        default:
//            break;
//    }

    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                FuncAnnotation* item = [[FuncAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = self.startStr;
                item.type = 0;
                [_baiduMapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                FuncAnnotation* item = [[FuncAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = self.toWhereStr;
                item.type = 1;
                [_baiduMapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            FuncAnnotation* item = [[FuncAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_baiduMapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
//        // 添加途经点
//        if (plan.wayPoints) {
//            for (BMKPlanNode* tempNode in plan.wayPoints) {
//                FuncAnnotation* item = [[FuncAnnotation alloc]init];
//                item = [[FuncAnnotation alloc]init];
//                item.coordinate = tempNode.pt;
//                item.type = 5;
//                item.title = tempNode.name;
//                [_baiduMapView addAnnotation:item];
//            }
//        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_baiduMapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
        
//        [WSProgressHUD dismiss];
//        [SVProgressHUD dismiss];
        [KVNProgress dismiss];

    }else{
        
        [KVNProgress dismiss];
        [SVProgressHUD showErrorWithStatus:@"路线规划失败"];
        
    }

}


// 步行
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_baiduMapView.annotations];
    [_baiduMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_baiduMapView.overlays];
    [_baiduMapView removeOverlays:array];
    


    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        self.walkRouteLine = plan;
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                FuncAnnotation* item = [[FuncAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = self.startStr;
                item.type = 0;
                [_baiduMapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                FuncAnnotation* item = [[FuncAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = self.toWhereStr;
                item.type = 1;
                [_baiduMapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            FuncAnnotation* item = [[FuncAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_baiduMapView addAnnotation:item];
            
            
            [self.walkStepArray addObject:transitStep.instruction];
            self.allTime = transitStep.duration;
            self.allDistance = transitStep.distance;

            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_baiduMapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
        
//        [WSProgressHUD dismiss];
//        [SVProgressHUD dismiss];
        [KVNProgress dismiss];

    }else{
        
        [KVNProgress dismiss];
        [SVProgressHUD showErrorWithStatus:@"路线规划失败"];

    }
}

// 公交

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    
    NSArray* array = [NSArray arrayWithArray:_baiduMapView.annotations];
    [_baiduMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_baiduMapView.overlays];
    [_baiduMapView removeOverlays:array];
    

    if (error == BMK_SEARCH_NO_ERROR) {
//        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (BMKTransitRouteLine *plan in result.routes) {
            
            [arr addObject:plan];
            
        }
        
        NSArray *sortArray = [self getConvenientLineBySortArray:arr];
        
        self.dataArray = [NSMutableArray arrayWithArray:sortArray];
        [self.tableView reloadData];
        
        BMKTransitRouteLine *plan = sortArray.firstObject; // 定义一个 时间最短的 换乘路线
        

        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                FuncAnnotation* item = [[FuncAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = self.startStr;
                item.type = 0;
                [_baiduMapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                FuncAnnotation* item = [[FuncAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = self.toWhereStr;
                item.type = 1;
                [_baiduMapView addAnnotation:item]; // 添加起点标注
            }
            FuncAnnotation* item = [[FuncAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_baiduMapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_baiduMapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
        
//        [WSProgressHUD dismiss];
//        [SVProgressHUD dismiss];
        [KVNProgress dismiss];

    }else if (error == BMK_SEARCH_ST_EN_TOO_NEAR) {
        
        [SVProgressHUD showErrorWithStatus:@"起点终点太近,跳转到步行路线..."];
        [KVNProgress dismiss];
        [self walkBtnAction];
        
    }else if (error == BMK_SEARCH_RESULT_NOT_FOUND){
        
        [KVNProgress dismiss];
        [SVProgressHUD showErrorWithStatus:@"没有找到检索结果"];
        
    }

}

//路线排序,获取用时最短路线
- (NSArray *)getConvenientLineBySortArray:(NSMutableArray *)array {
    
    [array sortUsingComparator:^NSComparisonResult(BMKTransitRouteLine *obj1, BMKTransitRouteLine * obj2) {
        
        float f1 = [self getSecondsWithRoutePlanDuration:obj1.duration];
        float f2 = [self getSecondsWithRoutePlanDuration:obj2.duration];
        
        if (f1 > f2) {
            return NSOrderedDescending;
        }else if (f1 < f2){
            return NSOrderedAscending;
        }else {
            return NSOrderedSame;
        }
    }];
    return array;
    
}

// 通过duration 获取到具体的数值
- (float) getSecondsWithRoutePlanDuration:(BMKTime *) duration {
    
    BMKTime *time = duration;
    
    NSString *timeStr = [NSString stringWithFormat:@"%d:%d:%d",time.hours,time.minutes,time.seconds];
    
    return [timeStr getSecondsFormatByTimeString];
    
}


#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[FuncAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(FuncAnnotation*)annotation];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    return nil;
}



- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(FuncAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"icon_qidian"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"icon_qidian"];
                view.image = [UIImage imageNamed:@"icon_qidian"];
//                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = YES;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"icon_zhongdian"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"icon_zhongdian"];
                view.image = [UIImage imageNamed:@"icon_zhongdian"];
//                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = YES;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"icon_bus"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"icon_bus"];
                view.image = [UIImage imageNamed:@"icon_bus"];
                view.canShowCallout = YES;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"icon_rail"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"icon_rail"];
                view.image = [UIImage imageNamed:@"icon_rail"];
                view.canShowCallout = YES;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"zhongjian"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"zhongjian"];
                view.canShowCallout = YES;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageNamed:@"zhongjian"];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
//        case 5:
//        {
//            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
//            if (view == nil) {
//                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
//                view.canShowCallout = TRUE;
//            } else {
//                [view setNeedsDisplay];
//            }
//            
//            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
//            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
//            view.annotation = routeAnnotation;
//        }
//            break;
        default:
            break;
    }
    
    return view;
}


//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_baiduMapView setVisibleMapRect:rect];
    _baiduMapView.zoomLevel = _baiduMapView.zoomLevel - 0.3;
}


#pragma mark ----------定位-----------------
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
    [_baiduMapView updateLocationData:userLocation];
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
    
    [_baiduMapView updateLocationData:userLocation];
    [Helper sharedHelper].nowLocation = userLocation;
    
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


#pragma mark-----------发起导航-------------
//发起导航
- (void)startNavi
{
    //节点数组
    NSMutableArray *nodesArray = [[NSMutableArray alloc]    initWithCapacity:2];
    
    //起点
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = self.fromCoordinate.longitude;
    startNode.pos.y = self.fromCoordinate.latitude;
    
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:startNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = self.toCoordinate.longitude;
    endNode.pos.y = self.toCoordinate.latitude;
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    //发起路径规划
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}
// 算路成功后，在回调函数中发起导航，如下：
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    DLog(@"算路成功");
    
    //路径规划成功，开始导航
    [BNCoreServices_UI showPage:BNaviUI_NormalNavi delegate:self extParams:nil];
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary*)userInfo
{
    switch ([error code]%10000)
    {
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONFAILED:
            DLog(@"暂时无法获取您的位置,请稍后重试");
            break;
        case BNAVI_ROUTEPLAN_ERROR_ROUTEPLANFAILED:
            DLog(@"无法发起导航");
            break;
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONSERVICECLOSED:
            DLog(@"定位服务未开启,请到系统设置中打开定位服务。");
            break;
        case BNAVI_ROUTEPLAN_ERROR_NODESTOONEAR:
            DLog(@"起终点距离起终点太近");
            break;
        default:
            DLog(@"算路失败");
            break;
    }
}

//算路取消回调
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    DLog(@"算路取消");
}

#pragma mark - 安静退出导航

- (void)exitNaviUI
{
    [BNCoreServices_UI exitPage:EN_BNavi_ExitTopVC animated:YES extraInfo:nil];
}

#pragma mark - BNNaviUIManagerDelegate

//退出导航页面回调
- (void)onExitPage:(BNaviUIType)pageType  extraInfo:(NSDictionary*)extraInfo
{
    if (pageType == BNaviUI_NormalNavi)
    {
        DLog(@"退出导航");
    }
    else if (pageType == BNaviUI_Declaration)
    {
        DLog(@"退出导航声明页面");
    }
}


- (CLLocationCoordinate2D)getWithCoordinate:(CLLocationCoordinate2D )coordinate{
    
    CLLocationCoordinate2D coor = coordinate;//原始坐标
    //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
    NSDictionary* testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_COMMON);
    //转换GPS坐标至百度坐标(加密后的坐标)
    testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);
    NSLog(@"x=%@,y=%@",[testdic objectForKey:@"x"],[testdic objectForKey:@"y"]);
    //解密加密后的坐标字典
    CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);//转换后的百度坐标

    return baiduCoor;
}

#pragma mark------------路线详情跳转-------------
- (void)didClickToDetailRoute{
    
    DLog(@"点击了路线详情！");
    
    DetailRouteController *detailRC = [[DetailRouteController alloc]init];
    detailRC.myPlace = self.startStr;
    detailRC.terminal = self.toWhereStr;
    detailRC.myLocation = self.fromCoordinate;
    detailRC.routeStepArray = self.walkStepArray;
    detailRC.walkRouteLine  = self.walkRouteLine;
    [self.navigationController pushViewController:detailRC animated:YES];
}


- (void)didClickToMore{
    
    self.hiddenView.alpha = 0;
    //
//
    [self setTableViewFrame:NO];

//    [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
//        
//        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.equalTo(self.view).offset(200);
//        }];
//    } completion:^(BOOL finished) {
//        
//        
//        //        self.hiddenView.alpha = 1;
//    }];
    

}

#pragma mark-----------tableView------------


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RootLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RootLineCell"];
    
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"RootLineCell" owner:nil options:nil].firstObject;
    }
    
    cell.lineImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_line_%ld",indexPath.row%4]];
    cell.rootText.backgroundColor = RGBCOLOR(243, 244, 247);
    BMKTransitRouteLine *plan = self.dataArray[indexPath.row];
    
    BMKTime *time = plan.duration;
    
    
    NSInteger size = [plan.steps count];
    NSMutableString *a = [NSMutableString string];
    float metter = 0;
    int staNum = 0;
    for (int i = 0; i < size; i++) {
        BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
        int type = transitStep.stepType;
        
        if (type != 2) {
            
            BMKVehicleInfo *vehInfo = transitStep.vehicleInfo;
            [a appendString:[NSString stringWithFormat:@" > %@",vehInfo.title]];
            staNum += vehInfo.passStationNum;
        }else if(type == 2){
            
            metter += transitStep.distance;
        }
    }
    
    NSString *root = [a substringFromIndex:2];
    
    cell.rootText.text = root;
    cell.nationNum.text = [NSString stringWithFormat:@"%d站",staNum];
    if (metter < 1000) {
        
        cell.walkMeter.text = [NSString stringWithFormat:@"步行%.1f米",metter];
        
    }else{
        
        cell.walkMeter.text = [NSString stringWithFormat:@"步行%.1f公里",metter/1000];
        
    }
    if (time.hours > 0) {
        
        cell.time.text = [NSString stringWithFormat:@"%d小时%d分钟",time.hours,time.minutes];
    }else{
        
        cell.time.text = [NSString stringWithFormat:@"%d分钟",time.minutes];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.backgroundColor = [UIColor clearColor];
//    [btn setTitle:@"隐 藏" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"show_detalBtn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnYinCang) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}
- (void)btnYinCang{
    
    [self setTableViewFrame:YES];
    self.hiddenView.alpha = 1;

    
//    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
//        
//        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.equalTo(self.view).offset(self.view.frame.size.height);
//        }];
//    } completion:^(BOOL finished) {
//        
//        self.hiddenView.alpha = 1;
//    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray* array = [NSArray arrayWithArray:_baiduMapView.annotations];
    [_baiduMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_baiduMapView.overlays];
    [_baiduMapView removeOverlays:array];
    
    
    BMKTransitRouteLine *plan = self.dataArray[indexPath.row];
    // 计算路线方案中的路段数目
    NSInteger size = [plan.steps count];
    int planPointCounts = 0;
    for (int i = 0; i < size; i++) {
        BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
        if(i==0){
            FuncAnnotation* item = [[FuncAnnotation alloc]init];
            item.coordinate = plan.starting.location;
            item.title = self.startStr;
            item.type = 0;
            [_baiduMapView addAnnotation:item]; // 添加起点标注
            
        }else if(i==size-1){
            FuncAnnotation* item = [[FuncAnnotation alloc]init];
            item.coordinate = plan.terminal.location;
            item.title = self.toWhereStr;
            item.type = 1;
            [_baiduMapView addAnnotation:item]; // 添加起点标注
        }
        FuncAnnotation* item = [[FuncAnnotation alloc]init];
        item.coordinate = transitStep.entrace.location;
        item.title = transitStep.instruction;
        item.type = 3;
        [_baiduMapView addAnnotation:item];
        
        //轨迹点总数累计
        planPointCounts += transitStep.pointsCount;
    }
    
    //轨迹点
    BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
    int i = 0;
    for (int j = 0; j < size; j++) {
        BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
        int k=0;
        for(k=0;k<transitStep.pointsCount;k++) {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }
        
    }
    // 通过points构建BMKPolyline
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [_baiduMapView addOverlay:polyLine]; // 添加路线overlay
    delete []temppoints;
    [self mapViewFitPolyLine:polyLine];
    
//    [UIView animateWithDuration:1.0 animations:^{
//        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.equalTo(self.view).offset(k_height);
//        }];
//    } completion:^(BOOL finished) {
//        self.hiddenView.alpha = 1;
//    }];
    
    [self setTableViewFrame:YES];
    self.hiddenView.alpha = 1;
}

- (void)setTableViewFrame:(BOOL)isDown{
    
    if (isDown == NO) {
       
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
//            
//            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.view).offset(k_height);
//                
//            }];
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:<#(NSTimeInterval)#> animations:<#^(void)animations#> completion:<#^(BOOL finished)completion#>]
//        }];
        
        
        [UIView animateWithDuration:1.5 animations:^{
       
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(k_height);

            }];
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:1.5 delay:0.5 options:UIViewAnimationCurveEaseIn animations:^{
                
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view).offset(200);
                }];
            } completion:^(BOOL finished) {
                
            }];
        }];
    }else{
        
        
        [UIView animateWithDuration:1.5 animations:^{
            
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(200-20);
            }];

        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:1.5 delay:0.5 options:UIViewAnimationCurveEaseIn animations:^{
                
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view).offset(k_height);
                }];
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

#pragma mark-------------get方法----------------
-(UIView *)topView{
    
    if (!_topView) {
        
        UIView *topView = [UIView new];
        topView.backgroundColor = RGBACOLOR(68, 193, 94, 1);
        
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
        _titleLB.text = @"规划路线";
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
        

        
//        UIView *btnView = [[UIView alloc]init];
        
        _topView = topView;
    }
    
    return _topView;
    
}

-(UIView *)rightView{
    
    if (!_rightView) {
       
        _rightView = [UIView new];
        
        _rightView.backgroundColor = [UIColor clearColor];

        
        CGFloat btnW = 44;
        CGFloat btnH = 44;
        CGFloat jiangeH = 10;
        
        UIButton *carBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        carBtn.backgroundColor = [UIColor clearColor];
        carBtn.tag = 1001;
        [carBtn setTitle:@"" forState:UIControlStateNormal];
        [carBtn setImage:[UIImage imageNamed:@"map_bt_taxi_nor"] forState:UIControlStateNormal];
        [carBtn setImage:[UIImage imageNamed:@"map_bt_taxi_sel"] forState:UIControlStateSelected];

//        [carBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateSelected];
        [_rightView addSubview:carBtn];
        [carBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_rightView).offset(0);
            make.left.equalTo(_rightView).offset(0);
            make.size.mas_equalTo(CGSizeMake(btnW, btnH));
        }];
        
        [carBtn addTarget:self action:@selector(carBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *busBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        busBtn.backgroundColor = [UIColor clearColor];
        busBtn.tag = 1002;
        [busBtn setTitle:@"" forState:UIControlStateNormal];
//        [busBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateSelected];
        [busBtn setImage:[UIImage imageNamed:@"map_bt_bus_nor"] forState:UIControlStateNormal];
        [busBtn setImage:[UIImage imageNamed:@"map_bt_bus_sel"] forState:UIControlStateSelected];
        [_rightView addSubview:busBtn];
        [busBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(carBtn.mas_bottom).offset(jiangeH);
            make.left.equalTo(_rightView).offset(0);
            make.size.mas_equalTo(CGSizeMake(btnW, btnH));
        }];
        
        [busBtn addTarget:self action:@selector(busBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *walkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        walkBtn.tag = 1003;
        walkBtn.backgroundColor = [UIColor clearColor];
        [walkBtn setTitle:@"" forState:UIControlStateNormal];
        [walkBtn setImage:[UIImage imageNamed:@"map_bt_walk_nor"] forState:UIControlStateNormal];
        [walkBtn setImage:[UIImage imageNamed:@"map_bt_walk_sel"] forState:UIControlStateSelected];
//        [walkBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateSelected];
        
        
        [_rightView addSubview:walkBtn];
        [walkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(busBtn.mas_bottom).offset(jiangeH);
            make.left.equalTo(_rightView).offset(0);
            make.size.mas_equalTo(CGSizeMake(btnW, btnH));
        }];
        
        [walkBtn addTarget:self action:@selector(walkBtnAction) forControlEvents:UIControlEventTouchUpInside];
        

        
    }
    
    return _rightView;
}

- (void)backToPop{
    

}

//- (UISegmentedControl *)lineSegment {
//    
//    if (!_lineSegment) {
//        NSArray *array = @[@"公交",@"驾车",@"步行"];
//        _lineSegment = [[UISegmentedControl alloc] initWithItems:array];
//        _lineSegment.apportionsSegmentWidthsByContent = YES;
//        [self.view addSubview:_lineSegment];
//        [_lineSegment addTarget:self action:@selector(didClickToChangeSearchWay:) forControlEvents:(UIControlEventValueChanged)];
//        
//    }
//    return _lineSegment;
//}

//起点
- (BNRoutePlanNode *)startNode {
    if (!_startNode) {
        _startNode = [[BNRoutePlanNode alloc] init];
        _startNode.pos = [[BNPosition alloc] init];
        _startNode.pos.x = self.fromCoordinate.longitude;
        _startNode.pos.y = self.fromCoordinate.latitude;
        
        _startNode.pos.eType = BNCoordinate_BaiduMapSDK;
        
    }
    return _startNode;
}

//终点
- (BNRoutePlanNode *)endNode {
    
    //地理编码 -- 获取经纬度
    
    if (!_endNode) {
        _endNode = [[BNRoutePlanNode alloc] init];
        _endNode.pos = [[BNPosition alloc] init];
        _startNode.pos.x = self.toCoordinate.longitude;
        _startNode.pos.y = self.toCoordinate.latitude;
        
        _endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    }
    return _endNode;
    
}


- (UIButton *)routeButton {
    
    if (!_routeButton) {
        _routeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _routeButton.backgroundColor = RGBCOLOR(0, 145, 255);
        _routeButton.frame = KFrame;
        _routeButton.center = KCenter;
//        CGPointMake(self.view.frame.size.width * .5, self.hiddenView.frame.size.height * .5 + 25);
        
        [_routeButton setTitle:@"路线详情" forState:(UIControlStateNormal)];
        [_routeButton setTintColor:[UIColor whiteColor]];
        _routeButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _routeButton.layer.cornerRadius = 4.0f;
        [_routeButton addTarget:self action:@selector(didClickToDetailRoute) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _routeButton;
}

- (UIButton *)moreButton {
    
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _moreButton.backgroundColor = RGBCOLOR(0, 145, 255);
        _moreButton.frame = KFrame;
        _moreButton.center = KCenter;
        
        [_moreButton setTitle:@"更多选择" forState:(UIControlStateNormal)];
        [_moreButton setTintColor:[UIColor whiteColor]];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _moreButton.layer.cornerRadius = 4.0f;
        [_moreButton addTarget:self action:@selector(didClickToMore) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _moreButton;
}

- (UIButton *)naviButton {
    
    if (!_naviButton) {
        _naviButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _naviButton.backgroundColor = RGBCOLOR(0, 145, 255);
        _naviButton.frame = KFrame;
        _naviButton.center = KCenter;
        
        [_naviButton setTitle:@"开始导航" forState:(UIControlStateNormal)];
        [_naviButton setTintColor:[UIColor whiteColor]];
        _naviButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _naviButton.layer.cornerRadius = 4.0f;
        [_naviButton addTarget:self action:@selector(startNavi) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _naviButton;
    
}

//// 创建 routeSearcher 对象
//- (BMKRouteSearch *)routeSearcher {
//    
//    if (!_routeSearcher) {
//        _routeSearcher = [[BMKRouteSearch alloc] init];
//    }
//    return _routeSearcher;
//}

- (void)dealloc {
    if (_routeSearcher != nil) {
        _routeSearcher = nil;
    }
    if (_baiduMapView) {
        _baiduMapView = nil;
    }
}

- (NSMutableArray *)walkStepArray {
    
    if (!_walkStepArray) {
        _walkStepArray = [NSMutableArray array];
    }
    return _walkStepArray;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
