//
//  PropetyMarco.h
//  LoveQi
//
//  Created by tops on 2018/2/23.
//  Copyright © 2018年 李琦. All rights reserved.
//

#ifndef PropetyMarco_h
#define PropetyMarco_h


#define MF_Image(imagename) [UIImage getImageByName:imagename]

#define LRWeakSelf(type)  __weak typeof(type) weak##type = type;
#define LRStrongSelf(type)  __strong typeof(type) type = weak##type;

#endif /* PropetyMarco_h */
