//
//  ZFMainTabBarController.m
//  ZFCityGuides
//
//  Created by macOne on 16/1/20.
//  Copyright © 2016年 WZF. All rights reserved.
//

#define headerViewHeight  self.view.bounds.size.height * 0.3

#import "ZFMainTabBarController.h"
#import "TabBarItemCell.h"
#import "TabBarAnimationController.h"
#import "MainNavigationController.h"

#import "EssentialsViewController.h"


@interface ZFMainTabBarController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UICollectionView *itemCollectView;

@property (strong, nonatomic) UICollectionViewCell *selectedCell;

@property (strong, nonatomic) UICollectionViewCell *currentCell;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (copy, nonatomic) NSArray *itemCellIcons;

@property (strong, nonatomic) NSMutableArray *childViewControllers;

@property (copy, nonatomic) NSArray *sortedVisibleCells;


@end

@implementation ZFMainTabBarController

-(void)dealloc{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChangedFrame object:nil];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
//        self.view.backgroundColor = [UIColor whiteColor];
   
    UIView *contentView = [UIView new];
    contentView.backgroundColor = kContentViewBgColor;
    contentView.frame = CGRectMake(0, headerViewHeight, self.view.frame.size.width, self.view.frame.size.height - headerViewHeight);
    [self.view addSubview:contentView];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
//

    
    [self addViewOnContentView:contentView];

    [self initChildViewControllers];
    
    //通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewFrameNotification:) name:kChangedFrame object:nil];

}

-(void)addViewOnContentView:(UIView *)contentView{
    
    UIImageView *imageView = [UIImageView new];
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:strPath];
    imageView.image = image;
    imageView.frame = CGRectMake(20, contentView.frame.size.height - 50, 90, 30);
    [contentView addSubview:imageView];
    

    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //用于强制显示中文的下午和上午
    dateFormatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:@"hh:mma"];
    NSString *timeString = [dateFormatter stringFromDate:currentDate];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:timeString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0]}];
    
    [attrString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0] , NSBaselineOffsetAttributeName : @5} range:NSMakeRange(5, 2)];
    
    
    UILabel *cityTime = [UILabel new];
    cityTime.attributedText = attrString;

    cityTime.textColor = kTabItemTextNormal;
    cityTime.frame = CGRectMake(contentView.bounds.size.width - 100, contentView.frame.size.height - 40, 100, 30);
    [contentView addSubview:cityTime];
    
    
    UILabel *cityName = [UILabel new];
    cityName.textColor = kTabItemTextNormal;
    cityName.font = [UIFont fontWithName:TitleBoldFontName size:20.0] ;
    cityName.textAlignment = NSTextAlignmentCenter;
    cityName.frame = CGRectMake(CGRectGetMinX(cityTime.frame) - 100, CGRectGetMinY(cityTime.frame), 100, 30);
    [contentView addSubview:cityName];
    
    
    NSArray *array = @[@"WEATHER",@"SEARCH",@"SETTING",@"ALL CITIES"];
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:array];
    segmentControl.layer.borderWidth = 1;
    segmentControl.layer.borderColor = kSegmentBorderColor.CGColor;
    segmentControl.layer.cornerRadius = 5.0;
    segmentControl.layer.masksToBounds = YES;
    segmentControl.tintColor = [UIColor blackColor];
    segmentControl.frame = CGRectMake(20, CGRectGetMinY(cityTime.frame) - 50 - 30, contentView.frame.size.width - 20*2, 50);
    [contentView addSubview:segmentControl];
    
    NSDictionary *selectedDic = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:BodyFontName size:10.0]};
    NSDictionary *normalDic = @{NSForegroundColorAttributeName : kTabItemTextNormal, NSFontAttributeName : [UIFont fontWithName:BodyFontName size:10.0]};
    [segmentControl setTitleTextAttributes:normalDic forState:UIControlStateNormal];
    [segmentControl setTitleTextAttributes:selectedDic forState:UIControlStateSelected];
    
    
    //collectionview 布局
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    
    //计算itemsize
    flowLayout.itemSize = CGSizeMake((self.view.frame.size.width - 1 *2)/3.0 , (segmentControl.frame.origin.y - 30) /3.0);
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    
    CGRect frame = contentView.frame;
    frame.size.height = (segmentControl.frame.origin.y - 30)  + 1 *2;
    
    _itemCollectView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    [_itemCollectView registerClass:[TabBarItemCell class] forCellWithReuseIdentifier:@"tabItemCell"];
    _itemCollectView.dataSource = self;
    _itemCollectView.delegate = self;
    _itemCollectView.backgroundColor = kViewBgColor;
    //取消延迟高亮，立即触发
    _itemCollectView.delaysContentTouches = NO;
    [self.view addSubview:_itemCollectView];
}

