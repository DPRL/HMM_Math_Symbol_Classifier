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

function testing


round_num = 1;

for iround_num = 1:round_num
    iround_num

cur_dir = cd;

source_dir = strcat(cur_dir, '/parameter',num2str(iround_num));
foldername = dir(source_dir);
folder_names = {foldername.name};
namelen = length(folder_names);

parameter_index = {}; % used to find which symbol's parameter is singular

hmm_parameter = struct('symbol_name',{},'prior1',{}, 'transmat1',{},...
    'mu1',{}, 'Sigma1',{}, 'mixmat1',{});

for inamelen = 3:namelen
    
    load_data = load(strcat(source_dir,'/',folder_names{inamelen}));
    hmm_parameter(inamelen-2) =  load_data;
    
    parameter_index{inamelen-2} = folder_names{inamelen};
    
end

testset = load('testset.mat');
sample_num = length(testset.fv_and_si);
correct_num = 0;

top5_correct_num = 0;


lablist1 = struct('lab',{});
lablist2 = struct('lab',{});

multi_lablist1 = struct('lab',{});
single_lablist2 = struct('lab',{});

multi_lablist1 = struct('lab',{});
single_lablist2 = struct('lab',{});

    multi_num = 0;
    single_num = 0;
    
    
    multi_correct_num = 0;
    single_correct_num = 0;
    
    top5_multi_correct_num = 0;
    top5_single_correct_num = 0;



for isample_num = 1:sample_num
    

    multi_stroke = testset.fv_and_si(isample_num).multi_str;
    
    LL = zeros(1,namelen-2);
    
    real_LL = zeros(1,namelen-2);
    
    for inamelen =1:namelen-2
         
        LL(inamelen) = mhmm_logprob(testset.fv_and_si(isample_num).feature_vector',...
             hmm_parameter(inamelen).prior1, hmm_parameter(inamelen).transmat1,...
             hmm_parameter(inamelen).mu1, hmm_parameter(inamelen).Sigma1,...
             hmm_parameter(inamelen).mixmat1);

             
         
         if ~(isreal( LL(inamelen)))|isnan(LL(inamelen))
             
              real_LL(inamelen) = -inf;
              
         else real_LL(inamelen) =  LL(inamelen);
              
         end
    
    end
    
    
    
   [sorted_LL, sorted_index] = sort(real_LL);
    max_index = sorted_index(namelen-2);
    max_index2 = sorted_index(namelen-3);
    max_index3 = sorted_index(namelen-4);
    max_index4 = sorted_index(namelen-5);
    max_index5 = sorted_index(namelen-6);
    
    %top 1
    if strcmp(hmm_parameter(max_index).symbol_name,testset.fv_and_si(isample_num).si)
        
        correct_num = correct_num+1;
        
    end
    %top 5
    if strcmp(hmm_parameter(max_index).symbol_name,testset.fv_and_si(isample_num).si)|...
            strcmp(hmm_parameter(max_index2).symbol_name,testset.fv_and_si(isample_num).si)|...
            strcmp(hmm_parameter(max_index3).symbol_name,testset.fv_and_si(isample_num).si)|...
            strcmp(hmm_parameter(max_index4).symbol_name,testset.fv_and_si(isample_num).si)|...
            strcmp(hmm_parameter(max_index5).symbol_name,testset.fv_and_si(isample_num).si)
        
        top5_correct_num = top5_correct_num+1;
        
        if multi_stroke > 0
            
            top5_multi_correct_num = top5_multi_correct_num + 1;
            
        else
            
            top5_single_correct_num = top5_single_correct_num + 1;
        end
        
    end
    
    lablist1(isample_num).lab = testset.fv_and_si(isample_num).si;
