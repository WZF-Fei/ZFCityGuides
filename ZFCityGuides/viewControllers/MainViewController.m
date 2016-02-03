//
//  MainViewController.m
//  ZFCityGuides
//
//  Created by macOne on 16/1/11.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "MainViewController.h"
#import "ZFLayoutButton.h"
#import "ZFTransformScrollView.h"
#import "ZFScrollViewCell.h"
#import "ZFMainTabBarController.h"
#import "PresentAnimationController.h"
#import "ZFInteractiveTransition.h"


static const CGFloat kInsetTop = 15.0;
static const CGFloat kInsetLeft = 20.0;
static const CGFloat kInsetBottom = 10.0;
static const CGFloat kInsetRight = 20.0;
static const CGFloat duration = 1.0;

@interface MainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,POPAnimationDelegate,UIViewControllerTransitioningDelegate,ZFScrollViewCellDelegate>

//用于可以移动的button layer
@property (strong,nonatomic) CALayer *backgroundLayer;

@property (strong,nonatomic) ZFLayoutButton *GridButton;

@property (strong,nonatomic) ZFLayoutButton *SliderButton;

@property (copy,nonatomic) NSArray *displayCellImages;

@property (strong,nonatomic) UICollectionView *cityCollectView;

@property (strong,nonatomic) ZFTransformScrollView *scrollView;

@property (copy,nonatomic) NSArray *dataArray;

@property (assign,nonatomic) CGRect cityFrame;

@property (assign,nonatomic) BOOL bCanClicked;

@property (strong,nonatomic) ZFInteractiveTransition *interactionViewController;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kViewBgColor;
    //加入头部背景颜色
    UIView *headView = [UIView new];
    headView.backgroundColor = kNavBgColor;
    CGRect headFrame = self.view.frame;
    headFrame.size.height = 80;
    headView.frame = headFrame;
    [self.view addSubview:headView];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoView.frame = CGRectMake(40, 40, 100, 30);
    [headView addSubview:logoView];
    
    UILabel *author = [UILabel new];
    author.frame = CGRectMake(CGRectGetMaxX(logoView.frame) + 100, 40, 100, 30);
    author.text = @"Created By Airfei";
    author.textColor = [UIColor whiteColor];
    author.font = [UIFont fontWithName:TitleBoldFontName size:17.0];
    [self.view addSubview:author];
    
    [self initButtons];

    [_scrollView setHidden:YES];

}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSLog(@"viewwillappear");
    for (UICollectionViewCell *cell in _cityCollectView.visibleCells) {

        //恢复到原始状态
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.duration = 0.5;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        [cell.layer pop_addAnimation:scaleAnimation forKey:nil];
        
        POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        alphaAnimation.duration = 0.5;
        alphaAnimation.toValue = @1.0;
        [cell pop_addAnimation:alphaAnimation forKey:nil];

    }
    
}

