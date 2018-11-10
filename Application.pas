program test;
Uses Math, SysUtils,  Crt;

    (*************************************************************** Introduction *********************************************************)

(*
 *  Specifications fonctionnelles
 *      1 - Possibilite de choisir un nombre
 *      2 - Afficher le nombre base 2
 *      3 - Afficher les segments ABCDEFG en language TRUE / FALSE
 *     4 - Afficher le nombre dans l'afficheur
 *     5 - Affichage relatif du nombre, possiblite de definir un decalage en X et en Y
 *     6 - Possibilite de definir un zoom
 *    7 - Calculer la place restante et propose de rajouter un nombre     
 *)
 
 (*
  * L'application r‚ponds au 7 points ‚nonc‚ ci-dessus.
  * Resume du fonctionnement de l'application :
  *     1 - Demande un nombre a l'utilisateur, un niveau de zoom, et la valeur des decalages en sur l'axe X et Y
  *     2 - Verifie que le nombre saisi rentre dans l'afficheur (80 * 25)
  *     3a - Si le nombre n'est pas valide, demande de nouveau un nombre
  *     3b - Si le nombre est valide :
  *         - Affiche les marges disponibles en absisse et en ordonn‚
  *         - Affiche le nombre de digits pouvant encore etre inser‚s
  *         - affiche pour chaque digit l'etat de ses segments sous forme de 1 / 0 avec 1 = TRUE et 0 = FALSE
  *         - affiche l'‚quivalent binaire du nombre saisi
  *     4 -Laisse la possibilit‚e … l'utilisateur de completer son nombre avec autant de digit que l'afficheur peut encore contenir
  *     5 - R‚pŠte 3b : met et … jours la valeur du nombre, son binaire, l'etat de ses segments, la taille des marges et le nombre de digits pouvant encore etre inser‚
  *     6 - lorsqu'il n'y a plus de place, notifie l'utilisateur qu'il ne peut plus completer son nombre.
  *     7 - Appuyer sur une touche quitte l'application
  *)
  
  (*
   *    Description rapide des fonctions et outils critique de l'application
   *        - Le Binaire du nombre est calcul‚ au sein de fonction 'Binary' et stocke le nombre binaire dans un tableau qui est ensuite afficher en haut a droite de la fenetre
   *        - Le calcul de l'etat des segments se fait plusieurs etapes :
   *            a - Dans la boucle principale, la fonction 'processNumber' est execut‚e. Elle itere sur chaque digit du nombre et les transmet … la fonction 'BinaryForList'.
   *            b - 'BinaryForList' calcule le binaire du digit qui lui a ete transmis. Ce binaire de 4bits au plus (le digit etant compris entre 0 et 9) est inser‚ dans un ‚l‚ment d'une 
   *                liste chaine qui contient un tableau pouvant contenir 4 entiers. 
   *            c - Lorsque 'ProcessNumber' a fini d'iterer sur les digit du nombre, la liste chaine est desormais remplis de tableaux de taille 4 representant le binaire
   *                de chaque digit du nombre. Par exemple, si le nombre est 12, on aura le premier element contenant un tableau [0, 0, 0, 1] et le deuxieme element contenant [0, 0, 1, 0].
   *                La liste est desormais prˆte … ˆtre exploit‚e, la fonction 'processList' est appel‚e.
   *            d - 'ProcessList' transmet chaque element de la liste aux fonctions represantant les differents segments de l'afficheur nomm‚es 'processA', 'processB', etc.
   *                Ces fonctions renvoient 1 si le segment doit etre activ‚, 0 si il doit rester invisible.  Ces resultats sont concaten‚s au fur et … mesure dans un chaine de caractŠre. Par exemple,
   *                pour le chiffre 12, on obtient une chaine '01100001101101' qui represent l'etat des 7 segments pour les deux digits du nombre. Les indexes 1 a 7 correspondent au premier
   *                digit (b et c activ‚s), et de 8 a 14 se trouve le second digit (a, b, d, e, g activ‚s).
   *            e - Une fois que la chaŒne contient les etats de tout segments pour tout les digits du nombre, 'printSegmentState' imprime un par un l'etat des segments sur la
   *                fenˆtre en dessous de l'equivalent binaire du nombre.
   *            f - Les fonctions 'processHorizontal' et 'processVertical' sont appel‚es, ce sont elles qui impriment les digits du nombre a l'ecran en calculant au fur et a mesure les
   *            decalages n‚c‚ssaires. Pour determiner quels segments imprimer, elles itŠrent dans la chaŒne de caractere contenant l'etat des segments.
   *        - Le cadre repr‚sentant les limite 80 * 25 est imprim‚ par la fonction 'printScreen'
   *        - 'processFreeSpace' est la fonction en charge de verifier combien de digit peuvent etre inserer
   *)
   
   (*
    *       Location des fontions 
    *           1 - Application.pas
    *               Binary
    *               binaryForList
    *               processList
    *               processNumber
    *               askUser
    *               getWidthNumber
    *               getHeightNumber
    *               processMargin
    *               processFreeSpace
    *               checkInput
    *               updateScreen
    *
    *       2 - Printing.pas
    *               printTab
    *               printBinaryRecu
    *               printVertical
    *               processVertical
    *               printHorizontal
    *               processHorizontal
    *               printScreen
    *               printSegmentState
    *
    *       3 - LinkedList.pas
    *               insertNode
    *               freeList
    *               printList
    *
    *       4 - equations.pas
    *               processA
    *               processB
    *               processC
    *               processD
    *               processE
    *               processF
    *               processG
    *)
    
    (*************************************************************** Constantes *********************************************************)
    
