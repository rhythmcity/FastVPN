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
#import <NetworkExtension/NetworkExtension.h>
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
        
        [[NSNotificationCenter defaultCenter] addObserverForName:NEVPNStatusDidChangeNotification object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            if ([NEVPNManager sharedManager].connection.status == NEVPNStatusConnecting) {
                self.loadView.hidden = NO;
                self.contentLabel.text = @"正在连接...";
                [self.loadView starAnimation];
            }else  if ([NEVPNManager sharedManager].connection.status == NEVPNStatusConnected) {
            

                
                [self.loadView stopAnimation];
                self.contentLabel.text = @"连接成功";
            } else if ([NEVPNManager sharedManager].connection.status == NEVPNStatusDisconnected) {
            
                [_loadView removeALLAnimation];
                _loadView.hidden = YES;
                self.contentLabel.text = @"";
            }
            
            [self.vpnSwitch setOn:([NEVPNManager sharedManager].connection.status == NEVPNStatusConnected) animated:YES];
        }];
        
  

    }
    
    return self;

}



- (void)setEntity:(VPNEntity *)entity {
    _entity = entity;
    [self loadVpnConfig];;
}


- (void)loadVpnConfig {

    
    NEVPNManager *vpnManager = [NEVPNManager sharedManager];
    
    [vpnManager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
        }
        
        NEVPNProtocolIPSec *protocol = [[NEVPNProtocolIPSec alloc] init];
        protocol.username = self.entity.userName;
        protocol.passwordReference =   [self.entity.passWord dataUsingEncoding:NSUTF8StringEncoding];
        protocol.serverAddress = self.entity.ipServer;

        protocol.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
//        protocol.sharedSecretReference = [VPN server shared secret from keychain];
//        protocol.localIdentifier = @"[VPN local identifier]";
//        protocol.remoteIdentifier = @"[VPN remote identifier]";
        protocol.useExtendedAuthentication = YES;
        protocol.disconnectOnSleep = NO;
        protocol.identityData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"clientCert" ofType:@"p12"]];
        [vpnManager setProtocol:protocol];
        [vpnManager setOnDemandEnabled:YES];
        [vpnManager setLocalizedDescription:@"[You VPN configuration name]"];
        NSMutableArray *rules = [[NSMutableArray alloc] init];
        NEOnDemandRuleConnect *connectRule = [NEOnDemandRuleConnect new];
        [rules addObject:connectRule];
        [vpnManager setOnDemandRules:rules];
        [vpnManager saveToPreferencesWithCompletionHandler:^(NSError *error) {
            if(error) {
                NSLog(@"Save error: %@", error);
            }
            else {
                NSLog(@"Saved!");
            }
        }];
    }];

 
}

- (void)openVPN:(UISwitch *)sender{
    
    BOOL isOn = sender.isOn;
    
    if (isOn) {
         _loadView.hidden = NO;
        [_loadView starAnimation];
        
       
        if ([NEVPNManager sharedManager].connection.status == NEVPNStatusDisconnected) {
            
            NSError *startError;
            [[NEVPNManager sharedManager].connection startVPNTunnelAndReturnError:&startError];
            
            if (startError) {
                NSLog(@"%@",startError);
            }
        }
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_loadView stopAnimation];
        });
        
    } else {
             [[NEVPNManager sharedManager].connection stopVPNTunnel];
    }



}

@end