% in order to turn alower to a
    lower_index1 = strfind(lablist1(isample_num).lab, 'lower');
    upper_index1 = strfind(lablist1(isample_num).lab, 'upper');
    
    if lower_index1 > 0
        
        lablist1(isample_num).lab = lablist1(isample_num).lab(1:lower_index1-1);
        
    elseif upper_index1 > 0
       
     lablist1(isample_num).lab = lablist1(isample_num).lab(1:upper_index1-1);
     
    end
    
    lablist2(isample_num).lab = hmm_parameter(max_index).symbol_name;
    
    lower_index2 = strfind(lablist2(isample_num).lab, 'lower');
    upper_index2 = strfind(lablist2(isample_num).lab, 'upper');
    
    if lower_index2 > 0
        
        lablist2(isample_num).lab = lablist2(isample_num).lab(1:lower_index2-1);
        
    elseif upper_index2 > 0
       
     lablist2(isample_num).lab = lablist2(isample_num).lab(1:upper_index2-1);
     
    end
    
    if multi_stroke > 0
        
        multi_num = multi_num + 1;
        multi_lablist1(multi_num).lab = lablist1(isample_num).lab;
        multi_lablist2(multi_num).lab = lablist2(isample_num).lab;
        
        if strcmp(multi_lablist1(multi_num).lab, multi_lablist2(multi_num).lab)
           
            multi_correct_num = multi_correct_num + 1;
        end
       
        
        
    else 
        
        single_num = single_num + 1;
        single_lablist1(single_num).lab = lablist1(isample_num).lab;
        single_lablist2(single_num).lab = lablist2(isample_num).lab;
        
        if strcmp(single_lablist1(single_num).lab, single_lablist2(single_num).lab)
           
            single_correct_num = single_correct_num + 1;
        
        end  
        
    end
        
    
end

true_label = {lablist1.lab};
estimated_label = {lablist2.lab};

multi_true_label = {multi_lablist1.lab};
multi_estimated_label = {multi_lablist2.lab};

single_true_label = {single_lablist1.lab};
single_estimated_label = {single_lablist2.lab};

%confmat(true_label(:), estimated_label(:))
% confusion_matrix = confmat(true_label(:), estimated_label(:));
% confusion_matrix


correct_num
sample_num
correct_rate = correct_num/sample_num;
correct_rate
top5_correct_num
top5_correct_rate = top5_correct_num/sample_num;
top5_correct_rate

%confmat(multi_true_label(:), multi_estimated_label(:))

multi_num
multi_correct_num
multi_correct_rate = multi_correct_num/multi_num;
multi_correct_rate
top5_multi_correct_num
top5_multi_correct_rate = top5_multi_correct_num/multi_num;
top5_multi_correct_rate


%confmat(single_true_label(:), single_estimated_label(:))

single_num
single_correct_num
single_correct_rate = single_correct_num/single_num;
single_correct_rate
top5_single_correct_num
top5_single_correct_rate = top5_single_correct_num/single_num 

filename = strcat(cur_dir,'/','experiment_result',num2str(iround_num),'.txt');

fidw = fopen(filename,'w');

fprintf(fidw,'%s\r\n','correct_num');
fprintf(fidw,'%d\r\n',correct_num);
fprintf(fidw,'%s\r\n','sample_num');
fprintf(fidw,'%d\r\n',sample_num);
fprintf(fidw,'%s\r\n','correct_rate');
fprintf(fidw,'%f\r\n',correct_rate);
fprintf(fidw,'%s\r\n','top5_correct_num');
fprintf(fidw,'%d\r\n',top5_correct_num);
fprintf(fidw,'%s\r\n','top5_correct_rate');
fprintf(fidw,'%f\r\n',top5_correct_rate);

fprintf(fidw,'%s\r\n','multi_correct_num');
fprintf(fidw,'%d\r\n',multi_correct_num);
fprintf(fidw,'%s\r\n','multi_num');
fprintf(fidw,'%d\r\n',multi_num);
fprintf(fidw,'%s\r\n','multi_correct_rate');
fprintf(fidw,'%f\r\n',multi_correct_rate);
fprintf(fidw,'%s\r\n','top5_multi_correct_num');
fprintf(fidw,'%d\r\n',top5_multi_correct_num);
fprintf(fidw,'%s\r\n','top5_multi_correct_rate');
fprintf(fidw,'%f\r\n',top5_multi_correct_rate);

fprintf(fidw,'%s\r\n','single_correct_num');
fprintf(fidw,'%d\r\n',single_correct_num);
fprintf(fidw,'%s\r\n','single_num');
fprintf(fidw,'%d\r\n',single_num);
fprintf(fidw,'%s\r\n','single_correct_rate');
fprintf(fidw,'%f\r\n',single_correct_rate);
fprintf(fidw,'%s\r\n','top5_single_correct_num');
fprintf(fidw,'%d\r\n',top5_single_correct_num);
fprintf(fidw,'%s\r\n','top5_single_correct_rate');
fprintf(fidw,'%f\r\n',top5_single_correct_rate);

 fclose(fidw);

end    