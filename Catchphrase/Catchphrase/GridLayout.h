//
//  GridLayout.h
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridLayout : UICollectionViewFlowLayout

// Tracks items being inserted or removed that should have initial or final layout attributes applied to them
@property (nonatomic, strong) NSMutableArray *indexPathsToAnimate;

@end
