% Demo code to reproduce the results of "Dominant Rotated Local Binary Patterns for Texture Classification"
% The script run the test suite for Outex-10 dataset. It assumes the dataset
% is downloaded and saved in the same directory as the code. 
% 
% Author: Rakesh Mehta (rakesh.mehta@tut.fi)

clear all;
addpath('../000');
addpath('../images');
p = 16;
r = 3;
theta_feature = 90;                  % Feature selection threshold parameter (must be set between 85 to 95)


% Open the files with pre-defined training and testing partitions
fid1 = fopen('train.txt');
fid2 = fopen('test.txt');
train_num = str2double(fgets(fid1)); 
test_num = str2double(fgets(fid2));
train_class = zeros(train_num,1);
test_class = zeros(test_num,1);

% mapping=getmapping(p,'u2');        % Mapping can also be used, but it
                                     % results in drop of performance



% Compute the rlbp descriptor for the training images
for i = 1:train_num
    
    ln = fgets(fid1);
    line_split = strsplit(ln);
    img = imread(line_split{1});
    train_class(i,1) = str2double(line_split{2});
    rlbp_trains(i,:) = rlbp(img,r,p);
    
end
fclose(fid1);


% Compute the rlbp descriptor for the testing images
for i = 1:test_num
    
    ln = fgets(fid2);
    line_split = strsplit(ln);
    img = imread(line_split{1});
    test_class(i,1) = str2double(line_split{2});
    rlbp_tests(i,:) = rlbp(img,r,p);
end
fclose(fid2);

% Feature selection based on the frequency of the patterns
dominant_ids = get_dominant_ids(rlbp_trains, 0.01*theta_feature);


% Classification 
DM = zeros(test_num,train_num);
for j=1:test_num;
    test = rlbp_tests(j,dominant_ids);
    DM(j,:) = distMATChiSquare(rlbp_trains(:,dominant_ids),test)';
end


% Classification accuracy
accuracyDRLBP = ClassifyOnNN(DM,train_class,test_class)




