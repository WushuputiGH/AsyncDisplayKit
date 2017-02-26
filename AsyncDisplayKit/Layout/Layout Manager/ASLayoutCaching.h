//
//  ASLayoutCaching.h
//  ASDK-Layout-Test
//
//  Created by Michael Schneider on 2/17/17.
//  Copyright © 2017 mischneider. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASDimension.h"

NS_ASSUME_NONNULL_BEGIN

@class ASDisplayNode;
@class ASLayout;
@protocol ASLayoutType;

@protocol ASLayoutCacheInvalidating <NSObject>

/**
 * Invalidates all cached layouts for the given node.
 *
 * This method may be called from any thread.
 */
- (void)invalidateCachedLayoutsForNode:(ASDisplayNode *)nonde;

@end

@protocol ASLayoutCaching <ASLayoutCacheInvalidating>

/**
 * Returns the cached layout for a node with a specific size or nil if no
 * cached layout is availbale.
 */
- (nullable ASLayout *)cachedLayoutForNode:(ASDisplayNode *)node sizeRange:(ASSizeRange)sizeRange parentSize:(CGSize)parentSize;

/**
 * Returns the cached layout for a node's frame
 * cached layout is availbale.
 */
- (nullable ASLayout *)cachedLayoutForNode:(ASDisplayNode *)node frame:(CGRect)frame;

/**
 * Set a given layout for a node.
 */
- (void)setCachedLayout:(ASLayout *)layout forNode:(ASDisplayNode *)node sizeRange:(ASSizeRange)sizeRange parentSize:(CGSize)parentSize;

@end

NS_ASSUME_NONNULL_END
