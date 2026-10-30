import cv2,numpy as np,json
from pathlib import Path
root=Path('build/review-r30-10-2026-10-30');cap=cv2.VideoCapture(str(root/'source/pexels-29961571.mp4'))
frames=[];mats=[];previous=None;M=np.eye(3)
for i in range(144):
 ok,f=cap.read()
 if not ok:break
 f=cv2.resize(f,(1280,720));g=cv2.cvtColor(f,cv2.COLOR_BGR2GRAY)
 if previous is not None:
  mask=np.zeros_like(g);mask[:350,:]=255
  a=cv2.goodFeaturesToTrack(previous,maxCorners=400,qualityLevel=.01,minDistance=8,mask=mask)
  b,st,err=cv2.calcOpticalFlowPyrLK(previous,g,a,None)
  A,inl=cv2.estimateAffinePartial2D(a[st.flatten()==1],b[st.flatten()==1],method=cv2.RANSAC)
  T=np.eye(3);T[:2]=A;M=T@M
 frames.append(f);mats.append(np.linalg.inv(M));previous=g
valid=np.ones((720,1280),np.uint8)*255
for T in mats:valid=cv2.bitwise_and(valid,cv2.warpAffine(np.ones_like(valid)*255,T[:2],(1280,720)))
y,x=np.where(valid>0);left,right,top,bottom=int(x.min()+10),int(x.max()-10),int(y.min()+10),int(y.max()-10)
# Conservative fixed crop stays inside the overlap, away from warped corners.
left+=30;right-=30;top+=30;bottom-=30
out=cv2.VideoWriter(str(root/'stabilized.mp4'),cv2.VideoWriter_fourcc(*'mp4v'),24,(960,640))
for f,T in zip(frames,mats):
 f=cv2.warpAffine(f,T[:2],(1280,720));f=f[top:bottom,left:right];h,w=f.shape[:2];target=w/1.5
 if h>target:f=f[int((h-target)/2):int((h+target)/2),:]
 else:
  target=h*1.5;f=f[:,int((w-target)/2):int((w+target)/2)]
 out.write(cv2.resize(f,(960,640)))
out.release();cap.release()
(root/'stabilization.json').write_text(json.dumps({'frames':len(frames),'fps':24,'fixedCrop':[left,top,right,bottom],'lastTransform':mats[-1].tolist(),'method':'Upper-background feature tracking and inverse affine stabilization; fixed crop, no animated pan/zoom.'},indent=2))
