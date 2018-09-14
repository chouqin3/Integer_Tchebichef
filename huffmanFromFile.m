function tree=huffmanFromFile(valueInOrder)

n=length(valueInOrder);
node.left=int16(-1);
node.right=int16(-1);
node.parent=int16(-1);
node.value=int16(-1);
node.isleaf=false;
node.code='';
tree(2*n-1)=node;
leafClassify{valueInOrder{n}.codeLength}=[];%�����ֳ��ȶ�Ҷ�ӽڵ���з���
for i=1:n
    tree(i)=node;
    tree(i).value=valueInOrder{i}.value;
    tree(i).isleaf=true;
    leafClassify{valueInOrder{i}.codeLength}=[leafClassify{valueInOrder{i}.codeLength} i];%����Ҷ�ӽڵ�׷�ӵ��÷���
end
for i=n+1:2*n-1
    tree(i)=node;
end

%����huffman��
codeSize=valueInOrder{n}.codeLength;%�������λ����ʼ
nodeClassify=[];%���溬����λ�������нڵ�
internalNodeClassify{codeSize}=[];%�����ֳ��ȶ��ڽڵ���з���
i=n+1;
while i<=2*n-1 %����Ҫ�ֵ����n-1��    
    nodeClassify=[leafClassify{codeSize} internalNodeClassify{codeSize}];
    index=length(nodeClassify);%nodeClassify������±�
    while index>=2 %���иò㻹�п�����Ե��ֵܽڵ�
        %ȡ�������ڵ�������
        left=nodeClassify(index-1);
        right=nodeClassify(index);
        index=index-2;
        tree(left).parent=i;
        tree(left).code='0';
        tree(right).parent=i;
        tree(right).code='1';
        tree(i).left=left;
        tree(i).right=right;
        if codeSize>1 %�����ԵĽڵ�ĸ��ڵ��Ǹ������ֳ���Ϊ0,����ҪҲ�޷�����
            internalNodeClassify{codeSize-1}=[i internalNodeClassify{codeSize-1}];%���²������ڽڵ�����������
        end
        i=i+1;
    end
    %���иò�û�п�����Ե��ֵܽڵ�
    codeSize=codeSize-1;%ת����һ��ڵ�
end

%��ÿ��Ҷ�ӽڵ���б���,�ò�������Ҫ����,�����ڳ������,��֤���ɵ�������ȷ��
for i=1:n
    p=tree(i).parent;
    while(p~=-1)
        tree(i).code=strcat(tree(p).code,tree(i).code);
        p=tree(p).parent;
    end
end
end