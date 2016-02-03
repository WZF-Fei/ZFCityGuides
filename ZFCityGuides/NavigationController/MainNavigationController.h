//
//  MainNavigationController.h
//  ZFCityGuides
//
//  Created by macOne on 16/1/27.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFNavInteractiveTransition.h"

@interface MainNavigationController : UINavigationController

@property (strong,nonatomic) ZFNavInteractiveTransition *interactionViewController;

@end
