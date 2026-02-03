pid=$(ps aux --sort=-%mem | awk 'NR==2 {print $2}') && kill -9 $pid
ps aux --sort=-%mem | head -n 2 > output/qn4_output.txt
