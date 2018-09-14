function tree=huffmanFromFile(valueInOrder)

n=length(valueInOrder);
node.left=int16(-1);
node.right=int16(-1);
node.parent=int16(-1);
node.value=int16(-1);
node.isleaf=false;
node.code='';
tree(2*n-1)=node;
leafClassify{valueInOrder{n}.codeLength}=[];%按码字长度对叶子节点进行分类
for i=1:n
    tree(i)=node;
    tree(i).value=valueInOrder{i}.value;
    tree(i).isleaf=true;
    leafClassify{valueInOrder{i}.codeLength}=[leafClassify{valueInOrder{i}.codeLength} i];%将该叶子节点追加到该分类
end
for i=n+1:2*n-1
    tree(i)=node;
end

%建立huffman树
codeSize=valueInOrder{n}.codeLength;%从最长码字位数开始
nodeClassify=[];%保存含该种位数的所有节点
internalNodeClassify{codeSize}=[];%按码字长度对内节点进行分类
i=n+1;
while i<=2*n-1 %共需要兄弟配对n-1次    
    nodeClassify=[leafClassify{codeSize} internalNodeClassify{codeSize}];
    index=length(nodeClassify);%nodeClassify数组的下标
    while index>=2 %树中该层还有可以配对的兄弟节点
        %取出两个节点进行组合
        left=nodeClassify(index-1);
        right=nodeClassify(index);
        index=index-2;
        tree(left).parent=i;
        tree(left).code='0';
        tree(right).parent=i;
        tree(right).code='1';
        tree(i).left=left;
        tree(i).right=right;
        if codeSize>1 %最后配对的节点的父节点是根，码字长度为0,不需要也无法保存
            internalNodeClassify{codeSize-1}=[i internalNodeClassify{codeSize-1}];%将新产生的内节点放入分类数组
        end
        i=i+1;
    end
    %树中该层没有可以配对的兄弟节点
    codeSize=codeSize-1;%转向上一层节点
end

%对每个叶子节点进行编码,该操作不必要进行,仅用于程序调试,验证生成的树是正确的
for i=1:n
    p=tree(i).parent;
    while(p~=-1)
        tree(i).code=strcat(tree(p).code,tree(i).code);
        p=tree(p).parent;
    end
end
end