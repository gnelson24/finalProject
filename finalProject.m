function [] = finalProject()
    global dashboard;
    dashboard.load = 0;
    dashboard.fig = figure('numbertitle','off','name','Dashboard');
    
    %Factored load
    dashboard.factoredLoadLabel = uicontrol('style','text','units','normalized','position', [.034 .05 .11 .095],'string','Maximum Factored Load:','horizontalalignment','right');
    dashboard.factoredLoadDisplay = uicontrol('style','text','units','normalized','position',[.15 .05 .09 .05],'string', num2str(dashboard.load),'horizontalalignment','right');
        %Dead Load
        dashboard.deadLoad = uicontrol('Style','text','units','normalized','position',[.034 .85 .11 .095],'string', 'Dead Load:','horizontalalignment','right');
        dashboard.deadLoadBox = uicontrol('Style','edit','string','0','units','normalized','position',[.15 .9 .09 .05]);
        %Live Load
        dashboard.liveLoad = uicontrol('Style','text','units','normalized','position',[.034 .75 .11 .095],'string', 'Live Load:','horizontalalignment','right');
        dashboard.liveLoadBox = uicontrol('Style','edit','string','0','units','normalized','position',[.15 .8 .09 .05]);
        %Live Roof Load
        dashboard.liveRoofLoad = uicontrol('Style','text','units','normalized','position',[.034 .65 .11 .095],'string', 'Live Roof Load:','horizontalalignment','right');
        dashboard.liveRoofLoadBox = uicontrol('Style','edit','string','0','units','normalized','position',[.15 .7 .09 .05]);
        %Snow Load
        dashboard.snowLoad = uicontrol('Style','text','units','normalized','position',[.034 .55 .11 .095],'string', 'Snow Load:','horizontalalignment','right');
        dashboard.snowLoadBox = uicontrol('Style','edit','string','0','units','normalized','position',[.15 .6 .09 .05]);
        %Rain Load
        dashboard.rainLoad = uicontrol('Style','text','units','normalized','position',[.034 .45 .11 .095],'string', 'Rain Load:','horizontalalignment','right');
        dashboard.rainLoadBox = uicontrol('Style','edit','string','0','units','normalized','position',[.15 .5 .09 .05]);
        %Wind Load
        dashboard.windLoad = uicontrol('Style','text','units','normalized','position',[.034 .35 .11 .095],'string', 'Wind Load:','horizontalalignment','right');
        dashboard.windLoadBox = uicontrol('Style','edit','string','0','units','normalized','position',[.15 .4 .09 .05]);
        %Earthquake Load
        dashboard.earthquakeLoad = uicontrol('Style','text','units','normalized','position',[.034 .25 .11 .095],'string', 'Earthquake Load:','horizontalalignment','right');
        dashboard.earthquakeLoadBox = uicontrol('Style','edit','string','0','units','normalized','position',[.15 .3 .09 .05]);
    %Button to determine the factored load
    dashboard.findFactoredLoad = uicontrol('style','pushbutton','units','normalized','position',[.034 .18 .25 .05],'string','Determine Factored Load','callback', {@factoredLoad});
    
    %Moment Load
    dashboard.momentLoadLabel = uicontrol('style','text','units','normalized','position', [.5 .05 .11 .095],'string','Moment:','horizontalalignment','right');
    dashboard.momentDisplay = uicontrol('style','text','units','normalized','position',[.616 .05 .09 .05],'string', num2str(dashboard.load),'horizontalalignment','right');
        %x
        dashboard.x = uicontrol('Style','text','units','normalized','position',[.5 .35 .12 .095],'string', 'Moment Location (X):','horizontalalignment','right');
        dashboard.xBox = uicontrol('Style','edit','string','0','units','normalized','position',[.63 .4 .09 .05]);
        %l
        dashboard.l = uicontrol('Style','text','units','normalized','position',[.5 .25 .12 .095],'string', 'Length of Beam (L):','horizontalalignment','right');
        dashboard.lBox = uicontrol('Style','edit','string','0','units','normalized','position',[.63 .3 .09 .05]);
    %Button to determine the moment load
    dashboard.findMoment = uicontrol('style','pushbutton','units','normalized','position',[.5 .18 .25 .05],'string','Determine Moment','callback', {@momentLoad});
    
    %Below function calculates all 7 load combinations and determines the max to
    %to obtain the max factored load.
    function [] = factoredLoad(~,~)
        %LFRD Load Combinations
        %LC1 = 1.4D
        LC1 = 1.4*str2num(dashboard.deadLoadBox.String);
        %LC2 = 1.2D + 1.6L + 0.5(Lr or S or R)
        LC2 = 1.2*str2num(dashboard.deadLoadBox.String) + 1.6*str2num(dashboard.liveLoadBox.String) + 0.5*max([str2num(dashboard.liveRoofLoadBox.String),str2num(dashboard.snowLoadBox.String),str2num(dashboard.rainLoadBox.String)]);
        %LC3 = 1.2D + 1.6(Lr or S or R) + (L or 0.5W)
        LC3 = 1.2*str2num(dashboard.deadLoadBox.String) + 1.6*max([str2num(dashboard.liveRoofLoadBox.String),str2num(dashboard.snowLoadBox.String),str2num(dashboard.rainLoadBox.String)]) + max([str2num(dashboard.liveLoadBox.String),0.5*str2num(dashboard.windLoadBox.String)]);
        %LC4 = 1.2D + W + L + 0.5(Lr or S or R)
        LC4 = 1.2*str2num(dashboard.deadLoadBox.String) + str2num(dashboard.windLoadBox.String) + str2num(dashboard.liveLoadBox.String) + 0.5*max([str2num(dashboard.liveRoofLoadBox.String),str2num(dashboard.snowLoadBox.String),str2num(dashboard.rainLoadBox.String)]);
        %LC5 = 1.2D + E + L + 0.2S
        LC5 = 1.2*str2num(dashboard.deadLoadBox.String) + str2num(dashboard.earthquakeLoadBox.String) + str2num(dashboard.liveLoadBox.String) + 0.2*str2num(dashboard.snowLoadBox.String);
        %LC6 = 0.9D + W
        LC6 = 0.9*str2num(dashboard.deadLoadBox.String) + str2num(dashboard.windLoadBox.String);
        %LC7 = 0.9D + E
        LC7 = 0.9*str2num(dashboard.deadLoadBox.String) + str2num(dashboard.earthquakeLoadBox.String);
        
        dashboard.factoredLoadDisplay.String = num2str(max([LC1,LC2,LC3,LC4,LC5,LC6,LC7]));
    end
    
    %Function calculates the moment at a specific location (X) on a uniformly
    %loaded simple beam of length (L)
    function [] = momentLoad(~,~)
        %M = wx(L - w)/2
        dashboard.momentDisplay.String = str2num(dashboard.factoredLoadDisplay.String)*str2num(dashboard.xBox.String)*(str2num(dashboard.lBox.String) - str2num(dashboard.xBox.String))/2;
    end   
end