#pragma mark - 改变frame实现cell动画
-(void)changeViewFrameNotification:(NSNotification *)notification{
    
    CGFloat translationY = [[notification object] floatValue];

    for (TabBarItemCell *cell in self.sortedVisibleCells) {
        //取消手势
        if (translationY < 0) {
            
            [self transformForCell:self.sortedVisibleCells[cell.tag % 3] Factor:0 animated:YES];
        }
        
        CGRect rect = [self.view convertRect:cell.frame fromView:self.itemCollectView];
        
        CGFloat y = self.view.bounds.size.height - CGRectGetMaxY(rect) - (translationY - 44 - 20);

        if (y < 0 ) {

            //求偏移量
            CGFloat factor = y /cell.frame.size.height;
        
            [self transformForCell:self.sortedVisibleCells[cell.tag % 3] Factor:factor animated:YES];
        }
        
    }
    

    
}

-(void)transformForCell:(UICollectionViewCell *)cell Factor:(CGFloat)factor animated:(BOOL)animated{
    
    if (!animated) {
        return;
    }
    TabBarItemCell *tabBarCell = (TabBarItemCell *)cell;
//    NSLog(@"cell frame:%@",NSStringFromCGRect(tabBarCell.itemImageView.frame));
    
    NSInteger index = cell.tag;
    
    CGRect imageViewFrame = tabBarCell.itemImageView.frame;
    CGPoint labelFrame = tabBarCell.itemNameLabel.center;
  
    //block代码段
    void (^animationBlock)(void) = ^{
        
        tabBarCell.itemImageView.alpha = fabs(factor) > 0.6 ? 0 : 1- fabs(factor);
        tabBarCell.itemNameLabel.alpha = fabs(factor) > 0.6 ? 0 : 1- fabs(factor);
        
        CGAffineTransform t = CGAffineTransformIdentity;
        if (fabs(factor) < 0.2){
            t =  CGAffineTransformScale(t, 1- fabs(factor), 1- fabs(factor));
        }else{
            t =  CGAffineTransformScale(t, 0.8, 0.8);
        }
        
        tabBarCell.itemImageView.transform = t;
        tabBarCell.itemNameLabel.transform = t;
    };
    
    if (index == 0) {
        //向左移动
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.0];
        
        imageViewFrame.origin.x = (tabBarCell.frame.size.width - tabBarCell.itemImageView.frame.size.width)/2  * (1- fabs(factor));
        tabBarCell.itemImageView.frame = imageViewFrame;
        
        labelFrame.x = CGRectGetMidX(imageViewFrame) ;
        tabBarCell.itemNameLabel.center = labelFrame;

        animationBlock();
        
        [CATransaction commit];
        
    }
    else if (index == 1){
        //中间缩放
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.0];
        
        animationBlock();
        
        [CATransaction commit];
    }
    else if (index == 2){
        //向右移动

        [CATransaction begin];
        [CATransaction setAnimationDuration:0.0];
        
        imageViewFrame.origin.x = (tabBarCell.frame.size.width - tabBarCell.itemImageView.frame.size.width)/2  * (1 + fabs(factor));
        tabBarCell.itemImageView.frame = imageViewFrame;
        
        labelFrame.x = CGRectGetMidX(imageViewFrame) ;
        tabBarCell.itemNameLabel.center = labelFrame;
        
        animationBlock();
        
        [CATransaction commit];
        
    }
}

#pragma mark - 初始化子控制器
-(void)initChildViewControllers{
    
    _childViewControllers = [NSMutableArray new];
    
    //构造tabItem
    EssentialsViewController *firstVC = [EssentialsViewController new];
    MainNavigationController *konwNav = [[MainNavigationController alloc] initWithRootViewController:firstVC];
//    [childViewControllers addObject:konwNav];
    
    EssentialsViewController *essentialsVC = [EssentialsViewController new];
    MainNavigationController *essentialNav = [[MainNavigationController alloc] initWithRootViewController:essentialsVC];
//    [childViewControllers addObject:essentialNav];
    
    EssentialsViewController *thirdVC = [EssentialsViewController new];
    MainNavigationController *interstNav = [[MainNavigationController alloc] initWithRootViewController:thirdVC];
//    [childViewControllers addObject:interstNav];
    
    EssentialsViewController *fourthVC = [EssentialsViewController new];
    MainNavigationController *photosNav = [[MainNavigationController alloc] initWithRootViewController:fourthVC];
//    [childViewControllers addObject:photosNav];
    
    _childViewControllers =[@[konwNav,essentialNav,interstNav,photosNav,konwNav,essentialNav,interstNav,photosNav,konwNav] mutableCopy];
    
}

#pragma mark - tap 手势实现dismiss控制器
-(void)tapGestureRecognizer:(UITapGestureRecognizer *)recognizer{
    
    [self dismissViewControllerAnimated:YES completion:NULL];

 
}

