//
//  BaseViewController.m
//  HOUNOLVJU
//
//  Created by 蒋永昌 on 8/30/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property(nonatomic,strong)UIButton *iphoneBtn;

@end

@implementation BaseViewController


- (void)viewWillDisappear:(BOOL)animated {
    
    if (isiOS10) {
        //相当于刷新NavigationBar
        [self.navigationController setNavigationBarHidden:YES
                                                 animated:NO];
        [self.navigationController setNavigationBarHidden:NO
                                                 animated:NO];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    self.from = 1;
    
    // 轻扫
    
    // Do any additional setup after loading the view.
}


//-(void)addiPhoneCall{
//    
//    [self.view addSubview:self.iphoneBtn];
//    [_iphoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.right.equalTo(self.view).offset(-30);
//        make.bottom.equalTo(self.view).offset(-100);
//        make.size.mas_equalTo(CGSizeMake(50, 50));
//    }];
//
//}

- (void) doHandlePanAction:(UIPanGestureRecognizer *)paramSender{
    
    CGPoint point = [paramSender translationInView:self.view];
    NSLog(@"X:%f;Y:%f",point.x,point.y);
    
    paramSender.view.center = CGPointMake(paramSender.view.center.x + point.x, paramSender.view.center.y + point.y);
    
    [paramSender setTranslation:CGPointMake(0, 0) inView:self.view];
    
}


- (void)showTheLeftViewController{
    
    DLog(@"点击了侧边栏！");
}

- (void)backToDismiss{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backToRootController{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark--------刷新--------
- (void)loadNewData
{
    self.page = self.from;
    self.bagPage = self.from;
    [self loadData];
}

- (void)loadMoreData
{
    
    self.page++;
    self.bagPage += 15;
    
    [self loadData];
}

- (void)loadData
{
    
}

- (void)setTotalNum:(NSInteger)totalNum
{
    _totalNum = totalNum;
    
    if (_dataArr.count >= _totalNum) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }
    else
        [self.tableView.mj_footer resetNoMoreData];
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
