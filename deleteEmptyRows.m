function [COHR,SXX,SYY,SXY] = deleteEmptyRows(COHR,SXX,SYY,SXY)
% parent function: StartHere.m

emptyIdx = cellfun(@isempty, COHR); % logical array: true if cell is empty 
keepIdx = ~emptyIdx; % Index to the non-empty ones 
% apply to all important cell arrays 
COHR = COHR(keepIdx);
SXX = SXX(:,keepIdx(1,:)); % LFP is only one row so need to put 1 here 
SYY = SYY(keepIdx); 
SXY = SXY(keepIdx); 

end 