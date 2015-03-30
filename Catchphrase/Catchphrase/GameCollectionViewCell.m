//
//  GameCollectionViewCell.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "GameCollectionViewCell.h"
#import "Constants.h"

@interface GameCollectionViewCell()

// Containers
@property (strong, nonatomic) IBOutlet UIView *cardView;
@property (strong, nonatomic) IBOutlet UIView *cardViewShadow;
@property (strong, nonatomic) IBOutlet UIView *bottomArea;
@property (strong, nonatomic) IBOutlet UIView *topArea;
@property (strong, nonatomic) IBOutlet UIView *dividerLineView;

// Labels
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *teamOneLabel;
@property (strong, nonatomic) IBOutlet UILabel *teamTwoLabel;
@property (strong, nonatomic) IBOutlet UILabel *versusLabel;

// Constraints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *teamOneHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *teamTwoHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *versusSizeConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomAreaHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dividerLineViewHeightConstraint;

// Margin Constraints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cardViewShadowBottomConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *statusLeftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *statusBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *statusTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *teamOneRightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *teamOneLeftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *teamOneBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *teamTwoTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *teamTwoRightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *teamTwoLeftConstraint;

@end

@implementation GameCollectionViewCell

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
    
    // More button
    [self.moreButton setImage:[Constants moreHorizontal] forState:UIControlStateNormal];
    self.moreButton.tintColor = [[Constants instance] EXTRA_LIGHT_TEXT];
    
    // Team One
    self.teamOneLabel.font = [UIFont fontWithName:[Constants regFont]
                                             size:[Constants titleTextSize]];
    self.teamOneLabel.textColor = [[Constants instance] DARK_TEXT];
    self.teamOneLabel.numberOfLines = 0;
    self.teamOneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.teamOneLeftConstraint.constant = [Constants spacing];
    self.teamOneRightConstraint.constant = [Constants spacing];
    self.teamOneBottomConstraint.constant = [Constants spacing];
    
    // Team Two
    self.teamTwoLabel.font = [UIFont fontWithName:[Constants regFont]
                                             size:[Constants titleTextSize]];
    self.teamTwoLabel.textColor = [[Constants instance] DARK_TEXT];
    self.teamTwoLabel.numberOfLines = 0;
    self.teamTwoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.teamTwoLeftConstraint.constant = [Constants spacing];
    self.teamTwoRightConstraint.constant = [Constants spacing];
    self.teamTwoTopConstraint.constant = [Constants spacing];
    
    // Versus
    self.versusLabel.font = [UIFont fontWithName:[Constants boldFont]
                                            size:[Constants smallBodyTextSize]];
    self.versusLabel.textColor = [UIColor whiteColor];
    self.versusLabel.backgroundColor = [[Constants instance] LIGHT_BLUE];
    self.versusSizeConstraint.constant = [self.versusLabel sizeThatFits:CGSizeZero].width + ([Constants spacing] * 2);
    self.versusLabel.layer.cornerRadius = self.versusSizeConstraint.constant/2.0;
    self.versusLabel.layer.masksToBounds = YES;
}

- (IBAction) moreButtonTapped:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTapMoreOnCell:)]) {
        [self.delegate didTapMoreOnCell:self];
    }
}

- (void) configureCellWithGame:(Game*)game
{
    _currentGame = game;
    
    // Team one
    self.teamOneLabel.text = @"Team One";
    CGSize teamOneSize = [self.teamOneLabel sizeThatFits:CGSizeMake(self.teamOneLabel.frame.size.width, 0)];
    self.teamOneHeightConstraint.constant = teamOneSize.height + [Constants spacing];
    
    // Team two
    self.teamTwoLabel.text = @"Team Two";
    CGSize teamTwoSize = [self.teamTwoLabel sizeThatFits:CGSizeMake(self.teamTwoLabel.frame.size.width, 0)];
    self.teamTwoHeightConstraint.constant = teamTwoSize.height + [Constants spacing];
    
    [self layoutIfNeeded];
}

@end
