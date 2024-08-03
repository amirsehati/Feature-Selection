function   play_sound()

    h=load('handel.mat');
    yRange=[-0.7,0.7];
    soundsc(h.y,yRange);

end