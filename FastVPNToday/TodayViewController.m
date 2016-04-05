//
//  TodayViewController.m
//  FastVPNToday
//
//  Created by 李言 on 16/4/5.
//  Copyright © 2016年 李言. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "Masonry.h"
@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@1000);
    }];
    
    UISwitch *switchView = [[UISwitch alloc] init];
    
    [backView addSubview:switchView];
    
    [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView).offset(10);
        make.leading.equalTo(backView).offset(10);
    }];
    


    
    
    
//    [si mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view).offset(20);
//        make.top.equalTo(self.view).offset(10);
//        make.bottom.equalTo(self.view).offset(-10);
//    }];
//    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{

    return UIEdgeInsetsZero;

}

@end
