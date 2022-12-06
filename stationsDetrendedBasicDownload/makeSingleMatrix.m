function [output] = makeSingleMatrix(latSimplified, lonSimplified, vertSimplified, weekDay)
%Averages weekly data, positions rather than displacement or velocity,
%cleaned/detrended data

%round dates
if weekDay=="week"
    value=0.01918;
else
    value=0.00274;
end
possibleValues=[1995.98588:value:2022.00218];
funRound = @(x) round(round(x/value, 0)*value, 5);
latSimplified(:,4) = cellfun(funRound,latSimplified(:,4),'UniformOutput',false);
lonSimplified(:,4) = cellfun(funRound,lonSimplified(:,4),'UniformOutput',false);
vertSimplified(:,4) = cellfun(funRound,vertSimplified(:,4),'UniformOutput',false);
%convert to single timestream
output=[];
for i=1:length(latSimplified)
    disp(i);
    %[times, tokeep]=intersect(intersect(latSimplified{i,4},lonSimplified{i,4}),vertSimplified{i,4});
    [times, tokeep1, tokeep2]=intersect(latSimplified{i,4},lonSimplified{i,4});
    for j=4:6
        latSimplified{i,j} = latSimplified{i,j}(tokeep1, :);
        lonSimplified{i,j} = lonSimplified{i,j}(tokeep2, :);
    end
    [times, tokeep1, tokeep2]=intersect(lonSimplified{i,4},vertSimplified{i,4});
        for j=4:6
        latSimplified{i,j} = latSimplified{i,j}(tokeep1, :);
        lonSimplified{i,j} = lonSimplified{i,j}(tokeep1, :);
        vertSimplified{i,j} = vertSimplified{i,j}(tokeep2, :);
    end
    %Time, xDisp, yDisp, zDisp, xUncertainty, yUncertainty, zUncertainty
    dataOneStation=[latSimplified{i,4}, lonSimplified{i,5},latSimplified{i,5},vertSimplified{i,5},lonSimplified{i,6},latSimplified{i,6},vertSimplified{i,6}];
    name=char(latSimplified{i,1});
    outputName=sprintf("stations/%s.mat",name);
    save (outputName, 'dataOneStation');
%     for j=1:length(times)
%         %Time, xPosition, yPosition, xDisp, yDisp, zDisp
%         a=find(lonSimplified{i,4}==times(j,1));
%         b=find(latSimplified{i,4}==times(j,1));
%         c=find(vertSimplified{i,4}==times(j,1));
%         output=[output; times(j,1), latSimplified{i,3},latSimplified{i,2}, mean(lonSimplified{i,5}(a,1)), mean(latSimplified{i,5}(b,1)), mean(vertSimplified{i,5}(c,1))];
%     end
end
lonLat=[latSimplified{:,3}; latSimplified{:,2}].';
names=latSimplified(:,1);
save('stations/positionsLonLat.mat', 'lonLat');
save('stations/stationNames.mat', 'names');
end