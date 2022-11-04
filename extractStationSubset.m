function [latSimplified, lonSimplified, vertSimplified] = extractStationSubset(allLat, allLon, allVert)
latSimplified=cell(1,6);
lonSimplified=cell(1,6);
vertSimplified=cell(1,6);
j=1;
for i=1:length(allLat)
    if allLat{i,2} ~=0
        if all([allLat{i,2}(1,1)>42,allLat{i,2}(1,1)<52,allLat{i,3}(1,1)>-127,allLat{i,3}(1,1)<-115])
            %ELIMINATE MT ST HELENS
            if allLat{i,2}(1,1)>46.35 || allLat{i,2}(1,1)<46.1 ||  allLat{i,3}(1,1)>-122.1 || allLat{i,3}(1,1)<-122.25
                if numel(allLat{i,2})~=1
                    allLat{i,2}=mean(allLat{i,2}, 'all');
                    allLat{i,3}=mean(allLat{i,3}, 'all');
                    allLon{i,2}=mean(allLon{i,2}, 'all');
                    allLon{i,3}=mean(allLon{i,3}, 'all');
                    allVert{i,2}=mean(allVert{i,2}, 'all');
                    allVert{i,3}=mean(allVert{i,3}, 'all');
                end
                latSimplified(j,:)={allLat{i,1},allLat{i,2},allLat{i,3},allLat{i,4},allLat{i,5},allLat{i,6}};
                lonSimplified(j,:)={allLon{i,1},allLon{i,2},allLon{i,3},allLon{i,4},allLon{i,5},allLon{i,6}};
                vertSimplified(j,:)={allVert{i,1},allVert{i,2},allVert{i,3},allVert{i,4},allVert{i,5},allVert{i,6}};
                j=j+1;
            end
        end
    end
end
%fun = @(x) x(1);
%firstElementsTime = cellfun(fun,latSimplified(:, 4));
%firstElementsLat = cellfun(fun,latSimplified(:, 5));
%firstElementsLon = cellfun(fun,lonSimplified(:, 5));
%quiver(cell2mat(latSimplified(:,3)), cell2mat(latSimplified(:,2)), firstElementsLon, firstElementsLat);
end