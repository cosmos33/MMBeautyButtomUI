//
//  MMBottomViewModel.m
//  MMBeautyKit_Example
//
//  Created by sunfei on 2020/9/22.
//  Copyright © 2020 sunfei_fish@sina.cn. All rights reserved.
//

#import "MMBottomViewModel.h"

@interface MMBottomViewModelItem ()

@property (nonatomic, readwrite, weak) MMBottomViewModel *model;

@end

@implementation MMBottomViewModelItem

- (instancetype)initWithItem:(NSDictionary *)item {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:item];
        
        _curPos = [self.value floatValue];
        _version = [item objectForKey:@"version"];
        NSString * selected = [item objectForKey:@"selected"];
        if (selected) {
            _selected = selected.intValue;
        } else{
            _selected = NO;
        }
     
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@",key);
}

- (void)setNilValueForKey:(NSString *)key{
    NSLog(@"%@",key);
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _title = [coder decodeObjectForKey:@"title"];
        _icon = [coder decodeObjectForKey:@"icon"];
        _highlight = [coder decodeObjectForKey:@"highlight"];
        _value = [coder decodeObjectForKey:@"value"];
        _type = [coder decodeObjectForKey:@"type"];
        _identifier = [coder decodeObjectForKey:@"identifier"];
        _index = [coder decodeObjectForKey:@"index"];
        _curPos = [coder decodeFloatForKey:@"curPos"];
        _sliderType = [coder decodeObjectForKey:@"sliderType"];
        _version = [coder decodeObjectForKey:@"version"];
        _selected = [coder decodeBoolForKey:@"selected"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.icon forKey:@"icon"];
    [coder encodeObject:self.highlight forKey:@"highlight"];
    [coder encodeObject:self.value forKey:@"value"];
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeObject:self.identifier forKey:@"identifier"];
    [coder encodeObject:self.index forKey:@"index"];
    [coder encodeFloat:self.curPos forKey:@"curPos"];
    [coder encodeObject:self.sliderType forKey:@"sliderType"];
    [coder encodeObject:self.version forKey:@"version"];
    [coder encodeBool:self.selected forKey:@"selected"];
}

@end




@interface MMBottomViewBuautyModelItem ()

@property (nonatomic, readwrite) NSMutableArray <MMBottomViewModelItem *>* contents;

@end

@implementation MMBottomViewBuautyModelItem


- (instancetype)initWithItem:(NSDictionary *)item {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:item];
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *dict in item[@"contents"]) {
            MMBottomViewModelItem *tmpItem = [[MMBottomViewModelItem alloc] initWithItem:dict];
            [array addObject:tmpItem];
        }
        _contents = array.copy;
        NSLog(@"%@",item);
    }
    return self;
}

- (NSMutableArray *)allBeautyKeysAndValues{
    NSMutableArray * beautyArray = [NSMutableArray new];
    for (MMBottomViewModelItem *models in self.contents) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        dict[@"type"]=models.type;
        dict[@"value"]=models.value;
        [beautyArray addObject:dict];
    }
    return beautyArray;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _contents = [coder decodeObjectForKey:@"contents"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:self.contents forKey:@"contents"];
}
@end

@interface MMBottomViewModel ()

@end

@implementation MMBottomViewModel

- (instancetype)initWithItem:(NSDictionary *)item {
    self = [super init];
    if (self) {
        _name = item[@"name"];
        _type = item[@"type"];
        NSMutableArray<MMBottomViewModelItem *> *contents = [NSMutableArray array];
        for (NSDictionary *subItem in item[@"contents"]) {
            if ([_type isEqualToString:@"OneClickbeauty"]) {
                MMBottomViewBuautyModelItem *modelItem = [[MMBottomViewBuautyModelItem alloc] initWithItem:subItem];
                modelItem.model = self;
                [contents addObject:(MMBottomViewModelItem *)modelItem];
            } else {
                MMBottomViewModelItem *modelItem = [[MMBottomViewModelItem alloc] initWithItem:subItem];
                modelItem.model = self;
                [contents addObject:modelItem];
            }
        }
        _contents = contents.copy;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _name = [coder decodeObjectForKey:@"name"];
        _type = [coder decodeObjectForKey:@"type"];
        _contents = [coder decodeObjectForKey:@"contents"];
        if ([_type isEqualToString:@"OneClickbeauty"]) {
            for (MMBottomViewBuautyModelItem *item in self.contents) {
                item.model = self;
            }
        } else {
            for (MMBottomViewModelItem *item in self.contents) {
                item.model = self;
            }
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeObject:self.contents forKey:@"contents"];
}

@end
