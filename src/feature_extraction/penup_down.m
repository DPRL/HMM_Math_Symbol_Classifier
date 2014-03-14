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

% This function is used to get the penup\down feature, the distance of the
% point to the point of the beginning and the end of the stroke is taken
% into account
function ud = penup_down(all_point_coordinate)

coordinates = all_point_coordinate;
co_length = size(coordinates,1);%co_length is used to record the number of points in the symbol
up_down = ones(co_length,1);% up_down is used to record the penup\down feature

distance = zeros(co_length-1,1); % distance is used to record the distance between two consecutive points

for ico_length = 1: co_length-1
    
    distance(ico_length,1) = sqrt(sum((coordinates(ico_length+1,1:2)-coordinates(ico_length,1:2)).^2));
    
end

stroke_num = 1;%stroke_num is used to record how many strokes in the symbol


for ico_length = 1: co_length-1
   if   coordinates(ico_length,3)~=coordinates(ico_length+1,3)
       stroke_num = stroke_num + 1;
   end
end


% get the beginning and end index of each stroke
stroke_end_index = zeros(stroke_num,1);%record the end point's index
stroke_beginning_index = zeros(stroke_num,1);%record the beginning point's index

stroke_beginning_index(1,1)=1;
stroke_end_index(stroke_num,1) = co_length;

stroke_index=1;
for ico_length = 1: co_length-1
   if   coordinates(ico_length,3)~=coordinates(ico_length+1,3)
       stroke_end_index(stroke_index,1)=ico_length;
       stroke_beginning_index(stroke_index+1,1)=ico_length+1;
       stroke_index = stroke_index + 1;
   end
end


%get how many points in each stroke
stroke_point_num = zeros (stroke_num,1);%record how many points in each stroke;

for istroke_num = 1:stroke_num
    stroke_point_num(istroke_num) = stroke_end_index(istroke_num,1) - stroke_beginning_index(istroke_num,1)+1;
end

%get the length of each stroke
stroke_length = zeros(stroke_num,1);

for istroke_num = 1:stroke_num
    if coordinates(stroke_beginning_index(istroke_num,1),3)~= 0 % the stroke is actual stroke
        if stroke_point_num(istroke_num)==1
               stroke_length(istroke_num) = 0;
        else
            stroke_length(istroke_num) = sum(distance(stroke_beginning_index(istroke_num,1):(stroke_end_index(istroke_num,1)-1)));
        end
        
    else %the interpolated stroke
        stroke_length(istroke_num) = sum(distance(stroke_beginning_index(istroke_num,1)-1:stroke_end_index(istroke_num,1)));
    end
end

% get the penup\down feature values
for istroke_num = 1:stroke_num
   if coordinates(stroke_beginning_index(istroke_num,1),3)~= 0 % the stroke is actual stroke
        if stroke_point_num(istroke_num)==1
               up_down(stroke_beginning_index(istroke_num,1),1) = 1;
        elseif stroke_point_num(istroke_num)==2
             up_down(stroke_beginning_index(istroke_num,1),1) = 0;
             up_down(stroke_end_index(istroke_num,1),1) = 0;
        else
            up_down(stroke_beginning_index(istroke_num,1),1) = 0;
             up_down(stroke_end_index(istroke_num,1),1) = 0;
           for stroke_point_index = stroke_beginning_index(istroke_num,1)+1:stroke_end_index(istroke_num,1)-1
               
           distance_to_beginning =  sum(distance(stroke_beginning_index(istroke_num,1):stroke_point_index-1));
           distance_to_end = sum(distance(stroke_point_index:(stroke_end_index(istroke_num,1)-1)));
           delta_distance = abs(distance_to_beginning - distance_to_end);
           up_down(stroke_point_index,1) = 1 - delta_distance/stroke_length(istroke_num);

               
           end
        end
        
    else %the interpolated stroke
        for stroke_point_index = stroke_beginning_index(istroke_num,1):stroke_end_index(istroke_num,1)
           distance_to_beginning =  sum(distance(stroke_beginning_index(istroke_num,1)-1:stroke_point_index-1));
           distance_to_end = sum(distance(stroke_point_index:(stroke_end_index(istroke_num,1))));  
           delta_distance = abs(distance_to_beginning - distance_to_end);  
           up_down(stroke_point_index,1) = -(1 - delta_distance/stroke_length(istroke_num));
        
        end
    end
end

ud = up_down;
end