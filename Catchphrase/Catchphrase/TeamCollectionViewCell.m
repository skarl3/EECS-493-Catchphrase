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
@property (strong, nonatomic) IBOutlet UIView *cardViewShadow;
@property (strong, nonatomic) IBOutlet UIView *bottomArea;
@property (strong, nonatomic) IBOutlet UIView *topArea;
@property (strong, nonatomic) IBOutlet UIView *dividerLineView;

// Labels
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

// Constraints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomAreaHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dividerLineViewHeightConstraint;

// Margin Constraints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cardViewShadowBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *statusLeftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *statusBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *statusTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *addedLabelHeightConstraint;

@end

@implementation TeamCollectionViewCell

- (void) awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.topArea.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Containers
    self.cardView.backgroundColor = [UIColor whiteColor];
    self.cardView.layer.cornerRadius = [Constants borderRadius];
    self.cardView.layer.masksToBounds = YES;
    self.cardView.layer.shouldRasterize = YES;
    self.cardView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.cardViewShadowBottomConstraint.constant = -[Constants thinLineWidth];
    self.cardViewShadow.backgroundColor = [[Constants instance] LIGHT_LINE];
    self.cardViewShadow.layer.cornerRadius = [Constants borderRadius];
    
    self.topArea.backgroundColor = [UIColor whiteColor];
    self.bottomArea.backgroundColor = [UIColor whiteColor];
    self.dividerLineView.backgroundColor = [[Constants instance] LIGHT_LINE];
    self.dividerLineViewHeightConstraint.constant = [Constants thinLineWidth];
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
    self.addedLabel.textColor = [UIColor whiteColor];
    self.addedLabel.backgroundColor = [[Constants instance] LIGHT_BLUE];
    self.addedLabelHeightConstraint.constant = 0;
    
    // More button
    [self.moreButton setImage:[Constants moreHorizontal] forState:UIControlStateNormal];
    self.moreButton.tintColor = [[Constants instance] EXTRA_LIGHT_TEXT];
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
    
    self.addedLabelHeightConstraint.constant = (selected) ? [Constants controlBarHeight] : 0;
    [self animateLayoutIfNeededWithBounce:YES
                                  options:0
                               animations:nil];
}

- (void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    self.topArea.backgroundColor = (highlighted) ? [[Constants instance] EXTRA_LIGHT_BG] : [UIColor whiteColor];
    self.bottomArea.backgroundColor = (highlighted) ? [[Constants instance] EXTRA_LIGHT_BG] : [UIColor whiteColor];
}

@end
