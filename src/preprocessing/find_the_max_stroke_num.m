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

function find_the_max_stroke_num()

cur_dir = cd;

source_dir = strcat(cur_dir, '/divided_symbols_0.1');
foldername = dir(source_dir);
folder_names = {foldername.name};
namelen = length(folder_names);
accumulated_num =0

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
       
    for itrain_namelen = 3:train_namelen
        
        cd_symbol_data = read_symbol_data(strcat(indiv_symbol_train_dir,'/',train_sample_names{itrain_namelen}));
        
        if length(cd_symbol_data)>4
            strcat(indiv_symbol_train_dir,'/',train_sample_names{itrain_namelen})
        end
        
    end
    
    
    test_sample_name = dir(indiv_symbol_test_dir);
    test_sample_names = {test_sample_name.name};
    test_namelen = length(test_sample_names);
    
    for itest_namelen = 3:test_namelen
        
        cd_symbol_data = read_symbol_data(strcat(indiv_symbol_test_dir,'/',test_sample_names{itest_namelen}));
        
        if length(cd_symbol_data)>4
            strcat(indiv_symbol_test_dir,'/',test_sample_names{itest_namelen})
        end
        
    end
       
    accumulated_num
    
end

end