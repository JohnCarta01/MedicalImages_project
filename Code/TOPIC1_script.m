import iftiread.*
import niftiinfo.*

file_path = 'C:\Users\Luca\OneDrive - Politecnico di Milano\Desktop\Polimi\Magistrale\Biomedical images\TOPIC1\sub2_t1_2_t2.nii';

% Read the NIfTI file
data = niftiread(file_path);
img = data(:, :, 16);           
img = im2double(img);                           % convert values to double for normalization
img = normalize(img, [0 1]);                    % normalize values

% Get information about the NIfTI file
info = niftiinfo(file_path);

%volumeViewer(data);

%% View intensity/frequency
figure;
histogram(img, 'BinWidth', 0.0001); % Adjust the 'BinWidth' as needed
xlabel('Intensity');
ylabel('Frequency');
title('Intensity Histogram');

%% Plot image
% Original image
figure;
subplot(1, 4, 1);
imshow(img, []);
title('Original image');

%% Transformation 1
%  Renders the whole image darker to highlight ventricles
subplot(1, 4, 2);
title('Transformation 1');

gamma = 2.5;
minImg = min(img(:));
maxImg = max(img(:));
img_modified = applyGamma(img, gamma, [minImg maxImg]);
imshow(img_modified, []);

%% Transformation 2
%  Adds to transformation 1 a gamma function which brightens area around
%  ventricles
subplot(1, 4, 3);
title('Transformation 2');

minImg = min(img(:));
maxImg = max(img(:));
img_modified = applyGamma(img, gamma, [minImg maxImg]);

minImg = min(img_modified(:));
maxImg = max(img_modified(:));
img_modified = applyGamma(img_modified, 0.85, [((maxImg-minImg)*0.2+minImg) maxImg]);


imshow(img_modified, []);

%% Transformation 3
%  Adds to transformation 2 a gamma function which brightens area around
%  ventricles to ease the process of determining values in 'range'
subplot(1, 4, 4);
title('Transformation 3');

minImg = min(img(:));
maxImg = max(img(:));
img_modified = applyGamma(img, gamma, [minImg maxImg]);

minImg = min(img_modified(:));
maxImg = max(img_modified(:));
img_modified = applyGamma(img_modified, 0.85, [((maxImg-minImg)*0.2+minImg) maxImg]);
img_modified = applyGamma(img_modified, 0.85, [((maxImg-minImg)*0.2+minImg) maxImg]);

imshow(img_modified, []);

%%
function out = applyThresh(operator, image, threshold, value)
    out = image;
    if (operator == "lesser")
        underThreshold = out <= threshold;
        out(underThreshold) = value;
    elseif (operator == "greater")
        underThreshold = out >= threshold;
        out(underThreshold) = value;
    end
end

function out = applyGamma(image, gamma, range)
    out = image;
    mask = image >= range(1) & image <= range(2);
    out(mask) = image(mask).^ gamma;
    out(~mask) = image(~mask);
end

function out = normalize(image, range)
    smol = min(image(:))
    big = max(image(:))

    out = (image - smol) ./ (big - smol);
    out = out.*(range(2)-range(1)) + range(1);
end