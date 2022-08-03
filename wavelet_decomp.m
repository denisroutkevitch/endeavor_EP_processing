%% Load traces
close all
ssep_data = struct('Time', [], 'C4_C3', [], 'C4', [], 'Cz', [], 'Cervical', [], 'C3_C4', [], 'C3', [], 'Cz2', [], 'Cervical2', []);
positions = {'C4_C3', 'C4', 'Cz', 'Cervical', 'C3_C4', 'C3', 'Cz2', 'Cervical2'};
var = s1021;
for i = 1:length(var)
    if isempty(var(i).SSEP) == 0
        ssep_data(end+1).('Time') = var(i).String_Time; 
        for j = 1:length(var(1).SSEP)
            if isempty(var(i).SSEP(j).Arms) == 1
                var(i).SSEP(j).Arms = zeros(length(var(i).SSEP(j).Legs), 1);
            elseif isempty(var(i).SSEP(j).Legs) == 1
                var(i).SSEP(j).Legs = zeros(length(var(i).SSEP(j).Arms), 1);
            end
            ssep_data(end).(positions{j}) = [var(i).SSEP(j).Arms, var(i).SSEP(j).Legs];
        end
    end
end

x = s1021(17).SSEP(3).Legs;
figure;
t = 0:100/length(x):99.99;
plot(t,x); title('Original trace'); axis padded; xlabel('Time (ms)');

%% Remove 60 Hz noise
Fs = length(x)/.1; %number of samples/ .1 s total time
d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter', 'SampleRate', Fs);
filtx = filtfilt(d,x);
plot(t,x,t,filtx); legend('Original', '60 Hz removed'); title('Original trace'); axis padded; xlabel('Time (ms)');

%% DWT
dwtmode('per', 'nodisp');
wname = 'db8';
level = 8;
[C,L] = wavedec(x, level, wname);
approx = appcoef(C, L, wname);
[D1,D2,D3,D4,D5] = detcoef(C, L, [1,2,3,4,5]);

figure;
subplot(6,1,1)
plot(approx); title('Approximation coefficients'); axis padded;
subplot(6,1,2)
plot(D5); title('Level 5 detail coefficients'); axis padded;
subplot(6,1,3)
plot(D4); title('Level 4 detail coefficients'); axis padded;
subplot(6,1,4)
plot(D3); title('Level 3 detail coefficients'); axis padded;
subplot(6,1,5)
plot(D2); title('Level 2 detail coefficients'); axis padded;
subplot(6,1,6)
plot(D1); title('Level 1 detail coefficients'); axis padded;

%% Denoise

xd = wden(x,'rigrsure','s','mln',level,wname);

figure;
hold on
plot(xd)
plot(x)
legend('Denoised', 'Original');
axis tight; title('Denoised trace');
hold off





