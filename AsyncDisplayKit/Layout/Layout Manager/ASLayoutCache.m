//
//  ASLayoutCache.m
//  ASDK-Layout-Test
//
//  Created by Michael Schneider on 2/17/17.
//  Copyright © 2017 mischneider. All rights reserved.
//

#import "ASLayoutCache.h"
#import "ASLayoutCacheEntry.h"

#import "ASLayout.h"

@interface ASLayoutCache ()
@property (nonatomic, strong) NSCache<ASDisplayNode *, ASLayoutCacheEntry *> *cache;
@property (nonatomic, strong) NSLock *lock;
@end

@implementation ASLayoutCache

- (instancetype)init
{
  if (self = [super init]) {
    _cache = [[NSCache alloc] init];
    _lock = [[NSLock alloc] init];
  }
  return self;
}

#pragma mark - ASLayoutCacheInvalidating

- (void)invalidateCachedLayoutsForNode:(ASDisplayNode *)node
{
  [_cache removeObjectForKey:node];
}

#pragma mark - ASLayoutCaching

- (nullable ASLayout *)cachedLayoutForNode:(ASDisplayNode *)node sizeRange:(ASSizeRange)sizeRange parentSize:(CGSize)parentSize
{
  ASLayoutCacheEntry *entry = [_cache objectForKey:node];
  [_lock lock];
    ASLayout *layout = [entry layoutForSizeRange:sizeRange parentSize:parentSize];
  [_lock unlock];
  return layout;
}

- (nullable ASLayout *)cachedLayoutForNode:(ASDisplayNode *)node size:(CGSize)size
{
  ASLayoutCacheEntry *entry = [_cache objectForKey:node];
  [_lock lock];
    ASLayout *layout = nil;
    NSArray *layouts = [entry layoutsForSize:size];
    for (ASLayout *l in layouts) {
      if (l.layoutElement == (id<ASLayoutElement>)node) {
        layout = l;
        break;
      }
    }
  [_lock unlock];
  return layout;
}

- (void)setCachedLayout:(ASLayout *)layout forNode:(ASDisplayNode *)node sizeRange:(ASSizeRange)sizeRange parentSize:(CGSize)parentSize
{
  [_lock lock];
    ASLayoutCacheEntry *entry = [_cache objectForKey:node];
    if (entry == nil) {
      entry = [[ASLayoutCacheEntry alloc] init];
      [_cache setObject:entry forKey:node];
    } else {
        NSLog(@"what??");
    }
    [entry addLayout:layout forSizeRange:sizeRange parentSize:parentSize];
  [_lock unlock];
}


@end
