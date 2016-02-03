//
//  ZFScrollViewCell.h
//  ZFCityGuides
//
//  Created by macOne on 16/1/14.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZFScrollViewCellDelegate <NSObject>

-(void) touchCellViewAtIndex:(NSInteger)index;

@end

@interface ZFScrollViewCell : UIView

@property (weak, nonatomic) id <ZFScrollViewCellDelegate> delegate;

@property (assign,nonatomic) NSInteger cellTag;

-(instancetype)initWithFrame:(CGRect)frame withDictionary:(NSDictionary *)dict;

@end
