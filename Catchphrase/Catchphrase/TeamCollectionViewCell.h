//
//  TeamCollectionViewCell.h
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@class TeamCollectionViewCell;

@protocol TeamCellDelegate <NSObject>

- (void) didTapMoreOnCell:(TeamCollectionViewCell*)cell;

@end

@interface TeamCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) Team *currentTeam;
@property (nonatomic, strong) IBOutlet UIButton *moreButton;
@property (nonatomic, weak) id<TeamCellDelegate> delegate;

- (void) configureCellWithTeam:(Team*)team;

@end
