function realdata = data_grabbing(f)
%     root = fullfile('/','Users','nickats','Desktop','porcine_spinal_chord_project','pig data processing','pig_1021');
    fid = fopen(f);
    binar = fread(fid, 'double');
    %plot(binar, color = 'b'), xlabel('time (ms)'), ylabel('values')
    %hold on
    
    k = 100;
    spoint = 0;
    spointar = [1];
    epoint = 0;
    epointar = [];
    
    %locate starting and ending points of each trace
    for i = 1:length(binar)-k
        if binar(i:i+k) == 0
            if (i+k+1 < length(binar)) && (binar(i+k+1) ~= 0)
                spoint = i+100;
                spointar(end+1)= spoint;
            end
    
        end
        spoint = 0;
    end
    
    for i = length(binar):-1:1+k
        if binar(i-k:i) == 0
            if (i-k-1 > 0) && (binar(i-k-1) ~= 0)
                epoint = i-100;
                epointar(end+1)= epoint;
            end
    
        end
        epoint = 0;
    end
    
    epointar = flip(epointar);
    
    %populate realdata array with nonzero values of each trace
    realdata = zeros(max(epointar-spointar), length(spointar));
    for i= 1:length(spointar)
        %xline(spointar(i));
        %xline(epointar(i));
        realdata(1:(epointar(i)-spointar(i)+1), i)...
            = binar(spointar(i):epointar(i));
    end
    %hold off;

    fclose(fid);
end

