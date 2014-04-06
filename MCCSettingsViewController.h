//
//  MCSettingsViewController.h
//  MC Chat
//
//  Created by Lucas Chen on 4/6/14.
//  Copyright (c) 2014 GTLucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCCSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *Txt_Name;
- (IBAction)Btn_Go:(id)sender;

@end
