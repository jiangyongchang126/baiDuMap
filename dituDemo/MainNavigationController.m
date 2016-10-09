//
//  MainNavigationController.m
//  HOUNOLVJU
//
//  Created by 蒋永昌 on 8/30/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "MainNavigationController.h"


@interface MainNavigationController ()<UINavigationControllerDelegate>

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;

//    self.navigationBar.barTintColor = [UIColor colorWithRed:68/255.0 green:193/255.0 blue:94/255.0 alpha:1.0];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.alpha = 0.3;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
//    //导航栏背景透明
    UIImage *image = [UIImage new];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:image];
}

//状态条设置为白色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if ([NSStringFromClass([viewController class]) isEqualToString:@"DetailRouteController"]){
        //左上角返回按钮
        UIImage *backImg = [UIImage imageNamed:@"back"];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:backImg forState:UIControlStateNormal];
        [backBtn setTitle:@"" forState:UIControlStateNormal];
        backBtn.size = CGSizeMake(35, 25);
        [backBtn addTarget:(BaseViewController *)viewController action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }
    

    if ([NSStringFromClass([viewController class]) isEqualToString:@"BaiDuMapViewController"]) {
        
        //加入右上角信封显示
        UIImage *messageImg = [UIImage imageNamed:@"freshdata"];
        UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        messageBtn.backgroundColor = [UIColor clearColor];
        
        [messageBtn setImage:messageImg forState:UIControlStateNormal];
        messageBtn.size = CGSizeMake(35, 25);
        
        [messageBtn addTarget:viewController action:@selector(getData) forControlEvents:UIControlEventTouchUpInside];
        
        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:messageBtn];
    }
    

    
//    if ([NSStringFromClass([viewController class]) isEqualToString:@""]){
//        //左上角返回按钮
//        UIImage *backImg = [UIImage imageNamed:@"back"];
//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backBtn setImage:backImg forState:UIControlStateNormal];
//        [backBtn setTitle:@"" forState:UIControlStateNormal];
//        backBtn.size = CGSizeMake(50, 25);
//        [backBtn addTarget:(BaseViewController *)viewController action:@selector(backToDismiss) forControlEvents:UIControlEventTouchUpInside];
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    }
    
    if ([NSStringFromClass([viewController class]) isEqualToString:@"HomeViewController"] ||
        [NSStringFromClass([viewController class]) isEqualToString:@"MineListController"] ||
//        [NSStringFromClass([viewController class]) isEqualToString:@"TelViewController"] ||
        [NSStringFromClass([viewController class]) isEqualToString:@"OrderViewController"]) {
        //加入联系客服图标
        UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [phoneBtn setImage:[UIImage imageNamed:@"leftlineicon"] forState:UIControlStateNormal];
//        [phoneBtn setImage:[UIImage imageNamed:@"icon_home"] forState:UIControlStateSelected];
        [phoneBtn setTitle:@"" forState:UIControlStateNormal];
        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        phoneBtn.size = CGSizeMake(35, 25);
        [phoneBtn addTarget:viewController action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:phoneBtn];
        
    }

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
