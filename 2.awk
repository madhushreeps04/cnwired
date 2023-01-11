BEGIN{
st_time=0;
end_time=0;
psize=0;
flag=0;
}
{
if($5=="tcp" && $1=="r" && $4=="5")
{
psize+=$6;
if(flag==0)
{
st_time=$2;
flag=1;
}
end_time=$2;
}
}
END{
printf("throughput=%f mbps\n",(psize*8/1000000)/end_time-st_time);
printf("start time=%f ,endtime=%f\n",st_time,end_time);
}
