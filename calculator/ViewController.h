#import <UIKit/UIKit.h>
#import "LocalMemory.h"
typedef NS_ENUM(NSInteger, MyViewOrientation) {
    MyViewOrientationUnspecified,
    MyViewOrientationPortrait,
    MyViewOrientationLandscape,
};
@interface ViewController : UIViewController

@property (nonatomic) NSString * operationString; //текущая строка команд
@property (nonatomic) NSString *prevCharacter; // предыдуший символ
@property (nonatomic) NSArray *operationsList; // список математических операций + точка

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

- (IBAction)resultPressed:(id)sender;
- (IBAction)removeLastPressed:(id)sender;
- (IBAction)elementPressed:(UIButton*)sender;

@end

