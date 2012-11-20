BEGIN {
    found_src = 0;
    open_div = 0;
}
/_source/ { 
    found_src = 1; 
}

/<div/ {
    if (found_src) 
	open_div++;
}
/<\/div/ {
    if (found_src)  {
	open_div--;
	if (open_div == 0) {
	    found_src = 0;
	    print $0;
	}
    }
}
{ if (found_src && open_div > 0) print $0; }

