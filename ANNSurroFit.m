function objectives = ANNSurroFit(x, net, Xmax, Xmin)
    % Directly predict the objective values using the trained ANN
    % Use the ANN to predict objective values
    Xnorm = (x - Xmin) ./ (Xmax - Xmin);
    objectives = net(Xnorm')';
end
