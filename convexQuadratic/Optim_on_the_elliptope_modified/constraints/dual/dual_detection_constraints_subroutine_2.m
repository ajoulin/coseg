function space=dual_detection_constraints_subroutine_2(one_pic_bar,one_pic,T1,T2)

n=size(one_pic,1);

% space=one_pic*ones(1,n);
% space=space+space'-one_pic*one_pic';

I=find(one_pic);
J=find(one_pic==0);
I=repmat(I,1,size(J,1));
J=repmat(J',size(I,1),1);

if strcmp(class(one_pic),'single')
    space=zeros(size(one_pic,1),'single');
    space(I(:)+(J(:)-1)*size(one_pic,1))=1;
else
   space=sparse(I(:),J(:),1,size(one_pic,1),size(one_pic,1));
end

%space=sparse(I(:),J(:),1,size(one_pic,1),size(one_pic,1));


%subsubdual=3/2*(sum(T2)*(space+space')+diag((T2).*one_pic));  


% space=one_pic_bar*ones(1,n);
% space=space+space'-one_pic_bar*one_pic_bar';

%subsubdual=subsubdual+3/2*(sum(-T1)*(space+space')+diag((-T1).*one_pic_bar));  

clear I J

space=3/2*sum(T2-T1)*(space);
space=space+space';

space=space+3/2*(diag((T2-T1).*one_pic));  