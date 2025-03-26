function vectortext(ax, v, varargin)
if ndims(v) == 3
v = reshape(v, size(v,1), size(v,3));
end
text(ax, v(1,:), v(2,:), v(3,:), varargin{:})
end