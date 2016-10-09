//
//  ViewController.m
//  dituDemo
//
//  Created by 蒋永昌 on 04/10/2016.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "ViewController.h"
#import "BaiDuMapViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius =  5.0;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor redColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"地图" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(150, 50));
        make.center.equalTo(self.view);
        
    }];
    
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)btnAction:(UIButton *)sender{
    
    BaiDuMapViewController *baiduMVC = [[BaiDuMapViewController alloc]init];
    
    [self.navigationController pushViewController:baiduMVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
