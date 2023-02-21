fid = fopen('C:\Users\Denis\Documents\Data\211021 Pig Walkway\DARPp05.fsx');

fsx = {};
ii = 1;

while ~feof(fid)
    
    fsx{ii,1} = fgetl(fid);
    
    if contains(fsx{ii,1}, 'TILEARRAY')
        break;
    end

    ii = ii+1;
end

binar = fread(fid, 'ubit1');

fclose(fid);