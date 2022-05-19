function [ft_norm, ft] = ftsections(tr)
    L = length(tr);   %samples
    Fs = 1;     %samples/ms
    f = ((0:L-1) * Fs/L)'; %samples/ms/samples
    for i=1:100:length(tr)-100
        if i+99 <= length(tr)
            ft = cat(2,ft,fftshift(fft(tr(i:i+99))));
        else
            ft = cat(2,ft,fftshift(fft(tr(i:length(tr)))));
        end
    end
    ft_norm = ft./L;
end
