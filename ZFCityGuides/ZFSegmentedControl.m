//
//  ZFSegmentedControl.m
//  ZFCityGuides
//
//  Created by macOne on 16/3/18.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "ZFSegmentedControl.h"

@interface ZFSegmentedControl()

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, copy) NSMutableArray *segmentItems;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIColor *foregroundColor;

@property (nonatomic, strong) UIFont *font;


@end

@implementation ZFSegmentedControl


-(instancetype)initWithItems:(NSArray *)items{
    
    self = [super init];
    
    if (self) {
        
        self.items = items;
        [self layoutUI];
    }
    return self;
}


-(void)layoutUI{
    
    _contentView =[UIView new];
    [self addSubview:_contentView];
    
    if (self.items) {
        
        int i = 0;
        for (NSString *item in self.items) {
            UIButton *button = [UIButton new];
            
            button.tag = i;
            [button setTitle:item forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:10.0];
            button.layer.borderWidth = 0.5;
            [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.segmentItems addObject:button];
            [self.contentView addSubview:button];
            i++;
        }
    }
}

-(void)clickItem:(UIButton *)sender{
    
    for (UIView *segmentView in self.segmentItems) {
        
        if ([segmentView isKindOfClass:[UIButton class]]) {
            ((UIButton *)segmentView).selected = NO;
        }
        
    }
    sender.selected = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSegmentedControlAtIndex:)]) {
        [self.delegate clickSegmentedControlAtIndex:sender.tag];
    }
}
-(void)setNormalImage:(UIImage *)image forSegmentAtIndex:(NSInteger)index{
    
    UIView *segmentView = self.segmentItems[index];
   
    for (UIView *subView in segmentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIButton *button = ((UIButton *)segmentView) ;
    CGFloat itemWidth = self.frame.size.width / self.segmentItems.count;

    [button setImage:image forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, (itemWidth - image.size.width)/2.0, 0, 0);

}

-(void)setSelectedImage:(UIImage *)image forSegmentAtIndex:(NSInteger)index{
    
    UIView *segmentView = self.segmentItems[index];
    
    for (UIView *subView in segmentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIButton *button = ((UIButton *)segmentView) ;
    CGFloat itemWidth = self.frame.size.width / self.segmentItems.count;
    
    [button setImage:image forState:UIControlStateSelected];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, (itemWidth - image.size.width)/2.0, 0, 0);
    
}


-(void)setTitle:(NSString *)text forSegmentAtIndex:(NSInteger)index{
    
    UIView *segmentView = self.segmentItems[index];
    
    for (UIView *subView in segmentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIButton *button = [UIButton new];
    button.frame = segmentView.frame;
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.borderWidth = 0.5;
    
    [segmentView addSubview:button];
    
}

- (void)setTitleTextAttributes:(NSDictionary<NSString *,id> *)attributes forState:(UIControlState)state{
    
    self.foregroundColor = [attributes objectForKey:NSForegroundColorAttributeName];
    self.font = [attributes objectForKey:NSFontAttributeName];
    
    
    for (UIView *segmentView in self.segmentItems) {
        
        if ([segmentView isKindOfClass:[UIButton class]]) {
            ((UIButton *)segmentView).titleLabel.font = self.font;
            [((UIButton *)segmentView) setTitleColor:self.foregroundColor forState:state];;
        }
        
    }

    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    
    if (self.segmentItems) {
        
        //默认均分宽度
        CGFloat itemWidth = self.frame.size.width / self.segmentItems.count;
        int i = 0;
        for (UIView *subView in self.segmentItems) {

            subView.frame = CGRectMake(i * itemWidth,0, itemWidth,self.frame.size.height);
            i++;
        }
    }
}
#pragma mark - getter and setter

-(NSArray *)items{
    
    if (!_items) {
        _items = [[NSArray alloc] init];
    }
    
    return _items;
}

-(NSMutableArray *)segmentItems{
    
    if (!_segmentItems) {
        _segmentItems = [[NSMutableArray alloc] init];
    }
    
    return _segmentItems;
}

-(void)setTintColor:(UIColor *)tintColor{
    
    
    for (UIView *segmentView in self.segmentItems) {
        
        if ([segmentView isKindOfClass:[UIButton class]]) {
            
            [((UIButton *)segmentView) setBackgroundImage:[self createImageWithColor:kTabItemBgSelected] forState:UIControlStateSelected];
        }
        
    }

    
    _tintColor = tintColor;
}

- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}




@end