-(void)initButtons{
    
    _backgroundLayer = [CALayer layer];
    _backgroundLayer.frame = CGRectMake(30, 100, 75, 35);
    _backgroundLayer.backgroundColor = kControlBgColor.CGColor;
    _backgroundLayer.cornerRadius = CGRectGetHeight(_backgroundLayer.frame)/2;
    [self.view.layer addSublayer:_backgroundLayer];
    
    
    _GridButton = [ZFLayoutButton new];
    _GridButton.titleLabel.font = [UIFont systemFontOfSize:10.0 weight:10];
    _GridButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    UIImage *GridImage = [[UIImage imageNamed:@"layout_grid@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_GridButton setImage:GridImage forState:UIControlStateNormal];
    [_GridButton setTitleColor:kButtonTextTintColor forState:UIControlStateNormal];
    [_GridButton setTitle:@"GRID" forState:UIControlStateNormal];
    [_GridButton addTarget:self action:@selector(showGridLayout:) forControlEvents:UIControlEventTouchUpInside];
    
    //动态改变长度
    CGSize size  = [self sizeWithString:_GridButton.titleLabel.text font:_GridButton.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGRect layerFrame = _backgroundLayer.frame;
    layerFrame.size.width = size.width + 25 *2;
    _GridButton.frame = layerFrame;
    _backgroundLayer.frame = layerFrame;
    [self.view addSubview:_GridButton];
    
    
    _SliderButton = [ZFLayoutButton new];
    CGRect frame = _GridButton.frame;
    frame.origin.x = CGRectGetMaxX(_GridButton.frame) + 30;
    _SliderButton.titleLabel.font = [UIFont systemFontOfSize:10.0 weight:10];
    _SliderButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    _SliderButton.layer.cornerRadius =  CGRectGetHeight(_GridButton.frame)/2;
    UIImage *SliderImage = [[UIImage imageNamed:@"layout_slider@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_SliderButton setImage:SliderImage forState:UIControlStateNormal];
    [_SliderButton setTitleColor:kButtonTextTintColor  forState:UIControlStateNormal];
    [_SliderButton setTitle:@"SLIDES" forState:UIControlStateNormal];
    [_SliderButton addTarget:self action:@selector(showSlideLayout:) forControlEvents:UIControlEventTouchUpInside];
    
    //动态改变长度
    size  = [self sizeWithString:_SliderButton.titleLabel.text font:_SliderButton.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    layerFrame = frame;
    layerFrame.size.width = size.width + 25 *2;
    _SliderButton.frame = layerFrame;
    [self.view addSubview:_SliderButton];
    
    
    _cityFrame = self.view.frame;
    _cityFrame.origin.y = CGRectGetMaxY(_SliderButton.frame) + 5;
    _cityFrame.size.height = self.view.frame.size.height - _cityFrame.origin.y - 20;
    
    _GridButton.selected = YES;
    [self setUpGridView];
    [self setUpSlidesView];
}

-(void)setUpGridView{
    
    //collectionview 布局
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    
    //计算itemsize根据EdgeInset
    flowLayout.itemSize = CGSizeMake((_cityFrame.size.width - (kInsetLeft + kInsetRight + 10))/2.0, (_cityFrame.size.height -(kInsetBottom + kInsetTop + 10)) / 2.0);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    
    _cityCollectView = [[UICollectionView alloc] initWithFrame:_cityFrame collectionViewLayout:flowLayout];
    [_cityCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CityCell"];
    
    _cityCollectView.dataSource = self;
    _cityCollectView.delegate = self;
    _cityCollectView.backgroundColor = kViewBgColor;
    [self.view addSubview:_cityCollectView];
    
}
-(void)setUpSlidesView{
    

    //也可以使用collectionView来实现，此处用scrollview
    _scrollView = [[ZFTransformScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.frame = CGRectMake(self.view.bounds.size.width, CGRectGetMaxY(_SliderButton.frame) + 20., self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(_SliderButton.frame) - 20);
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i< self.displayCellImages.count; i++)
    {

        ZFScrollViewCell *contentCell = [[ZFScrollViewCell alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*i , 0, self.view.bounds.size.width, _scrollView.frame.size.height - 30) withDictionary:self.dataArray[i]];
        contentCell.cellTag = i;
        contentCell.delegate = self;

        [_scrollView addSubview:contentCell];
        
    }

    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * self.displayCellImages.count, _scrollView.frame.size.height);    
//    CATransform3D t = CATransform3DMakeRotation(DEGREES_TO_RADIANS(30), 1, 0, 0);
//    _scrollView.layer.transform = CATransform3DPerspect(t, CGPointMake(0, 0), 500);

}

#pragma mark - setter and getter 用于测试数据
-(NSArray *)displayCellImages{
    if (!_displayCellImages) {
        _displayCellImages = [[NSArray alloc] init];
    }
    
    _displayCellImages = @[@"beijing",@"shanghai",@"hongkong",@"guangzhou"];
    
    return _displayCellImages;
}

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    
    _dataArray = @[@{@"image":@"beijing",
                     @"name":@"beijing",
                     @"pic":@"34",
                     @"location":@"97",
                     @"walk":@"15",
                     @"secret":@"90",
                     @"card":@"48"
                     },
                   @{@"image":@"shanghai",
                     @"name":@"shanghai",
                     @"pic":@"35",
                     @"location":@"90",
                     @"walk":@"15",
                     @"secret":@"83",
                     @"card":@"49"
                    },
                   @{@"image":@"hongkong",
                     @"name":@"hongkong",
                     @"pic":@"34",
                     @"location":@"106",
                     @"walk":@"15",
                     @"secret":@"56",
                     @"card":@"44"
                     },
                   @{@"image":@"guangzhou",
                     @"name":@"guangzhou",
                     @"pic":@"35",
                     @"location":@"80",
                     @"walk":@"15",
                     @"secret":@"56",
                     @"card":@"50"
                     },
                   ];
    
    return _dataArray;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"CityCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];

    if(indexPath.section==0)
    {
        cell.layer.cornerRadius = 6;
        cell.backgroundColor = kControlBgColor;
        
        //在cell上创建UIImageview UILabel 也可以在cell上创建
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height *0.7)];
        imageView.backgroundColor = kControlBgColor;
        NSString *strPath = [[NSBundle mainBundle] pathForResource:self.displayCellImages[indexPath.row] ofType:@"jpg"];
        imageView.image = [UIImage imageWithContentsOfFile:strPath];

        [cell.contentView addSubview:imageView];
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.backgroundColor = kControlBgColor;
        nameLabel.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame), cell.frame.size.width, cell.frame.size.height *0.2);
        nameLabel.text = [self.displayCellImages[indexPath.row] uppercaseString];
        nameLabel.textColor = kTextlightBlueColor;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont fontWithName:TitleBoldFontName size:20.0];
        [cell.contentView addSubview:nameLabel];
        
        cell.clipsToBounds = YES;
    }
    return cell;
    
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(kInsetTop, kInsetLeft, kInsetBottom, kInsetRight);
}

#pragma mark -UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell *selectedCell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    
    for (UICollectionViewCell *cell in collectionView.visibleCells) {
        
        if ([cell isEqual:selectedCell]) {
          
            //选中的cell的放大
            POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            scaleAnimation.duration = 0.5;
            scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.05, 1.05)];
            [cell.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
            
            POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            alphaAnimation.duration = 0.5;
            alphaAnimation.toValue = @1.0;
            [cell pop_addAnimation:alphaAnimation forKey:nil];
            
            [alphaAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                if (finished) {
                    
                    ZFMainTabBarController *mainTabBarVC = [[ZFMainTabBarController alloc] init];
                    mainTabBarVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    mainTabBarVC.transitioningDelegate = self;
                    
                    self.interactionViewController = [ZFInteractiveTransition new];
                    [self presentViewController:mainTabBarVC animated:YES completion:NULL];
                }

            }];

        }
        else{
            
            //未选中的可视cell的缩放
            POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            scaleAnimation.duration = 0.5;
            scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.95, 0.95)];
            [cell.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
            
            POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            alphaAnimation.duration = 0.5;
            alphaAnimation.toValue = @0.7;
            [cell pop_addAnimation:alphaAnimation forKey:nil];
            
        }
    }

}


 
#pragma mark - private method

