%% Polynomial best fit demo
%@Author: Andrew Chan

function Polyfiter(y, power, xTitle, yTitle, fig)
time = y(1,:);
ySet = y(2,:);

figure(fig);
%Plot range of values in ySet
hold on;
%Find best fit line
%fprintf('Power: %d\n', power);
%coeff = curveFit(time, ySet, power);
%display for diary
%disp("Coefficients: ");
%disp(coeff');
%yBestFit = curveValues(time, coeff);

%fprintf('-----------------------\n')
%Plot best fit curves
%plot(time, yBestFit, 'DisplayName',  sprintf('%d power estimation of %s', power, yTitle))
plot(time, ySet,'-*', 'DisplayName', sprintf('Original Data Set of %s', yTitle));
legend('show');
title(sprintf('Estimation of %s vs %s', xTitle, yTitle));
xlabel(xTitle);
ylabel(yTitle);

hold off;
%% Curve fitting function
%Inputs
%	xSet = domain of points to fit (AS ROWS)
% ySet = y values for coresponding indicies of xSet values (AS ROWS)
%	p = highest polynomial estimation
%Output
% coefficients of function
% coefficients = [c1 c2 c3 .. c(p+1)]
% y = c1 + c2(x) + c3(x^2) + c4(x^3) + ... c(p+1)x^p
    function coefficients = curveFit(xSet, ySet, p)
        %length of X set
        m = length(xSet);
        
        %Start forming A matrix out of xSet elements
        A = [ones(1, m)', zeros(m, p)];
        for i = 2: p+1
            %Forming vectors after 1
            A(:, i) = (xSet').^(i-1);
        end
        
        %Now, we want to solve AT*A*Xls = AT*y
        %From problem 2.2, we created function getxLs which finds xLs given A and b
        coefficients = getxLs(A, ySet');
    end

%% Generating curve values
%Input
% xSet -> Domain of curve
% coefficients -> best fit coefficients generated with curveFit function
% estVal -> Range of best fit line
    function estVals = curveValues(xSet, coefficients)
        %Length of coefficients
        n = length(coefficients);
        %length of X set
        m = length(xSet);
        %Checks if power estimation is 1 or 2
        if(n > 2)
            %Preallowcating
            X = [ones(1, m); xSet; zeros(n-2, m)];
            for i = 3 : n
                %Generating X matrix
                X(i, :) = xSet .*X(i-1, :);
            end
        elseif(n > 1)
            X = [ones(1, m); xSet];
        else
            X = [ones(1,m)];
        end
        % y = C' * X
        estVals = coefficients' * X;
    end

%Could we say that inv(S) = 1./S?
%Solving Sy = b~ eliminates the 0 indexed elements just as (1./S)U' would

%Input
% A -> main matrix
% b -> the b in A*xLs = b

%Output
% xLs
    function xLs = getxLs(A, b)
        [U, S, V] = svd(A);
        
        %bTmp = U'*b
        %y = S\bTmp
        %xLs = V*y
        
        %Equivilently,xLs = V* S^-1 * U' * b
        %xLs = V*(S\(U'*b));
        
        %Part g solution
        xLs = A\b;
        
        %Or even xLs = V * (1./S) * U' * b?
        %xLs = V * (S.^-1) * U' * b;
        %Tests reveal that this doesn't work.
    end
end







