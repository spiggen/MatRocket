classdef rocket < handle
    properties (Access = private)
        InternalData struct = struct()
    end

    methods
        function obj = subsasgn(obj, S, value)
            if strcmp(S(1).type, '.')
                obj.InternalData.(S(1).subs) = value;
            else
                obj = builtin('subsasgn', obj, S, value);
            end
        end

        function value = subsref(obj, S)
            if strcmp(S(1).type, '.') && isfield(obj.InternalData, S(1).subs)
                value = obj.InternalData.(S(1).subs);
            else
                value = builtin('subsref', obj, S);
            end
        end
    end
end