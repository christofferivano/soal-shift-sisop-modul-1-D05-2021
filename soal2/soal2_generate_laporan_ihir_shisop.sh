{ 
	#a
	if (NR != 1) { 
		temp = $NF/($(NF-3) - $NF)*100; 
		if (temp >= profit) {
			profit = temp; 
			row = $1;
		} 
	}
	
	#b 
	if ($3 ~ /17/ && $10 == "Albuquerque") {
		flag = 0; 
		for (a=0; a<i; a++) {
			if (arr[a] == $7) {
				flag = 1;
			}
		} 
		
		if (flag != 1) {
			arr[i] = $7; 
			i++;
		}
	}

	#c
	if ($8 == "Home Office") {
		ho++;
	} else if ($8 == "Consumer") {
		cu++;
	} else if ($8 == "Corporate") {
		co++;
	}

	#d
	if ($13 == "Central") {
		c += $NF;
	} else if ($13 == "East") {
		e += $NF;
	} else if ($13 == "South") {
		s += $NF;
	} else if ($13 == "West") {
		w += $NF;
	} 
} 

END { 
	#a
	printf "Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %.2f%%.\n\n", row, profit;
	
	#b
	printf "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:\n"
	for (a=0; a<i; a++) {
		print arr[a];
	}  
	
	#c
	if (ho < cu && ho < co) {
		printf "\nTipe segmen customer yang penjualannya paling sedikit adalah Home Office dengan %d transaksi.\n\n", ho;
	} else if (cu < ho && cu < co) {
		printf "\nTipe segmen customer yang penjualannya paling sedikit adalah Consumer dengan %d transaksi.\n\n", cu;
	} else if (co < ho && co < cu) {
		printf "\nTipe segmen customer yang penjualannya paling sedikit adalah Corporate dengan %d transaksi.\n\n", co;
	}

	#d
	if (c < e && c < s && c < w) {
		printf "Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah Central dengan total keuntungan %.4f.\n", c;
	} else if (e < c && e < s && e < w) {
		printf "Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah East dengan total keuntungan %.4f.\n", e;
	} else if (s < c && s < e && s < w) {
		printf "Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah South dengan total keuntungan %.4f.\n", s;
	} else if (w < c && w < e && w < s) {
		printf "Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah West dengan total keuntungan %.4f.\n", w;
	} 
}
