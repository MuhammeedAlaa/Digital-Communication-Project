close all;
% bits to be transmitted
bitsNumber = 100000;

% frequency of the signal 1/T
signalFreq = 1;

samplingFreq = 25;

% generate random bits with bits number
bits = randi([0 1],bitsNumber,1);
PNRZ = [];
ber1 = [];
ber2 = [];
ber3 = [];
E_N0 = [];
for snr = -10:21
    N0 = 10^(-snr/10);
    
    % create filters
    h1 = ones(1, samplingFreq);
    h2 = ones(1, 1);
    h3 = sqrt(3) * linspace(0, 1 / signalFreq ,samplingFreq);
    
    %pulse shaping
    bipolarValue = bits * 2 - 1;
    waveForm = repelem(bipolarValue, samplingFreq);
    waveForm = waveForm + sqrt(N0/2)*randn(size(waveForm));
    plot((0:10*samplingFreq-1)/samplingFreq, waveForm(1:10*samplingFreq));
    title({'$input\ signal$'},'Interpreter','latex');
    ylabel({'g(t)'},'Interpreter','latex');xlabel({'t'},'Interpreter','latex');
    
    %apply convolution with different receivers
    y1 = conv(waveForm, h1) ;
    y2 = conv(waveForm, h2) ;
    y3 = conv(waveForm, h3) ;
    
    % plot the filters and the output of the filters
    if(snr == 21)
        displaySignals(h1, h3, samplingFreq, y1, y2, y3)
    end
    
    % sampling to get the output signals
    y1 = y1(samplingFreq - 1: samplingFreq:bitsNumber * samplingFreq);
    y2 = y2(samplingFreq - 1: samplingFreq:bitsNumber * samplingFreq);
    y3 = y3(samplingFreq - 1: samplingFreq:bitsNumber * samplingFreq);

    %thresholding with lambda = 0
    y1(y1 <= 0 ) = 0;
    y1(y1 > 0 ) = 1;
    y2(y2 <= 0 ) = 0;
    y2(y2 > 0 ) = 1;
    y3(y3 <= 0 ) = 0;
    y3(y3 > 0 ) = 1;
    
    % calculate the bit error rate (probability of error) for SNR value
    ber1(end+1) = sum(abs(y1 - bits) / length(bits));
    ber2(end+1) = sum(abs(y2 - bits) / length(bits));
    ber3(end+1) = sum(abs(y3 - bits) / length(bits));
    E_N0(end+1) = snr;
end
figure;
semilogy(E_N0, ber1, E_N0, ber2, E_N0, ber3);
set(legend('$Matched\ filter\ h_{1}(t)$','$h_{2}(t)=\delta(t)$','$h_{3}(t)=\sqrt{3}\ t$'),'Interpreter','latex');
xlabel({'\(E_b/N_0\), dB'},'Interpreter','latex');
ylabel({'Probability of error, \(P_e\)'},'Interpreter','latex');


% function to display the filters and output of receiver
function a = displaySignals(h1, h3, samplingFreq, output1, output2, output3)
    figure;
    set(gcf,'position',[100 100 1000 400])
    subplot(2,3,1);
    plot((0:samplingFreq-1)/samplingFreq,h1);
    title({'$Matched\ Filter$'},'Interpreter','latex');
    ylabel({'$h_{1}(t)$'},'Interpreter','latex');xlabel({'t'},'Interpreter','latex');

    subplot(2,3,2);
    stem(0,1, '^');
    title({'$\delta(t)$'},'Interpreter','latex');
    ylabel({'$h_{2}(t)$'},'Interpreter','latex');xlabel({'t'},'Interpreter','latex');

    subplot(2,3,3);
    plot((0:samplingFreq-1)/samplingFreq,h3);
    title({'$\sqrt{3}\ t$'},'Interpreter','latex')
    ylabel({'$h_{3}(t)$'},'Interpreter','latex');xlabel({'t'},'Interpreter','latex');
    
    subplot(2,3,4);
    plot((0:10*samplingFreq-1)/samplingFreq, output1(1:10*samplingFreq));
    title({'$$y_1(t)=r(t)*h_1(t)$'},'Interpreter','latex');
    ylabel({'$y_1(t)$'},'Interpreter','latex');xlabel({'t'},'Interpreter','latex');
    
    subplot(2,3,5);
    plot((0:10*samplingFreq-1)/samplingFreq, output2(1:10*samplingFreq));
    title({'$y_2(t)=r(t)*\delta(t)$'},'Interpreter','latex');
    ylabel({'$y_2(t)$'},'Interpreter','latex');xlabel({'t'},'Interpreter','latex');
    
    subplot(2,3,6);
    plot((0:10*samplingFreq-1)/samplingFreq, output3(1:10*samplingFreq));
    title({'$y_3(t)=r(t)*\sqrt{3}\ t$'},'Interpreter','latex');
    ylabel({'$y_3(t)$'},'Interpreter','latex');xlabel({'t'},'Interpreter','latex');
end