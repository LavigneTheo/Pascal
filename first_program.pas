program test;
Uses Math, SysUtils,  Crt;

const
        size = 35;
        widthScreen = 80;
        heightScreen = 25;
        xMax = widthScreen -4;
        yMax = heightScreen - 2;
        
type
        tab = array[0..size - 1] of  integer;
        Tptr = ^tab;
type
        Nptr = ^Node;
        Node = record
                data : array[0..3] of integer;
                child : Nptr;
        end;


var
        T : Tptr;
        zoom, xOffset, yOffset, freeSpace : integer;
        number, complement : LongInt;
        root : Nptr;
        endNode : Nptr;
        validInput : Boolean;
        
     {$I linkedList.pas}
     {$I equations.pas}
     {$I printing.pas}

procedure binary(num : LongInt);
var
        it, quotient, i : integer;
begin
        it := size - 1;
        for i := 0 to size - 1 do
         begin
             quotient := LongInt(Floor(num / Power(2, it)));
             if (quotient = 1) then
             begin
                 T^[it] := 1;
                 num := num mod LongInt(floor( Power(2, it)));
             end
             else
             begin
                T^[it] := 0;
             end;
                 it := it - 1;
            end;

end;

procedure binaryForList(num : LongInt);
var
        i : integer;
        it : integer;
        quotient : integer;
begin
        it :=  3;
        for i := 0 to 3 do
         begin
             quotient := Integer(Floor(num / Power(2, it)));
             if (quotient = 1) then
             begin
                  endNode^.data[it] := 1;
                 num := num mod Integer(floor( Power(2, it)));
             end
             else
             begin
                endNode^.data[it] := 0;
            End;
            it := it - 1;
        end;
end;

procedure processList(lengthNumber : integer);
var
        currentNode : Nptr;
        i , x: integer;
        str : string;
begin
        currentNode := root;
        for i := 0 to lengthNumber - 1 do
        begin
                str := Concat(str, IntToStr(processA(currentNode^.data)));
                str := Concat(str, IntToStr(processB(currentNode^.data)));
                str := Concat(str, IntToStr(processC(currentNode^.data)));
                str := Concat(str, IntToStr(processD(currentNode^.data)));
                str := Concat(str, IntToStr(processE(currentNode^.data)));
                str := Concat(str, IntToStr(processF(currentNode^.data)));
                str := Concat(str, IntToStr(processG(currentNode^.data)));
            
                currentNode := currentNode^.child;
            end;
            printSegmentState(str, lengthNumber);
       
        for x := 0 to lengthNumber - 1 do
        begin
              	processHorizontal(str, x);
                processVertical(str, x);                
            end;
           
end;

procedure processNumber(number : LongInt;index : integer);
var
        newNumber : Nptr;
        str : string;
        i, value : integer;
begin
        str := IntToStr(number);
        for i := 1 to Length(str) do
        begin
                binaryForList(StrToInt(str[i]));
                if i <> Length(str) then
                begin
                        insertNode();
                end;
        end;
       processList(Length(str));
end;

Procedure askUser;
Begin
	
    gotoxy(1, 1);
	write('Entrez le nomber :');
    readln(number);
    gotoxy(1, 2);
    write('Entrez le zoom :');
    readln(zoom);
        
    gotoxy(30, 1);
    write('Entrez le decalage en x :');
    readln(xOffset);
    gotoxy(30, 2);
    write('Entrez le decalage en y :');
    readln(yOffset);
end;

function getWidthNumber : integer;
var
    lengthNumber : integer;
begin 
	 lengthNumber := Length(IntToStr(number));
	getWidthNumber := lengthNumber * zoom + 3* lengthNumber + (lengthNumber - 1) + xOffset;
End;

function getHeightNumber : integer;
begin 
	getHeightNumber := 2 * zoom + 5 + yOffset;
End;

Procedure processMargin;
begin

	gotoxy(86, 16);
    write('Marge en absisse :  ',  xMax - getWidthNumber(), '   ');
    gotoxy(86, 17);
    write('Marge en ordonne :  ',  yMax - getHeightNumber(), '  ');
	end;

Procedure processFreeSpace;
var
    cumSize, widthNumber, xSizeDigit, ySizeDigit : integer;
begin
	xSizeDigit := zoom + 3;
    ySizeDigit := zoom * 2 + 5;
	widthNumber := getWidthNumber();
	cumSize := widthNumber + 1 + xSizeDigit;
    	freeSpace := 0;
    	
    	While cumSize <= xMax do
    	Begin
    		Inc(freeSpace);
    		cumSize := cumSize + 1 + xSizeDigit;
    		
        end;
    	gotoxy(20, 20);
	end;

function checkInput : Boolean;
var
    widthNumber, heightNumber, lengthNumber, xSizeDigit, ySizeDigit, it : integer;
begin
	
    lengthNumber := Length(IntToStr(number));
   
   xSizeDigit := zoom + 3;
   ySizeDigit := zoom * 2 + 5;
   
    //(lengthNumber - 1) = space between
	widthNumber := getWidthNumber();
	heightNumber := getHeightNumber();
	
	if (widthNumber >xMax) OR (heightNumber > yMax) Then
	begin
	checkInput := false;
	ClrScr();
	gotoxy(1, 15);
	writeln('Votre nombre exede les limite de la console. Veuillez en saisir un plus petit ou diminuer le zoom!');
	gotoxy(30, 16);
	writeln('(Pressez n importe quelle touche pour continuer)');
	Readln();
	ClrScr();
    End
    else 
    begin
    	checkInput := true;
    	
    	processFreeSpace();
    	processMargin();
    	gotoxy(86, 18);
    	write('Chiffre placable :  ',  freeSpace);
    	end;
end;

Function updateScreen : Boolean; 
var
    maxLongInt : LongInt;
begin
	gotoxy(1, 1);
	write('Entrez le nombre : ', number);
	processFreeSpace();
	
	if (Length(IntToStr(complement)) <= freeSpace) Then
	begin
        number := number * Floor(Power(10, Length(IntToStr(complement)))) + complement;
        end;
	
	 if (freeSpace = 0) Then
	 begin
	 	updateScreen := false;
    End
    Else
    Begin
    	updateScreen := true;
    	processMargin();
    	
    	gotoxy(86, 18);
    	write('Chiffre placable :  ',  freeSpace - Length(IntToStr(complement)), '    ');
    	end;
	
end;
	

begin
        new(T);
        
        validInput := false;
        
        Repeat
                askUser();
                
                if checkInput() = true Then
                begin
                    validInput := true;
                End;
        	
        Until validInput = TRUE;
        
        Repeat
            printScreen();
        
            binary(number);
            printBinaryRecu(size -1);

            new(root);
            root^.child := nil;
            endNode := root;

            processNumber(number, 0);
            
            gotoxy(86, 20);
            write('Completer le nombre : ');
            readln(complement);
            
        	Until (updateScreen() = false);
        
        gotoxy(86, 18);
    	write('Nombre maximum atteint');
        
        dispose(T);
        freeList(root);
end.

