//
//  ZFInteractiveTransition.m
//  ZFCityGuides
//
//  Created by macOne on 16/1/18.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "ZFInteractiveTransition.h"

@interface ZFInteractiveTransition ()

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UIViewController *viewController;
@property (assign, nonatomic) BOOL shouldCompleteTransition;

@property (assign, nonatomic) CGFloat Speed;

@end

@implementation ZFInteractiveTransition

-(void)dealloc {
    [_panGesture.view removeGestureRecognizer:_panGesture];
}

-(void)interactionForViewController:(UIViewController *)viewController{
    
    _viewController = viewController;
//    NSLog(@"viewcontroller:%@",_viewController);
    [self prepareGestureRecognizerInView:viewController.view];
}


- (void)prepareGestureRecognizerInView:(UIView*)view {
    
    
//    NSLog(@"self frame:%@",NSStringFromCGRect(view.frame));
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:_panGesture];
    
}

-(void)handleGesture:(UIPanGestureRecognizer *)recognizer{
    
    self.Speed = 0;
    CGPoint translation = [recognizer translationInView:[_viewController.view superview]];
    CGFloat beginY = 0;
    static CFTimeInterval beginTime = 0.0;

    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:

            beginY = translation.y;
            beginTime = CACurrentMediaTime();
            
            if (translation.y >0) {
                self.interactionInProgress = YES;
                [_viewController dismissViewControllerAnimated:YES completion:nil];

            }

          
            break;
        case UIGestureRecognizerStateChanged:
            if (self.interactionInProgress) {

                if (translation.y < 0) {
                    return;
                }
                //
                CGFloat fraction = fabs(translation.y / [UIScreen mainScreen].bounds.size.height );
                fraction = fminf(fmaxf(fraction, 0.0), 1.0);
                
                _shouldCompleteTransition = (fraction > 0.4);
                if (fraction >= 1.0)
                    fraction = 0.99;

                [self updateInteractiveTransition:fraction];
                
//                NSLog(@"translation point:%@ fraction:%f",NSStringFromCGPoint(translation),fraction);
                
                if (translation.y > 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kChangedFrame object:@(translation.y)];
                }
  
            }

            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            
            
            if (self.interactionInProgress) {
                
                //计算时间 滑动的速率
                CFTimeInterval timeInterval = CACurrentMediaTime() - beginTime;
                CGFloat slipDistanceY =  translation.y - beginY;
                
                self.Speed = slipDistanceY/ (timeInterval *1000);

                //当速率大于0.7（测试得到的结果） 响应dismiss方法
                if (self.Speed > 0.7) {
                    self.interactionInProgress = YES;
                    [_viewController dismissViewControllerAnimated:YES completion:nil];
                    [self finishInteractiveTransition];
                    return;
                }

                self.interactionInProgress = NO;
                if (!_shouldCompleteTransition || recognizer.state == UIGestureRecognizerStateCancelled) {
                    [self cancelInteractiveTransition];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kChangedFrame object:@(-1)];
                }
                else {
                    [self finishInteractiveTransition];
                }
            }
            break;
        default:
            break;
    }

}

- (CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}
@end
