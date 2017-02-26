//
//  ASLayoutType.h
//  ASDK-Layout-Test
//
//  Created by Adlai Holler on 2/17/17.
//  Copyright © 2017 mischneider. All rights reserved.
//

#import "ASBaseDefines.h"
#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

NS_ASSUME_NONNULL_BEGIN


/**
 * A protocol for objects that describe the layout of a given element.
 *
 * The object must support copying, size, and item->frame lookup.
 */
@protocol ASLayoutType <NSCopying>

/**
 * The size of this layout.
 */
@property (nonatomic, readonly) CGSize size;

/**
 * Request the frame for the given object.
 *
 * @param node The node
 *
 * @return The frame.
 */
- (CGRect)frameForNode:(id)node;

@end

/**
 * Immutable object representing the layout for one element.
 */
AS_SUBCLASSING_RESTRICTED
@interface ASLayoutBase : NSObject <ASLayoutType>

/**
 * Create a new layout with the given size and object frames.
 *
 * @param size The size of the layout.
 * @param frames The frames for the layout.
 */
- (instancetype)initWithSize:(CGSize)size frames:(NSMapTable<id, NSValue *> *)frames;

@end

NS_ASSUME_NONNULL_END
