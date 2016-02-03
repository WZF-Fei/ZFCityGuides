//
//  UINavigationController+Interactive.m
//  ZFCityGuides
//
//  Created by macOne on 16/2/2.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "UINavigationController+Interactive.h"
#import <objc/runtime.h>

@implementation UINavigationController (Interactive)


+ (void)load{
    //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //获得viewController的生命周期方法的selector
        SEL orignSelector = @selector(pushViewController:animated:);
        //自己实现的将要被交换的方法的selector
        SEL swizzleSelector = @selector(swizzle_pushViewController:animated:);
        //两个方法的Method
        Method orignMethod = class_getInstanceMethod([self class], orignSelector);
        Method swizzleMethod = class_getInstanceMethod([self class], swizzleSelector);
        
        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
        BOOL isAdd = class_addMethod(self, orignSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
        if (isAdd) {
            //如果成功，说明类中不存在这个方法的实现
            //将被交换方法的实现替换到这个并不存在的实现
            class_replaceMethod(self, swizzleSelector, method_getImplementation(orignMethod), method_getTypeEncoding(orignMethod));
        }else{
            //否则，交换两个方法的实现
            method_exchangeImplementations(orignMethod, swizzleMethod);
        }
        
    });
}

- (void)swizzle_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    MainNavigationController *navigation = (MainNavigationController *)self;
    navigation.interactionViewController = [ZFNavInteractiveTransition new];
    
    [self swizzle_pushViewController:viewController animated:animated];
    

}


@end
