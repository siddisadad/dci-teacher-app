from pathlib import Path
p=Path('lib/pages/login/login_widget.dart')
text=p.read_text()
pairs={'(':')','[':']','{':'}'}
stack=[]
line_starts=[0]
for i,ch in enumerate(text):
    if ch=='\n':
        line_starts.append(i+1)

for i,ch in enumerate(text,1):
    if ch in pairs:
        stack.append((ch,i))
    elif ch in pairs.values():
        if not stack:
            print('Unmatched close',ch,'at char',i)
            break
        o,pos=stack.pop()
        if pairs[o]!=ch:
            print('Mismatch',o,pos,'with',ch,i)
            break
else:
    if stack:
        print('Unmatched opens count:',len(stack))
        for o,pos in stack[-40:]:
            # find line number
            line_num=1
            for idx,start in enumerate(line_starts):
                if start>pos:
                    line_num=idx
                    break
                line_num=idx+1
            line_start=line_starts[line_num-1]
            line_end=text.find('\n',line_start)
            if line_end==-1: line_end=len(text)
            context=text[line_start:line_end]
            print(o,'at char',pos,'(line',line_num,') =>',context.strip())
    else:
        print('All matched')
