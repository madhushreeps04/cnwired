BEGIN{
time=0;
count=0;
}
{
if($1=="r" && $4==1 && $5=="tcp")
{
count+=$6;
time=$2;
printf("\n%f\t%f",time,(count/1000000));
}

}
END{
}

