function im_classification_merge()

    % RUN 1 - Intensity sift

    target_dir = '.\Caltech4\debug\target';
    sift_type = 'ip_intensity_1';
    vocab_size = 20;

    filename = strcat(target_dir, '\train_data_', sift_type, '_voc_', num2str(vocab_size),'.mat');
    
    % training
    load(filename);
    
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
    
    
    % Classifying
    
    % MAP
    
end

function [X_train, y_train] = make_data(train_data, class)
    X_train = train_data(:, 1:end-1);
    y_train = train_data(:, end);
    y_train(y_train ~= class) = 0;
    y_train(y_train == class) = 1;
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
