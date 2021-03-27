# soal-shift-sisop-modul-1-D05-2021

## 1. ERROR dan INFO USER
Soal 1 ini, diminta untuk mencari info dan error dari suatu user di `syslog.log`, lalu menghitungnya dan menampilkannya di `user_statistic.csv`

Pertama, untuk mencari pesan log pada barisnya dari error dan input yang ada di `syslog.log`, kita dapat menulis perintah seperti berikut :
```
grep -o "[I|E].*" syslog.log
```
Grep -o digunakan untuk mencari sebuah teks yang dimana pada kasus ini untuk mencari teks yang memiliki awalan huruf I / E dari `syslog.log` 
Kedua, untuk mencari pesan error dan menghitungnya bisa, ditulis seperti berikut :
```
grep -o "ERROR.*" syslog.log | cut -d "(" -f1 | sort | uniq -c
```
Setelah mencari satu line error yang dibutuhkan dengan grep dari `syslog.log` dapat dihitung menggunakan `uniq -l` untuk setiap baris errornya.
Ketiga, untuk mencari data error dan info beserta usernamenya dapat menggunakan perintah berikut :
```
grep -o "ERROR.*" syslog.log | cut -d "(" -f2 | cut -d ")" -f1 | sort | uniq -c
grep -o "INFO.*" syslog.log | cut -d "(" -f2 | cut -d ")" -f1 | sort | uniq -c
```
Untuk mengambil nama user bisa menggunakan cut yang diambil dari karakter "(" sampai ")"
Keempat, mencari error dan jumlahnya lalu dimasukkan ke dalam `error_message.csv` dapat dilakukan dengan perintah berikut :
```
modified=$(grep "The ticket was modified while updating" syslog.log | wc -l)
echo "Error,Count" > error_message.csv
printf "The ticket was modified while updating,%d" $modified | sort -t, -nr -k2 >> error_message.csv
```
Setelah kita mencari error yang dibutuhkan dengan menggunakan grep dari `syslog.log`, kita hitung dengan `wc -l` per line dari errornya setelah itu dimasukkan ke dalam variable. Lalu buat header `error_message.csv`, print kalimat error dan countnya dengan di sort dan dibagi menjadi 2 kolom menjadi -k2.
Kelima, untuk mencari jumlah error dan info beserta usernamenya dapat dilakukan dengan perintah berikut :
```
tr ' ' '\n' < syslog.log > test.txt
grep -o (.*)" test.txt | tr -d "(" | tr -d ")" | sort | uniq > user_statistic.txt
echo "Username,INFO,ERROR" > user_statistic.csv
while read -r userName
do
info=$(grep -E -o "INFO.*($userName)" syslog.log | wc -l)
error=$(grep -E -o "ERROR.*($userName)" syslog.log | wc -l)
echo "$userName,$info,$error" >> user_statistic.csv
done < user_statistic.txt
```
Pisahkan semua kata dari linenya menggunakan tr ' ' '\n' mengganti spasi menjadi newline dari `syslog.log` dan pindahkan datanya ke `test.txt`. Ambil semua nama dengan grep yang ada () pada `test.txt` lalu hapus "(" dan ")", sort, uniq, dan input ke user_statistic.txt. Lalu buat header pada `user_statistic.csv`.
Gunakan `while` untuk menghitung jumlah error dan info tiap usernamenya menggunakan `grep` lalu masukkan ke `user_statistic.csv`.


## 2. Kesimpulan TokoShiSop
Pada soal ini, kita diminta untuk mencari beberapa kesimpulan berdasarkan data penjualan pada `Laporan-TokoShiSop.tsv`, dimana kesimpulan tersebut dicari menggunakan script `soal2_generate_laporan_ihir_shisop.sh` dan hasil nya ditulis pada `hasil.txt`. Dikarenakan eksistensi file yang digunakan sebagai input pada soal ini adalah `.tsv`, yang setiap field nya dipisahkan oleh `tab`, kita perlu mendefinisikan **Field Separator** nya terlebih dahulu. Field separator ini dapat didefinisikan menggunakan `-F` option. Sehingga, untuk mencari beberapa kesimpulan tersebut, kita dapat menulis perintah seperti di bawah ini pada shell.
```
awk -F "\t" -f soal2_generate_laporan_ihir_shisop.sh Laporan-TokoShiSop.tsv > hasil.txt
```

Kesimpulan pertama yang diminta pada soal ini adalah **Row ID dan Profit Pencentage terbesar**, dimana profit pencentage didefinisikan sebagai profit/(sales - profit) * 100 dan output ditulis dengan format sebagai berikut.
```
Transaksi terakhir dengan profit percentage terbesar yaitu *ID Transaksi* dengan persentase *Profit Percentage*%.
```

Untuk mencari row id dan profit percentage terbesar, kita dapat menulis perintah seperti ini pada soal2_generate_laporan_ihir_shisop.sh.
```
{
	#a
	if (NR != 1) { 
		temp = $NF/($(NF-3) - $NF)*100; 
		if (temp >= profit) {
			profit = temp; 
			row = $1;
		} 
	}
	
	...
}
```
Dimana `$NF` merujuk pada profit, `$(NF-3)` merujuk pada sales, dan `$1` merujuk pada row id. Sedangkan, variabel `temp` merupakan variabel yang mewakili profit percentage setiap record transkasi, `profit` mewakili profit percentage terbesar, dan `row` mewakili row id dengan profit percentage terbesar dimana jika hasil profit percentage terbesar lebih dari 1, maka row id terbesar yang dipilih. Syarat `if (NR != 1)` digunakan untuk mencegah perhitungan pada baris pertama, sebab baris pertama bukan merupakan record transkasi, melainkan nama kolom.

