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

%The functino is used to train the model for each symbol. And the
%correspong parameter will be saved in the
%strcat('HMM_parameter_',symbol_name, '.mat') file

function trainingHMM

cur_dir = cd;

% set the extracted feature path
source_dir = strcat(cur_dir, '/extractedfeature');
foldername = dir(source_dir);
folder_names = {foldername.name};
namelen = length(folder_names);

round_num = 1;

for iround_num = 1:round_num
    
    iround_num
    % set the HMM paramter path
    destinate_dir = strcat(cur_dir,'/parameter',num2str(iround_num));
    mkdir(destinate_dir);
     
    for inamelen = 3:namelen
        
        tmp_file_name = folder_names{inamelen};
        tmp_file_name_length = length(tmp_file_name);
        symbol_name = '';
        % get the name of symbol
        for itmp_file_name_length = 1:tmp_file_name_length
            
            if tmp_file_name(itmp_file_name_length) == '.'
                break;
            else
                symbol_name = strcat(symbol_name,tmp_file_name(itmp_file_name_length));
            end      
        end
        symbol_name
               
        filename = strcat(source_dir, '/', tmp_file_name);
        load_data = load(filename);
               
        fv_and_si = load_data.fv_and_si;
        O = size(fv_and_si(1).feature_vector,2); %O the dimension of feature vector
        T = size(fv_and_si(1).feature_vector,1);%the length of sequence of feature vectors
        nex = length(fv_and_si); % the number of training sample for a kind of symbol
        
        data = zeros (O,T,nex);
        
        for inex = 1:nex
            data(:,:,inex)  = fv_and_si(inex).feature_vector';
        end
        
        original_data = data;
        M = 5; %M the number of components in the mixture Gaussian    
        Q = 6; %Q number of state

        %initilize the initial state distribution
        prior0 = zeros(Q,1);
        prior0(1) = 1;% the beginning would always be the first state
        
       %initilize the transition matrix, only allow the transition to itself or to the next state 
        transmat0 = zeros(Q,Q);
        
        for i=1:Q-1
           
            transmat0(i,i) = 0.5;
            transmat0(i,i+1) = 0.5;
            
        end
        
        transmat0(Q,Q) = 1;
        
         % these index are used to record how many points in each state
        state1_ind = 0;
        state2_ind = 0;
        state3_ind = 0;
        state4_ind = 0;
        state5_ind = 0;
        state6_ind = 0;
        %transmat0
        
       [mu0, Sigma0, mixmat0] = mixgauss_init(Q*M, reshape(data, [O T*nex]), 'diag', 'rnd');
        mu0 = reshape(mu0, [O Q M]);
        new_mu0 = mu0; 
        old_mu0 = mu0;
        Sigma0 = reshape(Sigma0, [O O Q M]);
        new_Sigma0 = Sigma0;
        old_Sigma0 = Sigma0;
        mixmat0 = mk_stochastic (rand(Q,M));
        new_mixmat0 = mixmat0;
        old_mixmat0 = mixmat0;
        
        seg_round = 5;
        
        for iseg_round = 1:seg_round
        
        seg_path = zeros(nex,T);
        
        for inex = 1:nex
            B = mixgauss_prob(original_data(:,:,inex), old_mu0, old_Sigma0, old_mixmat0);
            
            seg_path(inex,:) = seg_viterbi_path(prior0, transmat0, B);
            
            for iT = 1:T
                
                if seg_path(inex, iT) == 1
                    state1_ind = state1_ind + 1;
                    data1(:,state1_ind) = original_data(:,iT,inex);% data1 is used to record the data of points belong to state 1
                elseif seg_path(inex, iT) == 2
                    state2_ind = state2_ind + 1;
                    data2(:,state2_ind) = original_data(:,iT,inex);
                elseif seg_path(inex, iT) == 3
                    state3_ind = state3_ind + 1;
                    data3(:,state3_ind) = original_data(:,iT,inex);
                elseif seg_path(inex, iT) == 4
                    state4_ind = state4_ind + 1;
                    data4(:,state4_ind) = original_data(:,iT,inex);
                elseif seg_path(inex, iT) == 5
                    state5_ind = state5_ind + 1;
                    data5(:,state5_ind) = original_data(:,iT,inex);
                elseif seg_path(inex, iT) == 6
                    state6_ind = state6_ind + 1;
                    data6(:,state6_ind) = original_data(:,iT,inex);
                end
                
            end
        end
        
      %  seg_path(1,:)
        
       [mu01, Sigma01, mixmat01] = mixgauss_init(M, data1, 'diag', 'kmeans');
       [mu02, Sigma02, mixmat02] = mixgauss_init(M, data2, 'diag', 'kmeans');
       [mu03, Sigma03, mixmat03] = mixgauss_init(M, data3, 'diag', 'kmeans');
       [mu04, Sigma04, mixmat04] = mixgauss_init(M, data4, 'diag', 'kmeans');
       [mu05, Sigma05, mixmat05] = mixgauss_init(M, data5, 'diag', 'kmeans');
       [mu06, Sigma06, mixmat06] = mixgauss_init(M, data6, 'diag', 'kmeans');
       for iM = 1:M  
           new_mu0(:,1,iM) = mu01(:,iM);
           new_mu0(:,2,iM) = mu02(:,iM);
           new_mu0(:,3,iM) = mu03(:,iM);
           new_mu0(:,4,iM) = mu04(:,iM);
           new_mu0(:,5,iM) = mu05(:,iM);
           new_mu0(:,6,iM) = mu06(:,iM);
           
           new_Sigma0(:,:,1,iM) = Sigma01(:,:,iM);
           new_Sigma0(:,:,2,iM) = Sigma02(:,:,iM);
           new_Sigma0(:,:,3,iM) = Sigma03(:,:,iM);
           new_Sigma0(:,:,4,iM) = Sigma04(:,:,iM);
           new_Sigma0(:,:,5,iM) = Sigma05(:,:,iM);
           new_Sigma0(:,:,6,iM) = Sigma06(:,:,iM);
           
           new_mixmat0(1,iM) = mixmat01(iM,1);
           new_mixmat0(2,iM) = mixmat02(iM,1);
           new_mixmat0(3,iM) = mixmat03(iM,1);
           new_mixmat0(4,iM) = mixmat04(iM,1);
           new_mixmat0(5,iM) = mixmat05(iM,1);
           new_mixmat0(6,iM) = mixmat06(iM,1);
       end
       
       old_mu0 = new_mu0;
       old_Sigma0 = new_Sigma0;
       old_mixmat0 = new_mixmat0;
       
        end
       
          
        [LL, prior1, transmat1, mu1, Sigma1, mixmat1] = mhmm_em(data, prior0, transmat0, new_mu0, new_Sigma0,new_mixmat0, 'max_iter', 11,'cov_type','diag','adj_prior',0);
        
        filename = strcat(destinate_dir, '/', symbol_name, '_HMM_parameter', '.mat');
        
        save(filename, 'symbol_name','prior1', 'transmat1', 'mu1', 'Sigma1', 'mixmat1');
        
    end
    
end

end

