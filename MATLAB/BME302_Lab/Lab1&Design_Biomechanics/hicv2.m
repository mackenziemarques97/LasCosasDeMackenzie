% PROGRAM hic:  Returns an array containing the hic, the gsi, t1, and t2,
% where t1 and t2 are the time points that maximize the hic calculation.

function [hicvalue] = hic(filnme,m)

% filename containing accel mag input in (seconds, Gs)

% m = point skip. This simply speeds up the calculation for very large input files


%c ********************************************************************
%c *       Computes the HIC from the given accel. mag. input file
%c ********************************************************************

time = filnme(:,1);
mag1 = filnme(:,2);
npts = length(mag1);
tstep=(time(2)-time(1))*m;


%c      ********************************************************************
%c      *       Evaluate an array of integrals, incrementing dt by
%c      *       the point skip value, m.
%c      ********************************************************************

hic_max=0.0;
gsi=0.0;
int(1)=0.0;
for i=2:npts/m-1
   int(i)=int(i-1)+0.5*(mag1(i*m)+mag1(i*m+m))      ;
%   gsi=gsi+(0.5*(mag1(i*m)+mag1(i*m+m)))^2.5         ; 
end        
                  
%c      ********************************************************************
%c      *       Maximize the HIC by evaluating the differences in
%c      *       int(i) the array.
%c      ********************************************************************


for i=1:npts/m-2
   for j=i+1:npts/m-1
      hic1=int(j)-int(i)        ;
      hic1=(j-i)*(hic1/(j-i))^2.5          ;
      if (hic1>hic_max)
         hic_max=hic1  ;          
         t1=i           ; 
         t2=j            ;
      end         
   end                
end    

%sprintf('        GSI = %10.2f',gsi*time(npts))
sprintf('        HIC = %10.2f',hic_max*tstep)
sprintf('     T1(ms) = %10.2f',t1*tstep*1000)
sprintf('     T2(ms) = %10.2f',t2*tstep*1000)    
  
hicvalue = [hic_max*tstep, t1*tstep, t2*tstep];
   
