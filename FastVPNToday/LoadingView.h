//
//  LoadingView.h
//  FastVPN
//
//  Created by 李言 on 16/4/5.
//  Copyright © 2016年 李言. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^openSucceed) ();

@interface LoadingView : UIView

@property (nonatomic,copy)openSucceed openSucceedBlock;

- (void)starAnimation;

- (void)stopAnimation;

- (void)removeALLAnimation;
@end
