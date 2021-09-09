    //
//  MMBeautyBottomRecordView.m
//  MMBeautyKit_Example
//
//  Created by sunfei on 2020/9/29.
//  Copyright © 2020 sunfei_fish@sina.cn. All rights reserved.
//

#import "MMBeautyBottomRecordView.h"
#import "MMBeautyBottomView.h"


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

static NSArray * kMMBeautyKitOnceBeuatyArray(){
    static dispatch_once_t onceToken;
    static NSArray * array = nil;
    dispatch_once(&onceToken, ^{
        NSURL *path = [[NSBundle bundleForClass:MMBeautyBottomRecordView.class] URLForResource:@"MMBeautyKit" withExtension:@"bundle"];
        NSURL *jsonPath = [[NSBundle bundleWithURL:path] URLForResource:@"MMBeautyAutoModel" withExtension:@"geojson"];
        array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:jsonPath] options:0 error:nil];
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
            sself.reset ? sself.reset(item) : nil;
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
        NSLog(@"%@",obj);
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
        NSDictionary *dict = [kMMBeautyAutoModelArray() objectAtIndex:0];
        MMBottomViewModel *model = [[MMBottomViewModel alloc] initWithItem:dict];
        [models addObject:model];
    }
    if (options & MMBeautyUIItemKeyBeauty || options == MMBeautyUIItemKeyAll) {
        [models addObject:[[MMBottomViewModel alloc] initWithItem:[kMMBeautyAutoModelArray() objectAtIndex:1]]];
    }
    if (options & MMBeautyUIItemKeyMicroSurgery || options == MMBeautyUIItemKeyAll) {
        [models addObject:[[MMBottomViewModel alloc] initWithItem:[kMMBeautyAutoModelArray() objectAtIndex:2]]];
    }
    if (options & MMBeautyUIItemKeyMakeupStyle || options == MMBeautyUIItemKeyAll) {
        [models addObject:[[MMBottomViewModel alloc] initWithItem:[kMMBeautyAutoModelArray() objectAtIndex:3]]];
    }
    if (options & MMBeautyUIItemKeyMakeup || options == MMBeautyUIItemKeyAll) {
        [models addObject:[[MMBottomViewModel alloc] initWithItem:[kMMBeautyAutoModelArray() objectAtIndex:4]]];
    }
    if (options & MMBeautyUIItemKeyLookUp || options == MMBeautyUIItemKeyAll) {
        [models addObject:[[MMBottomViewModel alloc] initWithItem:[kMMBeautyAutoModelArray() objectAtIndex:5]]];
    }
    return models;
}

- (NSArray *)getAllselectedMakeUpItems{
    return [self.beautyView getAllselectedMakeUpItems];
}
@end
