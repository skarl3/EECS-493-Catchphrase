//
//  TeamCollectionViewCell.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "TeamCollectionViewCell.h"
#import "Constants.h"

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

@end

@implementation TeamCollectionViewCell

- (void) awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
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
}

@end