-(void)showGridLayout:(UIButton *)sender{
    
    if (_GridButton.selected) {
        return;
    }
    
    [_cityCollectView setHidden:NO];
    _backgroundLayer.frame = sender.frame;
    
    _SliderButton.selected = NO;
    _GridButton.selected = YES;
    _GridButton.userInteractionEnabled = NO;
    [self canEnableClick];
    
    int i = 0;
    for (UICollectionViewCell *cell in _cityCollectView.visibleCells) {
        
        NSArray *translationArray = @[@-5, @0, @-300, @-100];
        NSArray *angles = @[@(-2* M_PI/180), @(-5* M_PI/180), @(-30* M_PI/180), @(-10* M_PI/180)];
        //未选中的可视cell的缩放

        POPBasicAnimation *rotationAnimation = [POPBasicAnimation easeInEaseOutAnimation];
        rotationAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerRotation];
        rotationAnimation.duration = duration;
        rotationAnimation.fromValue = angles[i];
        rotationAnimation.toValue = @(0);
        
        
        
        POPBasicAnimation *translationAnimation = [POPBasicAnimation easeInEaseOutAnimation];
        translationAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerTranslationX];
        translationAnimation.duration = duration;
        translationAnimation.fromValue = translationArray[i];
        translationAnimation.toValue = @(0);

        [cell.layer pop_addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        [cell.layer pop_addAnimation:translationAnimation forKey:@"translationAnimation"];
        i++;
   
    }
    
    // collectionView 移动
    CGRect fromFrame = _cityCollectView.frame;
    CGRect toFrome = fromFrame;
    toFrome.origin.x = 0;
    
    POPBasicAnimation *frameAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    frameAnimation.name = @"showGridView";
    frameAnimation.duration = duration;
    frameAnimation.fromValue = [NSValue valueWithCGRect:fromFrame];
    frameAnimation.toValue = [NSValue valueWithCGRect:toFrome];
    frameAnimation.delegate = self;
    [_cityCollectView pop_addAnimation:frameAnimation forKey:@"frameAnimation"];
    
    [frameAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
    
        if (finished) {
            [_scrollView setHidden:YES];
        }

    }];

}

