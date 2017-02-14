//
//  AddressItem.h
//  ChooseLocation
//
//  Created by Sekorm on 16/8/26.
//  Copyright © 2016年 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMBAddressItem : NSObject

@property (nonatomic,copy) NSString *Id;

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *fullName;


@property (nonatomic,assign) BOOL  isSelected;

+ (instancetype)initWithName:(NSString *)name isSelected:(BOOL)isSelected;

+ (instancetype)initWithId:(NSString *)Id name:(NSString *)name fullName:(NSString *)fullName;


@end
