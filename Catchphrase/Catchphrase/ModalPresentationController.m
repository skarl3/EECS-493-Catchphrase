//
//  ModalPresentationController.m
//  artsyu
//
//  Created by Nicholas Gerard on 3/8/15.
//  Copyright (c) 2015 eecs481. All rights reserved.
//

#import "ModalPresentationController.h"

@implementation ModalPresentationController

- (BOOL)shouldRemovePresentersView
{
    return YES;
}

- (void)containerViewWillLayoutSubviews
{
    self.presentedView.frame = [self frameOfPresentedViewInContainerView];
}

@end
