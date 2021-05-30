bitsNumber = 10000;
signalFreq = 1;
samplingFreq = 10;
bits = randi([0 1],bitsNumber,1);
ber1 = [];
ber2 = [];
ber3 = [];
E_N0 = [];
for snr = -10:21
    N0 = 10^(-snr/10);
    waveForm = [];
    h1 = ones(1, samplingFreq);
    h2 = ones(1, 1);
    h3 = sqrt(3) * linspace(0,1 + 1 / signalFreq ,samplingFreq);
    %puls shping
    for b = 1:bitsNumber
        bipolarValue = bits(b) * 2 - 1;
        for sample = 1:samplingFreq
            waveForm(end+1) = bipolarValue;
        end
    end
    waveForm = waveForm + sqrt(N0)*randn(size(waveForm));
    y1 = conv(waveForm, h1) / samplingFreq;
    y2 = conv(waveForm, h2) / samplingFreq;
    y3 = conv(waveForm, h3) / samplingFreq; 
    y1 = y1(samplingFreq - 1: samplingFreq:bitsNumber * samplingFreq);
    y2 = y2(samplingFreq - 1: samplingFreq:bitsNumber * samplingFreq);
    y3 = y3(samplingFreq - 1: samplingFreq:bitsNumber * samplingFreq);
    y1(y1 <= 0 ) = 0;
    y1(y1 > 0 ) = 1;
    y2(y2 <= 0 ) = 0;
    y2(y2 > 0 ) = 1;
    y3(y3 <= 0 ) = 0;
    y3(y3 > 0 ) = 1;
    ber1,d = biterr(y1,bits);
%     ber2(end+1) = abs(sum(y2' - bits) / length(bits));
%     ber3(end+1) = abs(sum(y3' - bits) / length(bits));
    E_N0(end+1) = snr;
end
plot(E_N0, ber1);
