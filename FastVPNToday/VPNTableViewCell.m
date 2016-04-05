//
//  VPNTableViewCell.m
//  FastVPN
//
//  Created by 李言 on 16/4/5.
//  Copyright © 2016年 李言. All rights reserved.
//

#import "VPNTableViewCell.h"
#import "LoadingView.h"
#import "Masonry.h"
@interface VPNTableViewCell ()
@property (nonatomic,strong)UISwitch *vpnSwitch;
@property (nonatomic,strong)UILabel  *contentLabel;

@property (nonatomic,strong)LoadingView *loadView;

@end
@implementation VPNTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        _vpnSwitch = [[UISwitch alloc] init];
        
        [_vpnSwitch addTarget:self action:@selector(openVPN:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_vpnSwitch];
        
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_contentLabel];
        
        
        [_vpnSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView);
        }];
        
        
        
        _loadView = [[LoadingView alloc] init];
        
        [self.contentView addSubview:_loadView];
        
        
        __weak VPNTableViewCell *weakself = self;
        _loadView.openSucceedBlock = ^{
        __strong VPNTableViewCell *strongself = weakself;
            strongself.contentLabel.text = @"连接成功";
        
        };
        
        [self.loadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_vpnSwitch.mas_trailing).offset(10);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_loadView.mas_trailing).offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).offset(-10);
            make.centerY.equalTo(self.contentView);
        }];

    }
    
    return self;

}

- (void)openVPN:(UISwitch *)sender{
    
    BOOL isOn = sender.isOn;
    
    if (isOn) {
         _loadView.hidden = NO;
        [_loadView starAnimation];
        
        self.contentLabel.text = @"正在连接...";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_loadView stopAnimation];
        });
        
    } else {
        [_loadView removeALLAnimation];
        
        _loadView.hidden = YES;
        
        self.contentLabel.text = @"";
      
    }



}

@end
