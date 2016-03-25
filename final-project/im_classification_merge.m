function im_classification_merge()

    % RUN 1 - Intensity sift

    target_dir = '.\Caltech4\debug\target';
    sift_type = 'ip_intensity_1';
    vocab_size = 400;

    filename_train = strcat(target_dir, '\train_data_', sift_type, '_voc_', num2str(vocab_size),'.mat');
    filename_test = strcat(target_dir, '\test_data_', sift_type, '_voc_', num2str(vocab_size),'.mat');
    
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
    [X_test, t] = make_data(test_data, 1)
    labels_1 = classify_im(SVMModel_1, X_test)    
    MAP_1 = test(labels_1, t)
    
    
    [X_test, t] = make_data(test_data, 2);
    labels_2 = classify_im(SVMModel_2, X_test);    
    MAP_2 = test(labels_2, t);
    
    [X_test, t] = make_data(test_data, 3);
    labels_3 = classify_im(SVMModel_3, X_test);    
    MAP_3 = test(labels_3, t);
    
    [X_test, t] = make_data(test_data, 4);
    labels_4 = classify_im(SVMModel_4, X_test);
    MAP_4 = test(labels_4, t);

end

function [X, y] = make_data(data, class)
    X = data(:, 1:end-1);
    y = data(:, end);
    y(y ~= class) = 0;
    y(y == class) = 1;
end

function SVMModel = train_SVM(X, y)
    SVMModel = fitcsvm(X, y, 'KernelFunction', 'rbf', 'KernelScale', 'auto', 'Standardize', true);
end

function labels = classify_im(SVMModel, X)
    labels = predict(SVMModel, X);
end

function MAP = test(labels, t)
    % qualatitive part
    test_matrix = [labels', t'];
    quant_test_matrix = sortrows(test_matrix, -1);
    %MSE = (quant_test_matrix(1) - quant_test_matrix(2)).^2;
    
    % quantitative part
    fc = 0;
    total_score = 0;
    for i=1:size(quant_test_matrix, 1)
        quant_test_matrix(i, 2);
        fc = fc + quant_test_matrix(i, 2);
        if quant_test_matrix(i, 2) == 1
            score = fc / i;
        else 
            score = 0;
        end
        total_score = total_score + score;
    end
    
    MAP = total_score / size(quant_test_matrix, 1);    
end