const 
        //Taille du tableau dans lequel est stock‚ la representation binaire du nombre saisi par l'utilisateur
        size = 37;
        
        //Largeur et hauteur de l'‚cran ou s'affiche le nombre
        widthScreen = 80;
        heightScreen = 25;
        
        //La taille maximale en X et Y que le nombre peut occuper dans l'‚cran
        xMax = widthScreen -4;
        yMax = heightScreen - 2;
        
        (*************************************************************** Types *********************************************************)
        
type
        //Tableau utilise pour stocker la repr‚nsation binaire du nombre et son pointeur
        tab = array[0..size - 1] of  integer;
        Tptr = ^tab;
type
        (*
         *  Definition de la composition des ‚l‚ments de la liste chain‚e. Ceux-ci contiennent un pointeur vers l'element enfant (qui sera null si on est en bout de liste).
         *  Contient un tableau de taille 4 qui sera utilis‚ pour stocker la repr‚sentation binaire de chaque digit du nombre.
         *)
        Nptr = ^Node;
        Node = record
                data : array[0..3] of integer;
                child : Nptr;
            end;
            
     (*************************************************************** Variables globales *********************************************************)


var
        //Pointeur du tableau contenant la representation binaire du nombre
        T : Tptr;
        
        (*
         *  Variables 'zoom', 'xOffset', 'yOffset' seront d‚finis par l'utisateur pour d‚finir le zoom et les d‚calages en X et en Y
         *  'freeSpace' repr‚sente l'espace disponible sur l'‚cran pour inserer de nouveaux digits.
         *)
        zoom, xOffset, yOffset, freeSpace : integer;
        number, complement : LongInt;
        
        //D‚clare l'element a la racine de liste et l'element de fin.
        root : Nptr;
        endNode : Nptr;
        
      (*
      * Inclusion des fichiers n‚c‚ssaires au fonctionnement de l'application
      *)
     {$I linkedList.pas}
     {$I equations.pas}
     {$I printing.pas}
     
     (*************************************************************** Fonctions *********************************************************)
     

(*
 *  Calcule la repr‚sentation binaire du nombre saisi par l'utilisateur.
 *
 *  Detail du calcul :
 *      Voir 'binaryForList', le proc‚d‚ est le mˆme
 *
 *  Param LongInt 
 *                  num : nombre saisi par l'utilisateur
 *)
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
                 num := num - LongInt(floor( Power(2, it)));
             end
             else
             begin
                T^[it] := 0;
             end;
                 it := it - 1;
            end;
end;

(*
 *  Une fois que la liste chaine est remplie de la repr‚sentation binaire de chaque digit du nombre, cette fonction est appel‚e au sein 'processNumber'. Pour chaque digit du nombre,
 *  elle transmet un tableau de taille 4 contenant la repr‚sentation binaire du digit aux fonctions  processA/B/C/D/E/F/G qui d‚terminent si le segmentdoit ˆtre activ‚
 *  Ces fonctions renvoient 1 si le segement doit etre activ‚, 0 dans l'autre cas. Ces r‚sultatz sont concaten‚s au sein d'une chaŒne de caractŠre.
 *  Une fois que la chaŒne contient les etats de tout les segments pour tout les digits du nombre, le r‚sultat est imprim‚ a l'‚cran par la fonction 'printSegmentState', et les 
 *  fonctions 'processHorizontal' et 'processVertical' quand a elles impriment les digits.
 *  Une fois ces fonctions execut‚es, le calcul du binaire, des segments et l'affichage ont ‚t‚ r‚alis‚. On peut passer … un nouveau tours de boucle si il reste de l'espace a l'‚cran.
 *
 *  Param Integer 
  *                 lengthNumber : le nombre de digit qui compose le nombre
 *)
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

