    //
//  MMBeautyBottomRecordView.m
//  MMBeautyKit_Example
//
//  Created by sunfei on 2020/9/29.
//  Copyright © 2020 sunfei_fish@sina.cn. All rights reserved.
//

#import "MMBeautyBottomRecordView.h"
#import "MMBeautyBottomView.h"
#import <MMBeautyKit/MMBeautyKit-umbrella.h>

extern NSArray * kMMBeautyKitOnceBeuatyArray(){
    static dispatch_once_t onceToken;
    static NSArray * array = nil;
    dispatch_once(&onceToken, ^{
        NSURL *path = [[NSBundle bundleForClass:MMBeautyBottomRecordView.class] URLForResource:@"MMBeautyKit" withExtension:@"bundle"];
        NSURL *jsonPath = [[NSBundle bundleWithURL:path] URLForResource:@"MMBeautyAutoModel" withExtension:@"geojson"];
        array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:jsonPath] options:0 error:nil];
    });
    return array;
}


@interface MMBeautyBottomRecordView ()

@property (nonatomic, strong) MMBeautyBottomView *beautyView;

@property (nonatomic, assign) MMBeautyUIItemKeyOptions itemOptions;

@property (nonatomic, strong) NSMutableArray<MMBottomViewModel *> * models;

@end


static NSArray * kMMBeautyAutoModelArray(){
    static dispatch_once_t onceToken;
    static NSArray * array = nil;
    dispatch_once(&onceToken, ^{
        array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSBundle.mainBundle URLForResource:@"BeautyConfig" withExtension:@"geojson"]] options:0 error:nil];
        
    });
    return array;
}


@implementation MMBeautyBottomRecordView

