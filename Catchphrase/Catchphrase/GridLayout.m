//
//  GridLayout.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "GridLayout.h"
#import "Constants.h"

// Grid constants
const CGFloat kGridCellMaxSize = 180.0; // Maximum width allowed for grid cells
const CGFloat kGridCellAspectRatio = 5.0/4.0; // Aspect ratio of grid cells

@interface GridLayout()

// Cache grid cell widths at different screen sizes: { collectionView.width : item.width }
@property (nonatomic, strong) NSMutableDictionary *cachedGridLayouts;

@end

@implementation GridLayout

- (id) init
{
    self = [super init];
    
    if(self) {
        [self commonInit];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self commonInit];
    }
    
    return self;
}

- (void) commonInit
{
    _cachedGridLayouts = [NSMutableDictionary new];
}

- (void) prepareLayout
{
    [super prepareLayout];
    
    CGFloat spacing = [Constants spacing] * 2;
    CGFloat size = self.collectionView.frame.size.width;
    
    // Check the cache for grid item sizes at this collection view size; generate if none found
    if([self.cachedGridLayouts objectForKey:@(self.collectionView.frame.size.width)]) {
        size = ((NSNumber*)[self.cachedGridLayouts objectForKey:@(self.collectionView.frame.size.width)]).floatValue;
    }
    
    else {
        size = kGridCellMaxSize;
        NSInteger cellsPerRow = 1;
        while(size >= kGridCellMaxSize) {
            size = (self.collectionView.frame.size.width - ([Constants spacing] * ((cellsPerRow + 1) * 2))) / cellsPerRow;
            cellsPerRow++;
        }
        
        // Cache the generated item size
        [self.cachedGridLayouts setObject:@(size) forKey:@(self.collectionView.frame.size.width)];
    }
    
    // Set layout attributes
    self.itemSize = CGSizeMake(size, size * kGridCellAspectRatio);
    self.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    self.minimumLineSpacing = spacing;
}

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    if ([self.indexPathsToAnimate containsObject:itemIndexPath]) {
        CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(-M_PI_4/3.0);
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.7, 0.7);
        
        attr.transform = CGAffineTransformConcat(scaleTransform, rotateTransform);
        attr.alpha = 0;
    }
    
    return attr;
}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    if ([self.indexPathsToAnimate containsObject:itemIndexPath]) {
        CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(-M_PI_4/3.0);
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.7, 0.7);
        
        attr.transform = CGAffineTransformConcat(scaleTransform, rotateTransform);
        attr.alpha = 0;
    }
    
    return attr;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
                
            case UICollectionUpdateActionDelete:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
                
            case UICollectionUpdateActionMove:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
                
            default:
                break;
        }
        
    }
    
    self.indexPathsToAnimate = indexPaths;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath
{
    return [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath
{
    return [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [super layoutAttributesForElementsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}

- (CGSize)collectionViewContentSize
{
    return [super collectionViewContentSize];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    return CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds);
}

@end
