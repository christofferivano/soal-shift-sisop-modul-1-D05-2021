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


## 3. Koleksi Foto Kuuhaku
Untuk soal ketiga ini diminta untuk membantu Kuuhaku mewujudkan idenya supaya bisa mengoleksi foto-foto digital tanpa perlu repot-repot mencarinya manual serta menyembunyikannya menggunakan zip ber-password secara otomatis. Untuk melaksanakan idenya ada 5 langkah yang harus dilakukan yang dibagi menjadi poin a, b, c, d, e.
### 3. a Script untuk mengunduh 23 gambar
Ide yang pertama yang harus dilakukan adalah membuat sebuah script yang bisa mengunduh 23 gambar dari link berikut `https://loremflickr.com/320/240/kitten` dan menyimpan lognya ke sebuah file bernama `Foto.log`. Dengan menggunakan command wget dan looping menggunakan for maka script bisa dibuat lalu sekalian dengan wget kita memasukkan log-nya ke Foto.log dan memberikan nama file foto yang diunduh secara berurutan Koleksi_XX. 
```
for ((num=1; num<=23; num=num+1))
do
if [ $num -le 9 ]
then
wget -a Foto.log https://loremflickr.com/320/240/kitten -O "Koleksi_0$num"
else
wget -a Foto.log https://loremflickr.com/320/240/kitten -O "Koleksi_$num"
fi
done
```
Namun, tidak berhenti di sini saja, karena rupanya foto yang diunduh itu acak sehingga beberapa foto ada yang kembar. Oleh karena itu, foto-foto yang duplikat perlu dideteksi menggunakan command md5sum dan AWK mengidentifikasi MD5 (Message Digest Algorithm 5) foto-foto mana saja yang memiliki kesamaan dan menghapus salah satunya lalu me-rename kembali file Koleksi sehingga jadi berurutan lagi apabila ada file foto yang terhapus. 
```
md5sum * | \
sort | \
awk 'BEGIN{lasthash = ""} $1 == lasthash {print $2} {lasthash = $1}' | \
xargs rm

i=1
for fi in Koleksi_*; do
	mv "$fi" Koleksi_$i
	i=$((i+1))
done
```
Menggabungkan semuanya dan menyimpan script dengan nama soal3a.sh.
### 3. b Menjalankan script pengunduh foto secara terjadwal
Script pengunduh foto yang telah dibuat dijadwalkan untuk dijalankan setiap pukul 20.00 dari tanggal 1 tujuh hari sekali dan dari tanggal 2 4 hari sekali tiap bulan. dengan menggunakan crontab script dijalankan kurang lebih seperti ini pengaturannya.
```
0 20 */7,2-31/4
```
Kemudian supaya lebih rapi, gambar beserta log dalam Foto.log dipindahkan dalam sebuah folder yang dinamai berdasarkan tanggal hari ini dengan format "DD-MM-YYYY". Pendekatan awal berpikiran bisa dilaksanakan langsung lewat crontab tetapi mengalami kebuntuan bagaimana supaya bisa membuat folder dan hasilnya disimpan di dalamnya. Lalu, merubah pendekatan dan beralih ke script yang harus diubah. Pada wget terdapat command --force-directories untuk force creation of directories tetapi tidak berjalan sesuai keinginan karena folder benar memang terbuat sesuai penamaan tanggal hari ini. Namun, gambar yang diunduh tetap berada di luar folder dimana maksud yang diinginkan koleksi gambar bisa langsung disimpan dalam folder yang telah dibuat. Akhirnya mengambil langkah simpel dengan command mkdir dan mengubah direktori saat ini menjadi folder yang telah dibuat dengan command cd sebelum menjalankan script pengunduh.
```
mkdir "/home/amanullahd/$(date +"%d-%m-%Y")"
cd "/home/amanullahd/$(date +"%d-%m-%Y")"
```
### 3. c Menjalankan script bergantian tiap hari
Untuk ide ketiga ini bagaimana sedemikian rupa script bisa dijalankan untuk mengunduh foto dari 2 URL secara bergantian tiap hari. Langkah penyelesaian pertama adalah menggunakan semacam flag switch untuk bisa bergantian menjalankan unduhan yang mana tetapi cara ini terkendala terjadinya reset sehingga tiap kali script dijalankan tetap saja hanya melakukan hal yang sama tidak bisa bergantian. Untuk menangani kendala ini kepikiran untuk menyimpan nilai suatu tinggal di sebuah file sehingga tiap kali script dijalankan tidak terpengaruh oleh reset karena saat deklarasi nilai dalam file tidak berhubungan secara langsung. Namun, untuk penyelesaian ini juga terkendala dalam hal pengambilan argumen dalam file berupa tanggal yang bisa dilakukan operasi relasional. Oleh karena itu, dikarenakan tanggal untuk memulainya bebas kapan saja maka sekalian saja menetapkan tiap tanggal di tiap bulan dibedakan berupa ganjil dan genap sehingga terjadi pergantian di tiap harinya juga tiap bulan.
```
currentdate=$(date +%d)
currentmonth=$(date +%m)
currentyear=$(date +%Y)
if [ $(expr $currentyear % 4) == "0" ];
then
	if [ $currentmonth -eq 1 ] || [ $currentmonth -eq 3 ] || [ $currentmonth -eq 6 ] || [ $currentmonth -eq 7 ] || [ $currentmonth -eq 9 ] || [ $currentmonth -eq 10 ]
        then
                if [ $(expr $currentdate % 2) != "0" ];
                then
                gambar_kucing
                else
                gambar_kelinci
                fi
        else
        if [ $(expr $currentdate % 2) != "0" ];
                then
                gambar_kelinci
                else
                gambar_kucing
                fi
        fi
else
	if [ $currentmonth -eq 1 ] || [ $currentmonth -eq 4 ] || [ $currentmonth -eq 5 ] || [ $currentmonth -eq 8 ] || [ $currentmonth -eq 11 ] || [ $currentmonth -eq 12 ]
	then
		if [ $(expr $currentdate % 2) != "0" ];
		then
		gambar_kucing
		else
		gambar_kelinci
		fi
	else
	if [ $(expr $currentdate % 2) != "0" ];
                then
                gambar_kelinci
                else
                gambar_kucing
                fi
	fi
fi
```
Walaupun begitu, penyelesaian ini masih kurang tepat karena tiap tahunnya akan tetap menjalankan hal yang sama yang seharusnya bergantian sebab tanggal pada bulan Desember berakhir pada tanggal ganjil.
### 3. d Script yang menjadikan koleksi menjadi zip ber-password
Langkah selanjutnya adalah membuat koleksi foto yang telah diunduh menjadi zip dengan password berupa tanggal dengan format "MMDDYYYY". Dengan command zip kita tambahkan perintahnya dalam script yang telah dibuat sebelumnya. Dalam membuat zip-nya, kita buat tidak sekadar membuat tapi menggunakan update sehingga jika file Koleksi.zip bisa di-create dan bilamana sudah ada kita tinggal menambahkan ke dalamnya. Sebelum itu, karena direktori sebelumnya kita ubah menjadi dalam folder yang telah dibuat, kita ubah lagi karena yang akan kita masukkan adalah foldernya ke dalam sebuah file zip. 
```
cd ~
zip -u -m --password "$(date +"%m%d%Y")" -r Koleksi.zip "Kucing_$(date +"%d-%m-%Y")"
```
Ketika menjalankan fungsi untuk menjalankan pengunduh foto kelinci juga diperlakukan sama ditambahkan perintah tersebut dengan bedanya Kucing ==> Kelinci.
### 3. e Zip -> Unzip -> Zip
Langkah terakhir adalah membuat zip hanya ketika waktu tertentu yaitu ketika pukul 07.00 sampai 18.00 dan selebihnya file zip tidak perlu ada. Hal ini dilakukan dengan perintah crontab sehingga sedemikian rupa.
```
0 18 * * * unzip -P "$(date +"%m%d%Y")" Koleksi.zip -d Koleksi && rm Koleksi.zip
0 7 * * * cd Koleksi && zip -u -m --password "$(date +"%m%d%Y")" -r ../Koleksi.zip*
```
Dikarenakan script yang dijalankan sudah membuat zip maka kita perlu melakukan unzip di waktu pukul 18.00 dan isinya disimpan sementara dalam sebuah folder bernama Koleksi, untuk file Koleksi.zip-nya kita hapus. Lalu, pada pukul 07.00 kita masukkan lagi dalam file Koleksi.zip koleksi foto-foto sebelumnya serta Foto.log yang telah dikeluarkan sehingga seluruh folder beserta file dalam folder Koleksi masuk kembali dalam Koleksi.zip.
