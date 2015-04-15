//
//  TeamsCollectionViewController.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "TeamsCollectionViewController.h"
#import "GenericCollectionViewCell.h"
#import "Team.h"
#import "Game.h"
#import "Word.h"
#import "Round.h"
#import "Model.h"
#import "Constants.h"
#import "UIView+Additions.h"
#import "StartCollectionViewController.h"

@interface TeamsCollectionViewController ()

// Object model
@property (nonatomic, assign) BOOL hasFetchedCache; // Tracks the state of the Core Data fetch request
@property (nonatomic, assign) BOOL collectionIsUpdating; // Collection view is batch updating from Core Data changes
@property (nonatomic, assign) BOOL shouldReloadCollectionView; // Collection view should reload after Core Data changes
@property (nonatomic, strong) NSBlockOperation *objectBlock; // Item batch actions to take after new data loaded

// Transition
@property (nonatomic, strong) Team *destinationTeam;

@end

@implementation TeamsCollectionViewController

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
    self.collectionView.backgroundColor = [[Constants instance] EXTRA_LIGHT_YELLOW_BG];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height, 0);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height, 0);
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // If we haven't done so already, fetch cache
    if(!_hasFetchedCache) {
        _hasFetchedCache = YES;
        NSError *error;
        if (![[self fetchedTeamsController] performFetch:&error]) {
            NSLog(@"Unresolved teams fetch error %@, %@", error, [error userInfo]);
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
    if([segue.identifier isEqualToString:SegueToStartGameIdentifier] && _destinationTeam) {
        UINavigationController *root = [segue destinationViewController];
        StartCollectionViewController *destination = [root.childViewControllers firstObject];
        destination.selectedTeams = [ @[_destinationTeam] mutableCopy];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if([self.fetchedTeamsController sections].count==0) {
        return 1;
    }
    
    id<NSFetchedResultsSectionInfo> sec = [self.fetchedTeamsController sections][section];
    return [sec numberOfObjects] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0 && indexPath.section==0) {
        GenericCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NewTeamCellIdentifier
                                                                                    forIndexPath:indexPath];
        
        return cell;
    }
    
    else {
        TeamCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TeamCellIdentifier
                                                                                 forIndexPath:indexPath];
        cell.delegate = self;
        
        [self configureTeamCell:cell
                   forIndexPath:indexPath
                       animated:NO];
        
        return cell;
    }
}

- (void) configureTeamCell:(TeamCollectionViewCell*)cell
              forIndexPath:(NSIndexPath*)indexPath
                  animated:(BOOL)animated;
{
    NSIndexPath *offsetIdxPath = [NSIndexPath indexPathForRow:indexPath.row-1
                                                    inSection:indexPath.section];
    Team *team = [self.fetchedTeamsController objectAtIndexPath:offsetIdxPath];
    
    [cell configureCellWithTeam:team];
}

#pragma mark - Cell delegate

- (void) didTapMoreOnCell:(TeamCollectionViewCell *)cell
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:cell.currentTeam.team_name
                                                                             message:cell.currentTeam.team_desc
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             //NSLog(@"Cancel action");
                                                         }];
    
    NSString *newGameString = [NSString stringWithFormat:@"New Game With %@", cell.currentTeam];
    UIAlertAction *newGameAction = [UIAlertAction actionWithTitle:newGameString
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              _destinationTeam = cell.currentTeam;
                                                              [self performSegueWithIdentifier:SegueToStartGameIdentifier sender:self];
                                                          }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action) {
                                                             [[Model sharedManager] destroyObject:cell.currentTeam];
                                                         }];
    
    [alertController addAction:newGameAction];
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    
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
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if(indexPath.row==0 && indexPath.section==0) {
        [self showAlertForNewTeam];
    }
    
    else {
        // Show team info
    }
}

- (void) showAlertForNewTeam
{
    // Make a new team
    NSString *alertTitle = @"New Team";
    NSString *alertMessage = @"Give your new team a name!";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = [NSString stringWithFormat:@"Team name (%ld to %ld characters)",
                                 (long)kMinTeamNameLength, (long)kMaxTeamNameLength];
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(alertTextFieldDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:textField];
    }];
    
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"Team description (optional)";
//        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
//    }];
    
    void (^detachTextListener)() = ^void() {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UITextFieldTextDidChangeNotification
                                                      object:nil];
    };
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                       detachTextListener();
                                                   }];
    
    UIAlertAction *create = [UIAlertAction actionWithTitle:@"Create"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       detachTextListener();
                                                       UITextField *nameField = alertController.textFields.firstObject;
                                                       //UITextField *descField = alertController.textFields.lastObject;
                                                       Team *newTeam = [Team newTeamWithName:nameField.text
                                                                              andDescription:@""];
                                                       NSLog(@"Created new team: %@", newTeam.team_name);
                                                   }];
    
    [alertController addAction:cancel];
    [alertController addAction:create];
    
    create.enabled = NO;
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) alertTextFieldDidChange:(NSNotification *)notification
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController)
    {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = login.text.length >= kMinTeamNameLength && login.text.length <= kMaxTeamNameLength;
    }
}

#pragma mark - Core Data

- (NSFetchedResultsController *) fetchedTeamsController
{
    if (_fetchedTeamsController != nil) {
        return _fetchedTeamsController;
    }
    
    NSManagedObjectContext *context = [[Model sharedManager] managedObjectContext];
    
    // Set up fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Team"
                                              inManagedObjectContext:context];
    fetchRequest.entity = entity;
    
    // Set up sort descriptors
    NSSortDescriptor *team_name = [[NSSortDescriptor alloc] initWithKey:@"team_name" ascending:YES];
    NSSortDescriptor *team_id = [[NSSortDescriptor alloc] initWithKey:@"team_id" ascending:YES];
    [fetchRequest setSortDescriptors:@[team_name, team_id]];
    
    _fetchedTeamsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                  managedObjectContext:context
                                                                    sectionNameKeyPath:nil
                                                                             cacheName:@"TEAMS"];
    _fetchedTeamsController.delegate = self;
    return _fetchedTeamsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    _collectionIsUpdating = YES;
    _shouldReloadCollectionView = NO;
    _objectBlock = [[NSBlockOperation alloc] init];
    //NSLog(@"Beginning Updates");
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
                //NSLog(@"Insert Section");
                [collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
        case NSFetchedResultsChangeDelete: {
            [self.objectBlock addExecutionBlock:^{
                //NSLog(@"Delete Section");
                [collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
        case NSFetchedResultsChangeUpdate: {
            [self.objectBlock addExecutionBlock:^{
                //NSLog(@"Reload Section");
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
                    //NSLog(@"Reload Collection");
                    self.shouldReloadCollectionView = YES;
                }
                
                else {
                    [self.objectBlock addExecutionBlock:^{
                        //NSLog(@"Insert Item");
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
                //NSLog(@"Reload Collection");
                self.shouldReloadCollectionView = YES;
            }
            
            else {
                [self.objectBlock addExecutionBlock:^{
                    //NSLog(@"Delete Item");
                    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
                }];
            }
            break;
        }
            
        case NSFetchedResultsChangeUpdate: {
            [self.objectBlock addExecutionBlock:^{
                //NSLog(@"Reload Item");
                TeamCollectionViewCell *cell = (TeamCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
                [weakSelf configureTeamCell:cell forIndexPath:indexPath animated:YES];
            }];
            break;
        }
            
        case NSFetchedResultsChangeMove: {
            
            [self.objectBlock addExecutionBlock:^{
                //NSLog(@"Move Item");
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
            //NSLog(@"Ended updates");
            
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
