(*
 *  Ce fichier contient les fonctions necessaire au fonctionnement de la liste chainee.
 *)


(*
 *  Insert un nouvel element dans la liste chainee.Pour creer un nouvel element comme enfant du dernier element. L'enfant de ce nouvel element est lui meme definit comme
 *  null et l'element de fin est desormais l'element qui vient d'etre creer.
 *)
Function insertNode : Nptr;
begin
        new(endNode^.child);
        endNode := endNode^.child;
        endNode^.child := nil;
        insertNode := endNode;
end;

(*
 *  Supprimer recursivment les elements de la liste chainee. La recursion s'arrete lorsque l'on le pointeur null a ete trouve. C'est a partir de ce moment que les
 *  suppressions commencent.
 *
 *  Param Nptr : pointeur de l'element a partir duquel on veut effectuer la suppression
 *)
procedure freeList(currentNode : Nptr);
begin
        if (currentNode <> nil) then
        begin
                freeList(currentNode^.child);
                dispose(currentNode);
        end;
end;

(*
 *  Developpee a des fins de debogage.
 *  Imprime recursivement les element de la liste. La recursion s'arrete lorsque l'on le pointeur null a ete trouve.
 *
 *  Param Nptr : poiteur de l'element a partir duquel on veut imprimer la liste
 *)
procedure printList(currentNode : Nptr);
var
        i : integer;
begin
        if (currentNode <> nil) then
        begin
                writeln();
                write('[');
                for i := 0 to 3 do
                begin
                        if (i <> 3) then
                        begin
                                write(currentNode^.data[i], ', ');
                        end
                        else
                        begin
                                writeln(currentNode^.data[i], ']');
                        end;
                end;
                printList(currentNode^.child);
        end;
end;

(*
 *  Developpee a des fins de debogage.
 *  Imprime un seul et unique element de la liste chainee.
 *
 *  Param Nptr : pointeur de l'element dont l'ont veut imprime le tableau
 *)
procedure printNode(node : Nptr);
var
        i : integer;
begin
        write('[');
        for i := 0 to 3 do
        begin
                if (i <> 3) then
                begin
                        write(node^.data[i], ', ');
                end
                else
                begin
                        write(node^.data[i], ']');
                end;
        end;
end;