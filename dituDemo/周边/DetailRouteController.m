//
//  DetailRouteController.m
//  HOUNOLVJU
//
//  Created by 蒋永昌 on 9/13/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "DetailRouteController.h"
#import "RouteLineMessageCell.h"
#import "RootShowCell.h"
#import "myHeaderView.h"
#import "RouteFootView.h"

@interface DetailRouteController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView *topView;

@property (nonatomic, strong) myHeaderView *myHeaderView;
@property (nonatomic, strong) myHeaderView *myFooterView;

@property (nonatomic, strong) RouteFootView *footView;

@end

@implementation DetailRouteController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    //block传值
    self.myHeaderView.startLabel.text = self.myPlace;
    
    self.myFooterView.startLabel.text = self.terminal;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.topView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kiOS10_64);
    }];
    
    self.footView = [[RouteFootView alloc]initWithFrame:CGRectMake(0, k_height-50, k_width, 50)];
    self.footView.backgroundColor = RGBCOLOR(79, 173, 232);
    [self.view addSubview:self.footView];
    
    [self getSubViews];
    
    BMKTime *time = self.walkRouteLine.duration;
    float metter = self.walkRouteLine.distance;
    if (metter < 1000) {
        
        self.footView.rootsLabel.text = [NSString stringWithFormat:@"步行%.1f米",metter];
        
    }else{
        
        self.footView.rootsLabel.text = [NSString stringWithFormat:@"步行%.1f公里",metter/1000];
        
    }
    if (time.hours > 0) {
        
        self.footView.timeLabel.text = [NSString stringWithFormat:@"%d小时%d分钟",time.hours,time.minutes];
    }else{
        
        self.footView.timeLabel.text = [NSString stringWithFormat:@"%d分钟",time.minutes];
    }


    // Do any additional setup after loading the view.
}

- (void)getSubViews{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topView.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
    self.tableView.tableHeaderView = self.myHeaderView;
    
    self.tableView.tableFooterView = self.myFooterView;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RouteLineMessageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellID"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"RootShowCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RootShowCell"];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.routeStepArray.count ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row == 0) {
//        
//        RootShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RootShowCell"];
//        if (!cell) {
//            
//            cell = [[NSBundle mainBundle] loadNibNamed:@"RootShowCell" owner:nil options:nil].firstObject;
//
//        }
//        BMKTime *time = self.walkRouteLine.duration;
//        float metter = self.walkRouteLine.distance;
//        if (metter < 1000) {
//            
//            cell.walkLabel.text = [NSString stringWithFormat:@"步行%.1f米",metter];
//            
//        }else{
//            
//            cell.walkLabel.text = [NSString stringWithFormat:@"步行%.1f公里",metter/1000];
//            
//        }
//        if (time.hours > 0) {
//            
//            cell.hourLabel.text = [NSString stringWithFormat:@"%d小时%d分钟",time.hours,time.minutes];
//        }else{
//            
//            cell.hourLabel.text = [NSString stringWithFormat:@"%d分钟",time.minutes];
//        }
//        
//        
//        return cell;
//    }else{
    
        RouteLineMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"RouteLineMessageCell" owner:nil options:nil].firstObject;
            
        }
        cell.backgroundColor = [UIColor colorWithWhite:0.906 alpha:1.000];
        
        cell.routeStepLabel.text = self.routeStepArray[indexPath.row];
        cell.routeStepLabel.numberOfLines = 0;
        if ([cell.routeStepLabel.text containsString:@"步行"]||[cell.routeStepLabel.text containsString:@"走"]) {
            
            cell.tipImageView.image = [UIImage imageNamed:@"walk"];
            
        } else if ([cell.routeStepLabel.text containsString:@"乘坐地铁"]) {
            
            cell.tipImageView.image = [UIImage imageNamed:@"metro"];
            
        } else if ([cell.routeStepLabel.text containsString:@"换乘"]) {
            
            cell.tipImageView.image = [UIImage imageNamed:@"change"];
            
        } else if ([cell.routeStepLabel.text containsString:@"乘坐"]){
            
            cell.tipImageView.image = [UIImage imageNamed:@"justBus"];
            
        }
        
        return cell;

//    }
}


//cell自适应高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        
//        return 50;
//    }else{
    
        NSString *s = self.routeStepArray[indexPath.row];
        DLog(@"s:%@",s);
        //    CGRect rect = [s boundingRectWithSize:CGSizeMake([RouteLineMessageCell backWidth], 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]} context:nil];
        
        CGRect rect = [s boundingRectWithSize:CGSizeMake(k_width - 85, 8000)  options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                   attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f]}//传人的字体字典
                                      context:nil];
        
        //    DLog(@"height:%f",rect.size.height + 40);
        
        return rect.size.height + 40;
 
//    }
    
}





- (UIView *)myHeaderView {
    
    if (!_myHeaderView) {
        
        _myHeaderView = [[myHeaderView alloc] initWithFrame:CGRectMake(0, 0, k_width, 80)];
        _myHeaderView.backgroundColor = [UIColor colorWithRed:0.647 green:1.000 blue:0.601 alpha:1.000];
        _myHeaderView.startImg.image = [UIImage imageNamed:@"qidian"];
        
    }
    return _myHeaderView;
}


- (UIView *)myFooterView {
    
    if (!_myFooterView) {
        _myFooterView = [[myHeaderView alloc] initWithFrame:CGRectMake(0, 0, k_width, 80)];
        _myFooterView.backgroundColor = [UIColor colorWithRed:0.781 green:0.840 blue:1.000 alpha:1.000];
        _myFooterView.startImg.image = [UIImage imageNamed:@"zhongdian"];
    }
    return _myFooterView;
}


- (NSMutableArray *)routeStepArray {
    
    if (!_routeStepArray) {
        _routeStepArray = [NSMutableArray array];
    }
    return _routeStepArray;
}

-(UIView *)topView{
    
    if (!_topView) {
        
        UIView *topView = [UIView new];
        topView.backgroundColor = RGBACOLOR(68, 193, 94, 1);
        
        
        UILabel *_titleLB = [UILabel new];
        _titleLB.font = [UIFont boldSystemFontOfSize:20];
        _titleLB.backgroundColor = [UIColor clearColor];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.text = @"路线详情";
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
