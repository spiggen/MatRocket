function vectorquiver(ax, pos, vec, varargin)
if ndims(vec) == 3
vec = reshape(vec, size(vec,1), size(vec,3));
end
if ndims(pos) == 3
pos = reshape(pos, size(pos,1), size(pos,3));
end
quiver3(ax, pos(1,:), pos(2,:), pos(3,:), vec(1,:), vec(2,:), vec(3,:), varargin{:})
end