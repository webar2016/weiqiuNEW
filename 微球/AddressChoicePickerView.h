
//

#import <UIKit/UIKit.h>
#import "AreaObject.h"

typedef NS_ENUM(NSInteger, PlaceStyle) {
    //以下是枚举成员
    SinglePlaceChoice = 0,
    AnyPlaceChoice = 1,
    
    
};


@class AddressChoicePickerView;


typedef void (^AddressChoicePickerViewBlock)(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate,BOOL isSelected);


@interface AddressChoicePickerView : UIView

@property (copy, nonatomic)AddressChoicePickerViewBlock block;

- (instancetype)initWithPlaceStyle:(PlaceStyle)style;

- (void)show;
@end
