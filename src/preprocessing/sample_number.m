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

function sample_number()

cur_dir = cd;

source_dir = strcat(cur_dir, '/symbols');
foldername = dir(source_dir);
folder_names = {foldername.name};
namelen = length(folder_names);

filename = 'sample_number.txt';
fidw = fopen(filename,'w');
total_sample_number = 0;

for inamelen = 1:namelen
 if ~(strcmp(folder_names{inamelen},'.')|strcmp(folder_names{inamelen},'..'))
     indiv_symbol_name = folder_names{inamelen};
     indiv_symbol_dir = strcat(source_dir, '/', indiv_symbol_name);
        indiv_foldername = dir(indiv_symbol_dir);
        indiv_folder_names = {indiv_foldername.name};
        indiv_namelen = length(indiv_folder_names);
        indiv_sample_number = indiv_namelen - 2;
        total_sample_number = total_sample_number + indiv_sample_number;
        
        fprintf(fidw,'%s %d\r\n',indiv_symbol_name, indiv_sample_number);
 
 end

end
fprintf(fidw,'\r\n');
fprintf(fidw,'%s %d\r\n','total', total_sample_number);
fclose(fidw);
end