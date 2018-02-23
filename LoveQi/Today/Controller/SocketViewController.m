//
//  SocketViewController.m
//  LoveQi
//
//  Created by tops on 2018/2/5.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import "SocketViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface SocketViewController ()

/// 全局的scoket
@property (nonatomic, assign) int clientSocket;

@end

@implementation SocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _clientSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    
    [self connectSocket];
    // Do any additional setup after loading the view.
}

- (void)receiveMsgAndSendMsg:(NSString *)sendMsg {
    size_t sendLen = send(_clientSocket, sendMsg.UTF8String, strlen(sendMsg.UTF8String), 0);
    MRJLog(@"发送的字节数%ld", sendLen);
    uint8_t buffer[1024];//将空间准备出来
    size_t receiveLen = recv(_clientSocket, buffer, sizeof(buffer), 0);
    NSData *receiveData = [NSData dataWithBytes:buffer length:receiveLen];
    NSString *recStr = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    MRJLog(@"接收到消息是%@", recStr);
}

- (void)connectSocket {
    _clientSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    struct sockaddr_in serverAdd;
    serverAdd.sin_addr.s_addr = inet_addr("127.0.0.1");
    serverAdd.sin_family = AF_INET;
    serverAdd.sin_port = htons(80);
    int connetResult = connect(_clientSocket, (const struct sockaddr *)&serverAdd, sizeof(serverAdd));
    if (connetResult == 0) {
        MRJLog(@"链接成功!");
    } else {
        MRJLog(@"链接失败！！！！");
    }
    // Dispose of any resources that can be recreated.
}

- (void)closeSocket {
    close(_clientSocket);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
