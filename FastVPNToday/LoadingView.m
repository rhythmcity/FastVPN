//
//  LoadingView.m
//  FastVPN
//
//  Created by 李言 on 16/4/5.
//  Copyright © 2016年 李言. All rights reserved.
//

#import "LoadingView.h"
@interface LoadingView ()
@property (nonatomic, strong)CAShapeLayer *shapeLayer;

@property (nonatomic, strong)UIBezierPath *bezierPath;

@property (nonatomic, strong)UIBezierPath *gouBezierPath;
@end

@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame {

    if ([super initWithFrame:frame]) {
    }
    
    return self;
}

- (void)updateConstraints {

    [super updateConstraints];
    
  
}


- (UIBezierPath *)bezierPath {

    if (!_bezierPath) {
        
        _bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.height/3 startAngle:0 endAngle:2*M_PI clockwise:NO];
        
    }
    
    return _bezierPath;
}

- (UIBezierPath *)gouBezierPath {

    if (!_gouBezierPath) {
        _gouBezierPath = [UIBezierPath bezierPath];
        
        CGRect rectInCircle = CGRectInset(self.bounds, self.bounds.size.width*(1-1/sqrt(2.0))/2, self.bounds.size.width*(1-1/sqrt(2.0))/2);
        [_gouBezierPath moveToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width/9, rectInCircle.origin.y + rectInCircle.size.height*2/3)];
        
        [_gouBezierPath addLineToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width/3,rectInCircle.origin.y + rectInCircle.size.height*9/10)];
        [_gouBezierPath addLineToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width*8/10, rectInCircle.origin.y + rectInCircle.size.height*2/10)];
        
    }
    return _gouBezierPath;

}



- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.lineWidth = 1.5;
    }
    return _shapeLayer;

}


- (void)starAnimation {
    
    self.shapeLayer.path = self.bezierPath.CGPath;
    
    self.shapeLayer.strokeStart = 0;
    
    self.shapeLayer.strokeEnd = 0;
    

    [self.shapeLayer addAnimation:[self rolationAnimation] forKey:@"rotationanimation"];
    
    [self.shapeLayer addAnimation:[self loadingAnimation] forKey:@"loadingAnimation"];

}


- (void)stopAnimation {

    [self.shapeLayer removeAllAnimations];
    
    self.shapeLayer.path = self.gouBezierPath.CGPath;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.shapeLayer.lineWidth = 1.5;
    self.shapeLayer.lineCap = kCALineCapRound;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    
    [self.shapeLayer addAnimation:[self checkAnimation]  forKey:@"checkAnimation"];
}

- (void)removeALLAnimation {
    [self.shapeLayer removeAllAnimations];

}

#pragma mark - Animation

- (CAAnimation *)rolationAnimation {
    CABasicAnimation * animation = [CABasicAnimation animation];
    
    animation.keyPath = @"transform.rotation";
    animation.duration = 2.0;
    animation.fromValue = @0;
    animation.toValue = @(-2 * M_PI);
    animation.repeatCount = HUGE;
    return animation;
}


- (CAAnimation *)loadingAnimation {
    CABasicAnimation * headAnimation = [CABasicAnimation animation];
    headAnimation.keyPath = @"strokeStart";
    headAnimation.duration = 1.0;
    headAnimation.fromValue = @0;
    headAnimation.toValue = @0.25;
    headAnimation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CABasicAnimation * tailAnimation = [CABasicAnimation animation];
    tailAnimation.keyPath = @"strokeEnd";
    tailAnimation.duration  = 1.0;
    tailAnimation.fromValue = @0;
    tailAnimation.toValue = @1;
    tailAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CABasicAnimation * endHeadAnimation = [CABasicAnimation animation];
    endHeadAnimation.keyPath = @"strokeStart";
    endHeadAnimation.beginTime = 1;
    endHeadAnimation.duration = 0.5;
    endHeadAnimation.fromValue = @0.25;
    endHeadAnimation.toValue = @1;
    endHeadAnimation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CABasicAnimation * endTailAnimmation = [CABasicAnimation animation];
    endTailAnimmation.keyPath = @"strokeEnd";
    endTailAnimmation.beginTime = 1.0;
    endTailAnimmation.duration = 0.5;
    endTailAnimmation.fromValue = @1;
    endTailAnimmation.toValue = @1;
    endTailAnimmation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CAAnimationGroup * animations = [CAAnimationGroup animation];
    animations.duration = 1.5;
    animations.animations = @[headAnimation,tailAnimation,endHeadAnimation,endTailAnimmation];
    animations.repeatCount = HUGE;
    
    return animations;
    

}


- (CAAnimation *)checkAnimation {
  
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    checkAnimation.duration = 0.5f;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    checkAnimation.delegate = self;
    checkAnimation.removedOnCompletion = NO;
    checkAnimation.fillMode = kCAFillModeForwards;
    [checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
    
    
//    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    opacity.beginTime = 0.5f;
//    opacity.duration = 0.3f;
//    opacity.fromValue = @(1.0f);
//    opacity.toValue = @(0.0f);
//    opacity.delegate = self;
//    [opacity setValue:@"opacity" forKey:@"animationName"];
    
    
    
    
//    CAAnimationGroup * animations = [CAAnimationGroup animation];
//    animations.duration = 0.8;
//    animations.animations = @[checkAnimation];
   

    return checkAnimation;

}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if ([[anim valueForKey:@"animationName"]isEqualToString:@"checkAnimation"]) {
        !self.openSucceedBlock?:self.openSucceedBlock();
    }
    


}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.shapeLayer.frame = self.bounds;
    [self.layer addSublayer:self.shapeLayer];
    
    

}

@end
