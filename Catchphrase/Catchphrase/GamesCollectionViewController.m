//
//  GamesCollectionViewController.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "GamesCollectionViewController.h"
#import "GenericCollectionViewCell.h"
#import "Team.h"
#import "Game.h"
#import "Word.h"
#import "Round.h"
#import "Model.h"
#import "Constants.h"
#import "UIView+Additions.h"

#define NEW_CELL_IDXPATH [NSIndexPath indexPathForRow:0 inSection:0]

@interface GamesCollectionViewController ()

// Object model
@property (nonatomic, assign) BOOL hasFetchedCache; // Tracks the state of the Core Data fetch request
@property (nonatomic, assign) BOOL collectionIsUpdating; // Collection view is batch updating from Core Data changes
@property (nonatomic, assign) BOOL shouldReloadCollectionView; // Collection view should reload after Core Data changes
@property (nonatomic, strong) NSBlockOperation *objectBlock; // Item batch actions to take after new data loaded

@end

@implementation GamesCollectionViewController

static NSString * const GameCellIdentifier = @"GameCell";
static NSString * const NewGameCellIdentifier = @"NewGameCell";

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self commonInit];
    }
    
    return self;
}

- (id) initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    
    if(self) {
        [self commonInit];
    }
    
    return self;
}

- (void) commonInit
{
    // Setup
    _hasFetchedCache = NO;
    _collectionIsUpdating = NO;
    _shouldReloadCollectionView = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // View setup
    self.collectionView.backgroundColor = [[Constants instance] LIGHT_BG];
    self.collectionView.alwaysBounceVertical = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // If we haven't done so already, fetch cache
    if(!_hasFetchedCache) {
        _hasFetchedCache = YES;
        NSError *error;
        if (![[self fetchedGamesController] performFetch:&error]) {
            NSLog(@"Unresolved games fetch error %@, %@", error, [error userInfo]);
            _hasFetchedCache = NO;
        }
    }
    
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if([self.fetchedGamesController sections].count==0) {
        return 1;
    }
    
    id<NSFetchedResultsSectionInfo> sec = [self.fetchedGamesController sections][section];
    return [sec numberOfObjects] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath==NEW_CELL_IDXPATH) {
        GenericCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NewGameCellIdentifier
                                                                                    forIndexPath:indexPath];
        
        return cell;
    }
    
    else {
        GameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GameCellIdentifier
                                                                                 forIndexPath:indexPath];
        cell.delegate = self;
        
        [self configureGameCell:cell
                   forIndexPath:indexPath
                       animated:NO];
        
        return cell;
    }
}

- (void) configureGameCell:(GameCollectionViewCell*)cell
              forIndexPath:(NSIndexPath*)indexPath
                  animated:(BOOL)animated;
{
    NSIndexPath *offsetIdxPath = [NSIndexPath indexPathForRow:indexPath.row-1
                                                    inSection:indexPath.section];
    Game *game = [self.fetchedGamesController objectAtIndexPath:offsetIdxPath];
    
    [cell configureCellWithGame:game];
}

#pragma mark - Cell delegate

- (void) didTapMoreOnCell:(GameCollectionViewCell *)cell
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:cell.currentGame.game_name
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             NSLog(@"Cancel action");
                                                         }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action) {
                                                             [[Model sharedManager] destroyObject:cell.currentGame];
                                                         }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover) {
        popover.sourceView = cell.moreButton;
        popover.sourceRect = cell.moreButton.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath==NEW_CELL_IDXPATH) {
        [self performSegueWithIdentifier:SegueToStartGameIdentifier sender:self];
    }
    
    else {
        // Show game info/restore game if in progress
    }
}

#pragma mark - Core Data

