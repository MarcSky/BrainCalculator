#import "ViewController.h"
#import "BrainCalculator.h"

//00005+00003 - нет
//0.0005+0.0003 - да

@implementation ViewController {
    BOOL lastPressedIsOperation; //смотрю что предыдущий символ был операцией или точкой, чтобы дважды не нажать
}

@synthesize operationString = _operationString;

- (void)viewDidLoad {
    [super viewDidLoad];
    _operationString = [[LocalMemory singleton] getObject]; //получаем ранее сохраненную строку
    if(!_operationString) _operationString = [NSString new];
    self.operationsList = @[@"+", @"-", @"/", @"*", @"."]; //массив операций и точка
    lastPressedIsOperation = NO; //предыдущий символ который был нажат не является операцией
    self.prevCharacter = @"";
    self.resultLabel.text = (![_operationString length]) ? @"0" : _operationString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)resultPressed:(id)sender {
    
    _operationString = [NSString stringWithFormat:@"%0.2f",[[BrainCalculator calculateInfix:_operationString] doubleValue]];
    self.resultLabel.text = _operationString;
    [[LocalMemory singleton] saveObject:_operationString];

}

- (IBAction)removeLastPressed:(id)sender {
    if([_operationString length] > 0) {
        NSString *newString = [_operationString substringToIndex:[_operationString length]-1];
        self.resultLabel.text = newString;
        _operationString = newString;
        [[LocalMemory singleton] saveObject:_operationString];
        
    }
}

/*
Смотрим чтобы нельзя была вставить несколько символов математических операции подряд, чтоб при пустом экране нельзя было нажать на точку, 0 или математическую операция
 */
-(BOOL) isDuplicateOperation:(NSString *) character {
    BOOL cantInsert = NO; //если NO - то данный символ будет отображен на экране, если YES - то не будет
    BOOL isOperation = NO; //данный символ математическая операция или точка
    for (NSString* t in self.operationsList) {
        if([t isEqualToString:character])  { // данный символ является операцией
            isOperation = YES;
            break;
        }
    }
    
    //Если экран пустой и нажимается математическая операция то нельзя вставить символ (кроме знака -)
    if(isOperation && ![_operationString length] ){
        cantInsert = YES;
    }
    
    //если пустой экран и мы ставим минус то можно доавбить его в строку
    if(![_operationString length] && [character isEqualToString:@"-"]) {
        cantInsert = NO;
    }
    
    //если пустой экран и нажимается значение 0
    if(![_operationString length] && [character isEqualToString:@"0"]) {
        cantInsert = YES;
    }
    
    //если подряд идет два математических символа
    if(lastPressedIsOperation && isOperation) {
        cantInsert = YES;
    }
//    if([self.prevCharacter isEqualToString:@"0"] && [character isEqualToString:@"0"]) {
//        cantInsert = YES;
//    }
    
    lastPressedIsOperation = isOperation;
    self.prevCharacter = character;

    return cantInsert;
}

- (IBAction)elementPressed:(UIButton*)sender{
    if(![ self isDuplicateOperation:sender.currentTitle]) {
        _operationString = [NSString stringWithFormat:@"%@%@", _operationString, sender.currentTitle];
        self.resultLabel.text = _operationString;
        [[LocalMemory singleton] saveObject:_operationString];
    }
}

@end
