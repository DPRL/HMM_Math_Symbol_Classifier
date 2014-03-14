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

%The function is used to smooth the coordinate of points. Except the first
%and the last point of each stroke, other point's coordinate is the average of three
%points (the current one, the previous one and the subsequent one)

function smoothed_symbol_data = smoothing(A)% A is the name of input file

normalized_symbol_data = normalize(A);

tmp_symbol_data = normalized_symbol_data;
accumulated_point_num = 0;

for ii = 1:length(tmp_symbol_data.numinstroke)
   
    accumulated_point_num = accumulated_point_num +  tmp_symbol_data.numinstroke(ii);
   
for i = accumulated_point_num- tmp_symbol_data.numinstroke(ii)+2:accumulated_point_num-1
    
    tmp_symbol_data.coordinate(i, 1:2) = (normalized_symbol_data.coordinate(i-1, 1:2)...
        +normalized_symbol_data.coordinate(i, 1:2) +normalized_symbol_data.coordinate(i+1, 1:2))/3;
    
end

smoothed_symbol_data = tmp_symbol_data;

end