(*
 *  Recoit un par par les digits qui composent le nombre. Ceux-ci lui sont transmis par la fonction 'ProcessNumber'. Le digit etant compris entre 0 et 9, on itŠre 4 fois sur le nombre
 *  en testant au fur et a mesure de quelle puissance de 2 il est compos‚. Le r‚sultat compos‚ de 1 et de 0 est inser‚ dans un tableau de taille 4 au sein d'un ‚l‚ment de la liste
 *  chain‚e en vue d'une utilisation ult‚rieure. 
 *  
 *  Detail du calcul du binaire
 *  Power(2, it) : 'it' commence a 3 puis diminue jusqu'a atteindre 0. Ainsi ce morceau de code renvoie les valeurs de 2^3, 2^2, 2^1, 2^0 
 *  Floor(num / Power(...)) : test la divibilit‚ du nombre par les puissance enonc‚es ci-dessus. On arrondi le resultat car ce qui nous int‚resse est de savoir si le quotient est au
 *      moin ‚gal … 1, ce qui signifie dans ce cas que le binaire du nombre en question contient la puissance de 2 test‚e. Par exemple, pour 2, le test par 2^3 et 2^2 sera arrondi a 0
 *      tandis que 2^1 sera arrondis a 1. 2^0 ne sera pas ajout‚, voir ci-dessous.
 *  num := num - Integer(floor( Power(2, it))) : pour evit‚ d'ajouter toute les puissances de 2 pr‚sente aprŠs MSB, on enlŠve ensuite au nombre la valeur du bit qui a ‚t‚ 
 *      trouve‚ Ainsi pour 2, on enlŠve 2^1, le nombre est desormais ‚gale … 0 et aucune autre puissance de 2 ne sera ajout‚e dans le tableau.
 *  
 *  Param Integer 
  *                 num : digit entre 0 et 9
 *)
procedure binaryForList(num : Integer);
var
        quotient, i, it : integer;
begin
        it :=  3;
        for i := 0 to 3 do
         begin
             quotient := Integer(Floor(num / Power(2, it)));
             if (quotient = 1) then
             begin
                  endNode^.data[it] := 1;
                 num := num - Integer(floor( Power(2, it)));
             end
             else
             begin
                endNode^.data[it] := 0;
            End;
            it := it - 1;
        end;
end;

(*
 *  PremiŠre fonction … ˆtre appel‚e pour traiter le nombre entr‚ par l'utilisateur. Elle itŠre sur chaque digit du nombre et les transmets un par un … la fonction
 *  'BinaryForList'. A chaque tours de boucle elle ajoute un element vide a liste chain‚e afin que 'BinaryForList' puisse travailler au prochain tour de boucle sur un element
 *  vierge.
 *  Pour iterer sur les digits du nombre, celui-ci est converti en une chaine de caractŠre puis on traite cette chaine comme un tableau de caractŠre en iterant sur chaque caractŠre
 *  qu'elle contient.
 *  A la fin du processus, la liste chain‚e contient la representation binaire de chaque digit du nombre.
 *
 *  Param LongInt 
  *                 number : Nombre entr‚ par l'utilisateur
 *)
procedure processNumber(number : LongInt);
var
        newNumber : Nptr;
        str : string;
        i, value : integer;
begin
        str := IntToStr(number);
        for i := 1 to Length(str) do
        begin
                binaryForList(StrToInt(str[i]));
                //Si (i = Length(str)) alors on calcul‚ tout les binaires des digits, pas besoin d'inserer un nouvel ‚l‚ment
                if i <> Length(str) then
                begin
                        insertNode();
                end;
        end;
       processList(Length(str));
end;

(*
 *  Demande … l'utilisateur le nombre de d‚part, le zoom, le d‚calage souhait‚ en X et Y
 *
 *  Param X
 *)
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

(*
 * Cette fonction renvoie la largeur courante (en 'pixels') du nombre
 *  
 *  Explication du calcul de largeur du nombre
 *  lengthNumber * zoom : r‚percute l'effet du zoom. Par exemple, un zoom de 3 augmente la taille de chaque digit de 3. Si le nombre fait 2 digit, la taille totale a augmentee de 6.
 *  3* lengthNumber : la taille par default d'un digit est de 3, chaque digit ajoute donc automatiquement 3 a la taille totale
 *  (lengthNumber - 1) : r‚percute l'espace entre les nombres. Si il y a 6 digits, on aura donc 5 espaces soit la taille du nombre - 1
 *  xOffset : r‚percute le d‚calage sur l'axe des absisses d‚fini par l'utilisateur
 *
 *  Param X
 *  retourne Entier : la longueur que le nombre prends dans l'ecran sur l'axe X en prenant en compte le d‚cacalage
 *)
