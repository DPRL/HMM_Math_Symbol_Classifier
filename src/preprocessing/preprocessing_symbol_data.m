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

function preprocessing_symbol_data()

cur_dir = cd;

% set the input path
source_dir = strcat(cur_dir, '/divided_symbols_0.1');
foldername = dir(source_dir);
folder_names = {foldername.name};
namelen = length(folder_names);

% set the output path
destinate_dir = strcat(cur_dir,'/processed_symbols');
mkdir(destinate_dir);
preprocessed_test_dir = strcat(destinate_dir,'/testset');
mkdir(preprocessed_test_dir);
average_num = 30;
accumulated_num =0;


for inamelen = 3:namelen
    
    accumulated_num = accumulated_num + 1;
    indiv_symbol_name = folder_names{inamelen};
     indiv_symbol_name
    indiv_symbol_dir = strcat(source_dir, '/', indiv_symbol_name);
    indiv_symbol_test_dir = strcat(indiv_symbol_dir,'/',indiv_symbol_name,'test');
    indiv_symbol_train_dir = strcat(indiv_symbol_dir,'/',indiv_symbol_name,'train');
    
    train_sample_name = dir(indiv_symbol_train_dir);
    train_sample_names = {train_sample_name.name};
    train_namelen = length(train_sample_names);
    
    preprocessed_indiv_symbol_train_dir = strcat(destinate_dir,'/',indiv_symbol_name);
    mkdir(preprocessed_indiv_symbol_train_dir);
    
    % deal with each symbol class in training set
    for itrain_namelen = 3:train_namelen
        
        resampled_symbol_data = equal_distance(strcat(indiv_symbol_train_dir,'/',train_sample_names{itrain_namelen}),average_num);   
        files = dir(preprocessed_indiv_symbol_train_dir);
        numfiles = length(files) - 1;
        filename = strcat(preprocessed_indiv_symbol_train_dir,'/',indiv_symbol_name,'_',int2str(numfiles),'.txt');
        
        fidw = fopen(filename,'w');
     
     fprintf(fidw,'%s\r\n',indiv_symbol_name);
     
     fprintf(fidw,'%d\r\n',resampled_symbol_data.multi_str);
     
     fprintf(fidw,'%d\r\n',average_num);
     
     fprintf(fidw,'%f %f %f\r\n',(resampled_symbol_data.coordinate)');
     fclose(fidw);
               
    end
    
    
    test_sample_name = dir(indiv_symbol_test_dir);
    test_sample_names = {test_sample_name.name};
    test_namelen = length(test_sample_names);
     % deal with each symbol class in testing set   
      for itest_namelen = 3:test_namelen
        
        resampled_symbol_data = equal_distance(strcat(indiv_symbol_test_dir,'/',test_sample_names{itest_namelen}),average_num);
        
       files = dir(preprocessed_test_dir);
        filename = strcat(preprocessed_test_dir,'/',indiv_symbol_name,'_',int2str(itest_namelen - 2),'.txt');
        
         fidw = fopen(filename,'w');
     
     fprintf(fidw,'%s\r\n',indiv_symbol_name);
     
      fprintf(fidw,'%d\r\n',resampled_symbol_data.multi_str);
     
     fprintf(fidw,'%d\r\n',average_num);
     
     fprintf(fidw,'%f %f %f\r\n',(resampled_symbol_data.coordinate)');
     fclose(fidw);
               
      end       
    accumulated_num    
end

end

             