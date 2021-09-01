function [junk] = lap(junk)

% Dummy function that will be called if the function lap.cpp was not
% mex-compiled yet (m-files are called only if a mex file does not
% exist). 
message = sprintf('*********************************Read Me**********************************\n C++ CODE lap.cpp has NOT yet been complied\n The lap.cpp code contains a solver for the linear assignment problem \n Trying to compiling lap.cpp.................\n Done! \n Please click "Ok" botton to restart Matlab\n');
mex lap.cpp;
uiwait(msgbox(message));
quit;


