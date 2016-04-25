//
//  WBDraftSave.h
//  
//
//  Created by 徐亮 on 16/3/30.
//
//

#import <Foundation/Foundation.h>

@interface WBDraftSave : NSObject

- (instancetype)initWithData:(NSDictionary *)data;

- (NSDictionary *)showDraft;

@property (nonatomic, copy) NSString *userId;

/*
 *草稿类别,@"1"为答案,@"2"为长图文
 */
@property (nonatomic, assign) NSString *type;

/*
 *答案存放groupId，长图文存放newsType = 3
 */
@property (nonatomic, copy) NSString *aim;

/*
 *答案存放questionId，长图文存放commentId
 */
@property (nonatomic, copy) NSString *contentId;

/*
 *答案存放问题，长图文存放话题
 */
@property (nonatomic, copy) NSString *title;

/*
 *答案存放answerText，长图文存放comment
 */
@property (nonatomic, copy) NSString *content;

/*
 *图片宽高比
 */
@property (nonatomic, copy) NSString *imageRate;

/*
 *图片名称
 */
@property (nonatomic, copy) NSString *nameArray;

/*
 *图片
 */
//@property (nonatomic, copy) NSData *imagesArray;

@end
