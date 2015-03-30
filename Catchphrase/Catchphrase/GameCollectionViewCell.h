//
//  GameCollectionViewCell.h
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@class GameCollectionViewCell;

@protocol GameCellDelegate <NSObject>

- (void) didTapMoreOnCell:(GameCollectionViewCell*)cell;

@end

@interface GameCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) Game *currentGame;
@property (nonatomic, strong) IBOutlet UIButton *moreButton;
@property (nonatomic, weak) id<GameCellDelegate> delegate;

- (void) configureCellWithGame:(Game*)game;

@end
