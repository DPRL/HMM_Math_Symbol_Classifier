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

function divide_dataset()

test_proportion = 0.1;
cur_dir = cd;
source_dir = strcat(cur_dir, '\symbols');
foldername = dir(source_dir);
folder_names = {foldername.name};
namelen = length(folder_names);

destinate_dir = strcat(cur_dir,'\divided_symbols_',num2str(test_proportion));
mkdir(destinate_dir);

for inamelen = 3:namelen
    
    indiv_symbol_name = folder_names{inamelen};
    indiv_symbol_dir = strcat(source_dir, '\', indiv_symbol_name);
    
    indiv_file_name = dir(indiv_symbol_dir);
    indiv_file_names = {indiv_file_name.name};
    indiv_namelen = length(indiv_file_names);
    
    indiv_symbol_num = indiv_namelen - 2;
    
    testlen = ceil(indiv_symbol_num * test_proportion);
    trainlen = indiv_symbol_num - testlen;
    
    random_order = randperm(indiv_symbol_num);
    
    test_names = indiv_file_names(random_order(1:testlen)+2);
    train_names = indiv_file_names(random_order(testlen+1:indiv_symbol_num)+2);
    
    divided_indiv_symbol_dir = strcat(destinate_dir,'\',indiv_symbol_name);
    mkdir(divided_indiv_symbol_dir);
    
    divided_indiv_symbol_test_dir = strcat(divided_indiv_symbol_dir, '\', indiv_symbol_name, 'test');
    mkdir(divided_indiv_symbol_test_dir);
    divided_indiv_symbol_train_dir = strcat(divided_indiv_symbol_dir, '\', indiv_symbol_name, 'train');
    mkdir(divided_indiv_symbol_train_dir);
    
    for itestlen = 1:testlen
        
        copyfile(strcat(indiv_symbol_dir,'\',test_names{itestlen}), divided_indiv_symbol_test_dir);
        
    end
    
    for itrainlen = 1:trainlen
        
        copyfile(strcat(indiv_symbol_dir,'\',train_names{itrainlen}), divided_indiv_symbol_train_dir);
        
    end
    
end

end



