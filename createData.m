function createData

data_folder = uigetdir(cd,'Choose dataset location');



data_folders = {'Confocal', 'Split Detector'};
data_folders2 = {'confocal', 'split_detector'};

for m = 1:2
    folder_type = data_folders{m};
    data_type = data_folders2{m};
    folder = [data_folder '\' folder_type '\Training Images\'];
    folder2 = [data_folder '\' folder_type '\Training Manual Coord\'];
    files = dir(folder);
    files = files(3:end);
    if ~exist(['data/' data_type '/mat/0wide/train/imgs'],'dir')
		mkdir(['data/' data_type '/mat/0wide/train/imgs'])
		mkdir(['data/' data_type '/mat/0wide/train/truth'])
		mkdir(['data/' data_type '/mat/0wide/test/imgs'])
		mkdir(['data/' data_type '/mat/0wide/test/truth'])
		mkdir(['data/' data_type '/mat/1wide/train/imgs'])
		mkdir(['data/' data_type '/mat/1wide/train/truth'])
		mkdir(['data/' data_type '/mat/1wide/test/imgs'])
		mkdir(['data/' data_type '/mat/1wide/test/truth'])
		mkdir(['data/' data_type '/mat/2wide/train/imgs'])
		mkdir(['data/' data_type '/mat/2wide/train/truth'])
		mkdir(['data/' data_type '/mat/2wide/test/imgs'])
		mkdir(['data/' data_type '/mat/2wide/test/truth'])
		mkdir(['data/' data_type '/mat/3wide/train/imgs'])
		mkdir(['data/' data_type '/mat/3wide/train/truth'])
		mkdir(['data/' data_type '/mat/3wide/test/imgs'])
		mkdir(['data/' data_type '/mat/3wide/test/truth'])
    else
        continue
    end

	count = 0;
	for n = 1:length(files)
		img = imread([folder files(n).name]);
        try
			coords = round(dlmread([folder2 files(n).name(1:end-4) '_manualcoord.txt']));
		catch
			coords = round(dlmread([folder2 files(n).name(1:end-4) '_coords.csv']));
        end
		if all(size(img) >= 144)
			offsetx = (size(img,1) - 144)/2;
			offsety = (size(img,2) - 144)/2;
			coords(any(coords < 1 | coords > size(img,1),2),:) = [];
			
			imwrite(img(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety)),['data/' data_type '/mat/0wide/train/imgs/' num2str(count) '.png']);
			imwrite(img(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety)),['data/' data_type '/mat/1wide/train/imgs/' num2str(count) '.png']);
			imwrite(img(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety)),['data/' data_type '/mat/2wide/train/imgs/' num2str(count) '.png']);
			imwrite(img(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety)),['data/' data_type '/mat/3wide/train/imgs/' num2str(count) '.png']);
			
			temp = zeros(size(img),'uint8');
			temp(sub2ind(size(img),coords(:,2),coords(:,1))) = 1;
			temp = temp(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety));
			temp = temp + 1;

			imwrite(temp,['data/' data_type '/mat/0wide/train/truth/' num2str(count) '.png']);
			
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
			
			imwrite(temp,['data/' data_type '/mat/1wide/train/truth/' num2str(count) '.png']);
			
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
			
			imwrite(temp,['data/' data_type '/mat/2wide/train/truth/' num2str(count) '.png']);
			
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
			
			imwrite(temp,['data/' data_type '/mat/3wide/train/truth/' num2str(count) '.png']);
			
			count = count + 1;
		end
	end

	folder = [data_folder '\' folder_type '\Validation Images\'];
	folder2 = [data_folder '\' folder_type '\Validation Manual Coord\'];
	files = dir(folder);
	files = files(3:end);
	for width = 0:3
		count = 0;
		for n = 1:length(files)
			img = imread([folder files(n).name]);
        try
			coords = round(dlmread([folder2 files(n).name(1:end-4) '_manualcoord.txt']));
		catch
			coords = round(dlmread([folder2 files(n).name(1:end-4) '_coords.csv']));
        end
			if all(size(img) >= 144)
				offsetx = (size(img,1) - 144)/2;
				offsety = (size(img,2) - 144)/2;
				coords(any(coords < 1 | coords > size(img,1),2),:) = [];

				imwrite(img(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety)),['data/' data_type '/mat/' num2str(width) 'wide/test/imgs/' num2str(count) '.png']);

				temp = zeros(size(img),'uint8');
				temp(sub2ind(size(img),coords(:,2),coords(:,1))) = 1;
				temp = temp(1+floor(offsetx):end-ceil(offsetx),1+floor(offsety):end-ceil(offsety));
				temp = temp + 1;
				imwrite(temp,['data/' data_type '/mat/' num2str(width) 'wide/test/truth/' num2str(count) '.png']);

				count = count + 1;
			end
		end
	end
end