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

function extract_feature()

cur_dir = cd;

% set path for the preprocessed symbols
source_dir = strcat(cur_dir, '/processed_symbols');
foldername = dir(source_dir);
folder_names = {foldername.name};
namelen = length(folder_names);

% set path for the extracted feature
destinate_dir = strcat(cur_dir,'/extractedfeature');
mkdir(destinate_dir);

for inamelen = 3:namelen
    
   indiv_symbol_name = folder_names{inamelen};
   
   indiv_symbol_dir = strcat(source_dir, '/', indiv_symbol_name);
   indiv_symbol_filename = dir(indiv_symbol_dir);
   indiv_symbol_names = {indiv_symbol_filename.name};
   indiv_symbol_length = length(indiv_symbol_names);
   fv_and_si = struct('si',{},'feature_vector',{},'multi_str',{});
   
   for iindiv_symbol_length = 3:indiv_symbol_length
      
        fid = fopen(strcat(indiv_symbol_dir,'/',indiv_symbol_names{iindiv_symbol_length}));

tline = fgetl(fid);
symbol_identity = sscanf(tline, '%s');

tline = fgetl(fid);
multi_str = sscanf(tline, '%d');
    fv_and_si(iindiv_symbol_length-2).multi_str = multi_str;

tline = fgetl(fid);
average_length = sscanf(tline, '%d');

    fv_and_si(iindiv_symbol_length-2).si = symbol_identity;
     all_point_coordinate = zeros(average_length, 3);
     
         
    for iaverage_length= 1:average_length
        
        tline = fgetl(fid);
        all_point_coordinate(iaverage_length,:) = (sscanf(tline,'%f'))';
    
    end
    
    % calculate the features
    fv_and_si(iindiv_symbol_length-2).feature_vector(:,1) = slope_cosine(all_point_coordinate);
    fv_and_si(iindiv_symbol_length-2).feature_vector(:,2) = normalized_y_position(all_point_coordinate);
    fv_and_si(iindiv_symbol_length-2).feature_vector(:,3) = penup_down(all_point_coordinate);
    fv_and_si(iindiv_symbol_length-2).feature_vector(:,4) = curvature_sine(all_point_coordinate);
    
    [dim1, dim2] = size(fv_and_si(iindiv_symbol_length-2).feature_vector);
    
    for idim1 = 1:dim1
        
        for idim2 = 1:dim2
            
            if  ~isreal(fv_and_si(iindiv_symbol_length-2).feature_vector(idim1, idim2))
                fv_and_si(iindiv_symbol_length-2).feature_vector(idim1, idim2) = 0;
                
            end
        end
        
    end
    
    
     fclose(fid);   
   end
   savefile = strcat(destinate_dir,'/',indiv_symbol_name,'.mat');
   
   
    save(savefile, 'fv_and_si');
end

end





