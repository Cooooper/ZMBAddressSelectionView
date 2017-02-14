//
//  ChooseLocationView.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/22.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "ZMBAddressSelectionView.h"
#import "ZMBAddressView.h"
#import "ZMBAddressCell.h"
#import "ZMBAddressItem.h"


#define HYScreenW [UIScreen mainScreen].bounds.size.width

static  CGFloat  const  kHYTopViewHeight = 50; //顶部视图的高度
static  CGFloat  const  kHYTopTabbarHeight = 35; //地址标签栏的高度

@interface ZMBAddressSelectionView ()
<UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate,
UIGestureRecognizerDelegate>


@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) UIView *presentView;


@property (nonatomic,weak) ZMBAddressView * topTabbar;
@property (nonatomic,weak) UIScrollView * contentView;
@property (nonatomic,weak) UIView * underLine;
@property (nonatomic,strong) NSArray * dataSouce;
@property (nonatomic,strong) NSArray * dataSouce1;
@property (nonatomic,strong) NSArray * dataSouce2;
@property (nonatomic,strong) NSMutableArray * tableViews;
@property (nonatomic,strong) NSMutableArray * topTabbarItems;

@property (nonatomic,strong) ZMBAddressItem *selectedItem;

@end

@implementation ZMBAddressSelectionView

- (instancetype)init
{
  self = [super init];
  if (self) {
    
    [self setUp];
 
  }
  return self;
}


- (void)showInView:(UIView *)view
{
  if (view) {
    [view addSubview:self];
  }
  else {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
  }

  CGRect cframe = self.coverView.frame;
  
  cframe.size.height = self.frame.size.height;
  self.coverView.frame = cframe;
  
  [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
    [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
      
      CGRect frame = self.presentView.frame;
      CGRect cframe = self.coverView.frame;
      CGFloat y = self.frame.size.height - self.presentView.frame.size.height;
      frame.origin.y = y;
      cframe.size.height = self.frame.size.height - frame.size.height;
      
      self.coverView.frame = cframe;
      self.presentView.frame = frame;
      self.coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
    }];
    
    
  } completion:^(BOOL finished) {
  }];
}

- (void)hidden
{
  
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  
  if ([rootViewController isKindOfClass:[UINavigationController class]]) {
    
    UINavigationController *nav = (UINavigationController *)rootViewController;
    nav.interactivePopGestureRecognizer.enabled = YES;
  }
  
  [UIView animateWithDuration:0.3 animations:^{
    
    CGRect frame = self.presentView.frame;
    CGRect cframe = self.coverView.frame;
    
    frame.origin.y = self.frame.size.height;
    cframe.size.height = self.frame.size.height;
    
    self.presentView.frame = frame;
    
    self.coverView.alpha = 0;
    self.coverView.frame = cframe;
    
    
  } completion:^(BOOL finished) {
    if (finished) {
      [self removeFromSuperview];
    }
  }];

}

- (void)reloadProvinceTable:(NSArray *)provinces
{
  _dataSouce = provinces;
  UITableView *tableView = self.tableViews.firstObject;
  [tableView reloadData];
}

- (void)reloadCityTable:(NSArray *)cities
{
  _dataSouce1 = cities;
  UITableView *tableView = self.tableViews.count > 1 ? self.tableViews[1] : nil;
  [tableView reloadData];
}
- (void)reloadDistrictTable:(NSArray *)districts
{
  if (districts.count == 0 || !districts) {
    [self setUpAddress:self.selectedItem];
    return;
  }
  _dataSouce2 = districts;
  UITableView *tableView = self.tableViews.count > 2 ? self.tableViews[2] : nil;
  [tableView reloadData];
}

#pragma mark - setUp UI

