function [res] = dfsSearch(matr)
    global m depth marked indLeaves;
    if size(matr)==1
        res = 1;
        return
    end
    m = matr;
    depth = zeros(1,size(m));
    marked = ones(1,size(m))*(-1);
    indLeaves = find_leaves(m);
    marked(indLeaves) = 0;

    dfs(1);
    marked = max(marked)-marked+1;
    res = marked;
end

function result=dfs(x)
global m marked;

if marked(x)==0
	result = 0;
    return
end
nextVer = find(m(x,:)==1);
valNextVer = zeros(1,length(nextVer));
for i=1:length(nextVer)
    if (marked(nextVer(i))==-1)
        valNextVer(i) = dfs(nextVer(i));
    else
        valNextVer(i) = marked(nextVer(i));
    end
    
end
result = max(valNextVer)+1;
marked(x) = result;

end

function [leaves] = find_leaves(m)
    leaves = sum(m,2);
    leaves = find(leaves<0);
    
end