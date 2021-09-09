//
//  MDRecordFilterDrawerSlider.m
//  MDRecordSDK
//
//  Created by sunfei on 2019/2/20.
//  Copyright © 2019 sunfei. All rights reserved.
//

#import "MMDrawerSlider.h"

@interface MMDrawerSlider()

@property (nonatomic, readwrite) UISlider *slider;
@property (nonatomic, readwrite) UIImageView *imageView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, readwrite) UILabel *label;

@property (nonatomic, weak) NSLayoutConstraint *centerXConstraint;

@end

@implementation MMDrawerSlider

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.translatesAutoresizingMaskIntoConstraints = NO;
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        _slider.continuous = YES;
        _slider.minimumTrackTintColor = [UIColor colorWithRed:0 green:192.0/255 blue:1.0 alpha:1.0];
        _slider.maximumTrackTintColor = UIColor.whiteColor;
        [_slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _label.textColor = UIColor.whiteColor;
        _label.font = [UIFont systemFontOfSize:12];
        _label.textAlignment = NSTextAlignmentRight;
    }
    return _label;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _valueLabel.textColor = UIColor.whiteColor;
        _valueLabel.font = [UIFont systemFontOfSize:14];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.text = 0;
    }
    return _valueLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    [self addSubview:self.slider];
    [self addSubview:self.imageView];
    [self addSubview:self.valueLabel];
    [self addSubview:self.label];
    
    [self.imageView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:28].active = YES;
    [self.imageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.imageView.widthAnchor constraintEqualToConstant:32].active = YES;
    [self.imageView.heightAnchor constraintEqualToAnchor:self.imageView.widthAnchor].active = YES;
    
    [self.slider.centerYAnchor constraintEqualToAnchor:self.imageView.centerYAnchor].active = YES;
    [self.slider.leftAnchor constraintEqualToAnchor:self.imageView.rightAnchor constant:15.5].active = YES;
//    [self.slider.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-33.5].active = YES;
    [self.slider.rightAnchor constraintEqualToAnchor:self.label.leftAnchor constant:-8].active = YES;
    
    [self.label.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-33.5].active = YES;
    [self.label.centerYAnchor constraintEqualToAnchor:self.slider.centerYAnchor].active = YES;
    [self.label.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    [self.label.widthAnchor constraintEqualToConstant:30].active = YES;
    
    self.centerXConstraint = [self.valueLabel.centerXAnchor constraintEqualToAnchor:self.slider.leftAnchor constant:self.slider.currentThumbImage.size.width / 2.0];
    self.centerXConstraint.active = YES;
    [self.valueLabel.bottomAnchor constraintEqualToAnchor:self.slider.topAnchor constant:-8].active = YES;
    
    [self.slider setThumbImage:[UIImage imageNamed:@"MMBeautyUI.bundle/dragbutton@2x.png"] forState:UIControlStateNormal];
}

- (void)valueChanged:(UISlider *)slider {
    
    CGRect trackRect = [self.slider trackRectForBounds:self.slider.bounds];
    CGRect thumbRect = [self.slider thumbRectForBounds:self.slider.bounds
                                             trackRect:trackRect
                                                 value:self.slider.value];
    self.centerXConstraint.active = NO;
    self.centerXConstraint = [self.valueLabel.centerXAnchor constraintEqualToAnchor:self.slider.leftAnchor constant:thumbRect.origin.x + thumbRect.size.width / 2 - 2];
    self.centerXConstraint.active = YES;
    self.valueLabel.text = [NSString stringWithFormat:@"%ld",lround(self.sliderValue * 100)];
    self.valueChanged ? self.valueChanged(self, self.sliderValue) : nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self valueChanged:nil];
}

- (CGFloat)sliderValue {
    return self.slider.value;
}

- (void)setSliderValue:(CGFloat)sliderValue {
    self.slider.value = sliderValue;
    [self valueChanged:nil];
}

@end
