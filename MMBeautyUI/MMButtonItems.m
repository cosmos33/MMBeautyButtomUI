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
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) NSMutableArray *titles;

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

   
    UIScrollView *scrollerView = [[UIScrollView alloc] init];
    scrollerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:scrollerView];
    scrollerView.backgroundColor = [UIColor clearColor];
    scrollerView.showsHorizontalScrollIndicator = false;
    [scrollerView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [scrollerView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [scrollerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [scrollerView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    self.scrollerView = scrollerView;
    NSInteger index = 100;
    CGFloat leftCorn = 0;
    CGFloat size = 0;
    NSMutableArray<UILabel *> *labels = [NSMutableArray array];
    for (NSString *title in titles) {
        size += title.length;
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
        
        [scrollerView addSubview:titleLabel];
        [titleLabel.widthAnchor constraintEqualToConstant:title.length * 14.5].active = YES;
        [titleLabel.heightAnchor constraintEqualToConstant:17].active = YES;
        [titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        
        if (index == 100) {
            [titleLabel.leftAnchor constraintEqualToAnchor:scrollerView.leftAnchor constant:5].active = YES;
            self.centerXLC = [self.markView.centerXAnchor constraintEqualToAnchor:titleLabel.centerXAnchor];
            self.centerXLC.active = YES;
        } else {
            [titleLabel.leftAnchor constraintEqualToAnchor:scrollerView.leftAnchor constant:15 * (index - 100) + leftCorn].active = YES;
        }
        ++index;
        leftCorn += title.length * 15;
    }
    self.scrollerView.contentSize = CGSizeMake(size  * 14.5 + (titles.count - 1) * 15 + 5 , 40);
    self.titles = labels;
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
