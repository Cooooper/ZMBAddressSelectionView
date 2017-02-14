//
//  ChooseLocationView.h
//  ChooseLocation
//
//  Created by Sekorm on 16/8/22.
//  Copyright © 2016年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZMBAddressItem.h"

@class ZMBAddressSelectionView;

@protocol ZMBAddressSelectionViewDelegate <NSObject>

- (void)addressSelectionView:(ZMBAddressSelectionView *)selectionView willSelectedProvince:(NSString *)provinceId;
- (void)addressSelectionView:(ZMBAddressSelectionView *)selectionView willSelectedCity:(NSString *)cityId;


@end

@interface ZMBAddressSelectionView : UIView

@property (nonatomic,weak) id<ZMBAddressSelectionViewDelegate> delegate;

@property (nonatomic, copy) void(^addressSelectionFinished)(NSString *Id,NSString *fullName);

- (void)showInView:(UIView *)view;

- (void)reloadProvinceTable:(NSArray *)provinces;
- (void)reloadCityTable:(NSArray *)cities;
- (void)reloadDistrictTable:(NSArray *)districts;


@end
