//
//  AppDelegate.h
//  ZFCityGuides
//
//  Created by macOne on 16/1/11.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) MainNavigationController *rootNavigation;

+ (AppDelegate *)shareDelegate;
@end

