//
//  Connection.h
//  TcpTunnelSample
//
//  Created by hirauchi.shinichi on 2016/08/10.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

#import "GCDAsyncSocket.h"

@interface Connection : NSObject

@property GCDAsyncSocket *fromSocket;
@property GCDAsyncSocket *toSocket;

@end



