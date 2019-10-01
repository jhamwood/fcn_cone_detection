function createData

data_folder = uigetdir(cd,'Choose confocal dataset location');

folder = [data_folder '\Training Images\'];
folder2 = [data_folder '\Training Manual Coord\'];
files = dir(folder);
files = files(3:end);

mkdir('data/confocal/mat/0wide/train/imgs')
mkdir('data/confocal/mat/0wide/train/truth')
mkdir('data/confocal/mat/0wide/test/imgs')
mkdir('data/confocal/mat/0wide/test/truth')
mkdir('data/confocal/mat/1wide/train/imgs')
mkdir('data/confocal/mat/1wide/train/truth')
mkdir('data/confocal/mat/1wide/test/imgs')
mkdir('data/confocal/mat/1wide/test/truth')
mkdir('data/confocal/mat/2wide/train/imgs')
mkdir('data/confocal/mat/2wide/train/truth')
mkdir('data/confocal/mat/2wide/test/imgs')
mkdir('data/confocal/mat/2wide/test/truth')
mkdir('data/confocal/mat/3wide/train/imgs')
mkdir('data/confocal/mat/3wide/train/truth')
mkdir('data/confocal/mat/3wide/test/imgs')
mkdir('data/confocal/mat/3wide/test/truth')

count = 0;
for n = 1:length(files)
    img = imread([folder files(n).name]);
    coords = round(dlmread([folder2 files(n).name(1:end-4) '_manualcoord.txt']));
    if all(size(img) >= 144)
        offsetx = (size(img,1) - 144)/2;
        offsety = (size(img,2) - 144)/2;
        coords(any(coords < 1 | coords > size(img,1),2),:) = [];
        
        imwrite(img(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety)),['data/confocal/mat/0wide/train/imgs/' num2str(count) '.png']);
        imwrite(img(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety)),['data/confocal/mat/1wide/train/imgs/' num2str(count) '.png']);
        imwrite(img(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety)),['data/confocal/mat/2wide/train/imgs/' num2str(count) '.png']);
        imwrite(img(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety)),['data/confocal/mat/3wide/train/imgs/' num2str(count) '.png']);
        
        temp = zeros(size(img),'uint8');
        temp(sub2ind(size(img),coords(:,2),coords(:,1))) = 1;
        temp = temp(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety));
        temp = temp + 1;

        imwrite(temp,['data/confocal/mat/0wide/train/truth/' num2str(count) '.png']);
        
        temp = zeros(size(img),'uint8');
        temp(sub2ind(size(img),coords(:,2),coords(:,1))) = 1;
        temp = temp(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety));
        temp2 = temp;
        temp2([zeros(1,144); temp(1:end-1,:)] > 0) = 1;
        temp2([zeros(144,1) temp(:,1:end-1)] > 0) = 1;
        temp2([temp2(2:end,:); zeros(1,144)] > 0) = 1;
        temp2([temp2(:,2:end) zeros(144,1)] > 0) = 1;
        
        temp = temp2;
        temp = temp + 1;
        
        imwrite(temp,['data/confocal/mat/1wide/train/truth/' num2str(count) '.png']);
        
        temp = zeros(size(img),'uint8');
        temp(sub2ind(size(img),coords(:,2),coords(:,1))) = 1;
        temp = temp(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety));
        temp2 = temp;
        temp2([zeros(1,144); temp2(1:end-1,:)] > 0) = 1;
        temp2([zeros(144,1) temp2(:,1:end-1)] > 0) = 1;
        temp2([temp2(2:end,:); zeros(1,144)] > 0) = 1;
        temp2([temp2(:,2:end) zeros(144,1)] > 0) = 1;

        temp2([zeros(2,144); temp(1:end-2,:)] > 0) = 1;
        temp2([zeros(144,2) temp(:,1:end-2)] > 0) = 1;
        temp2([temp(3:end,:); zeros(2,144)] > 0) = 1;
        temp2([temp(:,3:end) zeros(144,2)] > 0) = 1;
        
        temp = temp2;
        temp = temp + 1;
        
        imwrite(temp,['data/confocal/mat/2wide/train/truth/' num2str(count) '.png']);
        
        temp = zeros(size(img),'uint8');
        temp(sub2ind(size(img),coords(:,2),coords(:,1))) = 1;
        temp = temp(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety));
        temp2 = temp;
        temp3 = temp;
        temp2([zeros(1,144); temp2(1:end-1,:)] > 0) = 1;
        temp2([zeros(144,1) temp2(:,1:end-1)] > 0) = 1;
        temp2([temp2(2:end,:); zeros(1,144)] > 0) = 1;
        temp2([temp2(:,2:end) zeros(144,1)] > 0) = 1;

        temp2([zeros(2,144); temp(1:end-2,:)] > 0) = 1;
        temp2([zeros(144,2) temp(:,1:end-2)] > 0) = 1;
        temp2([temp(3:end,:); zeros(2,144)] > 0) = 1;
        temp2([temp(:,3:end) zeros(144,2)] > 0) = 1;
        temp3([zeros(1,144); temp2(1:end-1,:)] > 0) = 1;
        temp3([zeros(144,1) temp2(:,1:end-1)] > 0) = 1;
        temp3([temp2(2:end,:); zeros(1,144)] > 0) = 1;
        temp3([temp2(:,2:end) zeros(144,1)] > 0) = 1;
        
        temp = temp3;
        temp = temp + 1;
        
        imwrite(temp,['data/confocal/mat/3wide/train/truth/' num2str(count) '.png']);
        
        count = count + 1;
    end
