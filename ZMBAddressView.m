//
//  AddressView.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/25.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "ZMBAddressView.h"

static  CGFloat  const  HYBarItemMargin = 15;
@interface ZMBAddressView ()
@property (nonatomic,strong) NSMutableArray * btnArray;
@end

@implementation ZMBAddressView

- (void)layoutSubviews{
  
  [super layoutSubviews];
  
  for (NSInteger i = 0; i <= self.btnArray.count - 1 ; i++) {
    
    UIView * view = self.btnArray[i];
    if (i == 0) {
      CGRect frame = view.frame;
      frame.origin.x = HYBarItemMargin;
      view.frame = frame;
    }
    if (i > 0) {
      UIView * preView = self.btnArray[i - 1];
      CGFloat x = HYBarItemMargin  + preView.frame.origin.x + preView.frame.size.width;
      CGRect frame = view.frame;
      frame.origin.x = x;
      view.frame = frame;
    }
    
  }
}

- (NSMutableArray *)btnArray{
  
  NSMutableArray * mArray  = [NSMutableArray array];
  for (UIView * view in self.subviews) {
    if ([view isKindOfClass:[UIButton class]]) {
      [mArray addObject:view];
    }
  }
  _btnArray = mArray;
  return _btnArray;
}

@end
