function [h] = viewDMR(DMRgrid,STRF,sp,linpred,predrate,faxis,taxis,dt,varargin)
% [hstruct] = viewDMR(DMRgrid,STRF,sp,linpred,predrate,faxis,taxis,dt,varargin)
% plot scrollable DRM stimulus, STRF and linear/rate predictions and spikes
% to keep memory down, only plot values in trange (specified in seconds)

par.twidth = 5; % width of time display in msec
par = parse_pv_pairs(par, varargin);
h.faxis = faxis;

% make time vector
tmax = dt*(size(DMRgrid,2)-1);
t = -par.twidth*1000:dt:tmax+par.twidth*1000; % in msec
h.t = t/1000; % in seconds
h.twidth = par.twidth; % in seconds 
tmax = tmax/1000;
taxis = taxis/1000;
trange = [0 tmax];

% % reduce variables to within trange
% tii = find(t>=trange(1)-par.twidth/1000 & t<=trange(2)+par.twidth/1000);
% t = t(tii);
% zero pad and then reduce data
h.DMRgrid = [zeros(size(DMRgrid,1),1000*h.twidth/dt) DMRgrid zeros(size(DMRgrid,1),1000*h.twidth/dt)];
clear DMRgrid
% DMRgrid = DMRgrid(:,tii);
zpad = zeros(1,1000*h.twidth/dt);
linpred = [zpad linpred(:)'/max(abs(linpred)) zpad];
% linpred = linpred(tii);
predrate = [zpad predrate(:)'/max(abs(predrate)) zpad];
% predrate = predrate(tii);
sp = [zpad sp(:)' zpad];
% sp = sp(tii);
spbins = find(sp>0);

figh = gcf;
clf(figh);
set(figh,'units','normalized');

% slider
% h.slider = uicontrol(figh,'units','normalized','Position',[.025 .95 .025 .025],'callback',@updateslider);
h.slider = uicontrol(figh,'style','slider','units','normalized','Position',[.025 .025 .95 .025]);
set(h.slider,'Value',trange(1)+diff(trange)/4,'Min',trange(1),'Max',trange(2),'sliderstep',[.01*max(taxis)/h.twidth max(taxis)/h.twidth]);
set(h.slider,'Callback',@updateslider);

% plot stimulus
h.DMRax = axes('position',[.1 .1 .85 .3]);
ylabel(h.DMRax,'Frequency (kHz)');
xlabel(h.DMRax,'Time (sec)');

tii = find(h.t>=h.slider.Value-h.twidth*.5 & h.t<= h.slider.Value+h.twidth*.5);
h.DMR = surf(h.DMRax,h.t(tii),faxis,h.DMRgrid(:,tii),'edgecolor','none');
set(h.DMRax,'view',[0 90],'clim',max(abs(caxis))*[-1 1]);
% set(h.DMRax,'position',[.05 .9 .1 .3],'ylabel','Frequency (kHz)','xlabel','Time (sec)');
set(h.DMRax,'xlim',h.slider.Value+h.twidth*[-.5 .5],'ylim',[min(faxis) max(faxis)],'yscale','log');

% plot STRF
h.STRFax = axes('position',[.1 .4 .85 .3]);
h.STRF = surf(h.STRFax,taxis,faxis,zeros(size(STRF)),STRF,'edgecolor','none');
set(h.STRFax,'view',[0 90],'clim',max(abs(caxis))*[-1 1],'xdir','reverse');
set(h.STRFax,'xlim',h.twidth*[-.5 .5],'ylim',[min(faxis) max(faxis)],'yscale','log','xtick',[]);

% normalize rates and predictions and plot with spikes
h.spax = axes('position',[.1 .7 .85 .2]);
hold on;
plot([min(t) max(t)],[0 0],'k');
h.linpredline = plot(h.t,linpred);
h.predrateline = plot(h.t,predrate);
h.splines = plot([1;1]*h.t(spbins),[-1;1]*ones(size(spbins)),'g');
set(h.spax,'xlim',h.slider.Value+h.twidth*[-.5 .5],'xtick',[],'ytick',[],'ylim',1.05*[-1 1]);

set(figh,'userdata',h);

end % main function

%%%% use slider to update time
function updateslider(src,event)
h = get(get(src,'parent'),'userdata'); % get handle structure
tlim = get(h.slider,'Value')+h.twidth*[-.5 .5];
set(h.spax,'xlim',tlim);
tii = find(h.t>=tlim(1) & h.t<= tlim(2));
h.DMR = surf(h.DMRax,h.t(tii),h.faxis,zeros(size(h.DMRgrid(:,tii))),h.DMRgrid(:,tii),'edgecolor','none');
set(h.DMRax,'view',[0 90],'xlim',tlim,'ylim',[min(h.faxis) max(h.faxis)],'yscale','log'); 
drawnow

end


