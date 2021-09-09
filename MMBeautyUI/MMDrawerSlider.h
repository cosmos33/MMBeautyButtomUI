//
//  MDRecordFilterDrawerSlider.h
//  MDRecordSDK
//
//  Created by sunfei on 2019/2/20.
//  Copyright © 2019 sunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDrawerSlider : UIView

@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UILabel *label;

@property (nonatomic, copy) void(^valueChanged)(MMDrawerSlider *slider, CGFloat value);

@property (nonatomic, assign) CGFloat sliderValue;

@property (nonatomic, readonly) UISlider *slider;
@property (nonatomic, readonly) UILabel *valueLabel;
@end

NS_ASSUME_NONNULL_END