- (void)setUp
{
  CGSize size = [UIScreen mainScreen].bounds.size;
  
  self.frame = CGRectMake(0, 0, size.width, size.height);
  
  _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
  _coverView.backgroundColor = kClearColor;
  [self addSubview:_coverView];
  
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(hidden)];
  [self.coverView addGestureRecognizer:tapGesture];
  tapGesture.delegate = self;
  
  _presentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 350)];
  [self addSubview:_presentView];
  
  
  UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, kHYTopViewHeight)];
  topView.backgroundColor = [UIColor whiteColor];
  [_presentView addSubview:topView];
  UILabel * titleLabel = [[UILabel alloc] init];
  titleLabel.text = @"所在地区";
  titleLabel.textColor = kTextColor;
  titleLabel.font = [UIFont systemFontOfSize:15];
  [titleLabel sizeToFit];
  [topView addSubview:titleLabel];

  titleLabel.center = CGPointMake(topView.frame.size.width * 0.5, topView.frame.size.height * 0.5);
  
  
  UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [topView addSubview:closeButton];
  closeButton.frame = CGRectMake(topView.frame.size.width - 60 , 0, 45, kHYTopViewHeight);
  [closeButton setTitle:@"取消" forState:UIControlStateNormal];
  closeButton.titleLabel.font = kFont(15);
  [closeButton setTitleColor:kMainColor forState:UIControlStateNormal];
  [closeButton addTarget:self action:@selector(hidden)];
  

  UIView * separateLine = [self separateLine];
  [topView addSubview: separateLine];
  
  CGRect separateLineframe = separateLine.frame;
  separateLineframe.origin.y = topView.frame.size.height - separateLine.frame.size.height;
  separateLine.frame = separateLineframe;
  
  
  
  ZMBAddressView * topTabbar = [[ZMBAddressView alloc]initWithFrame:CGRectMake(0, topView.frame.size.height, _presentView.frame.size.width, kHYTopTabbarHeight)];
  [_presentView addSubview:topTabbar];
  _topTabbar = topTabbar;
  [self addTopBarItem];
  UIView * separateLine1 = [self separateLine];
  [topTabbar addSubview: separateLine1];
  CGRect separateLine1Frame = separateLine1.frame;
  separateLine1Frame.origin.y = topTabbar.frame.size.height - separateLine.frame.size.height;
  separateLine1.frame = separateLine1Frame;
  
  [_topTabbar layoutIfNeeded];
  topTabbar.backgroundColor = [UIColor whiteColor];
  
  UIView * underLine = [[UIView alloc] initWithFrame:CGRectZero];
  [topTabbar addSubview:underLine];
  _underLine = underLine;
    CGRect underLineFrame = underLine.frame;
    underLineFrame.size.height = 2.0f;
    underLine.frame = underLineFrame;
  
  UIButton * btn = self.topTabbarItems.lastObject;
  [self changeUnderLineFrame:btn];
  
  underLineFrame.origin.y = separateLine1.frame.origin.y - underLine.frame.size.height;
  underLine.frame = underLineFrame;
  
  
  _underLine.backgroundColor = [UIColor orangeColor];
  UIScrollView * contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topTabbar.frame), _presentView.frame.size.width, _presentView.frame.size.height - kHYTopViewHeight - kHYTopTabbarHeight)];
  contentView.contentSize = CGSizeMake(HYScreenW, 0);
  [_presentView addSubview:contentView];
  _contentView = contentView;
  _contentView.pagingEnabled = YES;
  [self addNewTableView];
  _contentView.delegate = self;
}


- (void)addNewTableView
{
  
  UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViews.count * HYScreenW, 0, HYScreenW, _contentView.frame.size.height)];
  [_contentView addSubview:tableView];
  [self.tableViews addObject:tableView];
  tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  tableView.delegate = self;
  tableView.dataSource = self;
  tableView.rowHeight = 40;
  [tableView registerClass:[ZMBAddressCell class] forCellReuseIdentifier:@"ZMBAddressCell"];
}

