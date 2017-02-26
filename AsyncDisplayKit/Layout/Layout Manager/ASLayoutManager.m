//
//  ASLayoutManager.m
//  ASDK-Layout-Test
//
//  Created by Michael Schneider on 2/17/17.
//  Copyright © 2017 mischneider. All rights reserved.
//

#import "ASLayoutManager.h"
#import "ASLayoutCache.h"
#import "ASLayoutType.h"

#import "ASDisplayNode.h"
#import "ASLayout.h"

@interface ASLayoutElementStyle (Private)
- (ASLayoutElementSize)size;
@end

@interface ASLayoutManager ()

/**
 * The layout cache used by this layout manager.
 */
@property (nonatomic, strong, readwrite) id<ASLayoutCaching> layoutCache;

@end

@implementation ASLayoutManager

#pragma mark - Class

+ (instancetype)sharedManager
{
  static ASLayoutManager *sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedManager = [[self alloc] init];
  });
  return sharedManager;
}

#pragma mark - Lifecycle

- (instancetype)init
{
  self = [super init];
  if (self != nil) {
    _layoutCache = [[ASLayoutCache alloc] init];
  }
  return self;
}

#pragma mark - Measurement

- (ASLayout *)layoutForNode:(ASDisplayNode *)node sizeRange:(ASSizeRange)sizeRange parentSize:(CGSize)parentSize
{
  return [node calculateLayoutThatFits:sizeRange restrictedToSize:node.style.size relativeToParentSize:parentSize];
}

#pragma mark - Layout

- (void)layoutSubnodesOfNode:(ASDisplayNode *)node
{
  ASDisplayNodeAssertMainThread();
  
  ASLayout *layout = [self.layoutCache cachedLayoutForNode:node frame:node.frame];
  if (layout == nil) {
    ASSizeRange sizeRange = ASSizeRangeMake(node.bounds.size);
    layout = [self layoutForNode:node sizeRange:sizeRange parentSize:sizeRange.max];
    [self.layoutCache setCachedLayout:layout forNode:node sizeRange:sizeRange parentSize:sizeRange.max];
  }

  for (ASLayout *subnodeLayout in layout.sublayouts) {
    ((ASDisplayNode *)subnodeLayout.layoutElement).frame = subnodeLayout.frame;
  }
}

#pragma mark - Invalidation

- (void)invalidateLayoutOfNode:(ASDisplayNode *)node
{
  [self.layoutCache invalidateCachedLayoutsForNode:node];
  [node setNeedsLayout];
  
  ASDisplayNode *supernode = node.supernode;
  if (supernode != nil) {
    [self.layoutCache invalidateCachedLayoutsForNode:supernode];
  }
}

@end
