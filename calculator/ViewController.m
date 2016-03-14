#import "ViewController.h"
#import "BrainCalculator.h"
#define IS_PORTRAIT     UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])
#define IS_LANDSCAPE    UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
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
    _operationString = [NSString stringWithFormat:@"%0.2f", [[BrainCalculator calculateInfix:_operationString] doubleValue]];
    self.resultLabel.text = _operationString;
    [[LocalMemory singleton] saveObject:_operationString];
}

- (IBAction)removeLastPressed:(id)sender {
    if([_operationString length] > 0) {
        NSString *newString = [_operationString substringToIndex:[_operationString length]-1];
        self.resultLabel.text = newString;
        _operationString = newString;
        [[LocalMemory singleton] saveObject:_operationString];
    } else {
        lastPressedIsOperation = NO;
        self.prevCharacter = @"";
    }
}

//Данная функция проверяет является символ математической операцией или является/не является точкой
-(BOOL)isMathOrPointOperation:(NSString *)character {
    for (NSString* t in self.operationsList) {
        if([t isEqualToString:character])  { // данный символ является операцией
            return YES;
        }
    }
    return NO;
}

/*
 Смотрим чтобы нельзя была вставить несколько символов математических операции подряд, чтоб при пустом экране нельзя было нажать на точку, 0 или математическую операция
 */
-(BOOL) isDuplicateOperation:(NSString *) character {
    BOOL cantInsert = NO; //если NO - то данный символ будет отображен на экране, если YES - то не будет
    BOOL isOperation = [self isMathOrPointOperation:character]; //данный символ математическая операция или точка
    
    if(isOperation && ![_operationString length] ){
        cantInsert = YES;
    }
    
    //если пустой экран и мы ставим минус то можно доавбить его в строку
    if([character isEqualToString:@"-"] && ![_operationString length]) {
        cantInsert = NO;
    }
    
    //если подряд идет два математических символа
    if(lastPressedIsOperation && isOperation) {
        cantInsert = YES;
    }
    
    //после точки можно поставить 0 - например 20.017
    if(([self.prevCharacter isEqualToString:@"."] ||
        [self.prevCharacter isEqualToString:@"/"] ||
        [self.prevCharacter isEqualToString:@"*"]) &&
       [character isEqualToString:@"0"] &&
       _operationString.length > 2) {
        
        cantInsert = NO;
        lastPressedIsOperation = isOperation;
        self.prevCharacter = character;
        return cantInsert;
    }
    
    //если предыдущий элемент был
    if(lastPressedIsOperation && [character isEqualToString:@"0"]) {
        cantInsert = YES;
        self.prevCharacter = character;
        return cantInsert;
    }
    
    NSLog(@"lastpressed %hhd", lastPressedIsOperation);
    NSLog(@"isOeration %hhd", isOperation);
    
    
    
    lastPressedIsOperation = isOperation;
    self.prevCharacter = character;
    
    return cantInsert;
}

- (IBAction)elementPressed:(UIButton*)sender{
    if( ![ self isDuplicateOperation:sender.currentTitle] ) {
        
        //Если у нас на экран находится только число 0 и мы вводим новое число != 0 , то мы не хотим получить строку 01,02,03 и тд
        if([_operationString length] == 1 &&
           [_operationString isEqualToString:@"0"] &&
           ![sender.currentTitle isEqualToString:@"0"] &&
           ![self isMathOrPointOperation:sender.currentTitle]) {
            _operationString = @"";

        }        
        _operationString = [NSString stringWithFormat:@"%@%@", _operationString, sender.currentTitle];
        self.resultLabel.text = _operationString;
        [[LocalMemory singleton] saveObject:_operationString];
    }
}

@end
