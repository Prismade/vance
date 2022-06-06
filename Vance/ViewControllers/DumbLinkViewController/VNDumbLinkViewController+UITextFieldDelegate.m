//
//  VNDumbLinkViewController+UITextFieldDelegate.m
//  Vance
//
//  Created by Egor Molchanov on 06.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNDumbLinkViewController+UITextFieldDelegate.h"

@implementation VNDumbLinkViewController (UITextFieldDelegate)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.linkTextField resignFirstResponder];
    return YES;
}

@end
