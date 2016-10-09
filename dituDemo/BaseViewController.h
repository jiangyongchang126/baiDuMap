//
//  BaseViewController.h
//  HOUNOLVJU
//
//  Created by 蒋永昌 on 8/30/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (retain, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger bagPage;
@property (assign, nonatomic) NSInteger totalNum;
@property (assign, nonatomic) NSInteger from;

@property (nonatomic,strong)UITableView *tableView;

- (void)loadData;
- (void)loadNewData;
- (void)loadMoreData;
- (void)setTotalNum:(NSInteger)totalNum;

- (void)back;
- (void)backToRootController;

- (void)backToDismiss;

//- (void)addiPhoneCall;


@end
