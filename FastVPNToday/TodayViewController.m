//
//  TodayViewController.m
//  FastVPNToday
//
//  Created by 李言 on 16/4/5.
//  Copyright © 2016年 李言. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "VPNTableViewCell.h"
#import "Masonry.h"

static NSString * const VPNTABLEVIEWCELLINDENTITY = @"vpntableviewcellindentity";

@interface TodayViewController () <NCWidgetProviding,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *vpnTableView;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.vpnTableView];
    [self.vpnTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
}

- (UITableView *)vpnTableView {

    if (!_vpnTableView) {
        _vpnTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _vpnTableView.delegate = self;
        _vpnTableView.dataSource = self;
        [_vpnTableView registerClass:[VPNTableViewCell class] forCellReuseIdentifier:VPNTABLEVIEWCELLINDENTITY];
        _vpnTableView.separatorColor = [UIColor yellowColor];
        _vpnTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
       
    }
    return _vpnTableView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VPNTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VPNTABLEVIEWCELLINDENTITY];
    return cell;
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
