clear all, close all

fid = fopen("arms 955.bex");
binar = fread(fid, 'double');
plot(binar, color = 'b'), xlabel('time (ms)'), ylabel('values')
hold on

k = 100;
spoint = 0;
spointar = [1];
epoint = 0;
epointar = [];
s = struct;
fields = {'C4_C3', 'left_Cz', 'left_Cervical', 'C3_C4', ...
    'right_Cz', 'Cz_C4', 'Cz_C3', 'right_Cervical'};
jump = 1800;

for i = 1:length(binar)-k
    if binar(i:i+k) == 0
        if (i+k+1 < length(binar)) && (binar(i+k+1) ~= 0)
            spoint = i;
            spointar(end+1)= spoint;
        end

    end
    spoint = 0; 
end

for i = length(binar):-1:1+k
    if binar(i-k:i) == 0
        if (i-k-1 > 0) && (binar(i-k-1) ~= 0)
            epoint = i;
            epointar(end+1)= epoint;
        end

    end
    epoint = 0; 
end

epointar = flip(epointar);
realdata = zeros(max(epointar-spointar), length(spointar));

for i= 1:length(spointar)
    xline(spointar(i));
    xline(epointar(i));
    realdata(1:(epointar(i)-spointar(i)+1), i)...
    = binar(spointar(i):epointar(i));
end
hold off;

for i=1:size(realdata,2)
    s.(char(fields(i))) = realdata(:,i);
end

%%

%write function for this 
L = length(s.right_Cervical);   %samples            
Fs = 1;     %samples/ms
f = ((0:L-1) * Fs/L)'; %samples/ms/samples


X = fftshift(fft(s.right_Cervical));
X_norm = X/L;

figure(2)
subplot(1,2,1)
plot(f,abs(X_norm),'o'), xlabel('frequency'), ylabel('amplitude')
yline(.75.*max(abs(X_norm))); 
subplot(1,2,2)
plot(f,angle(X_norm),'o'), xlabel('frequency'), ylabel('phase angle')

X_recon = X;
keep = 0;
for i = 1:length(f)/2
    if abs(X_norm) > .75.*max(abs(X_norm))
       keep = keep+1;
    end
end
