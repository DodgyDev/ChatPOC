//
//  MCCMainViewController.m
//  MC Chat
//
//  Created by Lucas Chen on 4/6/14.
//  Copyright (c) 2014 GTLucas. All rights reserved.
//

#import "MCCMainViewController.h"


@interface MCCMainViewController (){
    MCPeerID *_peerID;
    MCSession *_session;
    MCAdvertiserAssistant *_advertiserAssistant;
    MCNearbyServiceBrowser *_browser;
    MCNearbyServiceAdvertiser *_serviceAdvertiser;
}

@end

@implementation MCCMainViewController
@synthesize Txt_Messages, Txt_InputMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:@"PeerID"];
    
    //Create the peer ID
    _peerID = [[MCPeerID alloc] initWithDisplayName:name];
    
    //Create a session using the peer ID we just created
    _session = [[MCSession alloc] initWithPeer:_peerID];
    [_session setDelegate:self];
    
    //Create a browser object to start looking for advertisers
    _browser = [[MCNearbyServiceBrowser alloc]initWithPeer:_peerID serviceType:@"shinobi-stream"];
    [_browser setDelegate:self];
    [_browser startBrowsingForPeers];
    
    _serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_peerID
                                                           discoveryInfo:nil
                                                             serviceType:@"shinobi-stream"];
    [_serviceAdvertiser setDelegate:self];
    [_serviceAdvertiser startAdvertisingPeer];
}

-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info{
    NSLog(@"Found Peer: %@", peerID);
    [_browser stopBrowsingForPeers];
    //Txt_Messages.text = [NSString stringWithFormat:@"%@\n%@", Txt_Messages.text, peerID];
    [_browser invitePeer:peerID toSession:_session withContext:Nil timeout:30.0];
    
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID{
    
}

-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    
    
    if(state == MCSessionStateConnected){
        NSLog(@"%@ Connected",[peerID displayName]);
        
        NSString *text = [NSString stringWithFormat:@"%@ Connected", [peerID displayName]];
                [self appendText:text withDispatch:YES];
        
    }else if(state ==MCSessionStateNotConnected){
        NSLog(@"%@ Disconnected",[peerID displayName]);
        NSString *text = [NSString stringWithFormat:@"%@ Disconnected", [peerID displayName]];
        [self appendText:text withDispatch:YES];
    }
};

-(void)appendText:(NSString*)text withDispatch:(BOOL)dispatch{
    
    if(dispatch){
    dispatch_sync(dispatch_get_main_queue(), ^{
        Txt_Messages.text = [NSString stringWithFormat:@"%@\n%@", Txt_Messages.text, text];
    });
    }else{
        Txt_Messages.text = [NSString stringWithFormat:@"%@\n%@", Txt_Messages.text, text];
    }
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:    (MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler{
    NSLog(@"Did Receive Invitation");
    invitationHandler(YES, _session);
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    
    NSString *test = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if([test hasSuffix:@"command://crashall"]){
        
        exit(0);
    }else{
        [self appendText:test withDispatch:YES];
        NSLog(@"%@",test);
    }
    NSRange range = NSMakeRange(Txt_Messages.text.length - 1, 1);
    [Txt_Messages scrollRangeToVisible:range];
    
};

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
};

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
};

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
};

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)Btn_Send:(id)sender {
    
    NSString* str = [NSString stringWithFormat:@"%@: %@", [_peerID displayName], Txt_InputMessage.text];
    
    
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self appendText:str withDispatch:NO];
    NSError *error;
    
    [_session sendData:data toPeers:[_session connectedPeers] withMode:MCSessionSendDataReliable error:&error];
    
}
@end
