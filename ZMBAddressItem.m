//
//  AddressItem.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/26.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "ZMBAddressItem.h"

@implementation ZMBAddressItem

+ (instancetype)initWithName:(NSString *)name isSelected:(BOOL)isSelected{
    
    ZMBAddressItem * item = [[ZMBAddressItem alloc]init];
    item.name = name;
    item.isSelected = isSelected;
    return item;
}

+ (instancetype)initWithId:(NSString *)Id name:(NSString *)name fullName:(NSString *)fullName
{
  ZMBAddressItem * item = [[ZMBAddressItem alloc]init];
  item.Id = Id;
  item.name = name;
  item.fullName = fullName;
  return item;
}

@end