-(void)showSlideLayout:(UIButton *)sender{
    

    if (_SliderButton.selected) {
        return;
    }

    [_scrollView setHidden:NO];
    
    _SliderButton.selected = YES;
    _GridButton.selected = NO;
    _SliderButton.userInteractionEnabled = NO;
    [self canEnableClick];
    _backgroundLayer.frame = sender.frame;
    
    int i = 0;
    for (UICollectionViewCell *cell in _cityCollectView.visibleCells) {
        
        NSArray *translationArray = @[@-300, @-200, @-600, @-600];
        NSArray *angles = @[@(-15* M_PI/180), @(-30* M_PI/180), @(-15* M_PI/180), @(-60* M_PI/180)];
        NSArray *scaleArray = @[@0, @0, @0, @-5];

        //未选中的可视cell的缩放
        
        POPBasicAnimation *rotationAnimation = [POPBasicAnimation easeInEaseOutAnimation];
        rotationAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerRotation];
        rotationAnimation.duration = duration;
        rotationAnimation.fromValue = @(0);
        rotationAnimation.toValue = angles[i];
        
        POPBasicAnimation *translationAnimation = [POPBasicAnimation easeInEaseOutAnimation];
        translationAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerTranslationX];
        translationAnimation.duration = duration;
        translationAnimation.fromValue = @(0);
        translationAnimation.toValue = translationArray[i];
        
        POPBasicAnimation *zPositionAnimation = [POPBasicAnimation easeInEaseOutAnimation];
        zPositionAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerZPosition];
        zPositionAnimation.duration = duration;
        zPositionAnimation.toValue = scaleArray[i];
        
        [cell.layer pop_addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        [cell.layer pop_addAnimation:translationAnimation forKey:@"translationAnimation"];
        [cell.layer pop_addAnimation:zPositionAnimation forKey:@"zPositionAnimation"];
        i++;
        
    }
    
    // collectionView 移动
    CGRect fromFrame = _cityCollectView.frame;
    CGRect toFrome = fromFrame;
    
    fromFrame.origin.x -= fromFrame.size.width;
    _cityCollectView.frame = fromFrame;
    
    POPBasicAnimation *frameAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    frameAnimation.name = @"showSliderView";
    frameAnimation.duration = duration;
    frameAnimation.fromValue = [NSValue valueWithCGRect:toFrome];
    frameAnimation.toValue = [NSValue valueWithCGRect:fromFrame];
    frameAnimation.delegate = self;

    [_cityCollectView pop_addAnimation:frameAnimation forKey:@"frameAnimation"];
    
    [frameAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        
        if (finished) {
            [_cityCollectView setHidden:YES];
        }
        
    }];

    
}

#pragma mark - 避免重复点击
-(void)canEnableClick
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW,duration * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
        if (_GridButton.isSelected) {
            _SliderButton.userInteractionEnabled = YES;
        }
        else if(_SliderButton.isSelected){
            _GridButton.userInteractionEnabled = YES;
        }
        
    });
    
}
#pragma mark - POPAnimationDelegate

- (void)pop_animationDidApply:(POPAnimation *)anim
{
//    NSLog(@"%@",anim.name );
    CGRect currentValue = [[anim valueForKey:@"currentValue"] CGRectValue];

    if ([anim.name isEqualToString:@"showSliderView"]) {
        
        CGRect frame = _scrollView.frame;
        CGFloat distanceY = 30 *(1 -fabs(currentValue.origin.x /_scrollView.frame.size.width));
        
        frame.origin.x = _scrollView.frame.size.width  + currentValue.origin.x;
        frame.origin.y =  CGRectGetMaxY(_SliderButton.frame) + 20.  +  distanceY  ;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.0];
        _scrollView.frame = frame;
        [UIView commitAnimations];
    }
    else if([anim.name isEqualToString:@"showGridView"]){

        CGRect frame = _scrollView.frame;
        CGFloat distanceY = 30 * (1 -  fabs(currentValue.origin.x /_scrollView.frame.size.width));
        
        frame.origin.x = _scrollView.frame.size.width  + currentValue.origin.x;
        frame.origin.y =  CGRectGetMaxY(_SliderButton.frame) + 20. +  distanceY ;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.0];
        _scrollView.frame = frame;

        [UIView commitAnimations];
    }
}


#pragma mark -UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    

    [_interactionViewController interactionForViewController:presented];
    
    PresentAnimationController *presentAnimation = [PresentAnimationController new];
    presentAnimation.dismiss = NO;
    return presentAnimation;
}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    PresentAnimationController *presentAnimation = [PresentAnimationController new];
    presentAnimation.dismiss = YES;
    return presentAnimation;
}


- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{

    return _interactionViewController.interactionInProgress ? _interactionViewController: nil;
}
#pragma mark - ZFScrollViewCellDelegate

-(void)touchCellViewAtIndex:(NSInteger)index{
   
    
    ZFMainTabBarController *mainTabBarVC = [[ZFMainTabBarController alloc] init];
    mainTabBarVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    mainTabBarVC.transitioningDelegate = self;
    [self presentViewController:mainTabBarVC animated:YES completion:NULL];
}

#pragma mark -计算字符串宽度

-(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end
