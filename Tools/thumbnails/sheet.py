import sys
from PIL import Image, ImageDraw
out, cols, files = sys.argv[1], int(sys.argv[2]), sys.argv[3:]
ims=[Image.open(f).convert("RGB") for f in files]
w,h=ims[0].size; rows=(len(ims)+cols-1)//cols
S=Image.new("RGB",(cols*w,rows*(h+14)),"#ccc"); d=ImageDraw.Draw(S)
for i,(f,im) in enumerate(zip(files,ims)):
    x,y=(i%cols)*w,(i//cols)*(h+14); S.paste(im,(x,y+14)); d.text((x+3,y+1),f.split("/")[-1],fill="black")
S.save(out)