function getWidthNumber : integer;
var
    lengthNumber : integer;
begin 
	 lengthNumber := Length(IntToStr(number));
	getWidthNumber := lengthNumber * zoom + 3* lengthNumber + (lengthNumber - 1) + xOffset;
End;

(*
 * Cette fonction renvoie la hauteur du nombre
 *
 *  Explication du calcul de hauteur du nombre
 *  2 * zoom : r‚percute l'effet du zoom, la hauteur d'un digit est compos‚ de 2 segments, ce qui explique que l'on multiplie par 2 le zoom. Par exemple, si l'ont prends le segment
 *                    b et c avec un zoom de 3, les DEUX segments augmenteront en proportions soit un total de 6.
 *  5 : la taille par d‚fault d'un segment est de 3 en sachant qu'il partage leurs extremit‚s. Par exemple B partage ses extremit‚s avec A et G / C
 *  xOffset : repercute le decalage sur l'axe des ordonn‚es d‚finie par l'utilisateur
 *
 *  Param X
 *  retourne Entier : la hauteur que le nombre prends dans l'ecran sur l'axe Y en prenant en compte le d‚calage
 *)
function getHeightNumber : integer;
begin 
	getHeightNumber := 2 * zoom + 5 + yOffset;
End;

(*
 *  Affiche les marges disponibles sur l'axe des absisses et des ordonn‚es
 *  xMax correspond a la taille maximale que peut atteindre le digit sur l'axe des absisses. yMax est sont equivalent sur l'axe des ordonn‚es.
 *  La diff‚rence entre la taille actuelle du nombre et la place maximale nous donne les dimensions des marges disponibles
 *  
 * Param X
 *)
Procedure processMargin;
begin

	gotoxy(86, 16);
    write('Marge en absisse :  ',  xMax - getWidthNumber(), '   ');
    gotoxy(86, 17);
    write('Marge en ordonne :  ',  yMax - getHeightNumber(), '  ');
	end;

 (*
 *  Calcul le nombre de digit pouvant ˆtre encore inser‚s
 *  Le r‚sulat est stock‚ dans la variable globale nomm‚e 'freeSpace'. Utilis‚ notament par 'updateScreen'.
 *
 * D‚tail du calcul de la place disponible : 
 *  xSizeDigit : repr‚sente la taille d'un digit sur l'axe X, soit 3 (la taille par default) + le zoom
 *  widthNumber : la largeur totale du nombre
 * cumSize : la taille total du nombre avec un digit suppl‚mentaire et l'espacement avec le nombre pr‚cedent (materialis‚ par le + 1)
 *
 *  On ne se soucie que de l'axe X etant donn‚ que l'on est limit‚ … une seule ligne, l'axe Y ne d‚passera jamais sa limite.
 *  La boucle While additionne autant de digit que possible et s'arrete lorsque la taille totale depasse la taille maximale autoris‚e. A chaque tour effectu‚, la
 *  la variable globale 'freeSpace' est increment‚e. A la sortie de la boucle on a trouve le nombre maximal de digit que l'ont peut ajouter.
 *  
 * Param X
 *)
Procedure processFreeSpace;
var
    cumSize, widthNumber, xSizeDigit : integer;
begin
	xSizeDigit := zoom + 3;
	widthNumber := getWidthNumber();
	cumSize := widthNumber + 1 + xSizeDigit;
    	freeSpace := 0;
    	
    	While cumSize <= xMax do
    	Begin
    		Inc(freeSpace);
    		cumSize := cumSize + 1 + xSizeDigit;
        end;
	end;

(*
 *  V‚rifie que le premier nombre entr‚ par l'utilisateur rentre dans l'ecran. Cette fonction sera execut‚e en boucle au sein du 'main'  aussi longtemps que la saisie ne sera pas 
 *      valide.
 *  xSizeDigit : repr‚sente la taille d'un digit sur l'axe X, soit 3 (la taille par default) + le zoom
 *  ySizeDigit : repr‚sente la taille d'un digit sur l'axe Y, soit 5 (la taille par default) + le zoom * 2 (un digit est compose de 2 segments horizontaux ce qui double la valeur)
 *  widthNumber :  largeur totale du nombre
 *  heightNumber : hauteur totale du  nombre
 *
 *  Compare la longueur et la largeur du nombre entr‚s par l'utilisateur avec la taille maximale autoris‚e sur les deux axes (xMax et yMax). Si le nombre n'est pas valide, vide
 *  la console et imprime un message pr‚venant l'utilisateur qu'il doit recommencer la saisie. Retournera FALSE dans ce cas.
 *  Sinon, appŠlle les fonctions 'processFreeSpace' et 'processMargin' en vu d'afficher a l'utilisateur ces informations.
 *  
 *
 *  Param X
 *  retourne Boolean : TRUE si le nombre entr‚ par l'utilisateur rentre dans l'ecran,  FALSE dans l'autre cas
 *)
