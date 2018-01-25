//
//  StringMacro.h
//  LoveQi
//
//  Created by tops on 2018/1/25.
//  Copyright © 2018年 李琦. All rights reserved.
//

#ifndef StringMacro_h
#define StringMacro_h

/// 字符串处理
#define MF_Trim(x) [x stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]
#define MF_SWF(FORMAT, ...) [NSString stringWithFormat:FORMAT, __VA_ARGS__]
#define MF_ObjString(obj) [NSString stringWithFormat:@"%@", obj]
#define MF_IntString(obj) [NSString stringWithFormat:@"%ld", obj]
#define MF_Replace(raw,f,r) [raw stringByReplacingOccurrencesOfString:f withString:r]
#define MF_isStringNull(string) ((string == nil || string.length == 0 || [string isEqualToString:@"(null)"]) ? YES : NO)/

#endif /* StringMacro_h */
