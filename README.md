DPRL Hidden Markov Model (HMM) math symbol classifier
---------------

DPRL Hidden Markov Model (HMM) Math Symbol Classifier
Copyright (c) 2010-2014 Lei Hu, Richard Zanibbi

DPRL Hidden Markov Model (HMM) Math Symbol Classifier is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

DPRL Hidden Markov Model (HMM) Math Symbol Classifier is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with DPRL Hidden Markov Model (HMM) Math Symbol Classifier.  If not, see <http://www.gnu.org/licenses/>.

Contact:
        - Lei Hu: lei.hu@rit.edu
        - Richard Zanibbi: rlaz@cs.rit.edu 


This document is about the HMM online math symbol classifier in the paper [HMM-Based Recognition of Online Handwritten Mathematical Symbols Using Segmental K-means Initialization and a Modified Pen-up/down Feature].
The details about preprocessing, feature selection and HMM algorithm can be found in the paper.

How to run the codes?
----
The codes are written in Matlab and include three parts: preprocessing, feature selection, training and classification.
Both training and classification use the [HMM toolbox].

**Preprocessing**

The function divide_dataset.m can divide the dataset randomly into training set and testing set. The parameter test_proportion control the proportion of sample in the testing set. If the value of test_proportion is 0.1, this means 10% of the samples in the dataset are assigned randomly to testing set and the other 90% samples are in training set.

The function preprocessing_symbol_data.m do the preprocessing. Input path and output path have to be set up. The average_num is the number of points of preprocessed symbol, and the default value is 30. For the input path, each symbol class has a folder. Within that folder, there are two folders, one for train and the other one for test.  For example, for symbol 0, we have a folder 0, and there are two folders 0test and 0train in folder 0. For the output path, each symbol class has a folder and the folder contains the preprocesed symbol data for that symbol class. Besides that, there is a folder testset which include the test preprocessed symbol data for symbol class. 

The format of symbol data before preprocessing is:

total number of strokes in that symbol

number of points in the 1st stroke

x coordinate of the 1st point of 1st stroke, y coordinate of the 1st point of 1st stroke

...

x coordinate of the last point of 1st stroke, y coordinate of the last point of 1st stroke

number of points in the 2nd stroke

x coordinate of the 1st point of 2nd stroke, y coordinate of the 2nd point of 1st stroke

...

x coordinate of the last point of 2nd stroke, y coordinate of the last point of 2nd stroke

The details of format of symbol data before preprocessing can be found in the folder symbol.

**Feature selection**

The function extract_feature.m does the feature extraction. The path for the preprocessed symbol and the path for the extracted feature need to be set up. For each folder in the preprocessed symbol path, a .mat file is produced to contains the extracted feature for the samples in that folder. For example, for folder 0 which contains many samples for symbol 0, the function extract_feature.m generates 0.mat which contains the features for symbol 0. 

**Training**

The function trainingHMM.m is used to train the HMM. The path for the extracted feature and the path for the HMM parameter needs to be set up. Parameter round_num is used to control the number of HMM classifiers which will be trained. If round_num is 10, that means 10 different HMM classifiers will be trained and each HMM classifier has a HMM model for each symbol class. In the folder for each HMM classifier, there is a HMM parameter for each symbol class. If we only train 1 HMM classifier, the HMM classifier folder is parameter 1. In the folder parameter1, each symbol class has its own HMM model parameter, such as 0_HMM_parameter.mat for symbol 0. Parameter Q controls the number of state. Parameter M controls the number of components in the mixture Gaussian. 

**Classification**

Function testing.m is used to test the HMM classifier on the testing set. Parameter round_num is used to control the number of HMM classifier which will be test. For example, if we only have 1 HMM classifier. The folder parameter1 contains the HMM parameter for the classifier and file testset.mat contains the extracted features for the testing samples. The parameter1, testset.mat and testing.m have to be in the same folder. The testing result will be write in the file experiment_result1.txt. It contains top-1 and top-5 recognition rate.

  [HMM-Based Recognition of Online Handwritten Mathematical Symbols Using Segmental K-means Initialization and a Modified Pen-up/down Feature]: http://ieeexplore.ieee.org/xpl/articleDetails.jsp?tp=&arnumber=6065353&queryText%3D%5BHMM-Based+Recognition+of+Online+Handwritten+Mathematical+Symbols+Using+Segmental+K-means+Initialization+and+a+Modified+Pen-up%2Fdown+Feature%5D

[HMM toolbox]: http://www.cs.ubc.ca/~murphyk/Software/HMM/hmm.html

    