- (void)addTopBarItem
{
  
  UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
  [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
  [topBarItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  topBarItem.titleLabel.font = [UIFont systemFontOfSize:14];
  [topBarItem sizeToFit];
  topBarItem.center = CGPointMake(_topTabbar.center.x, _topTabbar.frame.size.height * 0.5);
  [self.topTabbarItems addObject:topBarItem];
  [_topTabbar addSubview:topBarItem];
  [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
  if([self.tableViews indexOfObject:tableView] == 0){
    return self.dataSouce.count;
  }else if ([self.tableViews indexOfObject:tableView] == 1){
    return self.dataSouce1.count;
  }else if ([self.tableViews indexOfObject:tableView] == 2){
    return self.dataSouce2.count;
  }
  return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  ZMBAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ZMBAddressCell" forIndexPath:indexPath];
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  //省级别
  if([self.tableViews indexOfObject:tableView] == 0){
    
    ZMBAddressItem * item = self.dataSouce[indexPath.row];
    cell.addressLabel.text = item.name;
    cell.isSelected = item.isSelected;
    
    //市级别
  }else if ([self.tableViews indexOfObject:tableView] == 1){
//    NSIndexPath * indexPath0 = [self.tableViews.firstObject indexPathForSelectedRow];
    ZMBAddressItem * item = self.dataSouce1[indexPath.row];
    cell.addressLabel.text = item.name;
    cell.isSelected = item.isSelected;
    
    //区级别
  }else if ([self.tableViews indexOfObject:tableView] == 2){
    //        cell.addressLabel.text = self.dataSouce2[indexPath.row];
    ZMBAddressItem * item = self.dataSouce2[indexPath.row];
    cell.addressLabel.text = item.name;
    cell.isSelected = item.isSelected;
  }
  
  return cell;
}

#pragma mark - TableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];

  if([self.tableViews indexOfObject:tableView] == 0){
    
    ZMBAddressItem *item = self.dataSouce[indexPath.row];
    self.selectedItem = item;

    //之前有选中省，重新选择省,切换省.
    if (indexPath0 != indexPath && indexPath0) {
      
      for (int i = 0; i < self.tableViews.count; i++) {
        [self removeLastItem];
      }
      [self addTopBarItem];
      [self addNewTableView];
      [self scrollToNextItem:item.name];
      [self.delegate addressSelectionView:self willSelectedProvince:item.Id];

      return indexPath;
    }
    //之前未选中省，第一次选择省
    [self addTopBarItem];
    [self addNewTableView];
    [self scrollToNextItem:item.name];
    
    [self.delegate addressSelectionView:self willSelectedProvince:item.Id];

 
  }
  else if ([self.tableViews indexOfObject:tableView] == 1){
    
    ZMBAddressItem * item = self.dataSouce1[indexPath.row];
    self.selectedItem = item;

    //重新选择市,切换市
    if (indexPath0 != indexPath && indexPath0) {
      [self removeLastItem];
      [self addTopBarItem];
      [self addNewTableView];
      [self scrollToNextItem:item.name];
      [self.delegate addressSelectionView:self willSelectedCity:item.Id];
       return indexPath;
    }
    
    [self addTopBarItem];
    [self addNewTableView];
    [self scrollToNextItem:item.name];
    
    [self.delegate addressSelectionView:self willSelectedCity:item.Id];
    
    return indexPath;
  }
  else if ([self.tableViews indexOfObject:tableView] == 2){
    
    ZMBAddressItem * item = self.dataSouce2[indexPath.row];
    self.selectedItem = item;
    [self setUpAddress:item];
  
  }


  return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  ZMBAddressCell * cell = [tableView cellForRowAtIndexPath:indexPath];
  cell.isSelected = YES;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  ZMBAddressCell * cell = [tableView cellForRowAtIndexPath:indexPath];
  cell.isSelected = NO;
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  
  if (scrollView == _contentView) {
    NSInteger index = _contentView.contentOffset.x / HYScreenW;
    [UIView animateWithDuration:0.25 animations:^{
      [self changeUnderLineFrame:self.topTabbarItems[index]];
    }];
  }
}

#pragma mark - private

//点击按钮,滚动到对应位置
- (void)topBarItemClick:(UIButton *)btn
{
  
  NSInteger index = [self.topTabbarItems indexOfObject:btn];
  
  [UIView animateWithDuration:0.5 animations:^{
    self.contentView.contentOffset = CGPointMake(index * HYScreenW, 0);
    [self changeUnderLineFrame:btn];
  }];
}

//调整指示条位置
- (void)changeUnderLineFrame:(UIButton  *)btn
{

  CGRect underLineFrame = _underLine.frame;
  underLineFrame.origin.x = btn.frame.origin.x;
  underLineFrame.size.width = btn.frame.size.width;
  _underLine.frame = underLineFrame;
}

//完成地址选择,执行chooseFinish代码块
- (void)setUpAddress:(ZMBAddressItem *)addressItem
{
  
  NSInteger index = self.contentView.contentOffset.x / HYScreenW;
  UIButton * btn = self.topTabbarItems[index];
  [btn setTitle:addressItem.name forState:UIControlStateNormal];
  [btn sizeToFit];
  [_topTabbar layoutIfNeeded];
  [self changeUnderLineFrame:btn];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    [self hidden];
    
    if (self.addressSelectionFinished) {
      self.addressSelectionFinished(addressItem.Id,addressItem.fullName);
    }
  });
}

//当重新选择省或者市的时候，需要将下级视图移除。
- (void)removeLastItem
{
  
  [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
  [self.tableViews removeLastObject];
  
  [self.topTabbarItems.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
  [self.topTabbarItems removeLastObject];
}

//滚动到下级界面,并重新设置顶部按钮条上对应按钮的title
- (void)scrollToNextItem:(NSString *)preTitle
{
  
  NSInteger index = self.contentView.contentOffset.x / HYScreenW;
  UIButton * btn = self.topTabbarItems[index];
  [btn setTitle:preTitle forState:UIControlStateNormal];
  [btn sizeToFit];
  [_topTabbar layoutIfNeeded];
  [UIView animateWithDuration:0.25 animations:^{
    CGSize  size = self.contentView.contentSize;
    self.contentView.contentSize = CGSizeMake(size.width + HYScreenW, 0);
    CGPoint offset = self.contentView.contentOffset;
    self.contentView.contentOffset = CGPointMake(offset.x + HYScreenW, offset.y);
    [self changeUnderLineFrame: [self.topTabbar.subviews lastObject]];
  }];
}


#pragma mark - getter 方法

//分割线
- (UIView *)separateLine
{
  
  UIView * separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
  separateLine.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
  return separateLine;
}

- (NSMutableArray *)tableViews
{
  
  if (_tableViews == nil) {
    _tableViews = [NSMutableArray array];
  }
  return _tableViews;
}

- (NSMutableArray *)topTabbarItems
{
  if (_topTabbarItems == nil) {
    _topTabbarItems = [NSMutableArray array];
  }
  return _topTabbarItems;
}

//省级别数据源
- (NSArray *)dataSouce
{
  
  if (_dataSouce == nil) {
    _dataSouce = [NSArray array];

      }
  return _dataSouce;
}


//市级别数据源
- (NSArray *)dataSouce1
{
  
  if (_dataSouce1 == nil) {
    
    _dataSouce1 = [NSArray array];
  }
  return _dataSouce1;
}

//区级别数据源
- (NSArray *)dataSouce2
{
  
  if (_dataSouce2 == nil) {
    
    _dataSouce2 = [NSArray array];
  }
  return _dataSouce2;
}

@end
