//
//  ASLayoutType.m
//  ASDK-Layout-Test
//
//  Created by Adlai Holler on 2/17/17.
//  Copyright © 2017 mischneider. All rights reserved.
//

#import "ASLayoutType.h"
#import <UIKit/UIGeometry.h>



@interface ASLayoutBase ()
@property (nonatomic, strong, readonly) NSMapTable<id, NSValue *> *frames;
@end

@implementation ASLayoutBase

@synthesize size =_size;

- (instancetype)initWithSize:(CGSize)size frames:(NSMapTable<id, NSValue *> *)frames
{
  if (self = [super init]) {
    _size = size;
    _frames = [ASLayoutBase copyMapTable:frames];
  }
  return self;
}

- (CGRect)frameForNode:(id)node
{
  return [_frames objectForKey:node].CGRectValue;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

#pragma mark - Helpers

// Makes a copy with pointer functions suitable for ASLayout.
+ (NSMapTable *)copyMapTable:(NSMapTable *)source
{
  NSMapTable *result = [NSMapTable mapTableWithKeyOptions:(NSMapTableWeakMemory | NSMapTableObjectPointerPersonality) valueOptions:NSMapTableStrongMemory];
  for (id key in source) {
    id object = [source objectForKey:key];
    [result setObject:object forKey:key];
  }
  return result;
}

@end
