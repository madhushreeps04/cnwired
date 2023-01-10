BEGIN{
time=0;
t_s=0;
t_r=0;
}
{
if($1=="r" && $4==1 && $5=="tcp")
t_r+=6;
if($1=="+" && $3==0 && $5=="tcp")
t_s+=6;
}
END{
printf("transmission%f",$2);
printf("sent %fmbps",(t_s)/10000000);
printf("receive%f mbps",(t_r)/1000000);
}

