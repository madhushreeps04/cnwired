BEGIN{
tcp_count=0;
udp_count=0;
}
{
if($1=="d" && $5=="tcp")
tcp_count++;
if($1=="d" && $5=="cbr")
udp_count++;
}
END{
printf("TCP%d\n",tcp_count);
printf("UDP%d\n",udp_count);
}
