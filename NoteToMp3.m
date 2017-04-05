function MP3file = NoteToMp3(musicSheet,bpm)
[x,y]=size(musicSheet);
innerShift=length(musicSheet(1,:))/2;
MP3file=[];
   for i=1:x
       TimeInterSignal=zeros(1,length(note(musicSheet(i,1),60/bpm,musicSheet(i,4))));
       for j=1:y/2
            TimeInterSignal=TimeInterSignal+note(musicSheet(i,j),60/bpm,musicSheet(i,j+innerShift));
       end
       MP3file=[MP3file,TimeInterSignal];    
   end
end
