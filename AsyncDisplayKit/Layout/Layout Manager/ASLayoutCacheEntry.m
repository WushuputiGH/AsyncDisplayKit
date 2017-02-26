//
//  ASLayoutCacheEntry.m
//  ASDK-Layout-Test
//
//  Created by Adlai Holler on 2/17/17.
//  Copyright © 2017 mischneider. All rights reserved.
//

#import "ASLayoutCacheEntry.h"

#import "ASLayoutType.h"
#import "ASLayout.h"

#import <UIKit/UIGeometry.h>

typedef struct ASLayoutCacheEntryKey {
  ASSizeRange sizeRange;
  CGSize parentSize;
} ASLayoutCacheEntryKey;


@interface ASLayoutCacheEntry ()

/**
 * Use a mutable dictionary for now.
 * We could do something much more sophisticated to avoid the hit from boxing.
 */
@property (nonatomic, strong, readonly) NSMutableDictionary<NSValue *, ASLayout *> *layouts;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSValue *, NSArray<ASLayout *> *> *frameLayouts;

@end

@implementation ASLayoutCacheEntry


- (instancetype)init
{
  if (self = [super init]) {
    _layouts = [[NSMutableDictionary alloc] init];
    _frameLayouts = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)addLayout:(ASLayout *)layout forSizeRange:(ASSizeRange)sizeRange parentSize:(CGSize)parentSize
{
  ASLayoutCacheEntryKey entryKey = {.sizeRange = sizeRange, parentSize = parentSize};
  NSValue *key = [NSValue value:&entryKey withObjCType:@encode(ASLayoutCacheEntryKey)];
  _layouts[key] = layout;
  
  NSValue *frameKey = [NSValue valueWithCGRect:layout.frame];
  NSMutableArray *array = (NSMutableArray *)_frameLayouts[frameKey];
  if (array == nil) {
    _frameLayouts[frameKey] = [NSMutableArray array];
  }

  [(NSMutableArray *)_frameLayouts[frameKey] addObject:layout];
}

- (nullable ASLayout *)layoutForSizeRange:(ASSizeRange)sizeRange parentSize:(CGSize)parentSize
{
  ASLayoutCacheEntryKey entryKey = {.sizeRange = sizeRange, parentSize = parentSize};
  NSValue *key = [NSValue value:&entryKey withObjCType:@encode(ASLayoutCacheEntryKey)];
  return _layouts[key];
}

- (nullable NSArray<ASLayout *> *)layoutsForFrame:(CGRect)frame
{
  NSValue *key = [NSValue valueWithCGRect:frame];
  return [_frameLayouts[key] copy];
}

@end
