function figure_motore()    
npoli = 6;
rif =1;
        h = figure;
        set(h,'Tag','Figmotore','menubar','no',...
            'name','Motore Asincrono','Doublebuffer','on');
        axes;
        h1 = gca;
        set(h1,'Tag','motore','box','on',...
            'DataAspectRatio',[1 1 1],...
            'XtickMode','manual','YtickMode','manual');
	
        xx = cos(0:0.001:2*pi);
        yy = sin(0:0.001:2*pi);
	
        line(20*xx,20*yy,'parent',h1,'color','black');
        line(30*xx,30*yy,'parent',h1,'color','black');
        line(45*xx,45*yy,'parent',h1,'color','black');
        
        for i = 1:3
        angolo = pi/2 + (i-1)*((2*pi/3)/(npoli/2));
        cx = 31*cos(angolo);
        cy = 31*sin(angolo);
        color = [((i-1)==0) ((i-2)==0) ((i-3)==0)];
            for t = 1:npoli
                p = patch(cx+1*xx,cy+1*yy,'w');
                set(p,'Facecolor',color);
                angolo= angolo+2*pi/npoli;
                cx = 31*cos(angolo);
                cy = 31*sin(angolo);
            end
        end
        xx = (30+0*cos(npoli/2*(0:2*pi/150:2*pi))).*cos(0:2*pi/150:2*pi);
		yy = (30+0*cos(npoli/2*(0:2*pi/150:2*pi))).*sin(0:2*pi/150:2*pi);    
		line(xx,yy,'color','red','Parent',h1,'Linewidth',4,'Tag','Statore');
        
        xx = (20+0*cos(npoli/2*(0:2*pi/150:2*pi))).*cos(0:2*pi/150:2*pi);
		yy = (20+0*cos(npoli/2*(0:2*pi/150:2*pi))).*sin(0:2*pi/150:2*pi);    
		line(xx,yy,'color','blue','Parent',h1,'Linewidth',4,'Tag','Rotore');
        
        Ra = pi/2 + pi/npoli;
		line([0 40*cos(Ra)],[0 40*sin(Ra)],'color','red','Linewidth',2,'Parent',h1,'Tag','Rs');
        line([0 25*cos(Ra)],[0 25*sin(Ra)],'color','blue','Linewidth',2,'Parent',h1,'Tag','Rr');