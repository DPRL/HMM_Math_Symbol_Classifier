%{
    DPRL Hidden Markov Model (HMM) Math Symbol Classifier
    Copyright (c) 2010-2014 Lei Hu, Richard Zanibbi

    This file is part of DPRL Hidden Markov Model(HMM) Math Symbol Classifier.

    DPRL Hidden Markov Model (HMM) Math Symbol Classifier is free software: 
    you can redistribute it and/or modify it under the terms of the GNU 
    General Public License as published by the Free Software Foundation, 
    either version 3 of the License, or (at your option) any later version.

    DPRL Hidden Markov Model (HMM) Math Symbol Classifier is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with DPRL Hidden Markov Model (HMM) Math Symbol Classifier.  
    If not, see <http://www.gnu.org/licenses/>.

    Contact:
        - Lei Hu: lei.hu@rit.edu
        - Richard Zanibbi: rlaz@cs.rit.edu 
%}

% This function is used to resample the points to make the distance between
% the points along the original trajectory is the same. The points
% interpolated between points belong to different strokes are viewed
% points belong to invisible stroke. The third dimenstion of coordinate of
% these point is 0.

 function resampled_symbol_data = equal_distance(A, resampled_point_num) %A is the name of input file

smoothed_symbol_data = smoothing(A);
accumulated_distance = zeros(1,smoothed_symbol_data.num);

accumulated_distance(1) = 0;


for i = 2:smoothed_symbol_data.num
    
    delta_distance =  sqrt ((smoothed_symbol_data.coordinate(i,1)-smoothed_symbol_data.coordinate(i-1,1))^2 ...
        + (smoothed_symbol_data.coordinate(i,2)-smoothed_symbol_data.coordinate(i-1,2))^2);
    accumulated_distance(i) = accumulated_distance(i-1) + delta_distance;
    
end

total_distance = accumulated_distance(smoothed_symbol_data.num);

point_num = resampled_point_num; 

unit_distance = total_distance/(point_num-1);

tmp_symbol_data.num = point_num;
tmp_symbol_data.coordinate(1,:) = smoothed_symbol_data.coordinate(1,:);
tmp_symbol_data.coordinate(point_num,:) = smoothed_symbol_data.coordinate(smoothed_symbol_data.num,:);

tmp_symbol_data.multi_str = smoothed_symbol_data.multi_str;

j = 1;

for p = 1:point_num-2
    
    while accumulated_distance(j)<p*unit_distance
        j = j+1;
    end
    
    if smoothed_symbol_data.coordinate(j-1,3) == smoothed_symbol_data.coordinate(j, 3)
        
        tmp_symbol_data.coordinate(p+1,3) =  smoothed_symbol_data.coordinate(j-1,3);
        C = (p*unit_distance-accumulated_distance(j-1))/(accumulated_distance(j)-accumulated_distance(j-1));
        tmp_symbol_data.coordinate(p+1,1) =  smoothed_symbol_data.coordinate(j-1,1)...
            + (smoothed_symbol_data.coordinate(j,1)-smoothed_symbol_data.coordinate(j-1,1))*C;
        tmp_symbol_data.coordinate(p+1,2) =  smoothed_symbol_data.coordinate(j-1,2)...
            + (smoothed_symbol_data.coordinate(j,2)-smoothed_symbol_data.coordinate(j-1,2))*C;
    else
        tmp_symbol_data.coordinate(p+1,3) = 0;
        C = (p*unit_distance-accumulated_distance(j-1))/(accumulated_distance(j)-accumulated_distance(j-1));
        tmp_symbol_data.coordinate(p+1,1) =  smoothed_symbol_data.coordinate(j-1,1)...
            + (smoothed_symbol_data.coordinate(j,1)-smoothed_symbol_data.coordinate(j-1,1))*C;
        tmp_symbol_data.coordinate(p+1,2) =  smoothed_symbol_data.coordinate(j-1,2)...
            + (smoothed_symbol_data.coordinate(j,2)-smoothed_symbol_data.coordinate(j-1,2))*C;
    end
    
end

resampled_symbol_data = tmp_symbol_data;

end