end

folder = [data_folder '\Validation Images\'];
folder2 = [data_folder '\Validation Manual Coord\'];
files = dir(folder);
files = files(3:end);
for width = 0:3
    count = 0;
    for n = 1:length(files)
        img = imread([folder files(n).name]);
        coords = round(dlmread([folder2 files(n).name(1:end-4) '_manualcoord.txt']));
        if all(size(img) >= 144)
            offsetx = (size(img,1) - 144)/2;
            offsety = (size(img,2) - 144)/2;
            coords(any(coords < 1 | coords > size(img,1),2),:) = [];

            imwrite(img(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety)),['data/confocal/mat/' num2str(width) 'wide/test/imgs/' num2str(count) '.png']);

            temp = zeros(size(img),'uint8');
            temp(sub2ind(size(img),coords(:,2),coords(:,1))) = 1;
            temp = temp(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety));
            temp = temp + 1;
            imwrite(temp,['data/confocal/mat/' num2str(width) 'wide/test/truth/' num2str(count) '.png']);

            count = count + 1;
        end
    end
end

% folder = 'Split Detector\Training Images\';
% folder2 = 'Split Detector\Training Manual Coord\';
% files = dir(folder);
% files = files(3:end);
% 
% mkdir('data/sd/mat/train/imgs')
% mkdir('data/sd/mat/train/0wide')
% mkdir('data/sd/mat/train/1wide')
% mkdir('data/sd/mat/train/2wide')
% mkdir('data/sd/mat/train/3wide')
% mkdir('data/sd/mat/test/imgs')
% mkdir('data/sd/mat/test/truths')
% 
% count = 0;
% for n = 1:length(files)
%     img = imread([folder files(n).name]);
%     coords = round(dlmread([folder2 files(n).name(1:end-4) '_Coords.csv']));
%     if all(size(img) >= 144)
%         offsetx = (size(img,1) - 144)/2;
%         offsety = (size(img,2) - 144)/2;
%         coords(any(coords < 1 | coords > size(img,1),2),:) = [];
%         
%         imwrite(img(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety)),['data/sd/mat/train/imgs/' num2str(count) '.png']);
%         
%         temp = zeros(size(img),'uint8');
%         temp(sub2ind(size(img),coords(:,2),coords(:,1))) = 1;
%         temp = temp(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety));
%         temp = temp + 1;
% 
%         imwrite(temp,['data/sd/mat/train/0wide/' num2str(count) '.png']);
%         
%         temp = zeros(size(img),'uint8');
%         temp(sub2ind(size(img),coords(:,2),coords(:,1))) = 1;
%         temp = temp(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety));
%         temp2 = temp;
%         temp2([zeros(1,144); temp(1:end-1,:)] > 0) = 1;
%         temp2([zeros(144,1) temp(:,1:end-1)] > 0) = 1;
%         temp2([temp2(2:end,:); zeros(1,144)] > 0) = 1;
%         temp2([temp2(:,2:end) zeros(144,1)] > 0) = 1;
%         
%         temp = temp2;
%         temp = temp + 1;
%         
%         imwrite(temp,['data/sd/mat/train/1wide/' num2str(count) '.png']);
%         
%         temp = zeros(size(img),'uint8');
%         temp(sub2ind(size(img),coords(:,2),coords(:,1))) = 1;
%         temp = temp(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety));
%         temp2 = temp;
%         temp2([zeros(1,144); temp2(1:end-1,:)] > 0) = 1;
%         temp2([zeros(144,1) temp2(:,1:end-1)] > 0) = 1;
%         temp2([temp2(2:end,:); zeros(1,144)] > 0) = 1;
%         temp2([temp2(:,2:end) zeros(144,1)] > 0) = 1;
% 
%         temp2([zeros(2,144); temp(1:end-2,:)] > 0) = 1;
%         temp2([zeros(144,2) temp(:,1:end-2)] > 0) = 1;
%         temp2([temp(3:end,:); zeros(2,144)] > 0) = 1;
%         temp2([temp(:,3:end) zeros(144,2)] > 0) = 1;
%         
%         temp = temp2;
%         temp = temp + 1;
%         
%         imwrite(temp,['data/sd/mat/train/2wide/' num2str(count) '.png']);
%         
%         temp = zeros(size(img),'uint8');
%         temp(sub2ind(size(img),coords(:,2),coords(:,1))) = 1;
%         temp = temp(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety));
%         temp2 = temp;
%         temp3 = temp;
%         temp2([zeros(1,144); temp2(1:end-1,:)] > 0) = 1;
%         temp2([zeros(144,1) temp2(:,1:end-1)] > 0) = 1;
%         temp2([temp2(2:end,:); zeros(1,144)] > 0) = 1;
%         temp2([temp2(:,2:end) zeros(144,1)] > 0) = 1;
% 
%         temp2([zeros(2,144); temp(1:end-2,:)] > 0) = 1;
%         temp2([zeros(144,2) temp(:,1:end-2)] > 0) = 1;
%         temp2([temp(3:end,:); zeros(2,144)] > 0) = 1;
%         temp2([temp(:,3:end) zeros(144,2)] > 0) = 1;
%         temp3([zeros(1,144); temp2(1:end-1,:)] > 0) = 1;
%         temp3([zeros(144,1) temp2(:,1:end-1)] > 0) = 1;
%         temp3([temp2(2:end,:); zeros(1,144)] > 0) = 1;
%         temp3([temp2(:,2:end) zeros(144,1)] > 0) = 1;
%         
%         temp = temp3;
%         temp = temp + 1;
%         
%         imwrite(temp,['data/sd/mat/train/3wide/' num2str(count) '.png']);
%         
%         count = count + 1;
%     end
% end
% 
% folder = 'Split Detector\Validation Images\';
% folder2 = 'Split Detector\Validation Manual Coord\';
% files = dir(folder);
% files = files(3:end);
% count = 0;
% for n = 1:length(files)
%     img = imread([folder files(n).name]);
%     coords = round(dlmread([folder2 files(n).name(1:end-4) '_Coords.csv']));
%     if all(size(img) >= 144)
%         offsetx = (size(img,1) - 144)/2;
%         offsety = (size(img,2) - 144)/2;
%         coords(any(coords < 1 | coords > size(img,1),2),:) = [];
%         
%         imwrite(img(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety)),['data/sd/mat/test/imgs/' num2str(count) '.png']);
%         
%         temp = zeros(size(img),'uint8');
%         temp(sub2ind(size(img),coords(:,2),coords(:,1))) = 1;
%         temp = temp(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety));
%         temp = temp + 1;
%         imwrite(temp,['data/sd/mat/test/truths/' num2str(count) '.png']);
%         
%         count = count + 1;
%     end
% end