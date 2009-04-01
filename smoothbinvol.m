function vol=smoothbinvol(vol,layer)
% vol=smoothbinvol(vol,layer)
% convolve a 3x3 gaussian kernel to a binary image multiple times
% 
% Author: Qianqian Fang <fangq at nmr.mgh.harvard.edu>
%
% 

dim=size(vol);
dxy=dim(1)*dim(2);
fulllen=prod(dim);

weight=1./6.;

% in case vol is a logical
vol=double(vol);

for i=1:layer
    % find all non-zero values
	idx=find(vol);
    % get the neighbors of all the non-zero values
    % this may cause wrapping -- TODO
	nextidx=[idx+1; idx-1;idx+dim(1);idx-dim(1);idx+dxy;idx-dxy]';
    val=repmat(vol(idx),1,6);
    % find all 1-valued voxels that are located within the domain
	goodidx=find(nextidx>0 & nextidx<fulllen);
    % for all neighboring voxels, add a fraction from the non-0 voxels
    % problematic when running in parallel (racing)
	vol(nextidx(goodidx))=vol(nextidx(goodidx))+weight*val(goodidx);
    % the above line may change the values of the non-zero voxels, recover
    % them
    vol(idx)=val(:,1);
end
