//
//  TcpTunnel.m
//  TcpTunnelSample
//
//  Created by hirauchi.shinichi on 2016/08/10.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

#import "TcpTunnel.h"

@interface TcpTunnel () <GCDAsyncSocketDelegate>

@property (nonatomic) GCDAsyncSocket *listenSocket;
@property (nonatomic) NSMutableArray <Connection *> *connections; // 接続リスト

@end

@implementation TcpTunnel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.connections = [[NSMutableArray alloc] initWithCapacity:1];
        self.listenPort = 8080;
        self.port = 80;
        self.host = @"10.0.0.217";
    }
    return self;
}

#pragma mark - Private Method

// Accept
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"Accept:%p",sock);
    GCDAsyncSocket *toSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    if (![toSocket connectToHost:self.host onPort:self.port error:&error]) {
        NSLog(@"Error: %@", error);
    }
    else {
        Connection *connection = [Connection new];
        connection.fromSocket = newSocket;
        connection.toSocket = toSocket;
        @synchronized(self) {
            [self.connections addObject:connection];
        }
    }
}

// Disconnect
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"Disconnect:%p",sock);
    // 接続リストから検索して、反対側のソケットを切断し、リストから削除する
    for (Connection *connection in self.connections) {
        if ([connection.fromSocket.description isEqualToString:sock.description]) {
            [connection.toSocket disconnect];
            [self.connections removeObject:connection];
            break;
        }
        if ([connection.toSocket.description isEqualToString:sock.description]) {
            [connection.fromSocket disconnect];
            [self.connections removeObject:connection];
            break;
        }
    }
}

// Connect
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port

{
    NSLog(@"Connect:%p",sock);

    // 接続リストから検索して、読み込みを開始する
    for (Connection *connection in self.connections) {
        if ([connection.toSocket.description isEqualToString:sock.description]) {
            [connection.fromSocket readDataWithTimeout:3 tag:0];
            [connection.toSocket readDataWithTimeout:3 tag:0];
            break;
        }
    }
}

// ReadData
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"ReadData:%p %@",sock,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

    // 対象のトンネルを検索し、反対側のソケットに、そのまま書き込む
    for (Connection *connection in self.connections) {
        if ([connection.fromSocket.description isEqualToString:sock.description]) {
            [connection.toSocket writeData:data withTimeout:3.0 tag:0];
            break;
        }
        if ([connection.toSocket.description isEqualToString:sock.description]) {
            [connection.fromSocket writeData:data withTimeout:3.0 tag:0];
            break;
        }
    }
    // 受信は継続する
    [sock readDataWithTimeout:3 tag:0];
}

#pragma mark - Public Method

- (void) start {
    NSError *error = nil;
    self.listenSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.listenSocket acceptOnPort:self.listenPort error:&error];
}

- (void) stop {
    [self.listenSocket setDelegate:nil delegateQueue:NULL];
    [self.listenSocket disconnect];
    self.listenSocket = nil;
}

@end

