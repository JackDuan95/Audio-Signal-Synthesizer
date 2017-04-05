function [Criticalf,CriticalA]=pickCriticalFreq(f_domain,t_domain,a_domain)
    a=a_domain;
    t=t_domain;
    f=f_domain;
    for(i=1:length(t))
        for(k=1:4)
        [M,index] = max(a(:,i));
        if(index>20)
            for(j=0:20)
                a(index+j,i)=0;
                a(index-j,i)=0;
            end
        end
            Criticalf(i,k)=f(index);
            CriticalA(i,k)=M;
        end
    end
 end