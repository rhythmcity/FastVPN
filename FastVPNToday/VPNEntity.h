//
//  VPNEntity.h
//  FastVPN
//
//  Created by 李言 on 16/4/6.
//  Copyright © 2016年 李言. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPNEntity : NSObject
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *passWord;
@property (nonatomic,copy) NSString *ipServer;
@property (nonatomic,copy) NSString *des;

@end
