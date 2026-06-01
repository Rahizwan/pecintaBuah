<?php

namespace Database\Seeders;

use App\Models\Article;
use Illuminate\Database\Seeder;

class ArticleSeeder extends Seeder
{
    public function run(): void
    {
        $articles = [
            [
                'tag' => 'HEALTH',
                'title' => 'The Pectin Power: How an Apple a Day Shield Your Heart',
                'read_time' => '3 min read',
                'content' => "Apel bukan sekadar buah pencuci mulut yang menyegarkan. Secara ilmiah, buah ini merupakan salah satu agen terbaik dalam menjaga sistem kardiovaskular manusia. Rahasia utama di balik kehebatan apel terletak pada tingginya kandungan pektin, sejenis serat larut air yang menempel pada dinding sel tumbuhan.\n\nKetika masuk ke dalam sistem pencernaan, pektin akan berubah menjadi konsistensi seperti gel. Gel ini bekerja secara aktif mengikat kolesterol jahat (LDL) dan asam empedu di usus halus, lalu membawanya keluar dari tubuh sebelum sempat diserap ke dalam aliran darah. Proses ini memaksa hati memanfaatkan kolesterol yang ada di darah untuk memproduksi asam empedu baru, sehingga kadar kolesterol total tubuh menurun secara alami.\n\nSelain pektin, apel kaya akan antioksidan polifenol bernama kuersetin. Senyawa ini terbukti secara klinis mampu mengurangi peradangan pada pembuluh darah dan mencegah oksidasi lipid. Kombinasi serat pektin dan kuersetin inilah yang mematangkan fungsi endotel (dinding bagian dalam pembuluh darah), meminimalkan risiko plak tersumbat, dan menjaga tekanan darah tetap stabil dalam jangka panjang.",
            ],
            [
                'tag' => 'NUTRITION',
                'title' => 'The Potassium Engine: Bananas as Your Ultimate Natural Recovery Fuel',
                'read_time' => '3 min read',
                'content' => "Bagi para atlet atau siapa saja yang aktif bergerak, pisang sering kali menjadi pilihan utama untuk memulihkan tenaga. Mengapa buah ini begitu superior dibandingkan minuman energi kemasan? Jawabannya ada pada keseimbangan mikronutrisi unik yang ditawarkannya, terutama kalium (potasium) dan vitamin B6.\n\nKalium adalah elektrolit vital yang mengatur keseimbangan cairan seluler dan mengendalikan transmisi impuls saraf serta kontraksi otot. Saat tubuh lelah atau berkeringat, kadar kalium menurun, yang memicu terjadinya kram otot dan kelelahan mental. Sebatang pisang ukuran sedang mampu menyuplai sekitar 400-450 mg kalium secara instan untuk menyeimbangkan kembali cairan tubuh.\n\nTak kalah penting, pisang mengandung tiga jenis gula alami: sukrosa, fruktosa, dan glukosa, yang dikombinasikan dengan serat pangan. Struktur ini memberikan pasokan energi yang rilis secara bertahap (sustained energy release), sehingga tubuh tidak mengalami lonjakan gula darah yang ekstrem. Didukung oleh Vitamin B6 yang mempercepat metabolisme protein dan karbohidrat, pisang bertindak sebagai bahan bakar pemulihan seluler yang sempurna di dalam tubuh.",
            ],
            [
                'tag' => 'IMMUNITY',
                'title' => 'Beyond Vitamin C: The Multi-Layered Defense of Citrus Fruits',
                'read_time' => '3 min read',
                'content' => "Jeruk selalu identik dengan pemulihan sariawan dan daya tahan tubuh berkat kandungan Vitamin C (asam askorbat) yang melimpah. Namun, sains modern membuktikan bahwa pertahanan yang diberikan oleh buah jeruk jauh lebih kompleks dari sekadar satu jenis vitamin saja. Jeruk adalah gudang alami dari senyawa bioaktif bernama hesperidin dan naringenin.\n\nHesperidin adalah jenis flavonoid alami yang banyak ditemukan pada lapisan putih di bawah kulit jeruk. Senyawa ini bekerja sinergis dengan Vitamin C untuk memperkuat dinding pembuluh darah kapiler dan meningkatkan aktivitas sel darah putih (leukosit) dalam melacak serta melumpuhkan patogen asing seperti virus atau bakteri.\n\nDi sisi lain, jeruk juga mengandung serat larut air yang sangat ramah bagi mikrobioma usus (bakteri baik). Karena hampir 70% sistem imun manusia diproduksi di dalam jaringan pencernaan, kesehatan usus yang terjaga oleh serat jeruk ini secara otomatis memperkuat benteng pertahanan tubuh. Mengonsumsi jeruk utuh\u2014bukan sekadar air perasannya\u2014memastikan tubuh mendapatkan seluruh spektrum nutrisi pelindung ini untuk mengontrol stabilitas gula darah sekaligus menghalau radikal bebas.",
            ],
            [
                'tag' => 'STORAGE',
                'title' => 'Perfect Lighting and Framing: The Computer Vision Guide to Precise Fruit Scanning',
                'read_time' => '4 min read',
                'content' => "Selamat karena kamu telah meraih akurasi di atas 90%! Angka tinggi ini membuktikan bahwa kamu memahami cara kerja pengolahan citra digital (Computer Vision). Model AI MobileNetV2 yang tertanam di server kami bekerja dengan mengekstrak fitur visual seperti geometri bentuk, tekstur permukaan kulit buah, gradasi warna, hingga distribusi intensitas cahaya pada piksel gambar.\n\nMengapa posisi foto sangat menentukan hasil akurasi? Ketika kamu mengambil gambar secara tegak lurus (top-down atau straight-angle) dengan pencahayaan yang merata, kamu sedang meminimalkan derau spektural atau bayangan palsu yang bisa mengecoh komputer. Bayangan yang terlalu pekat dapat disalahartikan oleh AI sebagai bercak pembusukan, sementara pantulan cahaya lampu yang terlalu terang (glare) bisa menghapus tekstur asli kulit buah yang dibutuhkan untuk mendeteksi kesegaran.\n\nMempertahankan jarak kamera yang ideal juga memastikan objek buah berada tepat di area pusat kalkulasi (bounding box). Hal ini membuat proses pelapisan piksel gambar saat diubah menjadi ukuran 224x224 piksel di server FastAPI tidak mengalami distorsi bentuk. Dengan menjaga konsistensi teknik pengambilan gambar yang baik, kamu membantu model matematika AI mengeksekusi fungsi pembobotan data secara optimal dan akurat.",
            ],
            [
                'tag' => 'SAFETY',
                'title' => 'The Danger of Overripe: Understanding Chlorophyll Degradation and Food Safety',
                'read_time' => '3 min read',
                'content' => "Menemukan buah yang Unfresh (busuk) atau Overripe (terlalu matang) lewat aplikasi adalah langkah penyelamatan bagi kesehatan pencernaanmu. Secara biologis, buah yang melewati fase kematangan optimal akan mengalami proses penuaan seluler (senescence) yang ditandai dengan degradasi total zat hijau daun (klorofil) dan perombakan struktur dinding sel oleh enzim internal buah.\n\nPada fase ini, tekstur buah menjadi sangat lunak karena zat pektin yang awalnya kokoh telah larut sepenuhnya. Kondisi lembap dan tinggi gula ini merupakan lingkungan yang sangat disukai oleh spora jamur (seperti Aspergillus atau Penicillium) dan bakteri pembusuk untuk berkembang biak. Mikroorganisme ini melakukan fermentasi yang mengubah kandungan gula buah menjadi alkohol dan gas karbon dioksida.\n\nMengonsumsi buah yang sudah dalam tahap ini sangat berbahaya bagi dinding lambung manusia. Toksin yang dihasilkan oleh jamur (mikotoksin) tidak hilang hanya dengan memotong bagian yang busuk saja, karena benang-benang halus jamur (hifa) biasanya sudah menjalar ke bagian buah yang terlihat masih utuh. Efeknya bisa memicu iritasi lambung akut, diare, hingga keracunan makanan akibat penumpukan zat asam hasil fermentasi.",
            ],
            [
                'tag' => 'LIFESTYLE',
                'title' => 'The 10-Scan Milestone: Building Sustainable Healthy Habits Through Gamification',
                'read_time' => '3 min read',
                'content' => "Mencapai total 10 kali pemindaian buah adalah langkah awal yang luar biasa dalam membangun kebiasaan hidup baru. Psikologi perilaku menyebutkan bahwa kunci utama keberhasilan mengubah gaya hidup terletak pada konsistensi di awal dan adanya umpan balik visual (visual feedback) yang menyenangkan, seperti pelacakan statistik yang sedang kamu lakukan saat ini.\n\nDengan membiasakan diri memindai buah sebelum dikonsumsi, kamu secara sadar mengaktifkan perhatian penuh (mindful eating) terhadap apa yang masuk ke dalam tubuhmu. Kebiasaan sederhana ini melatih otak untuk memprioritaskan makanan utuh (whole foods) yang kaya serat dan mikronutrisi dibandingkan makanan olahan ultra-proses yang tinggi kalori kosong.\n\nSecara akumulatif, konsumsi buah yang terjadwal dan terpantau akan memberikan dampak masif bagi metabolisme tubuh. Pasokan air organik, vitamin, dan enzim pencernaan dari buah-buahan segar yang kamu pindai setiap hari membantu detoksifikasi fungsi hati, meningkatkan kecerahan kulit, dan menjaga kebugaran seluler tubuh. Jadikan pencapaian 10 scan ini sebagai batu loncatan menuju ratusan pemindaian sehat berikutnya!",
            ],
            [
                'tag' => 'TECHNOLOGY',
                'title' => 'Behind The Intelligence: How What The Fruits Analyzes Your Food',
                'read_time' => '2 min read',
                'content' => "Aplikasi What The Fruits? yang sedang kamu gunakan ini dibangun di atas arsitektur komputasi tingkat tinggi 3-Tier terdistribusi, yang memisahkan fungsi antarmuka seluler (Flutter), pusat kendali data (Laravel & PostgreSQL), dan otak pemrosesan berbasis visi komputer (FastAPI). Pemisahan struktur ini dilakukan agar aplikasi tetap terasa ringan dan responsif di ponsel pengguna, sementara komputasi kecerdasan buatan yang berat diselesaikan secara terisolasi di sisi server.\n\nKetika kamu mengambil foto buah melalui menu pemindaian, gambar tersebut akan dikirimkan ke server utama untuk dianalisis oleh tiga arsitektur jaringan saraf tiruan MobileNetV2 yang berjalan secara paralel. Model AI ini tidak sekadar menebak secara acak, melainkan mengekstraksi ribuan fitur visual mikroskopis dari permukaan kulit buah, mulai dari geometri bentuk, distribusi gradasi warna piksel, hingga konsistensi tekstur luar objek. Hebatnya, sistem ini mampu memberikan tiga analisis kompleks sekaligus\u2014menentukan jenis varietas buah, fase kematangan (ripeness), hingga tingkat kesegaran (freshness) biologis\u2014hanya dalam satu kali klik pemindaian dengan metrik penilaian matematis yang sangat objektif.",
            ],
            [
                'tag' => 'NUTRITION',
                'title' => 'The Big Three: Essential Health Facts of Apples, Bananas, and Oranges',
                'read_time' => '2 min read',
                'content' => "Kecerdasan buatan kami telah dilatih secara intensif menggunakan puluhan ribu sampel data dunia nyata untuk mengenali tiga buah super yang paling sering dikonsumsi masyarakat. Berikut adalah fakta botani dan manfaat kesehatan esensial dari ketiganya:\n\nApel (Apple): Buah pelindung jantung ini kaya akan serat larut bernama pektin yang banyak menempel di bawah kulitnya. Di dalam sistem pencernaan, pektin bekerja seperti magnet yang mengikat kolesterol jahat (LDL) dan membawanya keluar dari tubuh sebelum sempat terserap ke dalam aliran darah, sehingga membantu menjaga kesehatan kardiovaskular secara alami.\n\nPisang (Banana): Dikenal sebagai sumber energi pemulihan instan yang legendaris bagi tubuh. Pisang mengombinasikan tiga jenis gula alami (sukrosa, fruktosa, glukosa) dengan mineral kalium tingkat tinggi. Kalium berperan vital dalam menjaga keseimbangan cairan seluler sel otot, mengendalikan impuls saraf, serta mencegah kram otot setelah kamu lelah beraktivitas seharian.\n\nJeruk (Orange): Bukan sekadar buah penyembuh sariawan, jeruk adalah benteng pertahanan imun yang kuat. Selain kaya Vitamin C, jeruk mengandung flavonoid bioaktif bernama hesperidin. Senyawa ini bekerja sinergis memperkuat dinding pembuluh darah kapiler sekaligus mengoptimalkan kinerja sel darah putih dalam melacak dan melumpuhkan infeksi patogen asing.",
            ],
        ];

        foreach ($articles as $a) {
            Article::firstOrCreate(['title' => $a['title']], $a);
        }
    }
}
