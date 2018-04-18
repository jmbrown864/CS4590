[audioData, sampleRate] = audioread('mii simulation.wav');
left = audioData(1:end,1).';
right = audioData(1:end,2).';
mono = mean([left;right]);
clean = arrayfun(@(x) cutOff(x),mono);
filt = designfilt('lowpassfir','PassbandFrequency',0.01, ...
         'StopbandFrequency',0.05,'PassbandRipple',0.5, ...
         'StopbandAttenuation',20,'DesignMethod','kaiserwin');
dataIn = mono;
dataOut = filter(filt,dataIn);
space = fillSpace(clean);
audiowrite('mii_simulation_spaced.wav',space,sampleRate);
%sound(space,sampleRate);
%plot(space);
delay = [mono,zeros(1,5000)] + 2 .* [zeros(1,5000),dataOut];
sound(bassBoost(mono,dataOut),sampleRate);
plot(bassBoost(mono,dataOut));

function ret = cutOff(in)
    if abs(in) < (.0001)
        ret = 0;
    else
        ret = in;
    end
end

function ex = fillSpace(in)
    ex = in;
    c = 50;
    while c < length(ex)
        if isequal(zeros(1,10),ex(c-9:c))
            ex = [ex(1:c),zeros(1,50000),ex(c+1:end)];
            c = c + 100000 + 500;
        end
        c = c + 1;
    end
end

function bb = bassBoost(in,bass)
    c = 1;
    bb = in;
    while c <= length(in)
        if (in(c) > .75)
            bb = in + 10 .* [zeros(1,c),bass(c + 1:end)];
            break;
        end
        c = c + 1;
    end
end