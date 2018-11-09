

     Function insertNode : Nptr;
begin
        new(endNode^.child);
        endNode := endNode^.child;
        endNode^.child := nil;
        insertNode := endNode;
end;

procedure freeList(currentNode : Nptr);
begin
        if (currentNode <> nil) then
        begin
                freeList(currentNode^.child);
                dispose(currentNode);
        end;
end;

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