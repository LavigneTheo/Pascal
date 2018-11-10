
(*
 *  En charge de l'impression de la reprentation binaire du nombre (en haut a droite de la fenˆtre)
 *  La r‚cursivit‚ n'est pas necessaire, juste un petit entraŒnement avant le developpement de la liste chain‚e. 
  * La r‚cursivit‚ s'arrete lorque l'index est inferieur a 0.
 *
 *  Param Integer 
 *                  index : l'index auxquel on se trouve dans le tableau
 *)
procedure printBinary(index : integer);
begin
        if(index = size - 1) then
        begin
        	gotoxy(58, 1);
                write('Equivalent binaire : ');
        end;

        if(index >= 0) then
        begin
                write(T^[index]);
                printBinary(index - 1);
        end;
end;

(*
 *  Imprime un segment vertical (B, C, E, F). 
 *
 *  D‚tails du calcul de positionnement :
 *      x : correspond … la position du digit sur l'axe des absisses avant application du zoom
 *      y : correspond … la position du digit sur l'axe des ordonn‚es avant application du zoom
 *      xZoomEffect :  si on est sur un segment … droite (B et C), le zoom du digit courant doit etre pris en compte 
 *          ce qui n'est pas le cas des segments de gauche (D et E)
 *      yZoomEffect : l'effet du zoom n'est pas le meme selon que l'ont se trouve sur un segment du haut (B et F) 
 *          ou du bas (C et E). Details suppl‚mentaires dans la fonction 'printVertical'
 *      it : valeur de la boucle pour, fait au minimum 3 tours (taille par default du digit) … quoi on ajoute le zoom
 *
 *  Param : Integer
 *                  x : position sur l'axe des absisses
 *                  y : position sur l'axe des ordonnees
 *                  xZoomEffect : effet du zoom sur l'axe des absisses
 *                  yZoomEffect : effet du zoom sur l'axe des ordonnees
 *)
procedure printVertical(x, y, xZoomEffect, yZoomEffect : integer);
var
    it : integer;
begin 
	for it := 0 to 2 + zoom do
    	begin
            gotoxy(x + xZoomEffect,  y + it + yZoomEffect);
             write('*');
         end;
	end;
 
(*
 *  Calcule les positions de d‚part  des segments verticaux avant leurs impr‚ssions … l'‚cran (B, C, E, F)
 *
 *  Details du calcul :
 *      xTotalOffset : le d‚calage minimum du digit avant application du zoom
 *      xOffset + index * 1 + index * 3 : xOffset est la valeur du d‚calage en absisse d‚finie par l'utilisateur. 
 *          Ceux … quoi on ajoute l'index dans lequel on se trouve pour representer les espaces entre les chiffre. 
 *          Exemple, le deuxieme digit aura un index de 1, donc ajoutera bien l'equivalent de 1 espace. index * 3 
 *          r‚percute la taille par default des digit precedents.
 *      printVertical(5 + xTotalOffset, ...) : si l'on est sur un segment de droite, on ajoute 5 car l'affichage 
 *          commence a 2 et le digit fait 3 de large avant application du zoom. Lorsque l'ont est a gauche la valeur 
 *          est de 3.
 *      printVertical(..., 5 +yOffset , ..., ..., ...) : r‚percute le fait que si l'ont sur segment du haut, on se trouve au 
 *          minimum en 5, tandis que si l'ont est en bas on se trouve au minimum en 7. A cela on ajoute le d‚calage
 *          en ordonn‚ sp‚cifi‚ par l'utilisateur
 *      printVertical(..., ..., (index + 1) * zoom, ...) : applique l'effet du zoom sur l'axe des absisse, si l'ont est … 
 *          droite, le zoom du digit courant doit ˆtre appliquer, ce qui n'est pas le cas a gauche.
 *      printVertical(..., ..., ..., 0) : application du zoom sur les ordonn‚s. Celui ci n'a pas d'effet sur la position 
 *      initiale quand on est sur un segment du haut. La position du segment du bas en revanche sera increment‚e 
 *      la valeur du zoom
 *           
 *      Param String
 *                      str : chaine de caractere contenant l'etat de tout les segments pour tout les digits
 *                  Integer
 *                      index : le digit sur lequel on se trouve, le premier digit aura l'index 0
 *)
Procedure processVertical(var str : string; index : integer);
var 
    xTotalOffset : integer;
begin
	xTotalOffset := xOffset + index * 1 + index * 3;
	
	//B
	if(StrToInt(str[2 + 7 * index]) = 1) Then
    Begin
    	printVertical(5 + xTotalOffset, 5 + yOffset, (index + 1) * zoom, 0);
     end;
     
     //C
     if(StrToInt(str[3 + 7 * index]) = 1) Then
    Begin
    	printVertical(5 + xTotalOffset, 7 + yOffset, (index + 1) * zoom, zoom);
     end;
     
     //E
      if(StrToInt(str[5 + 7 * index]) = 1) Then
    Begin
       printVertical(3 + xTotalOffset, 7 + yOffset, index * zoom, zoom);
     end;
     
     //F
      if(StrToInt(str[6 + 7 * index]) = 1) Then
    Begin
        printVertical(3 + xTotalOffset, 5 + yOffset, index * zoom, 0);
         end;
