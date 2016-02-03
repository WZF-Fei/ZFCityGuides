//
//  ZFInteractiveTransition.h
//  ZFCityGuides
//
//  Created by macOne on 16/1/18.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFInteractiveTransition : UIPercentDrivenInteractiveTransition

-(void)interactionForViewController:(UIViewController *)viewController;

//用于判断交互手势是否进行中
@property (nonatomic, assign) BOOL interactionInProgress;


@end