#pragma mark - getter方法
-(NSArray *)itemCellIcons{
    if (!_itemCellIcons) {
        _itemCellIcons = [[NSArray alloc] init];
    }
    
    _itemCellIcons =@[ @{@"tabBarName"  : @"do you konw?",
                         @"tabIcon"     : @"dyk"},
                       @{@"tabBarName"  : @"essentials",
                         @"tabIcon"     : @"essentials"},
                       @{@"tabBarName"  : @"my favorites",
                         @"tabIcon"     : @"favorites"},
                       @{@"tabBarName"  : @"photos",
                         @"tabIcon"     : @"photos"},
                       @{@"tabBarName"  : @"walks",
                         @"tabIcon"     : @"walks"},
                       @{@"tabBarName"  : @"food & drink",
                         @"tabIcon"     : @"food"},
                       @{@"tabBarName"  : @"what to do",
                         @"tabIcon"     : @"wtd"},
                       @{@"tabBarName"  : @"my itineraries",
                         @"tabIcon"     : @"itineraries"},
                       @{@"tabBarName"  : @"secrets",
                         @"tabIcon"     : @"secrets"}];
  
    
    return _itemCellIcons;
}

-(NSArray *)sortedVisibleCells{
    
    if (!_sortedVisibleCells) {
        
        _sortedVisibleCells = [[NSArray alloc] init];
        _sortedVisibleCells = [self.itemCollectView.visibleCells sortedArrayUsingComparator:^NSComparisonResult(UICollectionViewCell *obj1, UICollectionViewCell *obj2) {
            //visiblecells 是无需的 按照tag值进行排序
            NSComparisonResult result = [[NSNumber numberWithInteger:obj1.tag] compare:[NSNumber numberWithInteger:obj2.tag]];
            return result;
        
        }];
        
    }
    return _sortedVisibleCells;

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.itemCellIcons count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"tabItemCell";
    
    TabBarItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];

    //构造cell
        
    cell.contentView.backgroundColor = kTabItemBgNormal;
    
    cell.itemImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"main-menu-iphone-%@@2x",self.itemCellIcons[indexPath.row][@"tabIcon"]]];
    cell.itemNameLabel.text = [self.itemCellIcons[indexPath.row][@"tabBarName"] uppercaseString];
    cell.tag = indexPath.row;
    return cell;
  
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectedCell && ![self.selectedCell isEqual:self.currentCell]) {
        
        [self updateCollectionViewCell:self.selectedCell atIndexPath:_currentIndexPath selected:NO];
    }
    
    [self updateCollectionViewCell:self.currentCell atIndexPath:indexPath selected:YES];
    
    _currentIndexPath = indexPath;
    self.selectedCell = self.currentCell;
    
    UIViewController *presentedVC = _childViewControllers[indexPath.row] ;
    presentedVC.transitioningDelegate = self;
    
    __weak typeof(self) weakSelf = self;
    
    [self presentViewController:presentedVC animated:YES completion:^{
        //remove presentingView
        [weakSelf.presentingViewController.view removeFromSuperview];
    }];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    

    self.currentCell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    //如当前要选择的cell已被选择 不出现高亮
    if ([self.currentCell isEqual:self.selectedCell]) {
        
        return;
    }

    [self updateCollectionViewCell:self.currentCell atIndexPath:indexPath highlighted:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.currentCell){
        
        [self updateCollectionViewCell:self.currentCell atIndexPath:indexPath highlighted:NO];
    }
}

#pragma mark - collectionViewCell 颜色状态变化
-(void)updateCollectionViewCell:(UICollectionViewCell *)collectionCell atIndexPath:(NSIndexPath *)indexPath selected:(BOOL)selected
{
    TabBarItemCell *itemCell = (TabBarItemCell *)collectionCell;
    
    NSString *strNormalImage =[NSString stringWithFormat:@"main-menu-iphone-%@@2x",self.itemCellIcons[indexPath.row][@"tabIcon"]];
    NSString *strSelectedImage = [NSString stringWithFormat:@"main-menu-iphone-%@-selected@2x",self.itemCellIcons[indexPath.row][@"tabIcon"]];
    
    itemCell.itemImageView.image = selected ? [UIImage imageNamed:strSelectedImage] : [UIImage imageNamed:strNormalImage];
    itemCell.itemNameLabel.textColor = selected ? [UIColor whiteColor] : kTabItemTextNormal;
    itemCell.contentView.backgroundColor = selected ? kTabItemBgSelected : kTabItemBgNormal;
  
}

-(void)updateCollectionViewCell:(UICollectionViewCell *)collectionCell atIndexPath:(NSIndexPath *)indexPath highlighted:(BOOL)highlighted
{
    
    collectionCell.contentView.backgroundColor = highlighted ? [UIColor blackColor] : kTabItemBgNormal;
    
}
#pragma mark -UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    
    TabBarAnimationController *presentAnimation = [TabBarAnimationController new];
    return presentAnimation;
}

#pragma mark -UIGestureRecognizerDelegate 判断手势点击的哪个View

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (touch.view != self.view) {
        return NO;
    }
    
    return YES;
}


@end