end;

(*
 *  Imprime un segment horizontal (A, D, G). 
 *
 *  D‚tails du calcul de positionnement :
 *      x : correspond … la position du digit sur l'axe des absisses avant application du zoom
 *      y : correspond … la position du digit sur l'axe des ordonn‚es avant application du zoom
 *      xZoomEffect :  cette valeur est la mˆme pour tout les segments puisque ce sont tous des segments qui
 *          commence … gauche
 *      yZoomEffect : l'effet du zoom n'est pas le meme selon que l'ont se trouve sur le segment du haut (A) 
 *          du milieu (G) ou du bas (D). Details suppl‚mentaires dans la fonction 'printHorizontal'
 *      it : valeur de la boucle pour, fait au minimum 3 tours (taille par default du digit) … quoi on ajoute le zoom
 *
 *  Param : Integer
 *                  x : position sur l'axe des absisses
 *                  y : position sur l'axe des ordonnees
 *                  xZoomEffect : effet du zoom sur l'axe des absisses
 *                  yZoomEffect : effet du zoom sur l'axe des ordonnees
 *)
procedure printHorizontal(x, y, xZoomEffect, yZoomEffect: integer);
var
    it : integer;
begin 
	for it := 0 to 2 + zoom do
    	begin
            gotoxy(x + it + xZoomEffect,  y + yZoomEffect);
             write('*');
         end;
	end;

(*
 *  Calcule les positions de d‚part  des segments horizontaux avant leurs impr‚ssions … l'‚cran (A, D, G)
 *
 *  Details du calcul :
 *      xTotalOffset : le d‚calage minimum du digit avant application du zoom
 *      xOffset + index * 1 + index * 3 + 3: xOffset est la valeur du d‚calage en absisse d‚finie par l'utilisateur. 
 *          Ceux … quoi on ajoute l'index dans lequel on se trouve pour representer les espaces entre les chiffre. 
 *          Exemple, le deuxieme digit aura un index de 1, donc ajoutera bien l'equivalent de 1 espace. index * 3 
 *          r‚percute la taille par default des digit precedents. + 3 r‚percute le fait l'ecran commence au 3e pixel
 *      printHorizontal(xTotalOffset, ...) : la valeur est la mˆme pour tout les segments car ce sont des segments
 *          situ‚s … gauche
 *      printHorizontal(..., 5 +yOffset , ..., ..., ...) : r‚percute le fait que si l'ont le segment du haut (A), on se trouve au 
 *          minimum en 5, du milieu (G) en 7, en bas (D) on se trouve au minimum en 9. A cela on ajoute le d‚calage
 *          en ordonn‚ sp‚cifi‚ par l'utilisateur
 *      printHorizontal(..., ..., (index + 1) * zoom, ...) : applique l'effet du zoom sur l'axe des absisse. La valeur est
 *          la mˆme pour tout les s‚gments car ils sont tous … gauche. On n'aura donc jamais … consid‚r‚ le zoom
 *          du digit courant.
 *      printHorizontal(..., ..., ..., 0) : application du zoom sur les ordonn‚s. Celui ci n'a pas d'effet sur la position 
 *          initiale quand on est sur le segment du haut (A). La position du segment du milieu (G) en revanche sera 
 *          increment‚e de la valeur du zoom, tandis que celui du bas (D) sera incr‚ment‚ de 2 fois le zoom
 *           
 *      Param String
 *                      str : chaine de caractere contenant l'etat de tout les segments pour tout les digits
 *                  Integer
 *                      index : le digit sur lequel on se trouve, le premier digit aura l'index 0
 *)
Procedure processHorizontal(var str : string; index : integer);
var
    xTotalOffset : integer;
begin
	xTotalOffset := xOffset +  index * 1 + index * 3 + 3;
    
    //A
	if(StrToInt(str[1 + 7 * index]) = 1) Then
     Begin
     	printHorizontal(xTotalOffset, 5 + yOffset, index * zoom, 0);
     End;
     
     //D
     if(StrToInt(str[4 + 7 * index]) = 1) Then
     Begin
        printHorizontal(xTotalOffset, 9 + yOffset, index * zoom, zoom * 2);
     End;
     
     //G
     if(StrToInt(str[7 + 7 * index]) = 1) Then
     Begin
     	printHorizontal(xTotalOffset, 7 + yOffset, index * zoom, zoom);
    End;
end;

(*
 *  Imprime le cadre … l'ecran (80 * 25)
 *
 *  Param X
 *)
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
     
     (*
      * Imprime l'etat des segement sous forme de 1 et 0.
      *
      * Param String
      *                 data : contient la l'etat de tout les segments pour chaque digit du nombre
      *             Integer
      *                 lengthNumber : la longueur du nombre
      *)
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
