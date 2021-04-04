# soal-shift-sisop-modul-1-D05-2021

## 1. ERROR dan INFO USER
Soal 1 ini, diminta untuk mencari info dan error dari suatu user di `syslog.log`, lalu menghitungnya dan menampilkannya di `user_statistic.csv`

Pertama, untuk mencari pesan log pada barisnya dari error dan input yang ada di `syslog.log`, kita dapat menulis perintah seperti berikut :
```
grep -o "[I|E].*" syslog.log
```
Grep -o digunakan untuk mencari sebuah teks yang dimana pada kasus ini untuk mencari teks yang memiliki awalan huruf I / E dari `syslog.log` sampai ke akhir line.\
![image](https://user-images.githubusercontent.com/73484021/113472711-41cb2a80-948f-11eb-9ee3-48167d36be5d.png)

Kedua, untuk mencari pesan error dan menghitungnya bisa, ditulis seperti berikut :
```
grep -o "ERROR.*" syslog.log | cut -d "(" -f1 | sort | uniq -c
```
Setelah mencari satu line error yang dibutuhkan dengan grep dari `syslog.log` dapat dihitung menggunakan `uniq -l` untuk setiap baris errornya. Sort dari yang paling sering muncul ERROR dari `syslog.log`.\
![image](https://user-images.githubusercontent.com/73484021/113472795-a1c1d100-948f-11eb-9818-fa9932865d0c.png)

Ketiga, untuk mencari data error dan info beserta usernamenya dapat menggunakan perintah berikut :
```
grep -o "ERROR.*" syslog.log | cut -d "(" -f2 | cut -d ")" -f1 | sort | uniq -c
grep -o "INFO.*" syslog.log | cut -d "(" -f2 | cut -d ")" -f1 | sort | uniq -c
```
Untuk mengambil nama user bisa menggunakan cut yang diambil dari karakter "(" sampai ")"\
![image](https://user-images.githubusercontent.com/73484021/113472887-39bfba80-9490-11eb-9c58-c7d0a173b133.png)

Keempat, mencari error dan jumlahnya lalu dimasukkan ke dalam `error_message.csv` dapat dilakukan dengan perintah berikut :
```
modified=$(grep "The ticket was modified while updating" syslog.log | wc -l)
cTicket=$(grep "Permission denied while closing ticket" syslog.log | wc -l)
closed=$(grep "Tried to add information to closed ticket" syslog.log | wc -l)
timeout=$(grep "Timeout while retrieving information" syslog.log | wc -l)
noExist=$(grep "Ticket doesn't exist" syslog.log | wc -l)
connection=$(grep "Connection to DB failed" syslog.log | wc -l)
echo "Error,Count" > error_message.csv
printf "The ticket was modified while updating,%d\n
Permission denied while closing ticket,%d\n
Tried to add information to closed ticket,%d\n
Timeout while retrieving information,%d\n
Ticket doesn't exist,%d\n
Connection to DB failed,%d\n" $modified $cTicket $closed $timeout $noExist $ connection |
sort -t, -nr -k2 >> error_message.csv
```
Setelah kita mencari error yang dibutuhkan dengan menggunakan grep dari `syslog.log`, kita hitung dengan `wc -l` per line dari errornya setelah itu dimasukkan ke dalam variable. Lalu buat header `error_message.csv`, print kalimat error dan countnya dengan di sort dan dibagi menjadi 2 kolom menjadi -k2.\
![image](https://user-images.githubusercontent.com/73484021/113472851-ee0d1100-948f-11eb-87df-585ac12dbd0b.png)

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
Gunakan `while` untuk menghitung jumlah error dan info tiap usernamenya menggunakan `grep` lalu masukkan ke `user_statistic.csv`.\
![image](https://user-images.githubusercontent.com/73484021/113472890-3f1d0500-9490-11eb-8ba5-8dbc5cfaa7fb.png)

Kendala :\
-Pada pengerjaan nomor 1b,1c karena muncul beberapa error saat menggunakan cut.

## 2. TokoShiSop
Pada soal ini, kita diminta untuk mencari beberapa kesimpulan berdasarkan data penjualan pada `Laporan-TokoShiSop.tsv`, dimana kesimpulan tersebut dicari menggunakan script `soal2_generate_laporan_ihir_shisop.sh` dan hasil nya ditulis pada `hasil.txt`. 

Dikarenakan eksistensi file yang digunakan sebagai input pada soal ini adalah `.tsv`, yang setiap field nya dipisahkan oleh `tab`, kita perlu mendefinisikan **Field Separator** nya terlebih dahulu. Field separator ini dapat didefinisikan menggunakan `-F` option. Selain itu, untuk menghasilkan perhitungan angka yang tepat, kita dapat menggunakan `LC_NUMERIC=en_US` sebelum menuliskan perintah awk. Sehingga, perintah yang ditulis pada shell adalah sebagai berikut:
```
LC_NUMERIC=en_US awk -F "\t" -f soal2_generate_laporan_ihir_shisop.sh Laporan-TokoShiSop.tsv > hasil.txt
```

Kesimpulan pertama yang diminta pada soal ini adalah **Row ID dan Profit Pencentage terbesar**, dimana profit pencentage didefinisikan sebagai profit/(sales - profit) * 100 dan output ditulis dengan format sebagai berikut.
```
Transaksi terakhir dengan profit percentage terbesar yaitu *ID Transaksi* dengan persentase *Profit Percentage*%.
```

Untuk menampilkan id transaksi terbaru yang memiliki profit percentage terbesar, kita dapat menulis perintah pada soal2_generate_laporan_ihir_shisop.sh sebagai berikut:
```
{
	#a
	if (NR != 1) { 
		temp = $NF/($(NF-3) - $NF)*100; 
		if (temp >= profit && $1 >= row) {
			profit = temp; 
			row = $1;
			id = $2;
		} 
	}
	
	...
}
```
Dimana `$NF` merujuk pada profit, `$(NF-3)` merujuk pada sales, `$1` merujuk pada row id, dan `$2` merujuk pada order id. Sedangkan, variabel `temp` merupakan variabel yang mewakili profit percentage setiap record transkasi, `profit` mewakili profit percentage terbesar, `row` mewakili row id dengan profit percentage terbesar dimana jika hasil profit percentage terbesar lebih dari 1, maka row id terbesar yang dipilih, dan `id` digunakan untuk menyimpan id transakasi yang memiliki row id dan profit percentage terbesar. Syarat `if (NR != 1)` digunakan untuk mencegah perhitungan pada baris pertama, sebab baris pertama bukan merupakan record transkasi, melainkan nama kolom.

Kemudian, untuk menuliskan output kesimpulan pertama, kita dapat menuliskan perintah berikut pada soal2_generate_laporan_ihir_shisop.sh.
```
END { 
	#a
	printf "Transaksi terakhir dengan profit percentage terbesar yaitu %s dengan persentase %.2f%%.\n\n", id, profit;
	
	...
}
```

Kesimpulan selanjutnya yang diminta adalah **nama customer pada transaksi tahun 2017 di Albuquerque**, dimana output ditulis dengan format sebagai berikut.
```
Daftar nama customer di Albuquerque pada tahun 2017 antara lain:
*Nama Customer1*
*Nama Customer2* dst
```

Untuk memperoleh daftar nama customer di Albuquerque pada tahun 2017, kita dapat menyimpan setiap nama customer yang ditemukan pada array `arr` dan mengecek setiap nama yang masuk sehingga tidak terdapat nama yang duplikat pada array arr. Untuk mendapat nama customer pada tahun 2017, kita dapat menggunakan `if ($3 ~ /17/)`, dimana `$3` merujuk pada order date dimana format tanggal yang digunakan pada file laporan adalah `dd-mm-yy`. Kemudian, untuk menemukan nama customer di Albuquerque, kita dapat menggunakan `if ($10 == "Albuqueque)"`, dimana `$10` merujuk pada city.
```
{ 
	...
	
	#b 
	if ($3 ~ /17/ && $10 == "Albuquerque") {
		flag = 0; 
		for (a=0; a<i; a++) {
			if (arr[a] == $7) {
				flag = 1;
				break;
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
 
Kemudian, untuk menuliskan output kesimpulan kedua, kita dapat menuliskan perintah berikut pada soal2_generate_laporan_ihir_shisop.sh.
```
END { 
	...
        
	#b
	printf "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:"
	for (a=0; a<i; a++) {
		print arr[a];
	}
        
        ...
}
```

Kesimpulan ketiga yang diminta adalah **segment customer dengan jumlah transaksi yang paling sedikit beserta jumlah transaksinya**. Untuk mencari jumlah transaksi setiap segment customer, kita dapat memanfaatkan `if` dan juga `variabel` yang akan di-increment untuk menghitung jumlah record transaksi dari setiap segment customer. Sehingga, perintah nya dapat ditulis menjadi seperti berikut:
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

Kemudian, untuk menuliskan output nya, kita dapat menuliskan perintah pada soal2_generate_laporan_ihir_shisop.sh seperti di bawah ini.
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

Selanjutnya, kesimpulan terakhir yang diminta adalah **region yang memiliki total profit paling sedikit beserta total keuntungannya**, dimana region penjualan TokoShiShop dibagi menjadi 4, yaitu Central, East, South, dan West. Perintah untuk mencari kesimpulan ini dapat ditulis sebagai berikut:
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

Kemudian, untuk menuliskan output nya, kita dapat menuliskan perintah sebagai berikut pada soal2_generate_laporan_ihir_shisop.sh.
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
![image](https://user-images.githubusercontent.com/76677130/113502671-f3ce2980-9557-11eb-9ec7-b3f30ad4ac64.png)

Adapun kendala yang dialami selama pengerjaan adalah sebagai berikut:
1. Perhitungan tidak mengikutsertakan angka di belakang titik (.) jika tidak menggunakan LC_NUMERIC=en_US
2. Muncul error division by zero karena tidak menggunakan if(NR!=1) pada soal 2a
3. Tidak dapat menggunakan index sebagai nama variabel


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
	if [ $i -le 9 ]
	then
	mv "$fi" Koleksi_0$i
	i=$((i+1))
	else
        mv "$fi" Koleksi_$i
        i=$((i+1))
	fi
done
```
Menggabungkan semuanya dan menyimpan script dengan nama soal3a.sh.
![Screenshot 2021-04-04 163346](https://user-images.githubusercontent.com/73422724/113505463-38ae8c00-9569-11eb-8549-fd545aa6990f.png)

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
![Screenshot 2021-04-04 163555](https://user-images.githubusercontent.com/73422724/113505481-61cf1c80-9569-11eb-9b1a-e227f5d2e4aa.png)
![Screenshot 2021-04-04 163620](https://user-images.githubusercontent.com/73422724/113505483-6398e000-9569-11eb-86f7-58c7e8febc0e.png)

### 3. d Script yang menjadikan koleksi menjadi zip ber-password
Langkah selanjutnya adalah membuat koleksi foto yang telah diunduh menjadi zip dengan password berupa tanggal dengan format "MMDDYYYY". Dengan command zip kita cari direktori Kucing_* dan Kelinci_* menggunakan loop lalu beri perintah zip. Dalam membuat zip-nya, kita buat tidak sekadar membuat tapi menggunakan update sehingga jika file Koleksi.zip bisa di-create dan bilamana sudah ada kita tinggal menambahkan ke dalamnya. Setelah itu direktori yang berisi koleksi foto perlu dihapus setelah file zip dibuat menggunakan command -m.
```
cd /home/amanullahd
for fi in Kucing_*; do
	zip -u -m --password "$(date +"%m%d%Y")" -r Koleksi.zip "$fi"
done

for fi in Kelinci_*; do
        zip -u -m --password "$(date +"%m%d%Y")" -r Koleksi.zip "$fi"
done
```
Ketika menjalankan fungsi untuk menjalankan pengunduh foto kelinci juga diperlakukan sama ditambahkan perintah tersebut dengan bedanya Kucing ==> Kelinci.

![Screenshot 2021-04-04 164056](https://user-images.githubusercontent.com/73422724/113505493-701d3880-9569-11eb-9da6-fa6350d95f5e.png)

### 3. e Zip -> Unzip -> Zip
Langkah terakhir adalah membuat zip hanya ketika waktu tertentu yaitu ketika pukul 07.00 sampai 18.00 dan selebihnya file zip tidak perlu ada. Hal ini dilakukan dengan perintah crontab sehingga sedemikian rupa.
```
0 7 * * 1-5 /home/amanullahd/soal3d.sh
0 18 * * 1-5 cd /home/amanullahd && unzip -P "$(date +"\%m\%d\%Y")" /home/amanullahd/Koleksi.zip && rm /home/amanullahd/Koleksi.zip
```
Pada pukul 07.00 pagi kita jalankan script untuk membuat zip serta menghapus semua jejak koleksi foto yang ada. Kemudian, ketika pukul 18.00 file Koleksi.zip yang telah dibuat kita extract menggunakan unzip disambung dengan menghapus file zip yang sudah tidak kita perlukan. Keduanya berjalan di hari yang sama sehingga password yang telah ditentukan adalah hari itu juga bisa kita otomatiskan saat hendak meng-extract direktori yang ada dalam file zip.
