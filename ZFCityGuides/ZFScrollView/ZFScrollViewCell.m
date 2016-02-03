//
//  ZFScrollViewCell.m
//  ZFCityGuides
//
//  Created by macOne on 16/1/14.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "ZFScrollViewCell.h"
#import "StatsViewController.h"

@interface ZFScrollViewCell ()

@property (copy, nonatomic) NSDictionary *dictionary;
@end
@implementation ZFScrollViewCell

#pragma mark -initial
-(instancetype)init{
    
    self = [super init];
    if (self) {
        self.backgroundColor = kViewBgColor;
        [self initViews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;

        [self initViews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame withDictionary:(NSDictionary *)dict{
    
    _dictionary = [[NSDictionary alloc] init];
    _dictionary = dict;
    return [self initWithFrame:frame];
}

#pragma mark - 布局视图
-(void)initViews{
    
    CGRect frame = self.frame;
    frame.origin.x = 30;
    frame.size.width -= 30*2;
    
    UIView *contentView = [[UIView alloc] initWithFrame:frame];
    contentView.backgroundColor = kControlBgColor;
    contentView.layer.cornerRadius = 8;
    contentView.clipsToBounds = YES;
    contentView.opaque = YES;
    [self addSubview:contentView];
    //UIImageView
    
    UIImageView *imageView = [UIImageView new];
    imageView.opaque = YES;
    imageView.frame = CGRectMake(0, 0, self.frame.size.width - 30*2, self.frame.size.height *0.4);
    NSString *strPath = [[NSBundle mainBundle] pathForResource:_dictionary[@"image"] ofType:@"jpg"];

    imageView.image = [UIImage imageWithContentsOfFile:strPath];

    [contentView addSubview:imageView];
    
    UILabel *contenName = [UILabel new];
    contenName.backgroundColor = kControlBgColor;
    contenName.textColor = kTextlightBlueColor;
    contenName.font = [UIFont fontWithName:TitleBoldFontName size:22.0];
    contenName.textAlignment = NSTextAlignmentCenter;
    contenName.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 20, self.frame.size.width - 30*2, 50);
    contenName.text = [_dictionary[@"name"] uppercaseString];
    [contentView addSubview:contenName];
    
    UILabel *line = [UILabel new];
    line.opaque = YES;
    line.backgroundColor = kControlBgColor;
    line.layer.borderColor = [UIColor lightGrayColor].CGColor;
    line.layer.borderWidth = 0.5;
    line.frame = CGRectMake(contentView.frame.size.width * 0.3/2.0, CGRectGetMaxY(contenName.frame) + 20, contentView.frame.size.width * 0.7, 1);
    [contentView addSubview:line];
    
    //平均分布UIImagView 左右边距40
    CGFloat gapWidth = (contentView.frame.size.width - 30 *2 - 5*30 )/ 4;
    
    UIImageView *picture = [UIImageView new];
    picture.backgroundColor = kControlBgColor;
    picture.opaque = YES;
    picture.frame = CGRectMake(30, CGRectGetMaxY(line.frame) + 20, 30, 30);
    picture.image = [UIImage imageNamed:@"photo.jpg"];
    [contentView addSubview:picture];
    
    UILabel *picLabel = [UILabel new];
    picLabel.backgroundColor = kControlBgColor;
    picLabel.text = _dictionary[@"pic"];
    picLabel.font = [UIFont boldSystemFontOfSize:13.0];
    picLabel.tintColor = kTextlightBlueColor;
    picLabel.textAlignment = NSTextAlignmentCenter;
    picLabel.frame = CGRectMake(30-2, CGRectGetMaxY(picture.frame) , 30, 25);
    [contentView addSubview:picLabel];
    
    UIImageView *location = [UIImageView new];
    location.backgroundColor = kControlBgColor;
    location.frame = CGRectMake(CGRectGetMaxX(picture.frame) + gapWidth, CGRectGetMaxY(line.frame) + 20, 30, 30);
    location.image = [UIImage imageNamed:@"location.jpg"];
    [contentView addSubview:location];
    
    UILabel *locationLabel = [UILabel new];
    locationLabel.backgroundColor = kControlBgColor;
    locationLabel.text = _dictionary[@"location"];
    locationLabel.font = [UIFont boldSystemFontOfSize:13.0];
    locationLabel.tintColor = kTextlightBlueColor;
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.frame = CGRectMake(CGRectGetMaxX(picture.frame) + gapWidth -2, CGRectGetMaxY(location.frame) , 30, 25);
    [contentView addSubview:locationLabel];
    
    UIImageView *walk = [UIImageView new];
    walk.backgroundColor = kControlBgColor;
    walk.frame = CGRectMake(CGRectGetMaxX(location.frame) + gapWidth, CGRectGetMaxY(line.frame) + 20, 30, 30);
    walk.image = [UIImage imageNamed:@"walk.jpg"];
    [contentView addSubview:walk];
    
    UILabel *walkLabel = [UILabel new];
    walkLabel.backgroundColor = kControlBgColor;
    walkLabel.text = _dictionary[@"walk"];
    walkLabel.font = [UIFont boldSystemFontOfSize:13.0];
    walkLabel.tintColor = kTextlightBlueColor;
    walkLabel.textAlignment = NSTextAlignmentCenter;
    walkLabel.frame = CGRectMake(CGRectGetMaxX(location.frame) + gapWidth -2, CGRectGetMaxY(walk.frame), 30, 25);
    [contentView addSubview:walkLabel];
    
    UIImageView *secret = [UIImageView new];
    secret.backgroundColor = kControlBgColor;
    secret.frame = CGRectMake(CGRectGetMaxX(walk.frame) + gapWidth, CGRectGetMaxY(line.frame) + 20, 30, 30);
    secret.image = [UIImage imageNamed:@"secret.jpg"];
    [contentView addSubview:secret];
    
    UILabel *secretLabel = [UILabel new];
    secretLabel.backgroundColor = kControlBgColor;
    secretLabel.text = _dictionary[@"secret"];
    secretLabel.font = [UIFont boldSystemFontOfSize:13.0];
    secretLabel.tintColor = kTextlightBlueColor;
    secretLabel.textAlignment = NSTextAlignmentCenter;
    secretLabel.frame = CGRectMake(CGRectGetMaxX(walk.frame) + gapWidth -2, CGRectGetMaxY(secret.frame), 30, 25);
    [contentView addSubview:secretLabel];
    
    UIImageView *card = [UIImageView new];
    card.backgroundColor = kControlBgColor;
    card.frame = CGRectMake(CGRectGetMaxX(secret.frame) + gapWidth, CGRectGetMaxY(line.frame) + 20, 30, 30);
    card.image = [UIImage imageNamed:@"card.jpg"];
    [contentView addSubview:card];
    
    UILabel *cardLabel = [UILabel new];
    cardLabel.backgroundColor = kControlBgColor;
    cardLabel.text = _dictionary[@"card"];
    cardLabel.font = [UIFont boldSystemFontOfSize:13.0];
    cardLabel.tintColor = kTextlightBlueColor;
    cardLabel.textAlignment = NSTextAlignmentCenter;
    cardLabel.frame = CGRectMake(CGRectGetMaxX(secret.frame) + gapWidth -2, CGRectGetMaxY(card.frame) , 30, 25);
    [contentView addSubview:cardLabel];
    
    UIButton *guide = [UIButton new];
    [guide setTitle:@"VIEW GUIDE" forState:UIControlStateNormal];
    [guide setTitleColor:kTextlightBlueColor forState:UIControlStateNormal];
    guide.titleLabel.font = [UIFont fontWithName:BodyFontName size:13.0] ;
    guide.frame = CGRectMake(contentView.frame.size.width * 0.1 /2.0, CGRectGetMaxY(picture.frame) + 60, contentView.frame.size.width * 0.9, 50);
    guide.layer.borderColor = [UIColor lightGrayColor].CGColor;
    guide.layer.borderWidth = 1;
    guide.layer.cornerRadius = 5;
    guide.backgroundColor = [UIColor whiteColor];
    [guide addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:guide];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    
//    UIView *parent = self.superview;
//    if (parent) {
//        self.frame = parent.bounds;
//    }
//
//}

-(void)clickButton:(UIButton *)sender{
 
    if ([self.delegate respondsToSelector:@selector(touchCellViewAtIndex:)]) {
        [self.delegate touchCellViewAtIndex:self.cellTag];
    }
}

-(void)tapRecognizer:(UITapGestureRecognizer *)recognizer{
    

    if ([self.delegate respondsToSelector:@selector(touchCellViewAtIndex:)]) {
        [self.delegate touchCellViewAtIndex:self.cellTag];
    }
}


@end
