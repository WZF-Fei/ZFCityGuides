//
//  ZFNavInteractiveTransition.h
//  ZFCityGuides
//
//  Created by macOne on 16/2/2.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFNavInteractiveTransition : UIPercentDrivenInteractiveTransition

-(void)interactionForViewController:(UIViewController *)viewController;

//用于判断交互手势是否进行中
@property (nonatomic, assign) BOOL interactionInProgress;
@property (nonatomic, assign) BOOL interactionOperationPop;

@end
