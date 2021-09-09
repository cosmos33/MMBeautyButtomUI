//
//  MMButtonItems.m
//  MMBeautyKit_Example
//
//  Created by sunfei on 2020/9/21.
//  Copyright © 2020 sunfei_fish@sina.cn. All rights reserved.
//

#import "MMButtonItems.h"

@interface MMButtonItems ()

@property (nonatomic, strong) UILabel *selectedLabel;
@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) NSLayoutConstraint *centerXLC;

@end

@implementation MMButtonItems

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewWithTitles:titles];
    }
    return self;
}

- (void)setupViewWithTitles:(NSArray<NSString *> *)titles {
    
    UIView *markView = [[UIView alloc] init];
    markView.translatesAutoresizingMaskIntoConstraints = NO;
    markView.backgroundColor = UIColor.whiteColor;
    _markView = markView;
    [self addSubview:markView];
    
    [markView.widthAnchor constraintEqualToConstant:10].active = YES;
    [markView.heightAnchor constraintEqualToConstant:2].active = YES;
    [markView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;

    NSInteger index = 100;
    NSMutableArray<UILabel *> *labels = [NSMutableArray array];
    for (NSString *title in titles) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.6];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleLabel.text = title;
        [labels addObject:titleLabel];
        titleLabel.userInteractionEnabled = YES;
        titleLabel.tag = index;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClicked:)];
        [titleLabel addGestureRecognizer:tap];
        ++index;
    }
    
    UIStackView *hStackView = [[UIStackView alloc] initWithArrangedSubviews:labels];
    hStackView.translatesAutoresizingMaskIntoConstraints = NO;
    hStackView.axis = UILayoutConstraintAxisHorizontal;
    hStackView.alignment = UIStackViewAlignmentCenter;
    hStackView.distribution = UIStackViewDistributionFill;
    hStackView.spacing = 15;
    [self addSubview:hStackView];
    
    [hStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [hStackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [hStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
    self.centerXLC = [markView.centerXAnchor constraintEqualToAnchor:labels[0].centerXAnchor];
    self.centerXLC.active = YES;
}

- (void)labelClicked:(UITapGestureRecognizer *)tap {
    UILabel *label = (UILabel *)[tap view];
    if (label.tag == _selectedLabel.tag) {
        return;
    }
    _selectedLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.6];
    _selectedLabel = label;
    label.textColor = UIColor.whiteColor;
    self.centerXLC.active = NO;
    self.centerXLC = [_markView.centerXAnchor constraintEqualToAnchor:_selectedLabel.centerXAnchor];
    self.centerXLC.active = YES;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
    
    self.buttonItemClicked ? self.buttonItemClicked(label.tag - 100) : nil;
}

- (void)selectIndex:(NSInteger)index {
    
    if (_selectedLabel) {
        _selectedLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.6];
    }
    
    UILabel *currentLabel = [self viewWithTag:index + 100];
    currentLabel.textColor = [UIColor whiteColor];
    _selectedLabel = currentLabel;
    
    self.centerXLC.active = NO;
    self.centerXLC = [_markView.centerXAnchor constraintEqualToAnchor:_selectedLabel.centerXAnchor];
    self.centerXLC.active = YES;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
    
    self.buttonItemClicked ? self.buttonItemClicked(index) : nil;
}

@end
