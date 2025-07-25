function [c, lags] = xcorr_ignore_nan_coeff(x, y, maxlag)
    % Cross-correlation ignoring NaNs with normalization ('coeff' like behavior)
    % Optional third argument: maxlag
    % 
    % Usage:
    %   c = xcorr_ignore_nan_coeff(x) % autocorrelation full
    %   c = xcorr_ignore_nan_coeff(x, y) % cross-correlation full
    %   c = xcorr_ignore_nan_coeff(x, y, maxlag) % cross-correlation limited to maxlag

    if nargin < 2 || isempty(y)
        y = x; % autocorrelation if only one input
    end
    
    x = x(:); % ensure column vectors
    y = y(:);
    
    N = length(x);
    M = length(y);

    % Determine full possible lags
    full_lags = -(M-1):(N-1);

    % Apply maxlag limit if given
    if nargin < 3 || isempty(maxlag)
        lags = full_lags;
    else
        maxlag = abs(maxlag); % make sure it's positive
        lags = -maxlag:maxlag;
        % Clip lags to available range
        lags = lags(lags >= min(full_lags) & lags <= max(full_lags));
    end

    c = NaN(size(lags)); % preallocate result

    for idx = 1:length(lags)
        lag = lags(idx);
        
        if lag < 0
            x_segment = x(1:end+lag);
            y_segment = y(1-lag:end);
        else
            x_segment = x(1+lag:end);
            y_segment = y(1:end-lag);
        end
        
        % Find valid (non-NaN) pairs
        valid = ~isnan(x_segment) & ~isnan(y_segment);
        
        if any(valid)
            x_valid = x_segment(valid);
            y_valid = y_segment(valid);
            
            % Subtract means of valid points
            x_valid = x_valid - mean(x_valid);
            y_valid = y_valid - mean(y_valid);
            
            numerator = sum(x_valid .* y_valid);
            denominator = sqrt(sum(x_valid.^2) * sum(y_valid.^2));
            
            if denominator ~= 0
                c(idx) = numerator / denominator;
            else
                c(idx) = NaN; % if denominator zero, undefined
            end
        else
            c(idx) = NaN; % no valid points
        end
    end
end
