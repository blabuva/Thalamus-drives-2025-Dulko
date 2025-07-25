function varargout = confplot_markUnitFF(varargin)
%CONFPLOT Linear plot with continuous confidence/error boundaries.
%
%   CONFPLOT(X,Y,L,U) plots the graph of vector X vs. vector Y with
%   'continuous' confidence/error boundaries specified by the vectors
%   L and U.  L and U contain the lower and upper error ranges for each
%   point in Y. The vectors X,Y,L and U must all be the same length.  
%
%   CONFPLOT(X,Y,E) or CONFPLOT(Y,E) plots Y with error bars [Y-E Y+E].
%   CONFPLOT(...,'LineSpec') uses the color and linestyle specified by
%   the string 'LineSpec'.  See PLOT for possibilities.
%
%   H = CONFPLOT(...) returns a vector of line handles.
%
%   For example,
%      x = 1:0.1:10;
%      y = sin(x);
%      e = std(y)*ones(size(x));
%      confplot(x,y,e)
%   draws symmetric continuous confidence/error boundaries of unit standard deviation.
%
%   See also ERRORBAR, SEMILOGX, SEMILOGY, LOGLOG, PLOTYY, GRID, CLF, CLC, TITLE,
%   XLABEL, YLABEL, AXIS, AXES, HOLD, COLORDEF, LEGEND, SUBPLOT, STEM.
%
%     � 2002 - Michele Giugliano, PhD (http://www.giugliano.info) (Bern, Monday Nov 4th, 2002 - 19:02)
%    (bug-reports to michele@giugliano.info)
%   $Revision: 1.0 $  $Date: 2002/11/11 14:36:08 $
%                        

if (nargin<2)
 disp('ERROR: not enough input arguments!');
 return;
end % if

x = [];  y = [];  z1 = [];  z2 = [];  spec = '';

switch nargin
 case 2
  y  = varargin{1};
  z1 = y + varargin{2};
  z2 = y - varargin{2};
  x  = 1:length(y);
 case 3
%   x  = varargin{1};
  y  = varargin{1};
  z1 = y + varargin{2};
  z2 = y - varargin{2};
    x  = 1:length(y);
  color_m = varargin{3} ;  
   color_c = varargin{4} ; 

 case 6
%   x  = varargin{1};
  y  = varargin{1};
  z1 = y + varargin{2};
  z2 = y - varargin{2};
    x  = 1:length(y);
  color_m = varargin{3} ;  
   color_c = varargin{4} ; 
   lineW = varargin{5} ;
      msize = varargin{6} ;
end % switch

if (nargin > 6)
  x  = varargin{1};
  y  = varargin{2};
  z1 = y + varargin{3};
  z2 = y - varargin{3};
%     x  = 1:length(y);
  color_m = varargin{4} ;  
   color_c = varargin{5} ; 
   mwidth = varargin{6} ;  
   msize = varargin{7} ;
   

      
end % 


p = plot(x,y,x,z1,x,z2, 'color', [0 0 0]);    YLIM = get(gca,'YLim');    delete(p);
a1 = area(x,z1,min(YLIM)); 
hold on;
set(a1,'LineStyle','none');     set(a1,'FaceColor',[color_c(1) color_c(2) color_c(3)]);
a2 = area(x,z2,min(YLIM)); 
set(a2,'LineStyle','none');     set(a2,'FaceColor',[1 1 1]);
if (~isempty(spec)),     
 spec = sprintf('p = plot(x,y,varargin{5}');
 for i=6:nargin,  spec = sprintf('%s,varargin{%d}',spec,i); end % for
 spec = sprintf('%s);',spec);
 eval(spec);
else
    
%     p = plot(x,y, 'color', [color_m(1)  color_m(2)  color_m(3) ], 'LineWidth', 3);
%     p = plot(x,y, 'o', 'color', [color_m(1)  color_m(2)  color_m(3) ], 'MarkerSize', msize, 'MarkerFaceColor', color_m, 'LineWidth', lineW  );
   
    
end;
hold off;

%set(gca,'Layer','top','XGrid','on','YGrid','on');               
set(gca,'Layer','top');               

% H = [p, a1, a2];
% 
% if (nargout>1) varargout{1} = H; end;
