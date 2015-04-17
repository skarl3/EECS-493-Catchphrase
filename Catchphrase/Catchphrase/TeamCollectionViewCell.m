//
//  TeamCollectionViewCell.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "TeamCollectionViewCell.h"
#import "Constants.h"
#import "UIView+Additions.h"

@interface TeamCollectionViewCell()

// Containers
@property (strong, nonatomic) IBOutlet UIView *cardView;
@property (strong, nonatomic) IBOutlet UIView *bottomArea;
@property (strong, nonatomic) IBOutlet UIView *topArea;
@property (strong, nonatomic) IBOutlet UIView *dividerLineView;

// Labels
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

// Constraints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomAreaHeightConstraint;

// Margin Constraints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *statusLeftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *statusBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *statusTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *addedTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *addedBottomConstraint;

@end

@implementation TeamCollectionViewCell

- (void) awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.topArea.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Containers
    self.cardView.backgroundColor = [UIColor clearColor];
    self.cardView.layer.cornerRadius = [Constants borderRadius];
    self.cardView.layer.masksToBounds = YES;
    self.cardView.layer.shouldRasterize = YES;
    self.cardView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.topArea.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    self.bottomArea.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    self.dividerLineView.backgroundColor = [[Constants instance] LIGHT_LINE];
    self.bottomAreaHeightConstraint.constant = [Constants controlBarHeight];
    
    // Status label
    self.statusLabel.font = [UIFont fontWithName:[Constants lightFont]
                                            size:[Constants smallBodyTextSize]];
    self.statusLabel.textColor = [[Constants instance] LIGHT_TEXT];
    self.statusLabel.numberOfLines = 0;
    self.statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.statusLeftConstraint.constant = [Constants spacing];
    
    // Name label
    self.nameLabel.font = [UIFont fontWithName:[Constants regFont]
                                          size:[Constants titleTextSize]];
    self.nameLabel.textColor = [[Constants instance] DARK_TEXT];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // Added label
    self.addedLabel.font = [UIFont fontWithName:[Constants boldFont]
                                           size:[Constants smallBodyTextSize]];
    self.addedLabel.textColor = [[Constants instance] LIGHT_BLUE];
    self.addedLabel.backgroundColor = [UIColor whiteColor];
    self.addedLabel.clipsToBounds = NO;
    self.addedLabel.layer.masksToBounds = NO;
    self.addedTopConstraint.constant = [Constants controlBarHeight];
    self.addedBottomConstraint.constant = -[Constants controlBarHeight];
    
    // More button
    [self.moreButton setImage:[Constants moreHorizontal] forState:UIControlStateNormal];
    self.moreButton.tintColor = [[[Constants instance] EXTRA_LIGHT_TEXT] colorWithAlphaComponent:0.8];
}

- (IBAction) moreButtonTapped:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTapMoreOnCell:)]) {
        [self.delegate didTapMoreOnCell:self];
    }
}

- (void) configureCellWithTeam:(Team*)team
{
    _currentTeam = team;
    
    self.nameLabel.text = team.team_name;
    self.statusLabel.text = team.statsString;
}

// Selection

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.addedTopConstraint.constant = (selected) ? 0 : [Constants controlBarHeight];
    self.addedBottomConstraint.constant = (selected) ? 0 : -[Constants controlBarHeight];
    [self animateLayoutIfNeededWithBounce:NO
                                  options:0
                               animations:^{
                                   self.topArea.backgroundColor = (selected) ? [UIColor whiteColor] : [UIColor colorWithWhite:1.0 alpha:0.6];
                                   self.bottomArea.backgroundColor = (selected) ? [UIColor whiteColor] : [UIColor colorWithWhite:1.0 alpha:0.8];
                               }];
}

- (void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.topArea.backgroundColor = (highlighted) ? [UIColor whiteColor] : [UIColor colorWithWhite:1.0 alpha:0.6];
    self.bottomArea.backgroundColor = (highlighted) ? [UIColor whiteColor] : [UIColor colorWithWhite:1.0 alpha:0.8];
}

@end
