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
#import "VPNEntity.h"
#import "Masonry.h"

static NSString * const VPNTABLEVIEWCELLINDENTITY = @"vpntableviewcellindentity";

NSString *const ShareGroupID    = @"group.com.liyan.FastVPN";
NSString *const shareEntitys    = @"shareEntitys";
NSString *const userName        = @"userName";
NSString *const passWord        = @"passWord";
NSString *const ipServer        = @"ipServer";
NSString *const des             = @"des";
@interface TodayViewController () <NCWidgetProviding,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *vpnTableView;
@property (nonatomic,strong)NSMutableArray *entityArray;
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
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:ShareGroupID];
    
    
    NSArray *share =  [shared objectForKey:shareEntitys];
    
    for (NSDictionary *dic in share) {
        VPNEntity *entity = [[VPNEntity alloc] init];
        entity.userName = [dic objectForKey:userName];
        entity.passWord = [dic objectForKey:passWord];
        entity.ipServer = [dic objectForKey:ipServer];
        entity.des      = [dic objectForKey:des];
        [self.entityArray addObject:entity];
    }
    
}

- (NSMutableArray *)entityArray {
    if (!_entityArray) {
        
        _entityArray = [NSMutableArray array];
        
    }
    
    return _entityArray;

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
    
    return self.entityArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VPNTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VPNTABLEVIEWCELLINDENTITY];
    cell.entity = self.entityArray[indexPath.row];
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
