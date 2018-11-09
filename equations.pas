function processA(var arr : array of integer) : integer;
begin
//a
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

function processB(var arr : array of integer) : integer;
begin
//a
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

function processC(var arr : array of integer) : integer;
begin
//a
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

function processD(var arr : array of integer) : integer;
begin
//a
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


function processE(var arr : array of integer) : integer;
begin
//a
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

function processF(var arr : array of integer) : integer;
begin
//a
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

function processG(var arr : array of integer) : integer;
begin
//a
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