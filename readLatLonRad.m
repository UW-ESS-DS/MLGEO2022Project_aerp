function [allLat, allLon, allVert] = readLatLonRad(folderPath)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
cd(folderPath);
latFiles = dir('*.lat');
lonFiles = dir('*.lon');
vertFiles = dir('*.rad');

%Grab list of station names
names=[];
for i=1:length(latFiles)
    names=[names; latFiles(i).name(1:end-4)];
end

%Grab list of base locations
locations = readlines('G:\Other computers\Lab Computer\Machine Learning\Project\sta_loc');
[locNames, remain]=strtok(locations); 
locNames=locNames(1:end-1, :);
[baseLongitudes, remain]=strtok(remain); 
baseLongitudes=cellfun(@str2num,baseLongitudes(1:end-1, :));
[baseLatitudes, ~]=strtok(remain); 
baseLatitudes=cellfun(@str2num,baseLatitudes(1:end-1, :));

locations2=readlines('G:\Other computers\Lab Computer\Machine Learning\Project\stationLocations');
[locNames2, remain2]=strtok(locations2);
locNamesTotal=[locNames; locNames2];
[baseLongitudes2, remain2]=strtok(remain2); 
baseLongitudes2=cellfun(@str2num,baseLongitudes2(1:end, :));
baseLongitudesTotal=[baseLongitudes; baseLongitudes2];
[baseLatitudes2, ~]=strtok(remain2); 
baseLatitudes2=cellfun(@str2num,baseLatitudes2(1:end, :));
baseLatitudesTotal=[baseLatitudes; baseLatitudes2];

%Prep cell array of all data
allLat=cell(length(names), 6);
allLon=cell(length(names), 6);
allVert=cell(length(names), 6);

%Process each file
for i=1:length(names)
    disp(i);
    %Get time series of data
    lat = readlines(join([names(i, :),'.lat']));
    lon = readlines(join([names(i, :),'.lon']));
    vert = readlines(join([names(i, :),'.rad']));
    %splitIndex=find(lat=="#       T             B_CLEANED       RE-SCALED_SIG_OBS");
    splitIndex=find(lat=="#       T            LDETRENDED       SIG_OBS");
    %splitIndex=find(lat=="#       T             RESIDUALS       SIG_RESID");
    lat=split(lat(splitIndex+1:end-1, 1));
    lat=cellfun(@str2num,lat(:, 2:end));
    lon=split(lon(splitIndex+1:end-1, 1));
    lon=cellfun(@str2num,lon(:, 2:end));
    vert=split(vert(splitIndex+1:end-1, 1));
    vert=cellfun(@str2num,vert(:, 2:end));

    %Associate that time series with a specific location
    latLonValue=find(locNamesTotal==names(i,:));
    baseLat=baseLatitudesTotal(latLonValue);
    baseLon=baseLongitudesTotal(latLonValue);
    %Collect data
    %Each row has station name, lat/lon of station, time, residual, sigma
    allLat(i,:)={names(i,:), baseLat, baseLon, lat(:, 1), lat(:, 2), lat(:, 3)};
    allLon(i,:)={names(i,:), baseLat, baseLon, lon(:, 1), lon(:, 2), lon(:, 3)};
    allVert(i,:)={names(i,:), baseLat, baseLon, vert(:, 1), vert(:, 2), vert(:, 3)};
end
end