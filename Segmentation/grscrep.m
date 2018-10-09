function [rep, maxi]=grscrep(Im, h, w)
    x=0:255;
    repartition=zeros(1,256);
    for i=1:h
        for j=1:w
            ind=Im(i,j);
            repartition(uint8(ind)+1)= repartition(uint8(ind)+1) +1;
        end
    end
    maxi=max(repartition);
    rep=[x;repartition];
end

%%