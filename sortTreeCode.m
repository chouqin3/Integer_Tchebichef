function [LeafsInOrder codenumbers codeCounts]=sortTreeCode(tree,number)
    leaf.value=0;
    leaf.code='';
    A{number}=[];
    LeafsInOrder{number}=[];
    for i=1:number
        A{i}=tree(i).code;
    end
    [~,IX]=sort(A);
    %��Ҷ�ӽڵ��������򣬲�ͳ�Ʋ�ͬλ���ı����Ƶ��
    codenumbers=[];
    codeCounts=[];
    bitnumber=0;
    index=0;
    for i=1:number
        leaf.value=tree(IX(i)).value;
        leaf.code=tree(IX(i)).code;
        [~, n]=size(leaf.code);
        if n==bitnumber
           codeCounts(index)=codeCounts(index)+1;
        else
           index=index+1;
           codenumbers(index)=n;
           codeCounts(index)=1;
           bitnumber=n;
        end
        LeafsInOrder{i}=leaf;
    end
end