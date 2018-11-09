
(*
 *  En charge de l'impression de la reprentation binaire du nombre (en haut a droite de la fenetre)
 *  La recursivite n'est pas necessaire mais m'a permis de verifier son fonctionnement en Pascal avant le developpement de la liste chainee. La recursivite s'arrete lorque 
 *  l'index est inferieur a 0.
 *
 *  Param Integer index : l'index dans lequel on se trouve dans le tableau
 *)
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

(*
 *  Imprime les segments verticaux (B, C, E, F). 
 *
 *  Detail du calcul de positionnement :
 *      x : correspond a la position du digit sur l'axe des absisses avant application du zoom
 *      y : correspond a la position du digit sur l'axe des ordonnees avant application du zoom
 *      xZoomEffect :  si on est sur un segment a droite (B et C), le zoom du digit courant doit etre pris en compte ce qui n'est pas le cas des segments de gauche (D et E)
 *      yZoomEffect : Meme problematique sur l'axe des ordonnees, l'effet du zoom n'est pas le meme selon que l'ont se trouve sur le segment du haut ou du bas.
 *      it : valeur de la boucle pour, fait au minimum 3 tours (taille par default du digit) a quoi on ajoute le zoom
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
            gotoxy(x + xZoomEffect, yOffset + y + it + yZoomEffect);
             write('*');
         end;
	end;
 
(*
 *  Calcules les differentes valeurs necessaire a l'impression du segment vertical a la bonne place sur l'ecran
 *
 *  Detail du calcul :
 *      xTotalOffset : le dacalage minimum du digit avant application du zoom
 *      xOffset + index * 1 + index * 3 : xOffset est la valeur du decalage en absisse definie par l'utilisateur. Ceux a quoi on ajoute l'index dans lequel on se trouve pour representer
 *          les espaces entre les chiffre. Exemple, le deuxieme digit aura un index de 1, donc ajoutera bien l'equivalent de 1 espace. index * 3 repercute la taille par default des digit 
 *           precedents.
 *      printVertical(5 + xTotalOffset, ...) : si l'ont est sur un segment de gauche, on ajoute 5 car l'affichage commence a 2 et le digit fait 3 de large avant application du zoom. Lorsque
 *           l'ont est a droite la valeur est de 3.
 *      printVertical(..., 5, ..., ..., ...) : repercute le fait que si l'ont est a en haut, on se trouve au minimum en 5, tandis que si l'ont est en bas on se trouve au minimum en 7
 *      printVertical(..., ..., (index + 1) * zoom, ...) : applique l'effet du zoom sur l'axe des absisse, si l'ont est a droite, le zoom du digit courant doit etre appliquer, ce qui n'est pas
 *          le cas a gauche.
 *      printVertical(..., ..., ..., 0) : applcation du zoom sur les ordonnees. Celui ci n'a pas d'effet dur la position initiale quand on est en haut. La position du segement du bas en 
 *      revanche sera increment‚e de la valeur du zoom
 *           
 *      Param String
 *                      str : chaine de caractere contenant l'etat des segments
 *                  Integer
 *                      index : le digit sur lequel on se trouve, le premier digit aura l'index 0
 *)
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

(*
 *  Imprime les segments horizontaux (A, D, G). 
 *
 *  Detail du calcul de positionnement :
 *      x : correspond a la position du digit sur l'axe des absisses avant application du zoom
 *      y : correspond a la position du digit sur l'axe des ordonnees avant application du zoom
 *      xZoomEffect :  repercute l'effet du zoom sur l'axe des absisses
 *      yZoomEffect : repercute l'effet du zoom sur l'axe des ordonnees. Cette valeur varie selon que l'ont soit en haut, au milieu ou en bas
 *      it : valeur de la boucle pour, fait au minimum 3 tours (taille par default du digit) a quoi on ajoute le zoom
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
            gotoxy(x + it + xZoomEffect, yOffset + y + yZoomEffect);
             write('*');
         end;
	end;

(*
 *  Calcule les differentes valeurs necessaire a l'impression du segment horizontal a la bonne place sur l'ecran
 *
 *  Detail du calcul :
 *      xTotalOffset : le dacalage minimum du digit avant application du zoom
 *      xOffset + index * 1 + index * 3 + 3:meme calcul que dans la fonction  'processVertical', on ajoute 3 car tout les segements horizontaux considerer comme a gauche
 *      printHorizontal(..., 5, ..., ..., ...) : si l'ont est en haut (A), on est au minimum en 5, au milieu (G) en 7, en bas (D) en 9
 *      printHorizontal(..., ..., index * zoom, ...) : applique l'effet du zoom sur l'axe des absisse, identique pour les segments horizontaux
 *      printHorizontal(..., ..., ..., 0) : applcation du zoom sur les ordonnees. Celui ci n'a pas d'effet dur la position initiale quand on est en haut. La position du segement du milieu
 *      sera incremente de la valeur du zoom et celui du bas 2 fois la valeur du zoom
 *           
 *      Param String
 *                      str : chaine de caractere contenant l'etat des segments
 *                  Integer
 *                      index : le digit sur lequel on se trouve, le premier digit aura l'index 0
 *)
Procedure processHorizontal(var str : string; index : integer);
var
    xTotalOffset : integer;
begin
	xTotalOffset := xOffset +  index * 1 + index * 3 + 3;
    
	if(StrToInt(str[1 + 7 * index]) = 1) Then
     Begin
     	printHorizontal(xTotalOffset, 5, index * zoom, 0);
     End;
     
     if(StrToInt(str[4 + 7 * index]) = 1) Then
     Begin
        printHorizontal(xTotalOffset, 9, index * zoom, zoom * 2);
     End;
     
     if(StrToInt(str[7 + 7 * index]) = 1) Then
     Begin
     	printHorizontal(xTotalOffset, 7, index * zoom, zoom);
    End;
end;

(*
 *  Imprime le cadre a l'ecran (80 * 25)
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
      *
      * Param String
      *                 data : contient la l'etat de tout les segment pour chaque
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
