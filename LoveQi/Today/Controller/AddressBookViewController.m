//
//  AddressBookViewController.m
//  LoveQi
//
//  Created by Mr on 2017/11/6.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "AddressBookViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface AddressBookViewController ()<CNContactPickerDelegate>

@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 100, 100, 60);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view.
}

- (void)btnClicked {
    [self getContacters];
//    CNContactPickerViewController *vc = [[CNContactPickerViewController alloc] init];
//    vc.delegate = self;
//    [self presentViewController:vc animated:YES completion:^{
//
//    }];
}

- (void)getContacters {
    //判断授权状态
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
        
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"授权成功");
                // 2. 获取联系人仓库
                CNContactStore * store = [[CNContactStore alloc] init];
                
                // 3. 创建联系人信息的请求对象
                NSArray * keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
                
                // 4. 根据请求Key, 创建请求对象
                CNContactFetchRequest * request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
                
                // 5. 发送请求
                [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                    
                    // 6.1 获取姓名
                    NSString * givenName = contact.givenName;
                    NSString * familyName = contact.familyName;
                    NSLog(@"%@--%@", givenName, familyName);
                    
                    // 6.2 获取电话
                    NSArray * phoneArray = contact.phoneNumbers;
                    for (CNLabeledValue * labelValue in phoneArray) {
                        
                        CNPhoneNumber * number = labelValue.value;
                        NSLog(@"%@--%@", number.stringValue, labelValue.label);
                    }
                }];
            } else {
                NSLog(@"授权失败");
            }
        }];
    }

}

// ============== contacts
#pragma mark - 选中一个联系人
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    
    NSLog(@"contact:%@",contact);
    //phoneNumbers 包含手机号和家庭电话等
    for (CNLabeledValue * labeledValue in contact.phoneNumbers) {
        
        CNPhoneNumber * phoneNumber = labeledValue.value;
        
        NSLog(@"phoneNum:%@", phoneNumber.stringValue);
        
    }
}

#pragma mark - 选中一个联系人属性
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    
    NSLog(@"contactProperty:%@",contactProperty);
}

#pragma mark - 选中一个联系人的多个属性
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperties:(NSArray<CNContactProperty*> *)contactProperties{
    
    NSLog(@"contactPropertiescontactProperties:%@",contactProperties);
}

#pragma mark - 选中多个联系人
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact*> *)contacts{
    
    NSLog(@"contactscontacts:%@",contacts);
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
