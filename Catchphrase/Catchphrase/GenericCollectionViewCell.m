//
//  GenericCollectionViewCell.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "GenericCollectionViewCell.h"
#import "Constants.h"

@implementation GenericCollectionViewCell

- (void) awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];//[[Constants instance] EXTRA_LIGHT_BG];
    self.layer.cornerRadius = [Constants borderRadius];
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.6].CGColor;
    self.layer.borderWidth = [Constants thinLineWidth];
    
    self.mainLabel.font = [UIFont fontWithName:[Constants lightFont]
                                          size:[Constants titleTextSize]];
    self.mainLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    
    self.iconImageView.image = [Constants add];
    self.iconImageView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.6];
}

- (void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.backgroundColor = (highlighted) ? [UIColor colorWithWhite:1.0 alpha:0.6] : [UIColor clearColor];
}

@end
