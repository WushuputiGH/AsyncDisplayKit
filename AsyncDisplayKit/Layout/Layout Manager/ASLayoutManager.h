//
//  ASLayoutManager.h
//  ASDK-Layout-Test
//
//  Created by Michael Schneider on 2/17/17.
//  Copyright © 2017 mischneider. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASBaseDefines.h"
#import "ASDimension.h"

@protocol ASLayoutCaching;
@protocol ASLayoutType;
@class ASDisplayNode;
@class ASLayout;

/**
 * A singleton cache / validator object that supports keeping a coherent
 * layout tree for all nodes in the application.
 *
 * The difference between the manager and the engines are that the manager is caching the layouts
 */
AS_SUBCLASSING_RESTRICTED
@interface ASLayoutManager : NSObject

- (instancetype) init __attribute__((unavailable("init not available")));

/**
 * The shared layout manager instance.
 */
@property (class, nonatomic, strong, readonly) ASLayoutManager *sharedManager;

/**
 * Returns the layout for a given node, sizeRange and parentSize.
 */
- (ASLayout *)layoutForNode:(ASDisplayNode *)node sizeRange:(ASSizeRange)sizeRange parentSize:(CGSize)parentSize;

/**
 * Immediately sets the frames of the given node's subnodes using the layout
 * corresponding to the element's bounds.
 *
 * This method must be called on the main thread.
 *
 * This method is called by `-[CALayer layoutSublayers:]` or `-[UIView layoutSubviews]`
 */
- (void)layoutSubnodesOfNode:(ASDisplayNode *)node;

/**
 * Walks up the node hierarchy from the given node,
 * invalidating cached layouts and calling -setNeedsLayout: on the
 * layout for each node, until the root node is reached.
 *
 * TODO: Schedules layout pre-caching.
 */
- (void)invalidateLayoutOfNode:(ASDisplayNode *)node;


@end
