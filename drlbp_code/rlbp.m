%RLBP returns the rotated local binary pattern image or histogram of an image.
%  [features] = rlbp(I,R,N,MAPPING,MODE) returns the rotated local binary pattern histogram of an intensity
%  image I. The RLBP codes are computed using N sampling points on a 
%  circle of radius R and using mapping table defined by MAPPING.
%  See the getmapping function for different mappings and use 0 for
%  no mapping. Possible values for MODE are
%       'h' or 'hist'  to get a histogram of LBP codes
%       'nh'           to get a normalized histogram
%  Otherwise an CLBP code image is returned.

%  [RLBP] = CLBP(I,SP,MAPPING,MODE) computes the RLBP codes using n sampling
%  points defined in (n * 2) matrix SP. The sampling points should be
%  defined around the origin (coordinates (0,0)).

%  Examples
%  --------
%       I=imread('rice.png');
%       [RLBP]=RLBP(I,1,8); %RLBP histogram in (8,1) neighborhood
%
%
%       I=imread('rice.png');
%       mapping=getmapping(8,'u2');
%       [RLBP]=RLBP(I, 1,8,mapping,'h'); %RLBP histogram in (8,1) neighborhood
                                          %using uniform patterns


function RLBP = rlbp(varargin) % image,radius,neighbors,mapping,mode)
% Authors: Rakesh Mehta

% The implementation is based on lbp code from MVG, Oulu University, Finland
% http://www.ee.oulu.fi/mvg/page/lbp_matlab


% Check number of input arguments.
% error(nargchk(1,5,nargin));

image=varargin{1};
d_image=double(image);

if nargin==1
    spoints=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
    neighbors=8;
    mapping=0;
    mode='h';
end

if (nargin == 2) && (length(varargin{2}) == 1)
    error('Input arguments');
end

if (nargin > 2) && (length(varargin{2}) == 1)
    radius=varargin{2};
    neighbors=varargin{3};
    
    spoints=zeros(neighbors,2);

    % Angle step.
    a = 2*pi/neighbors;
    
    for i = 1:neighbors
        spoints(i,1) = -radius*sin((i-1)*a);
        spoints(i,2) = radius*cos((i-1)*a);
    end

    
    if(nargin >= 4)
        mapping=varargin{4};
        if(isstruct(mapping) && mapping.samples ~= neighbors)
            error('Incompatible mapping');
        end
    else
        mapping=0;
    end
%     
    if(nargin >= 5)
        mode=varargin{5};
    else
        mode='h';
    end
end

if (nargin > 1) && (length(varargin{2}) > 1)
    spoints=varargin{2};
    neighbors=size(spoints,1);
    
    if(nargin >= 3)
        mapping=varargin{3};
        if(isstruct(mapping) && mapping.samples ~= neighbors)
            error('Incompatible mapping');
        end
    else
        mapping=0;
    end
    
    if(nargin >= 4)
        mode=varargin{4};
    else
        mode='h';
    end   
end
%mode='x';

% Determine the dimensions of the input image.
[ysize xsize] = size(image);



miny=min(spoints(:,1));
maxy=max(spoints(:,1));
minx=min(spoints(:,2));
maxx=max(spoints(:,2));

% Block size, each LBP code is computed within a block of size bsizey*bsizex
bsizey=ceil(max(maxy,0))-floor(min(miny,0))+1;
bsizex=ceil(max(maxx,0))-floor(min(minx,0))+1;

% Coordinates of origin (0,0) in the block
origy=1-floor(min(miny,0));
origx=1-floor(min(minx,0));

% Minimum allowed size for the input image depends
% on the radius of the used LBP operator.
if(xsize < bsizex || ysize < bsizey)
  error('Too small input image. Should be at least (2*radius+1) x (2*radius+1)');
end

% Calculate dx and dy;
dx = xsize - bsizex;
dy = ysize - bsizey;

% Fill the center pixel matrix C.
C = image(origy:origy+dy,origx:origx+dx);
d_C = double(C);

bins = 2^neighbors;
valMax = zeros(size(C));
%sgnMax = zeros(size(C));
% Initialize the result matrix with zeros.
RLBP=zeros(dy+1,dx+1);
% CLBP_M=zeros(dy+1,dx+1);
maxIdx = zeros(size(C));
%Compute the LBP code image

for i = 1:neighbors
  y = spoints(i,1)+origy;
  x = spoints(i,2)+origx;
  % Calculate floors, ceils and rounds for the x and y.
  fy = floor(y); cy = ceil(y); ry = round(y);
  fx = floor(x); cx = ceil(x); rx = round(x);
  % Check if interpolation is needed.
  if (abs(x - rx) < 1e-6) && (abs(y - ry) < 1e-6)
    % Interpolation is not needed, use original datatypes
    N = d_image(ry:ry+dy,rx:rx+dx);
    D{i} = N >= d_C;   
    cDif= (N - d_C); 
  else
    % Interpolation needed, use double type images 
    ty = y - fy;
    tx = x - fx;

    % Calculate the interpolation weights.
    w1 = (1 - tx) * (1 - ty);
    w2 =      tx  * (1 - ty);
    w3 = (1 - tx) *      ty ;
    w4 =      tx  *      ty ;
    % Compute interpolated pixel values
    N = w1*d_image(fy:fy+dy,fx:fx+dx) + w2*d_image(fy:fy+dy,cx:cx+dx) + ...
        w3*d_image(cy:cy+dy,fx:fx+dx) + w4*d_image(cy:cy+dy,cx:cx+dx);
    cDif= (N - d_C); 
    D{i} = N >= d_C;     
  end  
  
  % Update the dominant direction index is the absolute difference is 
  % larger than the previous maximum
  absDif = abs(cDif);
  curIds = absDif > valMax;
  maxIdx(curIds) = i; 
  valMax(curIds) = absDif(curIds);
end


% Compute the rotated features with respect to the index of dominant
% direction
for i=1:neighbors
  % Update the result matrix
  v = 2.^(mod((i-1-maxIdx)+neighbors,neighbors));
  RLBP = RLBP + v.*D{i};
end


%Apply mapping if it is defined
if isstruct(mapping)
    bins = mapping.num;
    sizarray = size(RLBP);
    RLBP = RLBP(:);
    RLBP = mapping.table(RLBP+1);
    RLBP = reshape(RLBP,sizarray);
end




% Finally compute the RLBP features
if (strcmp(mode,'h') || strcmp(mode,'hist') || strcmp(mode,'nh'))
    % Return with LBP histogram if mode equals 'hist'.
    RLBP=hist(RLBP(:),0:(bins-1));
    
    if (strcmp(mode,'nh'))
        RLBP= RLBP/sum(RLBP);
        
    end
else
    %Otherwise return a matrix of unsigned integers
%     if ((bins-1)<=intmax('uint8'))
%         CLBP_S=uint8(CLBP_S);
%         %CLBP_M=uint8(CLBP_M);
%     elseif ((bins-1)<=intmax('uint16'))
%         CLBP_S=uint16(CLBP_S);
%         %CLBP_M=uint16(CLBP_M);
%     else
%         CLBP_S=uint32(CLBP_S);
%         %CLBP_M=uint32(CLBP_M);
%     end
end






