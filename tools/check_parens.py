from pathlib import Path
p=Path('lib/pages/login/login_widget.dart')
text=p.read_text()
pairs={'(':')','[':']','{':'}'}
stack=[]
for i,ch in enumerate(text,1):
    if ch in pairs:
        stack.append((ch,i))
    elif ch in pairs.values():
        if not stack:
            print('Unmatched close',ch,'at',i)
            break
        o,pos=stack.pop()
        if pairs[o]!=ch:
            print('Mismatch',o,pos,'with',ch,i)
            break
else:
    if stack:
        print('Unmatched opens count:',len(stack))
        for o,pos in stack[-20:]:
            print(o,pos)
    else:
        print('All matched')
