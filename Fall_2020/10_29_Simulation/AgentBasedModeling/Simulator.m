clear all
nPeople = 100;          % Population size
Infect_dist = 6;        % Distance at which people can get infected
Infect_prob = 0.2;      % Probability of infectino spread at any given time instance

% Initialize plot
figure,
h = gcf;
subplot(2,1,1), scatter(0,0);
title(['Infection Prob. = ' num2str(Infect_prob) ' Infection distance = ' num2str(Infect_dist)])
a = gca;
subplot(2,1,2), scatter(0,0);
b = gca;

set(a,'units','normalized','position',[0.1 0.4 0.8 0.5])
set(b,'units','normalized','position',[0.1 0.1 0.8 0.25])

%% Generate Population
P = Population(nPeople);

P.People(1).infected = true;
P.People(2).infected = true;
P.People(3).infected = true;
nInfected=3;
ii=1;

%% Run simulation
while  nInfected(ii) ~= 0
    
    % Move all people around
    for jj = 1 : nPeople
        P.People(jj).move;
    end
    P.collectxy;
    
    % Spread infection
    P.infect(Infect_dist,Infect_prob);
    ii = ii+1;
    
    % Plotting
    P.scatter(a);
    title(a,['Infection Prob. = ' num2str(Infect_prob) ' Infection distance = ' num2str(Infect_dist)]);
    xlim([-50 50]);
    ylim([-50 50]);
    set(a,'xtick',[]);
    set(a,'ytick',[]);
    
    hold(a,'off');
    nInfected(ii) = sum(P.infected);
    nDead(ii) = sum(P.dead);
    nRecovered(ii) = sum(P.recovered);
    hb = bar(b,[nInfected(ii),nRecovered(ii),nDead(ii)],'FaceColor','flat');
    set(b,'xticklabel',{'Infected','Recovered','Dead'})
    hb.CData(1,:) = [1 0 0];
    hb.CData(2,:) = [0 1 0];
    hb.CData(3,:) = [0 0 0];
    F(ii-1) = getframe(h) ;
    pause(0.2);
end

%%
% create the video writer with 1 fps
writerObj = VideoWriter(['Prob' num2str(Infect_prob) 'Dist' num2str(Infect_dist) '.avi']);
writerObj.FrameRate = 5;
open(writerObj);
% write the frames to the video
for i=1:length(F)
% convert the image to a frame
frame = F(i) ;    
writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);
%%
figure,
plot(nInfected,'r');
hold on
plot(nRecovered,'g');
plot(nDead,'k');
xlabel('Time');
ylabel('Number of people')
legend('Active Cases','Recovered','Dead','Location','best')
title(['Infection Prob. = ' num2str(Infect_prob) ' Infection distance = ' num2str(Infect_dist)]);