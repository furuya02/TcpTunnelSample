//
//  TcpTunnel.h
//  TcpTunnelSample
//
//  Created by hirauchi.shinichi on 2016/08/10.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"

@interface TcpTunnel : NSObject

@property (nonatomic) NSInteger listenPort; // 待ち受けポート
@property (nonatomic) NSInteger port; // 接続先ポート
@property (nonatomic) NSString *host; // 接続先ホスト

- (void) start;
- (void) stop;

@end

