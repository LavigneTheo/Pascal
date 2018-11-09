procedure printTab(arr : array of integer; sizeTab : integer);
var
        i : integer;
begin
    for i := 0 to sizeTab - 1 do
                begin
                        writeln('[', i , ' => ', arr[i], ']');
                end;

end;

procedure printBinaryRecu(index : integer);
begin
        if(index = size - 1) then
        begin
        	gotoxy(58, 1);
                write('Equivalent binaire : ');
        end;

        if(index >= 0) then
        begin
                write(T^[index]);
                printBinaryRecu(index - 1);
        end
        else if(index = -1) then
        begin
                writeln();
        end;
end;


//Si on est en bas on ajoute zoom *1 si on est haut pas besoin, a gauche on apllique zoom, a droit on applique zoom + 1
procedure printVertical(x, y, xZoomEffect, yZoomEffect : integer);
var
    it : integer;
begin 
	for it := 0 to 2 + zoom do
    	begin
            gotoxy(x + xZoomEffect, yOffset + y + it + yZoomEffect);
             write('*');
         end;
	end;
            
Procedure processVertical(var str : string; index : integer);
var 
    xTotalOffset : integer;
   
begin
	xTotalOffset := xOffset + index * 1 + index * 3;
	if(StrToInt(str[2 + 7 * index]) = 1) Then
    Begin
    	printVertical(5 + xTotalOffset, 5, (index + 1) * zoom,0);
     end;
     
     if(StrToInt(str[3 + 7 * index]) = 1) Then
    Begin
    	printVertical(5 + xTotalOffset, 7, (index + 1) * zoom, zoom);
     end;
     
      if(StrToInt(str[5 + 7 * index]) = 1) Then
    Begin
       printVertical(3 + xTotalOffset, 7, index * zoom, zoom);
     end;
     
      if(StrToInt(str[6 + 7 * index]) = 1) Then
    Begin
        printVertical(3 + xTotalOffset, 5, index * zoom, 0);
         end;
end;

procedure printHorizontal(x, y, xZoomEffect, yZoomEffect: integer);
var
    it : integer;
begin 
	for it := 0 to 2 + zoom do
    	begin
            gotoxy(x + it + xZoomEffect, yOffset + y + yZoomEffect);
             write('*');
         end;
	end;

Procedure processHorizontal(var str : string; index : integer);
var
    xTotalOffset : integer;
begin
	xTotalOffset := xOffset +  index * 1 + index * 3;
    
	if(StrToInt(str[1 + 7 * index]) = 1) Then
     Begin
     	printHorizontal(3 + xTotalOffset, 5, index * zoom, 0);
     End;
     
     if(StrToInt(str[4 + 7 * index]) = 1) Then
     Begin
        printHorizontal(3 + xTotalOffset, 9, index * zoom, zoom * 2);
     End;
     
     if(StrToInt(str[7 + 7 * index]) = 1) Then
     Begin
     	printHorizontal(3 + xTotalOffset, 7, index * zoom, zoom);
    End;
end;

procedure printScreen;
var
    x, y : integer;
begin 
	for x := 1 to widthScreen do
    	begin
            gotoxy(x, 4);
             write('*');
         end;
     
     for x := 1 to widthScreen do
    	begin
             gotoxy(x, heightScreen + 3);
            write('*');
        end;
        
        for y := 1 to heightScreen do
    	begin
             gotoxy(1, y + 3);
            write('*');
            gotoxy(widthScreen, y + 3);
            write('*');
         end;
     end;
     
     Procedure printSegmentState(data : string; lengthNumber : integer);
     var
        i, j : integer;
        segments : string;
     begin
     	segments := 'ABCDEFG';
     	gotoxy(86, 2);
     	write('1=TRUE   -   0=FALSE');
     	for i := 0 to lengthNumber - 1 do
     	begin
     		gotoxy(86, 3 + i);
     		for j := 1 to 7 do
     		begin
     			
     			Write(segments[j], '=', data[i * 7 + j], ' ');
     			end;
     		end;
     	end;
