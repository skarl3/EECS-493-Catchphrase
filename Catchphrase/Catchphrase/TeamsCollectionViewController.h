//
//  TeamsCollectionViewController.h
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TeamCollectionViewCell.h"

@interface TeamsCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate, TeamCellDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedTeamsController;

- (void) showAlertForNewTeam;

@end