- (NSFetchedResultsController *) fetchedGamesController
{
    if (_fetchedGamesController != nil) {
        return _fetchedGamesController;
    }
    
    NSManagedObjectContext *context = [[Model sharedManager] managedObjectContext];
    
    // Set up fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game"
                                              inManagedObjectContext:context];
    fetchRequest.entity = entity;
    
    // Set up sort descriptors
    NSSortDescriptor *finished = [[NSSortDescriptor alloc] initWithKey:@"game_finished" ascending:YES];
    NSSortDescriptor *started = [[NSSortDescriptor alloc] initWithKey:@"game_started" ascending:NO];
    [fetchRequest setSortDescriptors:@[finished, started]];
    
    _fetchedGamesController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                  managedObjectContext:context
                                                                    sectionNameKeyPath:nil
                                                                             cacheName:@"GAMES"];
    _fetchedGamesController.delegate = self;
    return _fetchedGamesController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    _collectionIsUpdating = YES;
    _shouldReloadCollectionView = NO;
    _objectBlock = [[NSBlockOperation alloc] init];
    NSLog(@"Beginning Updates");
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    __weak UICollectionView *collectionView = self.collectionView;
    
    switch (type) {
            
        case NSFetchedResultsChangeInsert: {
            [self.objectBlock addExecutionBlock:^{
                NSLog(@"Insert Section");
                [collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
        case NSFetchedResultsChangeDelete: {
            [self.objectBlock addExecutionBlock:^{
                NSLog(@"Delete Section");
                [collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
        case NSFetchedResultsChangeUpdate: {
            [self.objectBlock addExecutionBlock:^{
                NSLog(@"Reload Section");
                [collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    __weak UICollectionView *collectionView = self.collectionView;
    __weak typeof (self) weakSelf = self;
    
    indexPath = [NSIndexPath indexPathForItem:indexPath.row+1 inSection:indexPath.section];
    newIndexPath = [NSIndexPath indexPathForItem:newIndexPath.row+1 inSection:newIndexPath.section];
    
    switch (type) {
            
        case NSFetchedResultsChangeInsert: {
            if ([self.collectionView numberOfSections] > 0) {
                if ([self.collectionView numberOfItemsInSection:indexPath.section] == 0) {
                    NSLog(@"Reload Collection");
                    self.shouldReloadCollectionView = YES;
                }
                
                else {
                    [self.objectBlock addExecutionBlock:^{
                        NSLog(@"Insert Item");
                        [collectionView insertItemsAtIndexPaths:@[newIndexPath]];
                    }];
                }
            }
            
            else {
                NSLog(@"Reload Collection");
                self.shouldReloadCollectionView = YES;
            }
            break;
        }
            
        case NSFetchedResultsChangeDelete: {
            if ([self.collectionView numberOfItemsInSection:indexPath.section] == 1) {
                NSLog(@"Reload Collection");
                self.shouldReloadCollectionView = YES;
            }
            
            else {
                [self.objectBlock addExecutionBlock:^{
                    NSLog(@"Delete Item");
                    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
                }];
            }
            break;
        }
            
        case NSFetchedResultsChangeUpdate: {
            [self.objectBlock addExecutionBlock:^{
                NSLog(@"Reload Item");
                GameCollectionViewCell *cell = (GameCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
                [weakSelf configureGameCell:cell forIndexPath:indexPath animated:YES];
            }];
            break;
        }
            
        case NSFetchedResultsChangeMove: {
            
            [self.objectBlock addExecutionBlock:^{
                NSLog(@"Move Item");
                [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
            }];
            break;
        }
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.shouldReloadCollectionView) {
        NSLog(@"Ending updates by reloading collection");
        [self.collectionView reloadData];
    }
    
    else {
        [self.collectionView performBatchUpdates:^{
            
            [self.objectBlock start];
            
        } completion:^(BOOL finished) {
            
            _collectionIsUpdating = NO;
            NSLog(@"Ended updates");
            
        }];
    }
}

#pragma mark - Transitions

- (void) viewWillTransitionToSize:(CGSize)size
        withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self.collectionViewLayout invalidateLayout];
    
    // Handle orientation changes
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        [self.collectionView layoutIfNeeded];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
}

@end
