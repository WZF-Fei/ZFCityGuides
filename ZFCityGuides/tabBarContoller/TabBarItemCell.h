//
//  TabBarItemCell.h
//  ZFCityGuides
//
//  Created by macOne on 16/1/21.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarItemCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *itemImageView;

@property (strong, nonatomic) UILabel *itemNameLabel;

@property (assign, nonatomic) BOOL isSelected;

@end
