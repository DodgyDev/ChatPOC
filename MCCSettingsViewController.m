//
//  MCSettingsViewController.m
//  MC Chat
//
//  Created by Lucas Chen on 4/6/14.
//  Copyright (c) 2014 GTLucas. All rights reserved.
//

#import "MCCSettingsViewController.h"
#import "MCCMainViewController.h"

@interface MCCSettingsViewController ()

@end

@implementation MCCSettingsViewController
@synthesize Txt_Name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Btn_Go:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:Txt_Name.text forKey:@"PeerID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    MCCMainViewController *mainVC = [[MCCMainViewController alloc] init];
    [self presentViewController:mainVC animated:YES completion:^{
        
    }];
}
@end