- (instancetype)initWithOptions:(MMBeautyUIItemKeyOptions)options andFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.itemOptions = options;
        self.models = [NSMutableArray new];
        [self.models addObjectsFromArray:[self getModelWithOptions:self.itemOptions]];
        MMBeautyBottomView *beautyView = [[MMBeautyBottomView alloc] init];
        beautyView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:beautyView];
        _beautyView = beautyView;
        
        __weak typeof(self) wself = self;
        beautyView.valueChaged = ^(MMBottomViewModelItem * _Nonnull item, NSInteger type) {
            __strong typeof(self) sself = wself;
            sself.valueChaged ? sself.valueChaged(item, type) : nil;
        };
        
        beautyView.reset = ^(MMBottomViewModelItem * _Nonnull item) {
            __strong typeof(self) sself = wself;
            NSString *str;
            if ([item.model.type isEqualToString:@"beauty"]) {
                str = @"beauty";
            } else if ([item.model.type isEqualToString:@"OneClickbeauty"]){
                str = @"OneClickbeauty";
            }
            sself.reset ? sself.reset(str,0) : nil;
        };
        
        beautyView.originImage = ^(BOOL touchInside) {
            __strong typeof(self) sself = wself;
            sself.originImage ? sself.originImage(touchInside) : nil;
        };
        
        beautyView.selectedModel = ^(MMBottomViewModelItem * _Nonnull item) {
            __strong typeof(self) sself = wself;
            if ([item.type isEqualToString:@"OneClickbeauty"]) {
                // 更新一键美颜对应的美颜参数值
                [sself updateModelValueWithOnceBeautyModel:item];
            }
            sself.selectedModel ? sself.selectedModel(item) : nil;
        };
        beautyView.clickSliderView = ^{
            __strong typeof(self) sself = wself;
            sself.clickSliderView ? sself.clickSliderView() : nil;
        };
        [beautyView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [beautyView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
        [beautyView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
        [beautyView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        if (self.models) {
            [beautyView setModels:self.models];
        }
    }
    return self;
}

- (void)updateModelValueWithOnceBeautyModel:(MMBottomViewModelItem *)model{
    // 只有包含 美颜 微整形 一键美颜 才会调整一键美颜中的参数
    if (!((self.itemOptions & MMBeautyUIItemKeyMicroSurgery
        && self.itemOptions & MMBeautyUIItemKeyOnceBeauty &&
        self.itemOptions & MMBeautyUIItemKeyBeauty ) || self.itemOptions & MMBeautyUIItemKeyAll)) {
        return;
    }
    NSArray *itemArr = [kMMBeautyKitOnceBeuatyArray() objectAtIndex:model.identifier.intValue];
    MMBottomViewModel *micSurModel = nil;
    MMBottomViewModel *beautyModel = nil;
    if (self.itemOptions & MMBeautyUIItemKeyMicroSurgery) {
        for (MMBottomViewModel *itemModel in self.models) {
            if ([itemModel.name isEqualToString:@"微整形"]) {
                micSurModel = itemModel;
                break;
            }
        }
    }
    if (self.itemOptions & MMBeautyUIItemKeyBeauty) {
        for (MMBottomViewModel *itemModel in self.models) {
            if ([itemModel.name isEqualToString:@"美颜"]) {
                beautyModel = itemModel;
                break;
            }
        }
    }
    [itemArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (MMBottomViewModelItem *beauty in beautyModel.contents) {
            if ([beauty.title isEqualToString:obj[@"title"]]) {
                NSNumber *number = [obj objectForKey:@"value"];
                beauty.curPos = number.floatValue;
                break;
            }
        }
        for (MMBottomViewModelItem *model in micSurModel.contents) {
            if ([model.title isEqualToString:obj[@"title"]]) {
                NSNumber *number = [obj objectForKey:@"value"];
                model.curPos = number.floatValue;
                break;
            }
        }
    }];
    
    [self.beautyView reloadData];
}

- (NSArray<MMBottomViewModel *> *)getModelWithOptions:(MMBeautyUIItemKeyOptions)options{
    NSMutableArray<MMBottomViewModel *> *models = [NSMutableArray array];
    if (options & MMBeautyUIItemKeyOnceBeauty || options == MMBeautyUIItemKeyAll) {
        NSDictionary *dict = nil;
        for (NSDictionary *tmpDic in kMMBeautyAutoModelArray()) {
            if ([[tmpDic objectForKey:@"name"] isEqualToString:@"一键美颜"]) {
                dict = tmpDic;
                break;
            }
        }
        MMBottomViewModel *model = [[MMBottomViewModel alloc] initWithItem:dict];
        [models addObject:model];
    }
    if (options & MMBeautyUIItemKeyBeauty || options == MMBeautyUIItemKeyAll) {
        NSDictionary *dict = nil;
        for (NSDictionary *tmpDic in kMMBeautyAutoModelArray()) {
            if ([[tmpDic objectForKey:@"name"] isEqualToString:@"美颜"]) {
                dict = tmpDic;
                break;
            }
        }
        MMBottomViewModel *model = [[MMBottomViewModel alloc] initWithItem:dict];
        [models addObject:model];
    }
    if (options & MMBeautyUIItemKeyMicroSurgery || options == MMBeautyUIItemKeyAll) {
        NSDictionary *dict = nil;
        for (NSDictionary *tmpDic in kMMBeautyAutoModelArray()) {
            if ([[tmpDic objectForKey:@"name"] isEqualToString:@"微整形"]) {
                dict = tmpDic;
                break;
            }
        }
        MMBottomViewModel *model = [[MMBottomViewModel alloc] initWithItem:dict];
        [models addObject:model];
    }
    if (options & MMBeautyUIItemKeyMakeupStyle || options == MMBeautyUIItemKeyAll) {
        NSDictionary *dict = nil;
        for (NSDictionary *tmpDic in kMMBeautyAutoModelArray()) {
            if ([[tmpDic objectForKey:@"name"] isEqualToString:@"风格妆"]) {
                dict = tmpDic;
                break;
            }
        }
        MMBottomViewModel *model = [[MMBottomViewModel alloc] initWithItem:dict];
        [models addObject:model];
    }
    if (options & MMBeautyUIItemKeyMakeup || options == MMBeautyUIItemKeyAll) {
        NSDictionary *dict = nil;
        for (NSDictionary *tmpDic in kMMBeautyAutoModelArray()) {
            if ([[tmpDic objectForKey:@"name"] isEqualToString:@"美妆"]) {
                dict = tmpDic;
                break;
            }
        }
        MMBottomViewModel *model = [[MMBottomViewModel alloc] initWithItem:dict];
        [models addObject:model];
    }
    if (options & MMBeautyUIItemKeyLookUp || options == MMBeautyUIItemKeyAll) {
        NSDictionary *dict = nil;
        for (NSDictionary *tmpDic in kMMBeautyAutoModelArray()) {
            if ([[tmpDic objectForKey:@"name"] isEqualToString:@"滤镜"]) {
                dict = tmpDic;
                break;
            }
        }
        MMBottomViewModel *model = [[MMBottomViewModel alloc] initWithItem:dict];
        [models addObject:model];
    }
    return models;
}

- (NSArray *)getAllselectedMakeUpItems{
    return [self.beautyView getAllselectedMakeUpItems];
}
@end
