//
//  MMBottomViewModel.h
//  MMBeautyKit_Example
//
//  Created by sunfei on 2020/9/22.
//  Copyright © 2020 sunfei_fish@sina.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@class MMBottomViewModel;
@interface MMBottomViewModelItem : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *icon;
@property (nonatomic, readonly) NSString *highlight;
@property (nonatomic, readonly) NSNumber *value;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSNumber *index;
@property (nonatomic, readonly) NSNumber *sliderType;
@property (nonatomic, readonly, weak) MMBottomViewModel *model;

@property (nonatomic, assign) CGFloat curPos;
@property (nonatomic, assign) CGFloat lut;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithItem:(NSDictionary *)item;
@end

@interface MMBottomViewModel : NSObject <NSCoding>

- (instancetype)initWithItem:(NSDictionary *)item;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSArray *contents;

@end


@interface MMBottomViewBuautyModelItem : MMBottomViewModelItem

@property (nonatomic, readonly) NSMutableArray <MMBottomViewModelItem *>* contents;

- (instancetype)initWithItem:(NSDictionary *)item;

- (NSMutableArray *)allBeautyKeysAndValues;

@end
NS_ASSUME_NONNULL_END
