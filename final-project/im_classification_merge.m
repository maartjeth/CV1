function im_classification_merge(sift_type, vocab_size)

    % RUN 1 - Intensity sift

    target_dir = '.\Caltech4\FeatureData';
    sift_type = 'ip_intensity_1';
    vocab_size = 400;
    
    filename_train = strcat(target_dir, '\train_data_', sift_type, '_voc_', num2str(vocab_size),'.mat');
    filename_test = strcat(target_dir, '\test_data_', sift_type, '_voc_', num2str(vocab_size),'.mat');
    
    test_dirs = {'.\Caltech4\ImageData\airplanes_test', '.\Caltech4\ImageData\cars_test', '.\Caltech4\ImageData\faces_test', '.\Caltech4\ImageData\motorbikes_test'};
    target_path = strcat(target_dir, '\html_blob_', sift_type, '_voc_', num2str(vocab_size),'.txt');
    
    % training
    load(filename_train);
    load(filename_test);
    
    % SVM class 1
    [X, y] = make_data(train_data, 1);
    SVMModel_1 = train_SVM(X, y);
    
    % SVM class 2
    [X, y] = make_data(train_data, 2);
    SVMModel_2 = train_SVM(X, y);
    
    % SVM class 3
    [X, y] = make_data(train_data, 3);
    SVMModel_3 = train_SVM(X, y);
    
    % SVM class 4
    [X, y] = make_data(train_data, 4);
    SVMModel_4 = train_SVM(X, y);
    
    
    % Classifying and computing MAP   
    [X_test, t] = make_data(test_data, 1);
    %[X, y] = make_data(train_data, 1);
    [labels_1, scores_1] = classify_im(SVMModel_1, X_test);
    AP_1 = test(scores_1, t)
    col1 = get_image_order(test_dirs, scores_1);
    
    [X_test, t] = make_data(test_data, 2);
    %[X, y] = make_data(train_data, 2);
    [labels_2, scores_2] = classify_im(SVMModel_2, X_test);    
    AP_2 = test(scores_2, t)
    col2 = get_image_order(test_dirs, scores_2);
    
    [X_test, t] = make_data(test_data, 3);
    %[X, y] = make_data(train_data, 3);
    [labels_3, scores_3] = classify_im(SVMModel_3, X_test);    
    AP_3 = test(scores_3, t)
    col3 = get_image_order(test_dirs, scores_3);
    
    [X_test, t] = make_data(test_data, 4);
    %[X, y] = make_data(train_data, 4);
    [labels_4, scores_4] = classify_im(SVMModel_4, X_test);
    AP_4 = test(scores_4, t)
    col4 = get_image_order(test_dirs, scores_4);
    
    MAP = (AP_1 + AP_2 + AP_3 + AP_4) / 4

    stitch_columns_html(target_path, col1, col2, col3, col4)
end

function [X, y] = make_data(data, class)
    X = data(:, 1:end-1);
    y = data(:, end);
    y(y ~= class) = 0;
    y(y == class) = 1;
end

function SVMModel = train_SVM(X, y)
    %SVMModel = fitcsvm(X, y, 'KernelFunction', 'rbf', 'KernelScale', 'auto', 'Standardize', true);
    SVMModel = fitcsvm(X, y, 'KernelFunction', 'linear', 'KernelScale', 'auto', 'Standardize', true);
end

function [labels, scores] = classify_im(SVMModel, X)
    [labels, scores] = predict(SVMModel, X);
end

function AP = test(scores, t)
    % qualatitive part
    test_matrix = [scores(:,1), t];
    quant_test_matrix = sortrows(test_matrix, 1);
    MSE = sum((quant_test_matrix(:, 1) - quant_test_matrix(:, 2)).^2)/size(quant_test_matrix, 1);
    
    % quantitative part
    fc = 0;
    total_score = 0;
    for i=1:size(quant_test_matrix, 1)
        fc = fc + quant_test_matrix(i, 2);
        if quant_test_matrix(i, 2) == 1
            score = fc / i;
        else 
            score = 0;
        end
        total_score = total_score + score;
    end
    
    AP = double(total_score / 50);  % change for other vocab sizes  
end
