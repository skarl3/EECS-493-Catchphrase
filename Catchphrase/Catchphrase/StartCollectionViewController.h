//
//  StartCollectionViewController.h
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamsCollectionViewController.h"

@interface StartCollectionViewController : TeamsCollectionViewController <NSFetchedResultsControllerDelegate, TeamCellDelegate>

@property (nonatomic, strong) NSMutableSet *selectedTeams;

@end
