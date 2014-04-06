//
//  MCCMainViewController.h
//  MC Chat
//
//  Created by Lucas Chen on 4/6/14.
//  Copyright (c) 2014 GTLucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCCMainViewController : UIViewController <MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCAdvertiserAssistantDelegate, UITextFieldDelegate, MCNearbyServiceAdvertiserDelegate>
- (IBAction)Btn_Send:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *Txt_Messages;
@property (weak, nonatomic) IBOutlet UITextField *Txt_InputMessage;

@end
