//
//  ASLayoutCacheEntry.h
//  ASDK-Layout-Test
//
//  Created by Adlai Holler on 2/17/17.
//  Copyright © 2017 mischneider. All rights reserved.
//

#import "ASBaseDefines.h"
#import "ASDimension.h"

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

NS_ASSUME_NONNULL_BEGIN

@class ASDisplayNode;
@class ASLayout;
@protocol ASLayoutType;

/**
 * Private class used only by ASLayoutCache.
 *
 * Not thread-safe.
 */
AS_SUBCLASSING_RESTRICTED
@interface ASLayoutCacheEntry : NSObject

- (void)addLayout:(ASLayout *)layout forSizeRange:(ASSizeRange)sizeRange parentSize:(CGSize)parentSize;

- (nullable ASLayout *)layoutForSizeRange:(ASSizeRange)sizeRange parentSize:(CGSize)parentSize;

/// Returns all layouts for a specific size
- (nullable NSArray<ASLayout *> *)layoutsForSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
