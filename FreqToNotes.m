function Notes=FreqToNotes(CFreq)
Notes=[];
   [x,y]=size(CFreq);
   for(i=1:x)
       for(j=1:y)
           if(CFreq(i,j)>4200||CFreq(i,j)<20)
               Notes(i,j)=0;   
           else
            Notes(i,j)=round(12*log(CFreq(i,j)/440)/log(2)+49);
           end
       end
   end
 end