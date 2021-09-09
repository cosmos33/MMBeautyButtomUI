//
//  MMBeautyTabView.h
//  MMBeautyKit_Example
//
//  Created by sunfei on 2020/9/21.
//  Copyright © 2020 sunfei_fish@sina.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMBottomViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMBeautyTabView : UIView

- (void)setModels:(NSArray<MMBottomViewModel *> *)models;

- (void)updateLabel:(CGFloat)sliderValue;

- (void)selectTab:(NSInteger)tabIndex;

@property (nonatomic, copy) void(^resetButtonClicked)(NSArray<MMBottomViewModel *> *, NSIndexPath *indexPath);
@property (nonatomic, copy) void(^selectedModel)(NSArray<MMBottomViewModel *> *models, NSIndexPath *indexPath);

- (NSArray *)getAllselectedMakeUpItems;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
