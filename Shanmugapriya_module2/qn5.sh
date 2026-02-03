ip route | awk '/default/ {print $3}' | sort > output/qn5_output.txt
