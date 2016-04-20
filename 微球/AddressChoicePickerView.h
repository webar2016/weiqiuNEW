
//

#import <UIKit/UIKit.h>
#import "AreaObject.h"
@class AddressChoicePickerView;
typedef void (^AddressChoicePickerViewBlock)(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate);
@interface AddressChoicePickerView : UIView

@property (copy, nonatomic)AddressChoicePickerViewBlock block;

- (void)show;
@end
