(*
 *  Ce fichier contient les fonctions permettant de determiner l'‚tat des segments 
 *
 *)

(*
 *  Calcul l'etat du segment A en fonction d'un digit compris entre 0 et 9
 *  
 *  Param array of integer
 *                  arr : tableau de taille 4 contenant la representation binaire d'un digit compris entre 0 et 9
 *)
function processA(var arr : array of integer) : integer;
begin
        if (arr[2] = 0) and (arr[0] = 0) and (arr[1] = 0) then
        begin
                processA := 1;
        end
        else if (arr[3] = 1) and (arr[2] = 0) and (arr[1] = 0) then
        begin
                processA := 1;
        end
        else if (arr[3] = 0) and (arr[1] = 1) then
        begin
                processA := 1;
        end
        else if (arr[0] = 1) and (arr[3] = 0) and (arr[2] = 1) then
        begin
                processA := 1;
        end
        else
        begin
                processA := 0;
        end;
end;

(*
 *  Calcul l'etat du segment B en fonction d'un digit compris entre 0 et 9
 *  
 *  Param array of integer 
 *                  arr : tableau de taille 4 contenant la representation binaire d'un digit compris entre 0 et 9
 *)
function processB(var arr : array of integer) : integer;
begin
        if (arr[3] = 0) and (arr[2] = 0) then
        begin
                processB := 1;
        end
        else if (arr[3] = 0) and (arr[0] = 0) and (arr[1] = 0) then
        begin
                processB := 1;
        end
        else if (arr[3] = 0) and (arr[0] = 1) and (arr[1] = 1) then
        begin
                processB := 1;
        end
        else if (arr[3] = 1) and (arr[2] = 0) and (arr[1] = 0) then
        begin
                processB := 1;
        end
        else
        begin
                processB := 0;
        end;
end;

(*
 *  Calcul l'etat du segment C en fonction d'un digit compris entre 0 et 9
 *  
 *  Param array of integer 
 *                  arr : tableau de taille 4 contenant la representation binaire d'un digit compris entre 0 et 9
 *)
function processC(var arr : array of integer) : integer;
begin
        if (arr[1] = 0) and (arr[3] = 0) then
        begin
                processC := 1;
        end
        else if (arr[0] = 1) and (arr[1] = 1) and (arr[3] = 0) then
        begin
                processC := 1;
        end
        else if (arr[1] = 1) and (arr[3] = 0) and (arr[2] = 1) then
        begin
                processC := 1;
        end
        else if (arr[1] = 0) and (arr[3] = 1) and (arr[2] = 0) then
        begin
                processC := 1;
        end
        else
        begin
                processC := 0;
        end;
end;

(*
 *  Calcul l'etat du segment D en fonction d'un digit compris entre 0 et 9
 *  
 *  Param array of integer 
 *                  arr : tableau de taille 4 contenant la representation binaire d'un digit compris entre 0 et 9
 *)
function processD(var arr : array of integer) : integer;
begin
        if (arr[0] = 0) and (arr[2] = 0) and (arr[3] = 0) then
        begin
                processD := 1;
        end
        else if (arr[1] = 1) and (arr[2] = 0) and (arr[3] = 0) then
        begin
                processD := 1;
        end
        else if (arr[0] = 0) and (arr[1] = 1) and (arr[3] = 0) then
        begin
                processD := 1;
        end
        else if (arr[0] = 1) and (arr[1] = 0) and (arr[3] = 0) and (arr[2] = 1) then
        begin
                processD := 1;
        end
        else if (arr[3] = 1) and (arr[2] = 0) and (arr[1] = 0) then
        begin
                processD := 1;
        end
        else
        begin
                processD := 0;
        end;
end;

(*
 *  Calcul l'etat du segment E en fonction d'un digit compris entre 0 et 9
 *  
 *  Param array of integer 
 *                  arr : tableau de taille 4 contenant la representation binaire d'un digit compris entre 0 et 9
 *)
function processE(var arr : array of integer) : integer;
begin
        if (arr[0] = 0) and (arr[1] = 0) and (arr[2] = 0) then
        begin
                processE := 1;
        end
        else if (arr[0] = 0) and (arr[1] = 1) and (arr[3] = 0) then
        begin
                processE := 1;
        end
        else
        begin
                processE := 0;
        end;
end;

(*
 *  Calcul l'etat du segment F en fonction d'un digit compris entre 0 et 9
 *  
 *  Param array of integer 
 *                  arr : tableau de taille 4 contenant la representation binaire d'un digit compris entre 0 et 9
 *)
function processF(var arr : array of integer) : integer;
begin
        if (arr[0] = 0) and (arr[1] = 0) and (arr[3] = 0) then
        begin
                processF := 1;
        end
        else if (arr[1] = 0) and (arr[3] = 0) and (arr[2] = 1) then
        begin
                processF := 1;
        end
        else if (arr[0] = 0) and (arr[3] = 0) and (arr[2] = 1) then
        begin
                processF := 1;
        end
        else if (arr[1] = 0) and (arr[3] = 1) and (arr[2] = 0) then
        begin
                processF := 1;
        end
        else
        begin
                processF := 0;
        end;

end;

(*
 *  Calcul l'etat du segment G en fonction d'un digit compris entre 0 et 9
 *  
 *  Param array of integer 
 *                  arr : tableau de taille 4 contenant la representation binaire d'un digit compris entre 0 et 9
 *)
function processG(var arr : array of integer) : integer;
begin
        if (arr[3] = 0) and (arr[2] = 1) then
        begin
                processG := 1;
        end
        else if (arr[3] = 0) and (arr[0] = 1) and (arr[1] = 1) then
        begin
                processG := 1;
        end
        else if (arr[1] = 0) and (arr[3] = 1) and (arr[2] = 0) then
        begin
                processG := 1;
        end
        else if (arr[0] = 0) and (arr[1] = 1) and (arr[3] = 0) then
        begin
                processG := 1;
        end
        else
        begin
                processG := 0;
        end;
end;