Kemudian, untuk menuliskan output kesimpulan pertama agar sesuai dengan format, kita dapat menuliskan perintah berikut pada soal2_generate_laporan_ihir_shisop.sh.
```
END { 
	#a
	printf "Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %.2f%%.\n\n", row, profit;
	
	...
}
```

Kesimpulan selanjutnya yang diminta adalah **nama customer pada transaksi tahun 2017 di Albuquerque**, dimana output ditulis dengan format sebagai berikut.
```
Daftar nama customer di Albuquerque pada tahun 2017 antara lain:
*Nama Customer1*
*Nama Customer2* dst
```

Untuk memperoleh daftar nama customer di Albuquerque pada tahun 2017, kita dapat menyimpan setiap nama customer yang ditemukan pada array `arr` dan mengecek setiap nama yang masuk sehingga tidak terdapat nama yang duplikat pada array arr. Untuk mendapat nama customer pada tahun 2017, kita dapat menggunakan `if ($3 ~ /17/)`, dimana `$3` merujuk pada order date dan format tanggal yang digunakan adalah `dd-mm-yy`. Kemudian, untuk menemukan nama customer di Albuquerque, kita dapat menggunakan `if ($10 == "Albuqueque)"`, dimana `$10` merujuk pada city.
```
{ 
	...
	
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

        ...
}
```
 
Kemudian, untuk menuliskan output kesimpulan kedua sesuai dengan format yang diberikan, kita dapat menuliskan perintah berikut pada soal2_generate_laporan_ihir_shisop.sh.
```
END { 
	...
        
	#b
	printf "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:\n"
	for (a=0; a<i; a++) {
		print arr[a];
	}
        
        ...
}
```

Kesimpulan ketiga yang diminta adalah **segment customer dengan jumlah transaksi yang paling sedikit beserta jumlah transaksinya**. Untuk mencari jumlah transaksi setiap segment customer, kita dapat memanfaatkan `if` dan juga `variabel` yang akan di-increment untuk menghitung jumlah record transaksi dari setiap segment customer. Sehingga, perintah nya dapat ditulis menjadi seperti ini.
```
{ 
	...

	#c
	if ($8 == "Home Office") {
		ho++;
	} else if ($8 == "Consumer") {
		cu++;
	} else if ($8 == "Corporate") {
		co++;
	}

	...
} 
```
Dimana `$8` merujuk pada segment serta `Home Office`, `Consumer`, dan `Corporate` merupakan segment customer yang dimiliki TokoShiShop. Sedangkan, variabel `ho` mewakili jumlah transaksi segment customer Home Office, `cu` mewakili jumlah transaksi segment customer Consumer, dan `co` mewakili jumlah transaksi segment customer Corporate.

Kemudian, untuk menuliskan output sesuai dengan format yang diminta, kita dapat menuliskan perintah pada soal2_generate_laporan_ihir_shisop.sh seperti di bawah ini.
```
END { 
	...  
	
	#c
	if (ho < cu && ho < co) {
		printf "\nTipe segmen customer yang penjualannya paling sedikit adalah Home Office dengan %d transaksi.\n\n", ho;
	} else if (cu < ho && cu < co) {
		printf "\nTipe segmen customer yang penjualannya paling sedikit adalah Consumer dengan %d transaksi.\n\n", cu;
	} else if (co < ho && co < cu) {
		printf "\nTipe segmen customer yang penjualannya paling sedikit adalah Corporate dengan %d transaksi.\n\n", co;
	}

	... 
}
```

Selanjutnya, kesimpulan terakhir yang diminta adalah **region yang memiliki total profit paling sedikit beserta total keuntungannya**, dimana region penjualan TokoShiShop dibagi menjadi 4, yaitu Central, East, South, dan West. Perintah untuk mencari kesimpulan ini dapat ditulis seperti berikut ini.
```
{ 
	...

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
```
Dimana `$13` merujuk pada region dan `$NF` merujuk pada profit. Selain itu, variabel `c` mewakili total profit untuk region Center, `e` mewakili total profit untuk region East, `s` mewakili total profit untuk region South, dan `w` mewakili total profit untuk region West.

Kemudian, untuk menuliskan outputnya, kita dapat menuliskan perintah seperti ini pada soal2_generate_laporan_ihir_shisop.sh.
```
END { 
	...

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
```

Sehingga dengan perintah-perintah di atas, output yang diperoleh pada hasil.txt adalah sebagai berikut.
```
Transaksi terakhir dengan profit percentage terbesar yaitu 9952 dengan persentase 100.00%.

Daftar nama customer di Albuquerque pada tahun 2017 antara lain:
Michelle Lonsdale
Benjamin Farhat
David Wiener
Susan Vittorini

Tipe segmen customer yang penjualannya paling sedikit adalah Home Office dengan 1783 transaksi.

Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah Central dengan total keuntungan 39706.3625.
```


## 3.
