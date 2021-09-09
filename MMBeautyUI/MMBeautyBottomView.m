//
//  MMBeautyBottomView.m
//  MMBeautyKit_Example
//
//  Created by sunfei on 2020/9/21.
//  Copyright © 2020 sunfei_fish@sina.cn. All rights reserved.
//

#import "MMBeautyBottomView.h"
#import "MMDrawerSlider.h"
#import "MMBeautyTabView.h"

@interface MMBeautyBottomView ()

@property (nonatomic) MMBeautyTabView *tabView;
@property (nonatomic) MMBottomViewModelItem *curItem;
@property (nonatomic, strong) MMDrawerSlider *slider;
@property (nonatomic) NSArray<MMBottomViewModel *> *models;
@end

@implementation MMBeautyBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame photoEdit:NO];
}

- (instancetype)initWithFrame:(CGRect)frame photoEdit:(BOOL)photoEdit {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView:photoEdit];
    }
    return self;
}

- (void)setupView:(BOOL)photoEdit {
    __weak typeof(self) wself = self;
    
    MMDrawerSlider *slider0 = [[MMDrawerSlider alloc] init];
    slider0.translatesAutoresizingMaskIntoConstraints = NO;
    slider0.imageView.hidden = YES;
    slider0.label.text = @"滤镜";
    slider0.sliderValue = 1.0;
    [self addSubview:slider0];
    
    slider0.valueChanged = ^(MMDrawerSlider * _Nonnull slider, CGFloat value) {
        __strong typeof(self) sself = wself;
        sself.curItem.lut = value;
        [sself.tabView updateLabel:value];
        // 滑动滑块调整美颜效果
        sself.valueChaged ? sself.valueChaged(sself.curItem, 1) : nil;
    };
    
    MMDrawerSlider *slider = [[MMDrawerSlider alloc] init];
    slider.translatesAutoresizingMaskIntoConstraints = NO;
    slider.imageView.image = [UIImage imageNamed:@"MMBeautyUI.bundle/constract@2x.png"];
    slider.imageView.userInteractionEnabled = YES;
    [self addSubview:slider];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSlider:)];
    [slider addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    slider.imageView.userInteractionEnabled = YES;
    [slider.imageView addGestureRecognizer:longpress];
    
    slider.valueChanged = ^(MMDrawerSlider * _Nonnull slider, CGFloat value) {
        __strong typeof(self) sself = wself;
        sself.curItem.curPos = value;
        [sself.tabView updateLabel:value];
        // 滑动滑块调整美颜效果
        sself.valueChaged ? sself.valueChaged(sself.curItem, 0) : nil;
    };
    
    MMBeautyTabView *tabView = [[MMBeautyTabView alloc] init];
    tabView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:tabView];
    
    tabView.resetButtonClicked = ^(NSArray<MMBottomViewModel *> * models, NSIndexPath *indexPath) {
        slider.slider.hidden = indexPath.section == 0;
        slider.valueLabel.hidden = indexPath.section == 0;
        __strong typeof(self) sself = wself;
        MMBottomViewModelItem *curItem = models[indexPath.section].contents[indexPath.row];
        if (sself.curItem) {
            sself.curItem = nil;
        }
        [slider setSliderValue:curItem.value.floatValue];
        sself.reset ? sself.reset(curItem) : nil;
    };
    
    tabView.selectedModel = ^(NSArray<MMBottomViewModel *> *models, NSIndexPath *indexPath) {
        __strong typeof(self) sself = wself;
        if (indexPath.row >= 0) {
            MMBottomViewModelItem *curItem;

            if (models.count == 1) {
                curItem = models[0].contents[indexPath.row];
            } else {
                curItem = models[indexPath.section].contents[indexPath.row];
            }
            if ([curItem.type isEqualToString:@"makeup"]) {
                slider0.hidden = NO;
                [slider0 setSliderValue:curItem.lut];
                slider.label.text = @"整妆";
            } else {
                slider0.hidden = YES;
                slider.label.text = @"";
            }
            if ([curItem.title isEqualToString:@"关闭"] || [curItem.title isEqualToString:@"无"] || [curItem.title isEqualToString:@"原图"]) {
                slider.slider.hidden = YES;
                slider0.hidden = YES;
                slider.valueLabel.hidden = YES;
                slider.label.text = @"";
            } else {
                slider.slider.hidden = NO;
                slider.valueLabel.hidden = NO;
            }
            sself.selectedModel ? sself.selectedModel(curItem) : nil;
            sself.curItem = curItem;
            slider.slider.minimumValue = [curItem.sliderType boolValue] ? -1 : 0;
            slider.slider.maximumValue = 1;
            [slider setSliderValue:curItem.curPos];
        }
        if (indexPath.section == 0) {
            slider.slider.hidden = YES;
            slider.valueLabel.hidden = YES;
        }
   
    };
    
    _tabView = tabView;

    [tabView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [tabView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [tabView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [tabView.topAnchor constraintEqualToAnchor:slider.bottomAnchor constant:8].active = YES;
    if (photoEdit) {
        [tabView.heightAnchor constraintEqualToConstant:158].active = YES;
    } else {
        [tabView.heightAnchor constraintEqualToConstant:238].active = YES;
    }
    
    [slider.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [slider.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [slider.heightAnchor constraintEqualToConstant:62].active = YES;
    
    [slider0.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [slider0.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [slider0.heightAnchor constraintEqualToAnchor:slider.heightAnchor].active = YES;
    [slider0.bottomAnchor constraintEqualToAnchor:slider.topAnchor].active = YES;
    _slider = slider;
}

- (void)setModels:(NSArray<MMBottomViewModel *> *)models {
    [self.tabView setModels:models];
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        self.originImage ? self.originImage(YES) : nil;
    } else if (longPress.state == UIGestureRecognizerStateCancelled ||
               longPress.state == UIGestureRecognizerStateEnded ||
               longPress.state == UIGestureRecognizerStateFailed) {
        self.originImage ? self.originImage(NO) : nil;
    }
}
- (void)tapSlider:(UITapGestureRecognizer *)tap{
    if (self.slider.slider.hidden == YES) {
        self.clickSliderView?self.clickSliderView(): nil;
    }
}

- (void)selectTab:(NSInteger)tabIndex {
    self.slider.slider.hidden = tabIndex == 0;
    self.slider.valueLabel.hidden = tabIndex == 0;
    [self.tabView selectTab:tabIndex];
}

- (NSArray *)getAllselectedMakeUpItems{
    return [self.tabView getAllselectedMakeUpItems];
}

- (void)reloadData{
    [self.tabView reloadData];
}

@end
