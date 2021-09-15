//
//  MMBeautyBottomRecordView.h
//  MMBeautyKit_Example
//
//  Created by sunfei on 2020/9/29.
//  Copyright © 2020 sunfei_fish@sina.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMBottomViewModel.h"

typedef NSString *MMBeautyUIStringKey NS_STRING_ENUM;


typedef NS_ENUM(NSUInteger, MMBeautyUIItemKey) {
    MMBeautyUIItemKey_OnceBeauty, // 一键美颜
    MMBeautyUIItemKey_Beauty,
    MMBeautyUIItemKey_MicroSurgery,
    MMBeautyUIItemKey_Makeup,
    MMBeautyUIItemKey_MakupStyle,
    MMBeautyUIItemKey_Lookup,
};

typedef NS_OPTIONS(NSUInteger, MMBeautyUIItemKeyOptions) {
    // detector to enable
    MMBeautyUIItemKeyOnceBeauty = 1 << 1,               // 一键美颜
    MMBeautyUIItemKeyBeauty = 1 << 2,                   // 美颜
    MMBeautyUIItemKeyMicroSurgery = 1 << 3,             // 微整形
    MMBeautyUIItemKeyMakeupStyle = 1 << 4,              // 风格妆
    MMBeautyUIItemKeyMakeup = 1 << 5,                   // 美妆
    MMBeautyUIItemKeyLookUp = 1 << 6,                   // 滤镜
    
    MMBeautyUIItemKeyAll = MMBeautyUIItemKeyOnceBeauty | MMBeautyUIItemKeyBeauty | MMBeautyUIItemKeyMicroSurgery | MMBeautyUIItemKeyMakeupStyle | MMBeautyUIItemKeyMakeup | MMBeautyUIItemKeyLookUp
};

NS_ASSUME_NONNULL_BEGIN
@interface MMBeautyBottomRecordView : UIView

- (instancetype)initWithOptions:(MMBeautyUIItemKeyOptions)options andFrame:(CGRect)frame;

@property (nonatomic, copy) void(^reset)(NSString * key,CGFloat value);
@property (nonatomic, copy) void(^valueChaged)(MMBottomViewModelItem *item, NSInteger type);
@property (nonatomic, copy) void(^selectedModel)(MMBottomViewModelItem *item);

@property (nonatomic, copy) void(^originImage)(BOOL touchInside);
@property (nonatomic, copy) void(^clickSliderView)(void);

- (NSArray *)getAllselectedMakeUpItems;

@end

NS_ASSUME_NONNULL_END
