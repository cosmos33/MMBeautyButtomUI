//
//  MMBeautyBottomView.h
//  MMBeautyKit_Example
//
//  Created by sunfei on 2020/9/21.
//  Copyright © 2020 sunfei_fish@sina.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMBottomViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMBeautyBottomView : UIView

@property (nonatomic, copy) void(^reset)(MMBottomViewModelItem *item);
@property (nonatomic, copy) void(^valueChaged)(MMBottomViewModelItem *item, NSInteger type);
@property (nonatomic, copy) void(^selectedModel)(MMBottomViewModelItem *item);
@property (nonatomic, copy) void(^clickSliderView)(void);
@property (nonatomic, copy) void(^originImage)(BOOL touchInside);

- (instancetype)initWithFrame:(CGRect)frame photoEdit:(BOOL)photoEdit;

- (void)selectTab:(NSInteger)tabIndex;

- (NSArray *)getAllselectedMakeUpItems;

- (void)setModels:(NSArray<MMBottomViewModel *> *)models;

@end

NS_ASSUME_NONNULL_END
