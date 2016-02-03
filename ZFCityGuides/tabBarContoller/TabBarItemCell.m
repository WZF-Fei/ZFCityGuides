//
//  TabBarItemCell.m
//  ZFCityGuides
//
//  Created by macOne on 16/1/21.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "TabBarItemCell.h"

@implementation TabBarItemCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initSubViews];
    }
    
    return self;
}

-(void)initSubViews{
    
    self.itemImageView.frame = CGRectMake((self.frame.size.width - self.frame.size.height *0.35)/2, (self.frame.size.height *0.5)/2, self.frame.size.height *0.35, self.frame.size.height *0.35);
    [self addSubview:self.itemImageView];
    
    self.itemNameLabel.frame = CGRectMake(0, CGRectGetMaxY(self.itemImageView.frame) +5 , self.frame.size.width, 30);
    self.itemNameLabel.font = [UIFont boldSystemFontOfSize:9.0f];
    self.itemNameLabel.textAlignment = NSTextAlignmentCenter;
    self.itemNameLabel.textColor = kTabItemTextNormal;
    [self addSubview:self.itemNameLabel];


}

#pragma mark -setter 

-(UIImageView *)itemImageView{
    
    if (!_itemImageView) {
        
        _itemImageView = [UIImageView new];
    }
    
    return _itemImageView;
}

-(UILabel *)itemNameLabel{
    
    if (!_itemNameLabel) {
        
        _itemNameLabel = [UILabel new];
    }
    
    return _itemNameLabel;
}

@end
