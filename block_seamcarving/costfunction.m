function G=costfunction(im) %%(xi,yi)
            G=zeros(size(im,1),size(im,2));
            for ii=1:size(im,3)
                %G=G+abs(filter2([1 0 -1],im(:,:,ii)))+abs(filter2([1;0;-1],im(:,:,ii))); 
                G=G+(filter2([.5 1 .5; 1 -6 1; .5 1 .5],im(:,:,ii))).^2; %faster and reasonably good.
            end
   end