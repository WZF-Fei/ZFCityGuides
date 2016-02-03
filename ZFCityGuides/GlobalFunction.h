//
//  GlobalFunction.h
//  ZFCityGuides
//
//  Created by macOne on 16/1/15.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalFunction : NSObject


extern CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ);

extern CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ);

extern UIColor* randomColor();

@end