function checkInput : Boolean;
var
    widthNumber, heightNumber, xSizeDigit, ySizeDigit, it : integer;
begin
   
   xSizeDigit := zoom + 3;
   ySizeDigit := zoom * 2 + 5;
   
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
    	write('Place disponible :  ',  freeSpace);
    	end;
end;

(*
 *  Permet de stopper la boucle principale lorsque la valeur de retour est FALSE. Si l'espace occup‚ apr‚s insertion du complement reste dans les dimensions de l'ecran,
 *  calcule la nouvelle valeur du nombre. L'appel … la fonction 'processFreeSpace' permet de mˆttre … jours la variable globale 'freeSpace' qui est utilis‚e ensuite pour verifier
 *  que la taille du complement ne d‚passe pas le nombre de digits pouvant encore ˆtre inser‚. Met a jours les Margin et le nombre de digits pouvant ˆtre inser‚s si la place disponible
 *  avant insertion  > 0.
 *  Un axe d'amelioration majeur serais de pr‚venir les debordement du type LongInt lorsque l'utilisateur rentre un complement trop grand.
 *  Un autre axe d'amelioration serais d'eviter le tour de boucle suppl‚mentaire, en effet lorsque l'utilisateur rentre le dernier digit possible, la fonction renvoie quand meme TRUE
 *   afin d'afficher a l'ecran le dernier digit. La fonction n'arretera le program qu'au tours suivant. Si ce n'etait pas le cas, le dernier digit ne serais pas afficher.
 *  Probleme de place disponible negative lorsque l'utilisateur saisie un compl‚ment trop grand. Pour fixer le probleme il faudrai ne mettre … 
 *  jours la valeur … l'‚cran que si la modification a ‚t‚ un succ‚s et pas seulement si il y avait de la place libre avant insertion.
 *
 *  D‚tail du calcul du nouveau nombre :
 *  Power(10, Length(IntToStr(complement)) : calcule la puissance de 10 permettant de decaler le nombre, par exemple, si le compl‚ment fait 3 digit on doit multiplier le nombre par 
 *  1000 soit 10^3
 *  number * Floor(...) : d‚cale effectivement le nombre d'autant de digits que necessaire
 *  + complement : une fois le nombre decal‚, on ajoute le complement. Par exemple, si le nombre est 12 et le compl‚ment 76, on multiplie 12 par 10^2. On obtient 1200. On ajoute
 *  ensuite le complement 1200 + 76 = 1276
 *
 *  Param X
 *  retourne Boolean : TRUE si l'espace disponible AVANT insertion est sup‚rieur a 0, sinon FALSE.
 *)
Function updateScreen : Boolean; 
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
	

    (*************************************************************** Main *********************************************************)
    
(*
 *  Initialise le tableau stockant le binaire du nombre
 *  
 *  Demande un nombre de d‚part … l'utilisateur jusqu'… ce le nombre soit valide
 * 
 *  Imprime le contour de l'ecran
 *
 *  Demande … l'utilisateur de completer son nombre jusqu'a ce qu'il n'y ai plus de place. LibŠre la m‚moire
 *  occup‚ par la liste … chaque tours de boucle. S'il n'y plus de place, la boucle s'arrŠte.
 *
 *  Notifie l'utilisateur qu'il n'y a plus de place, libŠre la m‚moire occup‚ par le tableau stockant le binaire et quitte
 *  le programme.
 *)
begin
        new(T);
        
        Repeat
                askUser();
        Until checkInput() = TRUE;
        
        printScreen();
        
        Repeat
            binary(number);
            printBinary(size -1);

            new(root);
            root^.child := nil;
            endNode := root;

            processNumber(number);
            
            gotoxy(86, 20);
            write('Completer le nombre : ');
            readln(complement);
            
            freeList(root);
            
        	Until (updateScreen() = false);
        
        gotoxy(86, 18);
    	write('Nombre maximum atteint');
        
        dispose(T);
end.

