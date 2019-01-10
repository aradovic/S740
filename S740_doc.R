#' ---
#' date: '`r Sys.time()`'
#' mainfont: Arial
#' output:
#'   html_document:
#'     toc: yes
#'   pdf_document:
#'     fig_caption: yes
#'     highlight: tango
#'     includes:
#'       after_body: after_body.tex
#'       before_body: before_body_p_HR.tex
#'       fontsize: 12pt
#'       in_header: header_HR.tex
#'     latex_engine: xelatex
#'     number_sections: yes
#'     pandoc_args:
#'     - --bibliography
#'     - bibliografija.bib
#'     - advances-in-geosciences.csl
#'     toc: yes
#'     toc_depth: 5
#'   word_document:
#'     fig_caption: yes
#'     reference_docx: TS_predlozak_demo_RM_1.docx
#'     toc: yes
#'     toc_depth: 5
#' ---
#' 
#' 
#' .
#' 
#' 
#' 
#' \newpage
#' 
#' 
## ---- echo=FALSE, warning=F, message=F-----------------------------------
setwd("D:\\SRCE_razno\\tecajevi_novi\\R_grafika\\S740_hr")
library(rmarkdown)
library(lattice)
library(latticeExtra)
#install.packages("htmltools",lib=.libPaths()[2], dependencies = TRUE) 
library(htmltools)
library(ggplot2)
library(knitr)
data(mtcars)
library(png)
library(grid)
library("gridExtra")
library(RColorBrewer)
library(sp)
library(spacetime)
library(ggExtra)
library(vcd)
library(plotrix)
library(rgdal)
load("prices.RData")
load("bugs_data.RData")
load("bugs_wide.RData")
load("AktivniRestorani_5.RData")
load("lattice_data.RData")
library(geoR)
data(elevation)
load("podaci_organizacijska_klima.RData")
load("dem_df.RData")

#' 
#' 
#' 
#' 
#' 
#' 
#' \newpage
#' 
#' \vspace*{8 cm} 
#' 
#' 
#' **Ovaj dokument generiran je iz RMarkdown skripte (Rstudio), kombiniranjem moguænosti jezika R, Latex-a i Pandoc-a.** 
#' 
#' 
#' \vspace*{1.1in} 
#' 
#'  ![](R-logo.png)  ![](pandoc.png)
#'  
#'  
#'  
#'  
#'  
#'  
#'  ![](LATEX-logo.png) ![](RStudio-logo.png)
#' 
#' 
#' 
#' 
#' 
#' \newpage
#' 
#' 
#' \clearpage
#' 
#' \setcounter{page}{1}
#' 
#' 
#' 
#' # Znaèaj statistièke grafike
#' 
#' Dva su kljuèna cilja statistièke grafike: 1) olakšavanje usporedbe izmeðu skupova grupa i 2) identificiranje trendova. Statistièka grafika se èesto upotpunjuje uporabom informacija o bojama koje su sadržane u nekoj varijabli. U sluèajevima kada statistièka grafika ukljuèuje sjenèanje podruèja (a ne samo iscrtavanje toèaka ili linija), npr. kao što je sluèaj u bar dijagramima, pita dijagramima, mozaièkim prikazima ili toplinskim mapama, veoma je važno da se boje temelje na percepciji i da ne stvaraju optièke iluzije ili sustavnu pristranost (engl. *systematic bias*). Autor filozofije grafièke gramatike (engl. „Grammar of Graphics“), Leland Wilkinson tako daje definciju statistièke grafike: "Statistièka grafika je ili treba biti trans-disciplinarno podruèje koje u obzir uzima znanstvene, statistièke, raèunalne, estetske, psihološke i druge èimbenike. Znanosti (prirodne, primijenjene ili društvene i, doista, takoðer i razlièite literarne, lingvistièke i povijesne discipline) generiraju podatke koji su relevantni za razlièite probleme, a koji se mogu prikazati kroz grafièki prikaz. Statistika savjetuje, ili, bolje reæi, upuæuje što se treba crtati. Softver i hardver su potrebni kako bi se proizveli prikazi u praksi: jako je malo onih koji danas posežu za olovkom i grafièkim papirom kao što je to bilo uobièajeno prije nekoliko desetljeæa. Jasno možemo vidjeti koliko je grafika privlaèna ili ne, a posebice koliko grafika funkcionira ili ne, u pogledu toga da ju korisnici adekvatno tumaèe. Takoðer je naveo i da je: „… statistièka grafika središnjica suvremenoga statistièkog istraživanja“.
#' 
#' 
#' 
#' Opæenito gledano, boja je sastavni dio grafièkih prikaza. Mnoge statistièke grafike posebno sadrže boju kao sastavni dio svojih grafièkih prikaza. Bilo koji softverski paket može lako generirati grafike u boji, kao i slike u boji koje su, tako, doslovce sveprisutne u elektronièkim publikacijama kao što su tehnièka izvješæa, slajdovi prezentacija, ili elektronièke verzije èlanaka u èasopisima te, sve više, i u tiskanim èasopisima. Meðutim, èesto odabir boja u takvim prikazima nije optimalan uslijed toga što odabir boja nije trivijalan zadatak i postoji relativno malo smjernica o tome kako bi se trebale odabrati adekvatne boje za odreðenu vrstu vizualizacije. Tri kljuène prepreke koje netko mora premostiti kada odabire boje za statistièku grafiku jesu: 
#' 
#' 
#' Iako nije prijeko potrebno da boje u statistièkom dijagramu odražavaju modne trendove, osnovna naèela poput izbjegavanja velikih podruèja s potpuno zasiæenim bojama (Tufte 1990) svakako što svakako treba slijediti. Nije nužno da korisnik ima diplomu iz grafièkog dizajna, veæ da softver korisnicima pruži intuitivan naèin odabira boja i kontroliranja njihovih osnovnih svojstava. Stoga, postoji potreba da se koristi model boje ili prostor boje koji opisuje boje u pogledu njihovih percepcijskih svojstava: nijansa, svjetlina i šarenilo.
#' 
#' Modeli boja su, opæenito, trodimenzionalni. Model boje, kakav obièno podržavaju softverski paketi, ukljuèuje specifikaciju boja kao Crveno-Zeleno-Plavo (engl. *Red-Green-Blue - RGB*). Ipak, ovakva specifikacija odgovara generiranju boja na zaslonu raèunala, a ne ljudskoj percepciji boja. Doslovno je nemoguæe da ljudi kontroliraju percepcijske karakteristike boja u ovakvom prostoru boja zato što nema jedne dimenzije koja odgovara, na primjer, nijansi ili svjetlini boje. Kao posljedica, postoji niz sugestija za razlièite prostore boja koji se temelje na percepciji. Svaka dimenzija prostora boje može se upariti sa percepcijskim svojstvom. Jedan, široko korišteni, pristup u softverskim paketima ukljuèuje **Nijansa-Zasicenost-Vrijednost)** (engl. *Hue-Saturation-Value - HSV*), jednostavnu transformaciju RGB trojki. Meðutim, nesretna je okolnost da dimenzije u HSV prostoru slabo mapiraju  percepcijska svojstva te korištenje HSV boja potièe korištenje visoko-zasiæenih boja. Model boja koji se zasniva na percepciji, kojim se ovi problemi rješavaju, ukljuèuje **Nijansa-Jaèina (èistoæa)-Osvijetljenost** (engl. *Hue-Chroma-Luminance - HCL*).
#' 
#' 
#' Kada se biraju boje, treba se voditi sljedeæim temeljnim naèelima:
#' 
#' * boje trebaju biti privlaène u odrðenoj mjeri
#' 
#' * boje trebaju "suraðivati" jedna s drugom.
#' 
#' Tipièna je svrha boje u statistièkoj grafici da omoguæi razlikovanje podruèja ili simbola na grafièkom prikazu te da omoguæi razlikovanje izmeðu razlièitih skupina ili razlièitih razina varijable. Drugim rijeèima, u dijagramu æe se koristiti nekoliko boja koje se nazivaju paleta boja. Iz svega navedenog veoma je važno znati i moæi stvarati vlastite sheme boja za vizualizaciju razlièitih fenomena. 
#' 
#' 
#' ##Prostori boja i ljudski vid
#' 
#' Kako bi se odabrale palete boja, bilo bi dobro imati osnovna poimanja o tome kako ljudi vide boje. 
#' 
#' Pretpostavlja se da ljudsko oko najbolje primjeæuje:
#' 
#' 1. percepciju kontrasta svjetla/tame 
#' 
#' 2. kontrasti žuto/plavo (obièno se povezuje s našim poimanjem toplih/hladnih boja)
#' 
#' 3. kontrasti zeleno/crveno
#' 
#' što je povezano s anatomskom graðom oka i funkcionalnim stanicama.
#' 
#' Mrežnica sadrži dvije vrste fotoreceptorskih stanica: èunjiæe i štapiæe. Èunjiæi služe za gledanje uz normalnu i jaku rasvjetu, a štapiæi za gledanje uz vrlo slabo osvjetljenje, noæu ili u tamnim prostorima. Èunjiæi stvaraju obojenu, a štapiæi samo sivo-crnu sliku. Dakle, pomoæu èunjiæa u mrežnici raspoznajemo boje. Tri su razlièite skupine èunjiæa u oku:
#' 
#' * èunjiæi osjetljivi na "crvenu" svjetlost - R (red)
#' * èunjiæi osjetljivi na "zelenu" svjetlost - G (green)
#' * èunjiæi osjetljivi na "plavu" svjetlost - B (blue)
#' 
#' Ljudsko oko ima tri odvojena receptora osjetljiva na tri osnovne boje (crvenu, zelenu i plavu) i osjet boje nastaje preklapanjem triju osnovnih osjeta. Svaka se druga boja može stvoriti kombinacijom crvene, zelene i plave svjetlosti. Kad svjetlost padne na mrežnicu osjete je jedna ili više skupina èunjiæa, ovisno o boji svjetlosti. Podražaj èunjiæa pretvara se u elektrièni impuls koji se kroz vidni živac prenosi u mozak.
#' 
#' 
#' \newpage
#' 
#' 
#' # Boje i palete u R-u
#' 
#' 
#' R je programski jezik otvorenoga kôda za statistièku analizu i grafiku. R ima iscrpne i moæne grafièke moguænosti koje su usko povezane s njegovim analitièkim moguænostima. I jedne i druge se brzo razvijaju. Svakih nekoliko mjeseci pojave se nove karakteristike i moguænosti. Inicijalnu verziju R-a razvili su Ross Ihaka i Robert Gentleman sa Sveuèilišta u Aucklandu (engl. University of Auckland). Danas je **The Core Team** odgovoran za razvoj R-a u razlièitim institucijama širom svijeta. Poput Linux-a, R je sustav *otvorenoga kôda*. Izvorni kôd može se pregledati ili izmijeniti i prilagoditi drugim sustavima. Izlaganje kôda kritièkom pregledu visoko-struènih korisnika pokazalo se iznimno uèinkovitim naèinom identificiranja grešaka u kôdu (engl. bugs) i ostalih nedostatnosti te je pobudilo ideje za unapreðenjem.
#' 
#' 
#' ## Boje u R-u
#' 
#' Modeli boja opæenito imaju tri dimenzije uslijed èinjenice o tri razlièita receptora za boje u èovjekovu oku. Boja se u R-u može specificirati pomoæu razlièitih sustava specifikacije:
#' 
#' 
#' * nazivom boje (za imenovane boje)
#' 
#' * RGB specifikaciji Crveno-Zeleno-Plavo
#' 
#' * HSV specifikaciji
#' 
#' * HCL specifikaciji
#' 
#' * Munsellovom naèinu specifikacije.
#' 
#' 
#' 
#' ### Neke funkcije iz paketa *grDevices*
#' 
#' Ovaj paket sadrži funkcije koje podržavaju i osnovnu *base* i *grid* grafiku (grid grafika se temelji na koordinatnoj mreži, o kojoj æe biti rijeèi kasnije). Za potpunu listu funkcija, unesite sljedeæe:
#' 
#' 
## ---- echo=T ,  eval=F, message=F, comment=NA, cache=F-------------------
library(help = "grDevices")

#' 
#' 
#' 
#' Osnovna grafika se veæinom oslanja na *grDevices* paket za odabir boja, gdje se može birati izmeðu nekoliko paleta. Paket, takoðer, pruža niz osnovnih operacija za prijelaz iz jednog u drugi prostor boja kao što su **adjustcolor()**, **col2rgb()**, **make.rgb()**, **rgb2hsv()**, **convertColor()** te za izraðivanje korisnièkih paleta **rgb()**, **hsv()**, **hcl()**, **gray()**, **colorRamp()**, **colorRampPalette()**, **densCols()**, **gray.colors()**.
#' 
#' 
#' Neke boje u R-u imaju nazive. Njihove nazive, 675 njih, može se pronaæi na popisu koji se dobije korištenjem funkcija **colors()** ili **colours()**.
#' 
#' 
#' #### Funkcija **colors()** ili **colours()** {grDevices}
#' 
#' Kao što smo veæ spomenuli, 675 boja u sustavu ima i deklariranu boju. Kako bi se korisnici što lakše koristili imenovanim bojama u sustavu, Stower institut je napravio vizualizaciju istih koja je dostupna na mrežnim stranicama: http://research.stowers-institute.org/efg/R/Color/Chart/. 
#' 
#' Rezultat funkcije **colors()** je vektor naziva boja kojim se upravlja na jednak naèin kao i bilo kojim drugim vektorom u sustavu. U ovom sluèaju to je vektor tipa *character*, tekst, pa se na njemu mogu primjeniti i sve funkcije unutar sustava koje rade s ovim tipom vektora, kao što je funkcija **grep()**.
#' 
#' * Odabiremo prema relativnoj poziciji vektora nazive boja:
#' 
## ---- echo=T , message=F, comment=NA, cache=F----------------------------
colors()[1:10]

#' 
#' * Odabiremo nazive iz vektora naziva boja koji sadrže tekst (engl. *string*) "blue" u imenu a do èega se može doæi korištenjem sljedeæe naredbe:
#' 
## ---- echo=T , message=F, comment=NA, cache=F----------------------------
colors()[grep("blue",colors())]

#' 
#' **ZA SAMOSTALAN RAD:** na naèin kojim smo izdvojili nazive svih boja koje u svojem nazivu sadrže niz znakova *blue* odvojite u posebne objekte sve boje koje u svojem nazivu sadržavaju nizove znakova *red* i *yellow*. Koliko postoji takvih boja u vektoru imenovanih boja?
#' 
#' 
#' 
#' ### Specifikacija boja Crveno-Zeleno-Plavo  (engl. *Red-Green-Blue - RGB*) 
#' 
#' Ovo je najèešæe korišten prostor boja (u daljnjem tekstu RGB). Svaka RGB boja se definira triom koji se sastoji od intenziteta za crvenu, zelenu i plavu valnu duljinu. Sustav se temelji na naèinu na koji su konstruirani raèunalni zasloni i TV ekrani gdje je svaki piksel kombinacija tri svjetlosna izvora. Ako je samo jedna od tri boje na maksimalnom intenzitetu, a ostale su na nuli, tada je boja koja rezultira ili èisto crvena, èisto zelena ili èisto plava.
#' 
#' Kljuèni problem ove sheme boja je taj da se ne temelji na tome kako ljudsko oko vidi boje. Iz toga može nastati nekoliko problema kada se koriste palete boja koje se temelje na RGB-u. Jedno moguæe rješenje je prebaciti se u drugi prostor boja gdje bi prvi izbori bilo korištenje HSV ili HSL specifikacije. Ove kratice znaèe Hue-Saturation-Value HSV i Hue-Saturation-Luminance HSL te se èesto koriste u izbornicima boja (engl. color pickers). Osnovni je problem taj da se, kako im i ime kaže (što se odnosi na dio naziva saturation (hrv. zasiæenost)), temelje na zasiæenosti. Stoga, ovakvi prostori boja ne rješavaju glavni problem skale boja RGB (iz http://hclwizard.org/why-hcl/).
#' 
#' 
#' Pored preciziranja boja u R-u pomoæu imena boja, boje je moguæe definirati i pomoæu **RGB** specifikacije u obliku **#RRGGBB**, a koja se sastoji od dvije heksadecimalne znamenke koje daju vrijednost u rasponu od 00 (potpuno odsustvo) to FF (potpuna zasiæenost). Neke funkcije u RGB sustavu trebaju drugaèiji naèin preciziranja kombinacije crvene - zelene - plave boje, tako što se koristi raspon 0-255 za svaki segment, gdje se kreæe od 0 za potpuno odsustvo specificirane RGB komponente i 255  za maksimalnu zasiæenost.
#' 
#' 
#' 
#' 
## ----fig.width=10, fig.height=3,echo=F,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="RGB model boja; Izvor:https://en.wikipedia.org/wiki/RGB_color_model", cache=T----
par(mfrow=c(1,2), mar=c(0,2,0,0))
img1 <- readPNG("RGB1.png")
img2 <- readPNG("RGB2.png")
plot(c(0, 540), c(0, 420), type = "n", xlab = "", ylab = "", axes = FALSE)
rasterImage(img1, 0, 0, 540, 420)
plot(c(0, 540), c(0, 420), type = "n", xlab = "", ylab = "", axes = FALSE)
rasterImage(img2, 0, 0, 540, 420)

#' 
#' #### Funkcija **rgb()**{grDevices}
#' 
#' 
#' 
#' Ova funkcija izraðuje boje koje odgovaraju datim intenzitetima (izmeðu 0 i maksimuma) za crvenu, zelenu i plavu primarnu boju, nakon postavljanja na skalu u rasponu od 0-255. Detalje potražiti u R dokumentaciji funkcije. Kako bi se upoznali s funkcijom, potrebno je unijeti **?rgb** u R konzolu.
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=F----------------------------
rgb((0:15)/15, green=0, blue=0, names=paste("red",0:15,sep="_"))

#' 
## ----fig.width=10, fig.height=3,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Korisnièki odreðena boja uz pomoæ RGB sheme, prikazana kao pita dijagram s jednakim brojem podjela kao i boja u paleti - parametar alpha varira", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,5), mar=c(0,0,0,0))

#izraðivanje paleta
my_rgb_colors_min <- rgb(red=0, green=0, blue=0, alpha=c(0, 0.2, 0.3, 0.4, 0.6, 0.8, 1))
my_rgb_colors_max <- rgb(red=1, green=1, blue=1, alpha=c(0, 0.2,0.3, 0.4, 0.6, 0.8, 1))
my_rgb_color_red <- rgb(red=1, green=0, blue=0, alpha=c(0, 0.2, 0.3, 0.4, 0.6, 0.8, 1))
my_rgb_color_green <- rgb(red=0, green=1, blue=0, alpha=c(0, 0.2, 0.3, 0.4, 0.6, 0.8, 1))
my_rgb_color_blue <- rgb(red=0, green=0, blue=1, alpha=c(0, 0.2, 0.3, 0.4, 0.6, 0.8, 1))

#vizualiziranje pripremljenih paleta
pie(rep(1,7), col= my_rgb_colors_min)
pie(rep(1,7), col= my_rgb_colors_max)
pie(rep(1,7), col= my_rgb_color_red)
pie(rep(1,7), col= my_rgb_color_green)
pie(rep(1,7), col= my_rgb_color_blue)

#' 
#' 
#' 
#' ### HSL/HSV specifikacija boja
#' 
#' Drugi model boja, koji tipièno podržavaju softverski paketi, jest model koji ukljuèuje specifikaciju boja kroz Zasiæenost-Vrijednost-Osvjetljenje (engl. *Hue-Saturation-Value - HSV*), koje se dobivaju jednostavnom transformacijom RGB trija (u daljnjem tekstu *HSV*). 
#' 
## ---- echo=F , message=F, comment=NA, cache=F, warning=F-----------------
par(mfrow=c(1,1), mar=c(0,0,0,0))
img <- readPNG("HSL_HSV_colors.png")

#' 
#' 
## ----fig.width=10, fig.height=3,echo=F,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="HSL i HSV cilindri; Izvor: https://en.wikipedia.org/wiki/HSL_and_HSV", cache=F----
#postavljanje grafièkih parametara
grid.raster(img)

#' 
#' **HSL** i **HSV** su dvije najuobièajenije cilindrièno-koordinatne prezentacije toèaka u RGB modelu boja. Ove dvije prezentacije preslažu geometriju RGB-a uz pokušaj da ona bude intuitivnija i percepcijski relevantnija od dekartove (kubusne) reprezentacije. HSL i HSV su razvijeni tijekom 1970-ih godina za aplikacije raèunalne grafike. Danas se koriste u izbornicima boja (engl. *color pickers*) u softveru za ureðivanje slika te, manje uobièajeno, u analizi slika i raèunalnoj vizualizaciji.
#' 
#' HSL znaèi nijansa, zasiæenost i osvijetljenost te se èesto naziva i HLS. HSV predstavlja nijansu, zasiæenost i vrijednost, a èesto se naziva i HSB (B za svjetlost, engl. *brightness*). Treæi model koji je uobièajen u raèunalnim vizualnim primjenama jest HSI, što predstavlja nijansu, zasiæenost i intenzitet. Iako su ove definicije obièno konzistentne, one nisu standardizirane tako da se bilo koja od kratica može koristiti za bilo koji od navedena tri ili nekoliko drugih povezanih cilindriènih modela. 
#' 
#' 
#' U svakom cilindru, kut oko središnje vertikalne osi odgovara „nijansi“, udaljenost od osi odgovara „zasiæenosti“, a udaljenost duž osi odgovara „osvijetljenosti“, „vrijednosti“ ili „svjetlost“. Potrebno je uoèiti da iako se „nijansa“ u HSL i HSV odnosi na isti atribut, njihove se definicije „zasiæenosti“ znaèajno razlikuju.
#' 
#' 
#' 
#' 
#' #### Funkcija **hsv()**{grDevices}  
#' 
#' 
#' Funkcija **hsv()** koristi vrijednosti nijanse, zasiæenosti i vrijednosti (u rasponu od 0 do 1) za specifikaciju boja. Funkcija prihvaæa ili jednu vrijednost za vektore vrijednosti ili vektore vrijednosti, i vraæa heksadecimalne vrijednosti. Funkcija ima oblik hsv (h=value, s=value, v=value, gamma=value, alpha=value). Funkciju **hcl()** može se gledati kao percepcijski temeljenu verziju **hsv()** funkcije.
#' 
#' 
#' 
#' 
## ---- echo=T, warning=F, message=F---------------------------------------
#priprema paleta (sheme boja)
my_hsv_colors_000 <- hsv(h=0, s=0, v=0)
my_hsv_colors_111 <- hsv(h=1, s=1, v=1)
my_hsv_colors_h  <- hsv(h=c(0,.1,.3, .5, .7,.9,1), s=1, v=1)
my_hsv_colors_s  <- hsv(h=0, s=c(0,.1,.3, .5, .7,.9,1), v=1)
my_hsv_colors_v  <- hsv(h=0, s=0, v=c(0,.1,.3, .5, .7,.9,1))

#' 
#' 
## ----fig.width=10, fig.height=3,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Korisnièke boje odreðene HSV shemom; alfa =1 (default)", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,5), mar=c(0,0,0,0))

#vizualiziranje pripremljenih paleta
pie(rep(1,7), col= my_hsv_colors_000)
pie(rep(1,7), col= my_hsv_colors_111)
pie(rep(1,7), col= my_hsv_colors_h)
pie(rep(1,7), col= my_hsv_colors_s)
pie(rep(1,7), col= my_hsv_colors_v)

#' 
#' 
#' \newpage
#' 
#' ### HCL specifikacija boja
#' 
#' 
#' *Hue-Chroma-Luminance HCL* prostor boja predstavlja alternativu prostorima boja poput RGB, HSV itd. Suprotno veæini dostupnih prostora boja, HCL skala boja temelji se na tome kako ljudsko oko vidi boje. Svaka boja u HCL prostoru boja definira se trojkom vrijednosti. Kako je spomenuto, boje se tipièno opisuju kao lokacije u trodimenzionalnim prostorima. Tri dimenzije koje ljudi tipièno koriste za opisivanje boja su: 
#' 
#' * nijansa: odreðuje boju
#' 
#' * zasiæenost (šarolikost): definira obojenost
#' 
#' * svijetlost: definira svjetlinu (èistoæu), kolièinu sive.
#' 
#' 
## ----fig.width=8, fig.height=4,echo=F,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Boje definirane HCL sustavom; Izvor: http://hclwizard.org/why-hcl", cache=F----
par(mfrow=c(1,1), mar=c(0,0,0,0))
img <- readPNG("hcl_spectrum.png")
grid.raster(img)

#' 
#' Kao što smo veæ naveli, ljudsko oko ima dvije vrste stanica koje odreðuju naš vid od kojih jedne (èunjiæi) detektiraju razlièite dijelove elektromegnetskoga spektra te oko 20 puta više štapiæa, stanica mrežnice koje prihvaæaju intenzitet svjetla te su odgovorne za našu percepciju osvijetljenosti (kontrast tamno/svijetlo). HCL prostor boje temelji se na ovim osnovnim èinjenicama o naèinu funkcioniranja ljudskoga oka i vida opæenito. Unutar HCL sustava osoba/korisnik izravno kontrolira boju (nijansu), šarolikost (obojenost) i svjetlinu (èistoæu, kolièinu sive). Ovo omoguæava da se izbjegnu mnogi problemi vezani za RGB palete boja. Modeli boja koji nastoje obuhvatiti ove percepcijske osi nazivaju se i prostorima boja temeljeni na percepciji.
#' 
#' 
#' 
#' 
#' #### Funkcija **hcl()**{grDevices}
#' .
#' 
#' Ova funkcija je korisna za izraðivanje niza boja koje imaju približno jednake perceptualne promjene. Funkcija stvara vektor boja iz vektora koji preciziraju nijansu, obojenost i osvijetljenost.
#' 
#' 
#' Funkcija **hcl()** koristi vrijednosti nijanse, obojenosti i osvijetljenosti za jednoznaèno odreðivanje boje. Funkcija prihvaæa bilo jedinstven skup vrijednosti ili vektore vrijednosti, te vraæa vektor heksadecimalnih vrijednosti za raspon nijansi od 0 do 360. Nijansa boje koja je specificirana kao kut u rasponu [0,360]. Kut od 0 stupnjeva oznaèava crvenu boju  kut od 120 stupnjeva zelenu, a kut od 240 stupnjeva oznaèava plavu boju. Raspon za obojenost ovisi o nijansi i osvijetljenosti, a raspon za osvijetljenost ovisi o nijansi i obojenosti. Za više detalja pogledati R dokumentaciju ali i primjer koji slijedi.
#' 
#' 
#' 
#' 
## ---- echo=T, warning=F, message=F---------------------------------------
#priprema paleta
my_hcl_colors_0_35_0 <- hcl(h=0, c=35, l=0)
my_hcl_colors_360_35_100 <- hcl(h=360, c=35, l=100)
my_hcl_colors_h_35_0 <- hcl(h=c(0,70, 150, 220, 290, 360), c=35, l=0)
my_hcl_colors_0_35_l <- hcl(h=0, c=35, l=c(0,20, 40, 60, 80, 100))
my_hcl_colors_360_35_l <- hcl(h=360, c=35, l=c(0,20, 40, 60, 80, 100))

#' 
#' 
#' 
#' 
## ----fig.width=10, fig.height=3,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Korisnièka paleta odreðena HCL shemom s promjenjivim parametrima", cache=F----
#definiranje grafièkih parametara
par(mfrow=c(1,5), mar=c(0,0,0,0))

#vizualiziranje pripremljenih paleta
pie(rep(1,7), col= my_hcl_colors_0_35_0)
pie(rep(1,7), col= my_hcl_colors_360_35_100)
pie(rep(1,7), col= my_hcl_colors_h_35_0)
pie(rep(1,7), col= my_hcl_colors_0_35_l)
pie(rep(1,7), col= my_hcl_colors_360_35_l)

#' 
#' Molim, komentirajte rezultate koje ste dobili.
#' 
#' 
#' 
#' ### Munsell specifikacija boje 
#' 
#' 
#' U znanosti o bojama, Munsell sustav boja je prostor boja koji specificira boje temeljem tri dimenzije boja: nijansa, vrijednost (svjetlost) i obojenost (èistoæa boje). Kreirao ga je profesor Albert H. Munsell poèetkom 20. stoljeæa te ga je USDA prihvatila kao službeni sustav boja za istraživanje tla tijekom 1930-ih. Munsell sustav boja temelji se na nešto razlièitoj matematici ali ima odreðenu sliènost sa HCL sustavom.
#' 
#' 
## ----fig.width=4, fig.height=3,echo=F,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Munsell model; Izvor: https://en.wikipedia.org/wiki/Munsell_color_system", cache=F----
par(mfrow=c(1,1), mar=c(0,3,0,2))
img <- readPNG("Munsell.png")
#img2 <- readPNG("RGB2.png")
plot(c(0, 540), c(0, 420), type = "n", xlab = "", ylab = "", axes = FALSE)
rasterImage(img,0, 0, 540, 420)

#' 
#' 
#' Paket **munsell** predstavlja okvir za rad s Munsell sustavom boja (https://en.wikipedia.org/wiki/Munsell_color_system).
#' 
#' 
#' 
#' ### Prilagodba za daltonizam
#' 
#' U sluèaju potrebe za prilagodbom za daltoniste, potrebno je upoznati se *dichroma* paketom, ali je to izvan djelokruga ovoga teèaja. Informacije o paketu i njegovim funkcijama prema potrebi pronaðite na CRAN stranici paketa (https://cran.r-project.org/web/packages/munsell/index.html).
#' 
#' 
#' 
#' ### Prijelaz izmeðu sustava boja
#' 
#' 
#' Kako je veæ spomenuto, boje se u R-u mogu specificirati indeksom, nazivom, heksadecimalno, RGB-om i Munsellom. Na primjer, prva boja, bijela, može se predstaviti nazivom "white". RGB komponente bijele boje ekvivalentne su specifikaciji crvene, zelene, i plave redom: 255, 255, 255. Inter-operabilnost meðu opisanim sustavima je moguæa i èesto je i neophodna http://research.stowers-institute.org/efg/R/Color/Chart/ColorChart.pdf.
#' 
#' 
#' 
#' #### Funkcija **col2rgb()**{grDevices}  .
#' 
#' 
#' Svaka od heksadecimalno definiranih boja koje su imenovane, mogu se prikazati u RGB formatu pomoæu funkcije **col2rgb()**:
#' 
#' Koristite ovaj kôd da biste vidjeli RGB vrijednosti za sve imenovane boje (prvih 10 boja):
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=F----------------------------
#u varijablu naziva nazivi_boja stavljamo imena imenovanih boja sustava
nazivi_boja <- colors()
#prebacujemo u RGB sustav
boje_rgb <- col2rgb(nazivi_boja)

#dodajemo atribut imena colona objektu klase matrix; preuzimamo iz vektora imena boja
colnames(boje_rgb) <- nazivi_boja

#transponiramo objekt radi lakše prezentacije - opcionalno
t(boje_rgb)[1:10,]

#' 
#' U sljedeæem primjeru, iz heksadecimalnog sustava na kojem boje specificira funkcija **terrain.colors()** prelazimo na *RGB* sustav boja na jednak naèin prikazan u sljedeæem primjeru s 20 boja kreiranih iz terrain.colors palete sustava R:
#' 
## ---- echo=T , message=F, comment=NA, cache=F----------------------------
#prebacujemo u RGB sustav 20 boja palete sustava terrain.colors
crgb <- col2rgb(cc <- terrain.colors(20))

#davanje atributa objektu
colnames(crgb) <- cc

#transponiranje radi lakše prezentacije - opcionalno
t(crgb)

#' 
#' #### Funkcija **col2hex()**{grDevices}
#' .
#' 
#' 
#' Svaka imenovana boja može se prikazati u heksadecimalnom formatu korištenjem funkcije **col2hex()** na naèin prikazan  u sljedeæem primjeru za prvih deset imenovanih boja sustava:
#' 
#' Koristite sljedeæe naredbekako bi se ispisale RGB vrijednosti za sve imenovane boje (prvih 10 boja):
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=F----------------------------
boje_rgb <- col2rgb(imena_boja <- colors())
colnames(crgb) <- cc
t(crgb)[1:10,]

#' 
#' 
#' Isti se primjer može napraviti pomoæu vektora razlièito specificiranih boja, kao što je sluèaj u primjeru koji slijedi:
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=F----------------------------
col2rgb(c("#4682B433", "#104E8b", "royalblue3"))

#' 
#' 
#' #### Funkcija **convertColor()**{grDevices}
#' .
#' 
#' Novija i fleksibilnija funkcija za prelazak izmeðu prostora boja je  **convertColor()**{grDevices}. Funkcija omoguæava konverziju boje izmeðu njihovih prikaza u standardnim prostorima boja. Kako biste se upoznali sa funkcijom unesite **?convertColor** u R konzolu. Postoje i cijeli kontribuirani paketi koji pružaju razlièite funkcije sa specifiènom sintaksom za inter-operabilnost meðu sustavima boja. Jedan od takvih paketa je i paket **colorspace**. Dodatne informacije o paketu, prema potrebi pronaðite na službenim CRAN stranicama paketa (https://cran.r-project.org/web/packages/colorspace/index.html).
#' 
#' 
#' .
#' 
#' 
#' 
#' **ZA SAMOSTALNI RAD**
#' 
#' - Napravite vektor duljine 8, definirajte nazive boja za daljnju uporabu. Dodijelite ovaj vektor objektu **moje_boje**. Za pomoæ, koristite sljedeæi dokument: http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf. 
#' 
#' - Odaberite nazive svih imenovanih boja u R-u koje sadrže rijeè *green* i dodijelite te vrijednosti karkatera objektu pod nazivom **green_colors**. Koja je duljina objekta?
#' 
#' - Koji je naziv 53. boje po redu imenovanih boja u R-u?
#' 
#' 
#' 
#' 
#' 
#' ## Palete (sheme boja) u R-u
#' 
#' 
#' 
#' Opæenito, razlikujemo tri tipa paleta:
#' 
#' 
#'  - **Kvalitativne palete**
#' 
#' 
#' Kvalitativne palete su skupovi boja kojima se prikazuju razlièite kategorije tj. koriste se za kodiranje kategorijkih varijabli. Obièno daju istu percepcijsku težinu svakoj kategoriji tako da se nijedna grupa ne percipira veæom ili znaèajnijom od druge.
#' 
#' 
#' 
#'  - **Sekvencijske palete**
#' 
#' Sekvencijske palete koriste se  za kodiranje numerièkih informacija koje imaju raspon u odreðenom intervalu i gdje se niske vrijednosti smatraju nezanimljivim, a visoke zanimljivim. 
#' 
#' - **Divergirajuæe palete **
#' 
#' Divergirajuæe palete se, takoðer, koriste za kodiranje numerièkih informacija koje imaju raspon na odreðenom intervalu; meðutim, ovaj interval sadrži i  neutralnu vrijednost. 
#' 
#' R nudi niz predloženih shema boja. S izuzetkom sivih, sve imaju istu sintaksu. Unese se željeni broj nijansi koje želite sa sheme i funkcija ispiše vektor boja. Slijede neke korisne funkcije za rad s paletama u R-u iz *grDevices* i *RColorBrewer* paketa.
#' 
#' ### Funkcije za upravljanje paletama {grDevices}
#' 
#' #### Funkcija **palette()**{grDevices}
#' 
#' .
#' 
#' 
#' Ovom funkcijom tražimo informacije o aktivnoj paleti u sustavu. Dodatno, funkcijom **palette()** možemo i upravljati paletom boja koja se koristi te možemo odrediti vlastitu, proizvoljnu paletu.
#' 
#' U primjeru ispod aktivna je paleta: black, red, green3, blue, cyan, magenta, yellow, gray što znaèi da u sluèaju potrebe za samo jednom bojom na našem grafu, koristi se prva boja, a to je crna. Moguæe je specificirati crnu kao željenu boju korištenjem grafièkoga parametra col=1 (kasnije æe biti objašnjeno) (jer je ovdje crna boja prva boja u zadanoj paleti) ili col="black". Ako je potrebna druga boja, druga æe se koristiti kao zadana, ovdje je to red; ako je potrebna treæa boja, koristit æe se *green3* itd.
#' 
## ---- echo=T , message=F, comment=NA, cache=F----------------------------
palette()

#' 
#' Povratak na prvobitnu paletu postiže se naredbom **palette("default")**.
#' 
#' Paleta boja može se promijeniti tako što æemo zadati vektor boja: 
#' 
## ----echo=F,encoding = "ISO8859_2", warning=FALSE,message=F, cache=F-----
par(mfrow=c(1,1), mar=c(0,0,0,0))

#' 
#' 
#' 
## ----fig.width=6, fig.height=3,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Promjena zadane (default) palete sa željenom; èetiri proizvoljne boje", cache=F----
par(mfrow=c(2,1), mar=c(0,0,0,0))

#postavljanje naše palete
palette(c("lightblue", "#4682B4", "#00008B", "darkgreen"))
barplot(c(1,1,1,1), axes=FALSE, col=c(1,2,3,4))

#povratak na zadanu (default) paletu
palette("default")
barplot(c(1,1,1,1), axes=FALSE, col=c(1,2,3,4))

#' 
#' 
#' #### Funkcija **gray()**{grDevices}
#' .
#' 
#' Funkcija kreira vektor boja iz vektora sivih razina. Funkcija **gray()** prima vrijednosti od 0 do 1, gdje 0 znaèi crno, a 1 znaèi bijelo. U kôdu koji slijedi, postavlja se vektor duljine numerièkih podataka kako biste dobili vektor sivih nijansi. Pita dijagrami su uobièajeni naèin vizualiziranja kreiranih shema boja te æe se u tom kontekstu koristiti u svim daljnjim primjerima.  
#' 
#' Ako želimo izraditi shemu boja (paletu) koja se sastoji od 15 sivih boja, a koje se protežu kroz cijeli spektar (0 - crno do 1 - bijelo) koristit æemo sljedeæi kôd:
#' 
#' 
#' 
#' 
## ----echo=T,encoding = "ISO8859_2", warning=FALSE,message=F, cache=F-----
#priprema paleta
my_gray_colors_1 <- gray((0:14/14), alpha=1)
my_gray_colors_08 <- gray((0:14/14), alpha=0.8)
my_gray_colors_06 <- gray((0:14/14), alpha=0.6)
my_gray_colors_04 <- gray((0:14/14), alpha=0.4)
my_gray_colors_02 <- gray((0:14/14), alpha=0.2)

#' 
## ----fig.width=10, fig.height=3,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Korisnièka paleta sivih boja, prikazana korištenjem pita dijagrama s jednakim brojem podjela; alpha argument varira", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,5), mar=c(0,0,0,0))

#vizualiziranje pripremljenih paleta
pie(rep(1,15), col= my_gray_colors_1)
pie(rep(1,15), col= my_gray_colors_08)
pie(rep(1,15), col= my_gray_colors_06)
pie(rep(1,15), col= my_gray_colors_04)
pie(rep(1,15), col= my_gray_colors_02)

#' 
#' 
#' 
#' #### Funkcije **heat.colors()**; **rainbow()**; **topo.colors()**{grDevices}   
#' .
#' 
#' Sustav R posjeduje nekoliko ugraðenih paleta boja. U biblioteci *grDevices* dostupno je pet funkcija za izradu vektora kontinuiranih boja iz ugraðenih paleta: **heat.colors()**, **cm.colors()**, **terrain.colors()**, **topo.colors()** i **rainbow()**. Ove funkcije se donekle razlikuju od funkcije **gray()**. Više detalja potražiti u R dokumentaciji. Otvorite dokumentacijsku karticu naredbom **?heat.colors** i upoznajmo se sa sintaksom.
#' 
#' Primjeri izrade vektora kontinuiranih boja (**heat.colors()**, **rainbow()** i **topo.colors()**):
#' 
#' 
#' 
## ----echo=T,encoding = "ISO8859_2", warning=FALSE,message=F, cache=F-----
my_heat_colors_1  <-heat.colors(15, alpha=1)
my_heat_colors_08 <- heat.colors(15, alpha=0.8)
my_heat_colors_06 <- heat.colors(15, alpha=0.6)
my_heat_colors_04 <- heat.colors(15, alpha=0.4)
my_heat_colors_02 <- heat.colors(15, alpha=0.2)

#' 
#' 
## ----fig.width=10, fig.height=3,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Izraðivanje vektora boja iz palete engl. 'heat colors'; alpha argument varira", cache=F----
#definiranje grafièkih parametara 
par(mfrow=c(1,5), mar=c(0,0,0,0))

#vizualiziranje pripremljenih paleta
pie(rep(1,15), col= my_heat_colors_1)
pie(rep(1,15), col= my_heat_colors_08)
pie(rep(1,15), col= my_heat_colors_06)
pie(rep(1,15), col= my_heat_colors_04)
pie(rep(1,15), col= my_heat_colors_02)

#' 
#' 
#' 
#' 
## ----echo=T,encoding = "ISO8859_2", warning=FALSE,message=F, cache=F-----
#radimo palete boja
my_rainbow_colors_1  <- rainbow(15, alpha=1)
my_rainbow_colors_08 <- rainbow(15, alpha=0.8)
my_rainbow_colors_06 <- rainbow(15, alpha=0.6)
my_rainbow_colors_04 <- rainbow(15, alpha=0.4)
my_rainbow_colors_02 <- rainbow(15, alpha=0.2)

#' 
#' 
## ----fig.width=10, fig.height=3,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Izraðivanje vektora boja iz palete engl. 'rainbow'; alpha argument varira", cache=F----
par(mfrow=c(1,5), mar=c(0,0,0,0))

#vizualiziranje pripremljenih paleta
pie(rep(1,15), col= my_rainbow_colors_1)
pie(rep(1,15), col= my_rainbow_colors_08)
pie(rep(1,15), col= my_rainbow_colors_06)
pie(rep(1,15), col= my_rainbow_colors_04)
pie(rep(1,15), col= my_rainbow_colors_02)

#' 
#' Funkcija **rainbow()** omoguæava pod-raspone ukupnog spektra:
#' 
#' 
#' 
## ----echo=T,encoding = "ISO8859_2", warning=FALSE,message=F, cache=F-----
#stvaranje palete boja
my_rainbow_colors_085_1 <- rainbow(15, start = 0.85, end =1 )
my_rainbow_colors_065_1 <- rainbow(15, start = 0, end = 1)
my_rainbow_colors_065_085 <- rainbow(15, start = 0.65, end = 0.85)
my_rainbow_colors_04_05 <- rainbow(15, start = 0.4, end = 0.5)
my_rainbow_colors_0_03 <- rainbow(15, start = 0, end= 0.3)

#' 
#' 
## ----fig.width=10, fig.height=3,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Izraðivanje vektora boja iz palete engl. 'rainbow'; varira raspon", cache=F----
par(mfrow=c(1,5), mar=c(0,0,0,0))

#vizualiziranje pripremljenih paleta
pie(rep(1,15), col= my_rainbow_colors_085_1)
pie(rep(1,15), col= my_rainbow_colors_065_1)
pie(rep(1,15), col= my_rainbow_colors_065_085)
pie(rep(1,15), col= my_rainbow_colors_04_05)
pie(rep(1,15), col= my_rainbow_colors_0_03)

#' 
#' 
#' 
## ----echo=T,encoding = "ISO8859_2", warning=FALSE,message=F, cache=F-----
#radimo palete boja
my_topo_colors_1  <- topo.colors(15, alpha=1)
my_topo_colors_08 <- topo.colors(15, alpha=0.8)
my_topo_colors_06 <- topo.colors(15, alpha=0.6)
my_topo_colors_04 <- topo.colors(15, alpha=0.4)
my_topo_colors_02 <- topo.colors(15, alpha=0.2)

#' 
#' Ponovno æemo vizualizirati palete pripremljene funkcijom **topo.colors()** željenim brojem boja i alpha parametrom. 
#' 
#' 
## ----fig.width=10, fig.height=3,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Izraðivanje vektora boja iz palete engl. 'topo.colors'; alpha argument varira", cache=F----
#definiranje grafièkih parametara
par(mfrow=c(1,5), mar=c(0,0,0,0))

#vizualiziranje pripremljenih paleta
pie(rep(1,15), col= my_topo_colors_1)
pie(rep(1,15), col= my_topo_colors_08)
pie(rep(1,15), col= my_topo_colors_06)
pie(rep(1,15), col= my_topo_colors_04)
pie(rep(1,15), col= my_topo_colors_02)

#' 
#' 
#' 
#' 
#' 
#' 
#' ####Funkcija **colorRampPalette()** {grDevices}  
#' .
#' 
#' Ova je funkcija slièna funkciji **colorRamp**{grDevices} ali kao argumente broja boja koje se trebaju pripremiti ova funkcija uzima cijeli broj kao vrijednost. Funkcija daje novu funkciju koja æe generirati popis boja. Prvo æemo se upoznati s funkcijom tako što æemo unijeti **?colorRampPalette** u R konzolu.
#' 
#' 
#' 
#' 
## ----fig.width=10, fig.height=3,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Izraðivanje funkcije kao rezultat druge funkcije **colorRampPalette()** sa zadanim brojem boja i graniènim bojama", cache=F----
#definiranje grafièkih parametara
par(mfrow=c(1,5), mar=c(0,0,0,0))

#stvaranje funkcije (funkcijom)
pal_1 <- colorRampPalette(colors=c("red", "blue") )

# odabir 5 boja iz palete
pal_1(15)

#interpolacija boja izmeðu odreðenih graniènika
my_colorRamp_1 <- pal_1(15)

#sve u jednom koraku
my_colorRamp_2 <- colorRampPalette(c("red", "green"))(15)
my_colorRamp_3 <- colorRampPalette(c("red4", "gray"))(15)
my_colorRamp_4 <- colorRampPalette(c("thistle4", "#00A600FF"))(15)
my_colorRamp_5 <- colorRampPalette(c("violetred", "royalblue"))(15)

#vizualizacija pripremljenih paleta
pie(rep(1,15), col= my_colorRamp_1)
pie(rep(1,15), col= my_colorRamp_2)
pie(rep(1,15), col= my_colorRamp_3)
pie(rep(1,15), col= my_colorRamp_4)
pie(rep(1,15), col= my_colorRamp_5)

#' 
#' 
#' Ponekad želimo izraditi vlastitu paletu kako bismo bojom oznaèili faktorske varijable - razine faktora. U tom sluèaju, uporabom funkcije **colorRampPalette()** potrebno je precizirati opcionalni argument *space* -  što je moguænost koja se koristi kada boje ne predstavljaju kvantitativnu skalu.
#' 
#' 
#' 
#' 
#' 
#' Za naprednije opcije u izradi shema boja koje definira korisnik paket *RColorBrewer* nudi još veæi broj moguænosti. Izvorni ColorBrewer osmislili su Cynthia Brewer i Mark Harrower te je bio namijenjen izradi mapa i kartiranju geografski referenciranih podataka, ali je pronašao svoj put i u grafikama tradicionalnih podataka. U biti, ovaj paket pruža prijedloge boja na osnovi kriterija kao što su broj željenih nijansi i tipu podataka - kategorijski, sekvencijalni ili divergentni. Interaktivna verzija može se pronaæi na http://colorbrewer2.org/.
#' 
#' 
#' ### Funkcije za upravljanje paletama {RColorBrewer}
#' 
#' 
#' Slijedi nekoliko korisnih funkcija iz paketa *RColorBrewer*.
#' 
#' ####Funkcija **display.brewer.all()**{RColorBrewer}
#' .
#' 
#' 
#' Paket *RColorBrewer* ima niz veæ izraðenih paleta (kvalitativne, sekvencijske i divergirajuæe) koje možemo vidjeti pozivom funkcije **display.brewer.all()**.
#' 
## ----fig.width=8, fig.height=7,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Ranije pripremljene pelete iz *RColorBrewer* paketa, funkcija **display.brewer.all()**", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,1), mai=c(1,1,1,1))

#prikaz svih paleta koje su raspoložive u paketu
display.brewer.all()

#' 
#' 
#' 
#' 
#' 
#' ####Funkcija **brewer.pal()**{RColorBrewer}  
#' 
#' .
#' 
#' Funkcija omoguæava raspoloživost paleta boja iz ColorBrewera u R-u. Kako biste nauèili više o sintaksi i moguænostima funkcije, unesite **?brewer.pal** u R konzolu.
#' 
#' Na primjer, ako želimo odabrati 15 boja iz palete **blues**, potrebno je napraviti sljedeæe:
#' 
#' 
## ----fig.width=10, fig.height=3,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Izraðivanje paleta s *RColorBrewer* paketom **brewer.pal()** ", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,5), mar=c(0,0,0.0,0))

# odabir 7 boja iz pripremljenih paleta - RColroBrewer paket
my_brewer_1 <- brewer.pal(7,"Blues") 
my_brewer_2 <- brewer.pal(7,"BuPu")
my_brewer_3 <- brewer.pal(7,"Reds")
my_brewer_4 <- brewer.pal(7,"Set3")
my_brewer_5 <- brewer.pal(7,"Spectral")

#vizualiziranje pripremljenih paleta
pie(rep(1,7), col= my_brewer_1)
pie(rep(1,7), col= my_brewer_2)
pie(rep(1,7), col= my_brewer_3)
pie(rep(1,7), col= my_brewer_4)
pie(rep(1,7), col= my_brewer_5)

#' 
#' 
#' 
#' Moguæe je kombinirati palete prema svojim potrebama, što se vidi iz primjera koji slijedi:
#' 
## ----fig.width=10, fig.height=3,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Izraðivanje palete kombinacijom dvaje palete paketa *RColorBrewer*", cache=F----
par(mfrow=c(1,1), mar=c(0,0,0.0,0))
two_palettes <- c(brewer.pal(8, "Set3"), brewer.pal(8, "Accent"))
pie(rep(1,16), col= two_palettes)

#' 
#' 
#' Upravljenje bojama i paletama u sustavu R neogranièeno je. Korisnik tako može kombinirati veæ postojeæe palete unutar sustava ili èak unijeti standardne palete nekoga specifiènog paketa kao što su, primjerice, palete specijaliziranoga programa otvorenoga kôda za vizualizaciju i analitiku geografski referenciranih podataka SAGA GIS (http://www.saga-gis.org/en/index.html) putem *RSAGA* paketa koji ga veže na sustav R. U primjeru koji slijedi pripremljena paleta boja je kombinacija dvije palete paketa *RColorBrewer*. 
#' 
#' 
#' 
## ----fig.width=10, fig.height=4,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Izraðivanje korisnièke palete kombinacijom funkcija paketa **graphics** i **RColorBrewer** primijenjeno na matrici *volcano*; Maunga Whau vulkan; a) paleta i b) reverzna shema boja - Blues", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,2), mar=c(2,2,0.5,1))

#radimo paletu od 20 plavih boja na osnovi pripremljene "BuPu" palete koja sadrži samo 9 plavih 
my_colors <-colorRampPalette(brewer.pal(5,"Blues"))(20)

#vizualiziranje matrice sa željenim paletama
image(volcano, col= my_colors)
image(volcano, col= rev(my_colors))

#' 
#' 
## ----fig.width=10, fig.height=4,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Izraðivanje korisnièke palete kombinacijom funkcija paketa **graphics** i **RColorBrewer** primijenjeno na matrici *volcano*; Maunga Whau vulkan; a) paleta i b) reverzna shema boja - Greens", cache=F----
#postavljenje grafièkih parametara
par(mfrow=c(1,2), mar=c(2,2,0.5,1))

#radimo paletu od 20 plavih boja na osnovu pripremljene "Greens" palete 
my_colors <-colorRampPalette(brewer.pal(5,"Greens"))(20)

#vizualiziranje matrice sa željenim paletama
image(volcano, col= my_colors)
image(volcano, col= rev(my_colors))

#' 
#' \newpage
#' 
#' # R grafika 
#' 
#' 
#' Najznaèajnija karakteristika postavke R grafike jest postojanje tri izdvojena sustava. Tako postoji tradicionalni sustav grafike (u daljem tekstu se na njega ponekad referira kao na osnovnu grafiku, *base* grafiku); *grid* grafièki sustav (http://www.e-reading.club/bookreader.php/137370/C486x_APPb.pdf) (u daljem tekstu se na njega ponekad referira kao na *lattice* grafiku) i *ggplot* sustav. 
#' 
#' Grid grafika je jedinstvena za R i znatno je jaèa od tradicionalnog sustava. Veæina funkcija koja producira potpune dijagrame korištenjem *grid* sustava dolazi iz *lattice* paketa Deepayan Sarkara, koji primjenjuje grafièki sustav Billa Clevelanda, *trellis*. Tradicionalni grafièki sustav  primjenjuje mnoge tradicionalne grafièke moguænosti S jezika (https://en.wikipedia.org/wiki/S_%28programming_language%29). Za dodatno i sofisticiranije izraðivanje kompleksnih grafièkih prikaza, pogledati u knjizi **R graphics** (Murrel 2006) kao i u dokumentaciji novorazvijenih funkcija vizualizacije iz razlièitih kontribuiranih paketa.
#'  
#'  
#' 
#' Funkcije u sustavima grafike i grafièkim paketima mogu se podijeliti na tri glavna tipa:
#' 
#' 1) funkcije visoke razine (engl. *high-level*) koje rezultiraju (ili inicijaliziraju) potpune dijagrame; neki primjeri su: **plot**, **hist**, **boxplot**, ili **pairs**
#' 
#' 
#' 2) funkcije niske razine (engl. *low-level*)  koje daju dodatni ishod postojeæim dijagramima koji su kreirani pomoæu funkcija visoke razine; neki primjeri: **points**, **lines**, **text**, **axis**, **title**, **legend**, **abline**
#' 
#' 3) funkcije za  *interaktivan* rad s grafièkim ureðajem.
#' 
#' Parovi funkcije visoke razine/*high-level* funkcije te funkcije niske razine/*low-level* funkcije bit æe jednakopravno korištene u daljnjem tekstu. Slièno vrijedi i za niz engleskih pojmova.
#' 
#' 
#' 
#' Jedna od najveæih prednosti jezika R je, svakako, moguænost osnovne grafike. Tradicionalni sustav ili *base* sustav, temelji se na *graphics* paketu. Paketi temeljeni na paketu *graphics* pružaju spektar grafièkih funkcija visoke razine, èiji se rezultat može naknadno doraðivati *low-level* funkcijama. Najznaèajniji izuzetak je paket *lattice* koji pruža potpune dijagrame temeljem *grid* sustava. Postoje odreðene ogranièene moguænosti kombiniranja dva sustava korištenjem paketa **gridBase**, ali je to izvan djelokruga ovoga teèaja.
#' Veoma je važno napomenuti da i nakon izrade novog dijagrama pomoæu funkcije crtanja visoke razine (engl. *high-level*), možete ga dopuniti pozivanjem funkcija crtanja niske razine. Meðutim, ovo se ne može napraviti nakon pozivanja Trellis funkcije paketa *lattice*.
#' 
#' 
#' 
#' R sustav grafike može se razložiti na èetiri izdvojene cjeline: grafièki paketi, grafièki sustavi, pokretaè grafike, ukljuèujuæi standardne grafièke ureðaje; i paketi grafièkih ureðaja, što je prikazano na slici koja slijedi:
#' 
#'  
## ----fig.width=6, fig.height=6,echo=F,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Organizacija R grafike. Izvor: http://www.e-reading.club/bookreader.php/137370/C486x_APPb.pdf", cache=F----
library(png)
library(grid)
img <- readPNG("grafika_1.png")
grid.raster(img)

#' 
#' 
#' Kljuèna funkcionalnost R grafike, a  koja je opisana u ovom priruèniku, pruža se putem pokretaèa grafike i dva sustava grafike, tradicionalne grafike i grida. Grafièki pokretaè sastoji se od funkcija iz **grDevices** paketa i pruža temeljnu podršku u rukovanju stvarima poput boja i fontova a grafièki ureðaji proizvode izlazni rezultat u razlièitim formatima grafike. Tradicionalni grafièki sustav (**base**) sastoji se od funkcija iz **graphics** paketa (https://stat.ethz.ch/R-manual/R-devel/library/graphics/html/00Index.html) a sustav grid grafike sastoji se od funkcija iz  **grid** paketa (https://stat.ethz.ch/R-manual/R-devel/library/grid/html/00Index.html).
#' 
#' 
#' \newpage
#' 
#' ## Izlazni grafièki formati (grafièki ureðaji - engl. *graphical devices*)
#' 
#' Uobièajen naèi rada s grafièkim sustavima i vizualizacijom opæenito je korištenje R sustava interaktivno - crtanje rezultata na zaslon. Vizualizacija podataka i meðurezultata dogaða se u kontinuitetu. Uglavnom, tek konaèni rezultat vizualizacije ili analize imamo potrebu izvesti kao grafiku visoke rezolucije na željeni medij (grafièki ureðaj, engl. *graphical devices*). Ponekad imamo potrebu izraditi dokument koji sadrži graf ili seriju statièkih grafova u željenim položajima. Takoðer, veoma èesto smo limitirani pravilima publikacije u kojem formatu i rezoluciji primaju grafike. Neki grafièki formati (ureðaji) više ili manje su standardni i prihvaæaju ih sve publikacije, kao što su PDF ili WMF, iz razloga što omoguæavaju skalabilne slike. Formati poput bitmapa (BMP) trebaju se koristiti samo ako nema alternative.
#' 
#' 
#' Važno je napomenuti da svaki grafièki ureðaj ima svoj vlastiti skup grafièkih parametara koje možemo odrediti prema svojim potrebama. Ako nemamo aktivnih (otvorenih) grafièkih ureðaja treba otvoriti isti prije postavljanja željenih grafièkih postavki. Koji je *default* grafièki ureðaj možemo pitati naredbom **options("device")**.
#' 
#' U drugom dijelu teèaja upoznat æemo se s kontribuiranim R paketom *lattice* koji pruža funkcije *Trellis* grafike. Kada se koristi *lattice* važno je navesti ureðaj za koji postavljamo postavke korištenjem funkcije **trellis.device()** prije izdavanja grafièkih naredbi. Detaljnjije o ovoj temi kasnije.
#' 
#' Unutar sustava R postoje funkcije koje omoguæavaju rad s višestrukim grafièkim ureðajima kao što su funkcija završetak postojeæega i propagacijua na novi ureðaj ili graf **plot.new()** ili **frame()**. Neki integrirani razvojni sustavi za razvoj (engl. IDE), kao što je RStudio, ne dopuštaju postojanje više od jednog grafièkog prozora u istom trenutku. Iz tog razloga funkcije poput **windows()** (otvaranje novoga grafièkog prozora), **dev.set()** (definiranje aktivnoga grafièkog prozora) ili **graphics.off()** (zatvaranje svih otvorenih grafièkih ureðaja) ne mogu se koristiti no ove funkcije je dobro imati na umu ako netko radi izravno u R-u ili nekom drugom IDE-u kao što je Tinn-R ili slièni.
#' 
#' Kako bi se dobile informacije o zadanim grafièkim ureðajima, kada se radi u RStudiju, u R konzolu unesite sljedeæe:
#' 
#' 
## ----echo=T,encoding = "ISO8859_2", comment=NA, warning=FALSE,message=F, cache=F----
options("device")

#' 
#' 
#' Što ste dobili kao rezultat prethodne funkcije **options("device")**? Kako se zove grafièki ureðaj RStudija?
#' 
#' 
#' Da bismo spremili rezultate vizualizacije napravljene u R-u, u neki od željenih grafièkih formata poput JPG, PNG, TIFF, PostScript, PDF ili nekog drugog s definiranim dimenzijama i rezolucijom, trebamo napraviti tri koraka:
#' 
#' 
#' 1) otvaranje grafièkoga ureðaja (npr. TIFF ili JPG)
#' 
#'  **jpeg('my_plot.jpg')**
#' 
#' 2) naš opcionalni graf na ureðaju
#' 
#'  **plot()**
#' 
#' 3) zatvaranje ureðaja.
#'      
#' **dev.off()**
#' 
#' 
#' Jedan jednostavan primjer izvoza visokorezolutne grafike iz R-a u PNG datoteku s preciziranim dimenzijama i rezolucijom:
#' 
#' 
## ----echo=T,encoding = "ISO8859_2", comment=NA, warning=FALSE,message=F, cache=F----
#otvorite ureðaj s opcijama
png(filename = "iris_dataset.png", width=15, height=15, units="cm", res=300) #open the device

#postavljanje grafièkih parametara za otvoreni ureðaj
par(mfrow=c(2,2)) 

#definiranje željene palete koja æe se koristiti u grafu
palette(c("lightblue", "#4682B4", "#00008B", "darkgreen"))

#prvi graf (opcionalni graf)
hist(iris$Sepal.Length, col="lightblue", main="Histogram Sepal.Length")  
rug(iris$Sepal.Length)

#drugi grafikon, dva histograma na jednom prikazu
hist(iris$Sepal.Width, col="lightblue", main="Histogram Sepal.Width /Sepal.Length")

hist(iris$Sepal.Length, col="lightgray", add=T)


#treæi graf
plot(iris$Sepal.Width,iris$Sepal.Length, col=iris$Species)

#èetvrti graf
hist(iris$Petal.Width, col="lightblue")
rug(iris$Petal.Width)

#zatvaranje ureðaja
dev.off() 

#' 
#' Svaki ureðaj ima svoj vlastiti skup grafièkih parametara. Ako je postojeæi ureðaj nulti ureðaj, funkcija **par()** æe otvoriti novi ureðaj prije upita za ispitivanje/postavljanje parametara. 
#' 
## ----echo=F,encoding = "ISO8859_2", warning=FALSE,message=F, cache=F-----
options(device="png")

#' 
#' 
#' Korisnik može kontrolirati format zadanog ureðaja korištenjem funkcije **options()**. Neki grafièki ureðaji, npr. PDF, dopuštaju višestruke stranice kao izlazni rezultat, dok drugi to ne omoguæavaju (PNG, JPG itd.).
#' 
#' 
#' 
#' \newpage
#' 
#' # Glavni grafièki sustavi u R-u
#' 
#' Grafika je uvijek bila jedna od najbolje razvijenih segmenata sustava R. Njegova grafika pruža neovisnost ureðaja, funkcije crtanja visoke razine (engl. *high-level*) koje produciraju cijeli prikaz. Dodatno, sustav sadržava i funkcije niske razine koje dopunjavaju postojeæi prikaz kao skup grafièkih parametara koji pružaju širok spektar kontrole nad detaljima crtanja.
#' 
#' ## Osnovna grafika (engl. *base*)
#' 
#' Osnovnu R grafiku karkterizira to što:
#' 
#'  * slijedi proces ljudskoga razmišljanja
#'  
#'  * daje odliène rezultate koji su potrebni kako bi se upravljalo svakim detaljem
#'  
#'  * **par()** je korisna funkcija za ispitivanje, postavljanje i uèenje o svim vrstama grafièkih parametara
#'  
#'  * tipièni tijek rada može se opisati kao: izraðivanje "praznog" ili "NULL" grafa koji samo postavlja koordinatni sustav. U sljedeæim koracima korisnik postepeno dodaje željene grafièke elemene kao što su podaci, naslov, legenda, osi i mnoge druge.
#' 
#' 
#' Sustav osnovne R grafike temelji se na konceptu crtanja podruèja okruženih marginama. Na korisniku je da, ako želi, stvori i višestruke grafove, svaki sa svojim marginama, a sve njih, kao cjelinu, definira vanjskom marginom. Kasnije æemo vidjeti i upoznati se sa znatno drugaèijim konceptom *viewport* u *lattice* grafici.
#' 
#' 
#' 
#' ### Paket *graphics*
#' 
#' Ovaj paket sadrži funkcije *base* grafike. Kako smo veæ i naveli, *base* grafika je tradicionalna S grafika i najstariji je grafièki sustav unutar R-a. U ovom æemo se dijelu upoznati sa skupom najvažnijih/najèešæih funkcija paketa. Za sve ostale moguænosti potrebno je posjetiti web stranicu paketa na CRAN-u (https://stat.ethz.ch/R-manual/R-devel/library/graphics/html/00Index.html).
#' 
#' Kao i obièno, informacije o paketu mogu se dobiti korištenjem kratice za R dokumentaciju; funkcija **Question()**{utils} paketa. Unosom **?graphics** u R konzolu dobit æemo informacije o odgovarajuæem kôdu kojim se može dobiti potpuni popis funkcija paketa s njihovim opisima **library(help = "graphics")**.
#' 
#' Za citiranje paketa, koristite funkciju **citation()**{utils} paketa na sljedeæi naèin: 
#' 
#' 
#' 
## ----echo=T,encoding = "ISO8859_2", comment=NA, warning=FALSE,message=F, cache=T----
citation("graphics")

#' 
#' 
#' R osnovna grafika pruža uobièajeni spektar standardnih statistièkih dijagrama, ukljuèujuæi dijagrame raspršivanja, box dijagrame, histograme, bar dijagrame, pita dijagrame i osnovne 3D dijagrame. U R-u se ovi osnovni tipovi dijagrama mogu proizvesti jednim pozivanjem funkcije, ali se dijagrami koji tako nastanu mogu smatrati polaznom osnovom za složenije prikaze. Moguænost dodavanja nekoliko grafièkih elemenata zajedno, kako bi se kreirao konaèni rezultat, predstavlja temeljnu karakteristiku R grafike.
#' 
#' 
#' 
#' #### Funkcija **par()**{graphics}
#' 
#' 
#' Ovo je jedna od najznaèajnijih funkcija iz paketa **graphics**. S tom funkcijom moguæe je postaviti ili propitati grafièke parametre koji se mogu promijeniti/definirati funkcijom **par()** ili **?par**. Prvih 10 parametara navedeni su ispod:
#' 
## ---- echo=T , message=F, comment=NA,tab.caption="Prvih deset simbola pch", cache=F----
par()[1:10]

#' 
#' Da bi se imena svih parametara koji postoje vidjela poredana po abecedi, unesite:
#' 
## ---- echo=T , message=F, comment=NA,tab.caption="Abecedno poredana imena grafièkih parametara u sustavu R", cache=F----
sort(names(par()))

#' 
#' 
#' Kako je veæ spomenuto, svaki ureðaj ima svoj skup grafièkih parametara. Ako je trenutaèni ureðaj nulti (engl. *null*), par æe onda otvoriti novi ureðaj prije propitivanja/postavljanja parametara (koji ureðaj je kontroliran preko funkcije **options("device")**).
#' 
#' 
#' **Neki znaèajni grafièki parametri**
#' 
#' 
#' #####Grafièki parametri koji kontroliraju velièinu teksta i simbola
#' .
#' 
#' Neki od najznaèajnijih grafièkih parametara za rad s tekstom (engl. *string*) su:
#' 
#' - **cex** -  broj koji ukazuje na velièinu po kojoj æe se tekst i simboli skalirati prilikom crtanja u odnosu na njihove zadane vrijednosti. 1= predodreðena vrijednost (engl. *default*), 1.5 je 50% veæa, 0.5 is 50% manja, itd. Na isti naèin može se kontrolirati i druga vrsta teksta koji se pojavljuje na dijagramu, poput poveæavanja naslova/podnaslova, tekstova na osi i sl. Funkcije koje nam omoguæavaju da kontroliramo odreðeni dio teksta imaju intuitivne nazive:
#' 
#' - **cex.axis**  - poveæavanje oznaka osi u odnosu na cex
#' 
#' - **cex.lab**   -  poveæavanje x i y naziva u donosu na cex
#' 
#' - **cex.main**  - poveæavanje naslova u odnosu na cex
#' 
#' - **cex.sub**  -	poveæavanje podnaslova u odnosu na cex.
#' 
#' 
#' 
#' 
#' Kako bi se dobile informacije o zadanoj vrijednosti specifiènog grafièkog parametra, u ovom sluèaju **cex** parametra, u R konzolu se treba unjeti sljedeæe:
#' 
#' 
## ---- echo=T , message=F, comment=NA,tab.caption="", cache=F-------------
par("cex")

#' 
#' U primjeru koji slijedi pokazat æemo uporabu parametra **cex**.
#' 
#' Ako pogledamo sliku ispod, molim da odgovorite koje su vrijednosti **cex** parametra na grafovima koji slijede:
#' 
#' 
## ----fig.width=5, fig.height=4,echo=FALSE,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Grafièki parametar - primjer korištenja za velièinu simbola **cex** parametar", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,3))

#prvi graf
plot(prices, main="Cex 1, default")

#drugi graf
plot(prices, cex=.6, main="Cex 0.6")

#treæi graf
plot(prices,  cex=3, main="Cex 3")

#' 
#' Slièno tako, ako želimo manipulirati velièinom drugih elemenata grafa, poput velièine podnaslova, funkcija/parametar **cex.sub()** se treba promijeniti. Pogledajte primjer ispod i komentirajte rezultat.
#' 
## ----fig.width=5, fig.height=4,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Grafièki parametar - velièina ispisa podnaslova **cex.sub**", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,3))

#prvi graf
plot(prices, sub="Podnaslov; default")

#drugi graf
plot(prices, sub="Podnaslov; 0.6", cex.sub=.6)

#treæi graf
plot(prices, sub="Podnaslov; 2",cex.sub=2)

#' 
#' \newpage
#' 
#' #####Grafièki parametri koji kontroliraju simbole za toèke na grafu (*pch*)
#' 
#' .
#' 
#' Svako se opažanje u skupu podataka može prikazati kao jedna toèka u koordinatnom sustavu. Ako nacrtamo sva opažanja kao jedinstven skup toèaka, koristit æe se jedna vrsta simbola na grafu, ona koja je zadana.
#' 
#' Kako bi se dobili podaci o zadanoj vrijednosti specifiènoga grafièkog parametra, u ovom sluèaju **pch** parametra, u R konzolu treba unijeti sljedeæe:
#' 
#' 
## ---- echo=T , message=F, comment=NA,tab.caption="Tablica", cache=F------
par("pch")

#' 
#' 
#' 
#' Ako si sami želimo prikazati koji su to najpopularniji simboli, možemo upisati sljedeæe linije kôda:
#' 
## ---- echo=T , message=F, comment=NA,tab.caption="Tablica", cache=F------
number_pch <- 20
x <- rep(1,number_pch)

#' 
## ----fig.width=5, fig.height=2,encoding = "ISO8859_2", warning=FALSE,message=F,echo=F ,include=TRUE,fig.cap="Grafièki parametar - tip toèke; prvih 20 **pch** parametar", cache=F----

#postavljanje grafièkih parametara
par(mar=c(0,0,0,0))

#crtanje pch simbola, axex supressed
plot(x, pch = 1:number_pch, axes = F,cex=1.8, ylim=c(0.75, 1.1), xlab = "", ylab = "")
text (1:number_pch ,0.95, labels = 1:number_pch, pos=1)

#' 
#' 
#' Slika koja slijedi prikazuje skupinu najpopularnijih simbola koji se koriste za prikaz opažanja na grafovima, ali su omoguæene i dodatne moguænosti. Sa slike koja slijedi vidimo da parametar **pch** = 1 znaèi prazan kružiæ.
#' 
#'  ![Grafièki parametar - tip toèke; **pch** parametar. Izvor: http://www.statmethods.net/advgraphs/parameters.html](grafika_2.png )
#'  
#'  
#' Odgovorite koje su vrijednosti **pch** parametra na grafovima koji slijede:
#' 
#' 
## ----fig.width=5, fig.height=4,echo=FALSE,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Grafièki parametar - tip toèke; **pch** parametar", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,3))

#prvi graf
plot(prices, pch="%")

#drugi graf
plot(prices, pch=8)

#treæi graf
plot(prices, pch=19)

#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' \newpage
#' 
#' #####Grafièki parametri koji kontroliraju boju elemenata grafa (*col*)
#' .
#' 
#' 
#' U primjeru koji slijedi promijenit æemo boju toèaka na dijagramu dok æe **pch** parametar ostati konstanta:
#' 
#' 
## ----fig.width=5, fig.height=4,echo=FALSE,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Grafièki parametar - boje elementa grafa, **col** parametar", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,3))

#prvi graf
plot(prices, pch=8)

#drugi graf
plot(prices, pch=8, col=3)

#treæi graf
plot(prices, pch=8, col="royalblue")

#' 
#' 
#' 
#' Pogledajmo prvih 6 elemenata u skupu podataka *iris* koji dolazi sa sustavom R te strukturu skupa podataka.
#' 
#' 
## ---- echo=T , message=F, comment=NA,tab.caption="", cache=F-------------
#prvih nekoliko podataka
head(iris)

#struktura podataka
str(iris)

#' 
#' Obratite pozornost na to da je jedna od varijabli u skupu podataka faktorska varijabla koja sadrži informacije o vrstama biljaka. Ostale èetiri varijable su kvantitativne varijable i opisuju odreðene morfološke karakteristike; mjere listiæa i latica biljke. Pored informacija o kvantitativnim varijablama s grafa, željeli bismo dati dodatne informacije o vrsti biljke (kategorija faktora) kojoj svaka toèka na grafu pripada. Najjednostvniji naèin da to napravimo je da svakom opažanju iz razlièite kategorije faktorske varijable dodijelimo drugaèiji simbol toèke ili boju. U ovom primjeru æemo dodijeliti razlièitu boju za svaku razinu faktora varijable *Species*. Kvantitativne varijable od interesa su *Petal.Length* i *Petal.Width*. Želimo obojati nivoe faktora *Species* drugom bojom.
#' 
#' I dalje koristimo generièku funkciju plot, dajuæi dva kvantitativna argumenta, i tada je graf koji se dobije kao rezultat dijagram raspršivanja. Pored toga, zadat æemo odreðeni vektor boja za svaki nivo faktorske varijable. U prvom sluèaju, za nivoe faktora æe biti æe korištene predodreðene boje *default* palette dok æemo u drugom sluèaju æemo za svaki nivo faktora sami odrediti boju kojom æe biti prikazani nivoi.
#' 
#' Dijagram raspršivanja je graf dvije kvantitativne varijable u jednom koordinatnom sustavu, ravnini. Ovo je svakako jedan od najznaèajnijih grafièkih naèina prikaza veze dviju kvantitativnih varijabli. 
#' 
#' 
#' 
#' 
## ----fig.width=7, fig.height=5,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Bojanje prema nivou faktora jedne varijable u skupu podataka; default boje palete i b) zadane boje", cache=F----
#postavljanje grafièkih parametara
palette("default")
par(mfrow=c(1,2))

#prvi graf
plot(iris$Petal.Length, 
     iris$Petal.Width, 
     pch=8, 
     col=iris$Species)

#izraðivanje boja
iris_colors <- c("gray","royalblue", "lightblue")

#drugi graf
plot(iris$Petal.Length, 
     iris$Petal.Width, 
     pch=8, 
     col= iris_colors[iris$Species])

#' 
#' 
#' 
#' \newpage
#' 
#' 
#' #####Grafièki parametri koji kontroliraju vrste linija (*lty*)
#' .
#' 
#' Postoji šest unaprijed definiranih vrsta linija u sustavu R. Ipak, postoji i moguænost da se definiraju i odreðene, prilagoðene linije. Vrsta linije može se precizirati kao unaprijed definirani cijeli broj  ili kao unaprijed definirano ime u obliku teksta (engl. string), ili kao heksadecimalni znakova koji preciziraju neku vrstu prilagoðene linije: primjeri vrsta linija mogu se vidjeti kao grafièki parametri funkcije **abline** (funkcija **abline** æe biti objašnjena kasnije: može se proizvoljno dodati prava linija postojeæem dijagramu. Linije se mogu definirati kao precizirane horizontalne/vertikalne linije ili linije odreðene argumentima nagiba i konstante). U primjeru koji slijedi crtamo horizontalne linije èiji je položaj definiran argumentom h.
#' 
#' 
#' 
## ----fig.width=6, fig.height=3,echo=F,encoding = "ISO8859_2", warning=FALSE,message=F,include=T,fig.cap="Unaprijed odreðeni tipovi linija u sustavu R", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,1), mar=c(1,5,2,1))

#stvaramo podatke
x <- 1:7
y <- 1:7

#crtamo
plot(x, y,
     xlim=c(1, 5), 
     ylim=c(-1,7), 
     type="n",
     axes=F, 
     xlab=NULL, 
     ylab=NULL)

#unaprijed zadane vrste linija u R-u
abline(h=0, lty=0) #blank
abline(h=1, lty=1) #solid
abline(h=2, lty=2) #dashed
abline(h=3, lty=3) #dotted
abline(h=4, lty=4) #dotdash
abline(h=5, lty=5) #longdash
abline(h=6, lty=6) #twodash
axis(2, 
     #labels = T,
     ylab="", #!notice
     labels=c("1", "2", "3", "4", "5", "6"), 
     at=c(1:6), 
     tick = TRUE, 
     las=1)

#' 
#' 
## ----fig.width=6, fig.height=3,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=T,fig.cap="Korisnièki tipovi linija", cache=F, fig.keep='last'----
#postavljanje grafièkih parametara
par(mfrow=c(1,1), mar=c(1,4,0.5,1))

#priprema podataka za crtanje
x <- 1:7
y <- 1:7

#prvi graf
plot(x, y,
     xlim=c(1, 5), 
     ylim=c(0,5), 
     type="n",
     axes=F, 
     xlab=NULL, 
     ylab=NULL)

#dodavanje linija
abline(h=1, lty="13")
abline(h=2, lty="F8")
abline(h=3, lty="431313")
abline(h=4, lty="22848222")

#definiranje osi
axis(2, 
     at=c(1:4),
     ylab=NULL, 
     labels=c("13", "F8", "431313", "22848222"), 
     cex.lab=0.4,
     tick = TRUE,
     las=1)

#' 
#' 
#' Pogledajte primjer i prokomentirajte rezultat:
#' 
#' 
## ----fig.width=7, fig.height=3,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Dodavanje elemenata na postojeæi graf - linije; parametar **lty** i **col** variraju", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,3))

#priprema podataka
x <- seq(0,pi,0.1)
y1 <- cos(x)
y2 <- sin(x)

#prvi graf
plot(c(0,3), c(0,1.3), type="n", xlab="x", ylab="y")

#dodavanje linija postojeæem dijagramu
lines(x, 
      y1, 
      col="red4",
      lwd=2)

lines(x, 
      y2, 
      col="darkseagreen",
      lty=4,
      lwd=2)

#drugi graf
plot(c(0,3), c(0,1.3),  type="n", xlab="x", ylab="y")

#dodavanje linija postojeæem dijagramu
lines(x, 
      y1,
      col="#00A600FF",
      lwd=2)

lines(x, 
      y2, 
      col="darkblue", 
      lwd=2)

#treæi graf
plot(c(0,3), c(0,1.3), type="n", xlab="x", ylab="y")

#dodavanje linija postojeæem dijagramu
lines(x, 
      y1,  
      lty=3,
      lwd=2)

lines(x, 
      y2, 
      lty=4,
      lwd=2)

#' 
#' \newpage
#' 
#' #####Grafièki parametri koji kontroliraju širinu linije (*lwd*)
#' 
#' Postoji jednostavan naèin kontroliranja širine (debljine) linije u sustavu. Komentirajte kôd koji slijedi:
#' 
## ----fig.width=7, fig.height=3,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Grafièki parametri - debljina linije **lwd** parametar", cache=F----
par(mfrow=c(1,1), mar=c(1,4,0.5,1))
x <- 1:7
y <- 1:7
plot(x, y,
     xlim=c(1, 5), 
     ylim=c(0,5), 
     type="n",
     axes=F, 
     xlab=NULL, 
     ylab=c())

abline(h=1, lwd=1)
abline(h=2, lwd=2)
abline(h=3, lwd=3)
abline(h=4, lwd=4)

#' 
#' 
#' \newpage
#' 
#' #####Grafièki parametri koji kontroliraju regiju crtanja  (*mfcol/mfrow*); *layout()* i *split.screen()* 
#' 
#' .
#' 
#' Vrlo korisna moguænost R sustava je moguænost definiranja vlastitoga podruèja crtanja. U primjeru koji slijedi podijelit æemo prostor za crtanje na èetiri podruèja, 1) dva retka i dva stupca i 2) jedan redak s èetiri stupca.
#' 
## ----fig.width=7, fig.height=7,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Podjela podruèja za crtanje; dva retka, dva stupca (mfrow=c(2, 2))", cache=F----

# postavljanje grafièkih parametara 
par(mfrow=c(2,2)) 

#definiranje boja za dijagram
palette(c("lightblue", "#4682B4", "#00008B", "darkgreen"))

#prvi graf (funkcija visoke razine)
hist(iris$Sepal.Length, col="lightblue", main="Histogram Sepal.Length")   

#unaprijeðenje prvog dijagrama (niska razina)
#dodavanje vrijednosti x osi
rug(iris$Sepal.Length) 

#drugi graf
hist(iris$Sepal.Width, 
     col="lightblue", main="Histogram Sepal.Width")

rug(iris$Sepal.Width)

#treæi graf
plot(iris$Sepal.Width,iris$Sepal.Length, 
     col=iris$Species, main="Dijagram raspršenja (engl. *scatterplot*)")

#èetvrti dijagram
hist(iris$Petal.Width, col="lightblue")
rug(iris$Petal.Width)

#' 
#' 
## ----fig.width=7, fig.height=4,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Podjela podruèja za crtanje; jedan redak s 4 grafa (mfrow=c(1, 4))", cache=F----

# postavljanje grafièkih parametara za otvoreni ureðaj (jedan red s èetiri stupca)
par(mfrow=c(1,4)) 

#definiranje boja za dijagram
palette(c("lightblue", "#4682B4", "#00008B", "darkgreen"))

#prvi graf (funkcija visoke razine)
hist(iris$Sepal.Length, col="lightblue", main="Histogram Sepal.Length")   # opcionalni dijagram

#unapreðenja prvog dijagrama (engl. *low-level* funkcijom)
#dodavanje vrijednosti x osi
rug(iris$Sepal.Length) 

#drugi graf
hist(iris$Sepal.Width, col="lightblue", main="Histogram Sepal.Width")

rug(iris$Sepal.Width)

#treæi graf
plot(iris$Sepal.Width,iris$Sepal.Length, col=iris$Species, main="Scatterplot")

#èetvrti dijagram
hist(iris$Petal.Width, col="lightblue")
rug(iris$Petal.Width)

#' 
#' Molimo pogledajte grafove iznad i odgovorite na sljedeæe:
#' 
#' 1) Opišite razliku izmeðu dva prethodna grafa.
#' 
#' 2) Kako su nastali naslovi grafova na slikama?
#' 
#' 3) Sagledavši grafièki prikaz i *iris* skup podataka, èemu služi funkcija **rug** ?
#' 
#' Postoje tri naèina manevriranja predlošcima u osnovnoj grafici:
#' 
#'  1) **par(mfrow)** - najjednostavnija metoda u osnovnoj grafici, koristi se za jednostavne grid predloške gdje je svaki panel iste velièine
#' 
#' 
#'  2) **layout()** - funkcija omoguæava kombiniranje panela 
#' 
#' 
#'  3) **split.screen()** -  omoguæava da se preciziraju koordinate na panelima koje više ne moraju biti jednostavni omjeri panela.
#'  
#' U veæini primjera u ovom teèaju koristili smo najjednostavnije rješenje - **par(mfrow)** postavku. Ovdje predstavljamo korištenje **layout()** (**layout.show()**) funkcija. Ove funkcije uzimaju  matricu i uvrštavaju je u predložak. Oblik matrice odgovara pojedinaènim dijelovima. Brojevi u matrici odgovaraju poretku grafa, a dijelovi s istim brojem predstavljaju jedan panel.
#' 
#' 
#' Kako je objašnjeno, prvo trebamo napraviti matricu koja æe se konvertirati u predložak:
#' 
## ----fig.width=5, fig.height=5,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Podjela podruèja za crtanje; **show.layout()** funkcija", cache=F----
#rbind kombinira dva vketora kao uzastopne redove u matricu
mat_lay <- rbind(c(1, 1), c(2, 3))

#zatražite klasu objekta
class(mat_lay)

#ispis 
mat_lay

#izraðivanje predloška
layout(mat_lay)

#vizualiziranje predloška
layout.show(3)

#'  
#' Sada kad imamo layout, u njega možemo crtati opcionalne grafièke prikaze.
#'  
## ----fig.width=6, fig.height=6,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Podjela podruèja za crtanje; **layout()** funkcija", cache=F----
#stvaranje *layouta*
layout(mat_lay)
par(mar=c(2,2,2,2))

for (i in 1:3) plot(1, 1, type = "n")

#' 
#' 
#' Posljednje rješenje **split.screen()** je izvan opsega ovoga teèaja i dalje se neæe razmatrati.
#' 
#' 
#' 
#' \newpage
#' 
#' 
#' #####Grafièki parametri koji kontroliraju margine grafa  (*mar/mai*) i (*oma/omi*)
#' .
#' 
#' Moguæe je postaviti margine za svaki panel parametrom *mar*/*mai* te vanjske margine parametrom/ima *oma*/*omi*.
#' 
#' Parametar *mar()*, numerièki vektor oblika c(bottom, left, top, right) daje broj linija margine kako bi se precizirale èetiri strane grafa. Zadano je c(5, 4, 4, 2) + 0.1. Opcionalno, margine se mogu postaviti uporabom parametra *mai*; numerièkog vektora oblika c(bottom, left, top, right) koji daje velièinu margina preciziranu u inèima. 
#' Drugi naèin je preciziranjem margina u inèima korištenjem argumenta *mai*, mjereno u centimetrima.
#' 
#' 
#' 
## ----fig.width=10, fig.height=10,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Grafièki parametar, odreðivanje margina u inch; **mai()** parametar", cache=F----
#postavljanje sveukupnih grafièkih parametara
par(mfrow=c(2,2))

#postavljanje parametara za prvi graf
par(mai=c(1,1,1,1))
    
#prvi graf (funkcija visoke razine)
hist(iris$Sepal.Length, 
     col="lightblue", 
     main="par(mai=c(1,1,1,1)")  

#postavljanje grafièkih parametara za drugi graf
par(mai=c(0,0,0,0))
    
#drugi graf
hist(iris$Sepal.Width, 
     col="lightblue", 
     main="par(mai=c(0,0,0,0)")

#postavljanje grafièkih parametara za treæi graf
par(mai=c(0.5,0.5,0.5,0.5))
    
#treæi graf
hist(iris$Sepal.Width, 
     col="lightblue", 
     main="par(mai=c(0.5,0.5,0.5,0.5))")

#postavljanje grafièkih parametara za èetvrti graf
par(mai=c(0.2,0.2,0.2,0.2))
    
#èetvrti graf
hist(iris$Sepal.Width, 
     col="lightblue", 
     main="par(mai=c(0.2,0.2,0.2,0.2))")

#' 
#' 
#' **ZA SAMOSTALNI RAD** 
#' 
#' Napravite sljedeæe: u ovoj kratkoj vježbi, koristite skup podataka *OrchardSprays* iz sustava R. Prvo se upoznajte sa skupom podataka tako što æete pogledati strukturu skupa podataka i prvih nekoliko redova podataka:
#' 
#' 
## ---- echo=T , message=F, comment=NA,tab.caption="", cache=F-------------
#pozivamo podatke iz sustava
data(OrchardSprays)

#pogledamo nekoliko prvih redaka; default, 6 redaka 
head(OrchardSprays)

#pogledajmo strukturu podataka
str(OrchardSprays)

#' 
#' Kreirajte png sliku (moja_prva_graf.png) 20 cm široku, 20 cm visoku, 300 dpi (engl. *dots per inch*) rezolucije na tvrdom disku vašega raèunala, tako što æete slijediti ove upute, naravno, prvo se upoznavši sa sintaksom funkcije **png()**:
#' 
#' 1) podijelite prostor za crtanje na tri segmenta, sva tri neka budu u jednom stupcu 
#' 
#' 2) U prvom segmentu dijagram koji crtate treba biti tipa histogram relativnih frekvencija varijable *decrease* sa zadanim brojem podjela, stupaca u dijagramu (engl. *bin*); histogram treba obojiti nekom bojom i treba se dati odgovarajuæ naslov 
#' 
#' 3) U drugom segmentu dijagram treba biti, takoðer, histogram s relativnim frekvencijama varijable "decrease" sa 50 stupaca u dijagramu; histogram treba obojiti bilo kojom bojom i treba dati odgovarajuæi naslov; dodajte podatke na ovaj histogram (pomoæ: koristite funkciju **rug()**)
#' 
#' 4) U treæem dijelu ovog prikaza treba biti grafièki prikaz adekvatan za kategorièke podatke (pomoæ: bar dijagram) s relativnim frekvencijama varijable *treatment*; stavite odgovarajuæi naslov
#' 
#' 5) Otvorite pripremljenu sliku.
#' 
#' 
#' 
#' #####Grafièki parametri koji kontroliraju automatsko obilježavanje osi (*ann*)
#' .
#' 
#' Ponekad je korisno imati moguænost suzbijanja automatskoga oznaèavanja osi kako bi se napravilo vlastito, u skladu s odreðenim potrebama. Ovo je moguæe definiranjem parametra **ann**, stavljanjem logièke oznake treba li se napraviti automatsko obilježavanje (ann=T, default) ili ne (ann=F). Zadano obilježavanje stavlja nazive vektora (varijabli) koje se crtaju na graf. Pogledajte primjer ispod i komentirajte rezultat kôda.
#' 
#' 
#' 
## ----fig.width=7, fig.height=4,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Grafièki parametar - automatska anotacija grafa; **ann** parametar", cache=F----

#postavljanje grafièkih parametara
par(mfrow=c(1,3))

#priprema podataka
x<- 1:10
y<-11:20

#prvi graf
plot(x,y, 
   type="b",
   axes=TRUE,
   ann=TRUE)

#drugi graf
plot(x,y, 
   type="b",
   axes=T,
   ann=F)

#treæi graf
plot(x,y, 
   type="b",
   xlab="x variable",
   ylab="y variable")

#' 
#' 
#' 
#' \newpage
#' 
#' #####Grafièki parametri koji kontroliraju pozadinu (podlogu) podruèja na kojoj se crta (*usr/bg*)
#' .
#' 
#' Za promjenu boje podloge na grafu dovoljno je postaviti grafièki parametar **bg**. Ali, ako je potrebno promijeniti bilo koji od grafièkih parametara koji su *read-only*, potreban je zaobilazni naèin koji je prikazan u primjeru koji slijedi.
#' 
## ----fig.width=7, fig.height=5,echo=FALSE,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Grafièki parametar - pozadina grafa  **usr**/**bg** parametar", cache=F----
#postavljanje grafièkih parametara 
par(mfrow=c(1,2), bg = "lightgrey")

#prvi graf; dijagram raspršenja dvije numerièke varijable 
plot(iris$Sepal.Length , iris$Petal.Length, type="n")
 
#dodavanje toèaka na postojeæi graf
points(iris$Sepal.Length , iris$Petal.Length)

#dodajemo naslov
title("Podaci iris")

#drugi graf
plot(iris$Sepal.Length , iris$Petal.Length, type="n", ann=F)

#"mijenjanje" read-only grafièkog parametra usr
polygon(c(-min(iris[,1])^2,-min(iris[,1])^2,max(iris[,1])^2,max(iris[,1])^2),c(-min(iris[,2])^2,max(iris[,2])^2,max(iris[,2])^2,-min(iris[,2])^2), col="aliceblue")
 
#crtamo toèke na postojeæem grafu
points(iris$Sepal.Length , iris$Petal.Length, pch=4, cex=0.6)

#dodajemo naslov
title("Podaci iris")

#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' \newpage
#' 
#' 
#' #####Grafièki parametri koji kontroliraju promjenu udaljenosti izmeðu osi te naslova i labela osi (*mgp*)
#' .
#' 
#' Ovo je koristan parametar za kontroliranje udaljenosti izmeðu osi i njihovih naziva i labela. Da se upoznamo s parametrom i njegovim zadanim vrijednostima pogledajmo informacijsku karticu za funkciju **par()**. Linija margine (u mex jedinicama; mex je faktor raširenosti velièine karaktera koji se koristi kako bi se opisale koordinate na marginama grafa) za nazive osi, labele osi i linije osi. Uoèite da mgp[1] utjeèe na naslov dok mgp[2:3] utjeèe na os. Zadane vrijednosti su vektor c(3, 1, 0).
#' 
#' Primijetite da æemo u sljedeæem primjeru (treæi primjer: mgp = c(3, -2, 0)), manipuliranjem parametrom labele osi ispisati unutar podruèja za prikaz podataka. Prvo pripremamo podatke koje æemo kasnije koristiti u crtanju. Ovakave, jednostavne podatke stvaramo radi boljeg primjeæivanja nastalih promjena u dimenzijama grafa:
#' 
#' 
## ---- echo=T, eval=F, warning=F, message=F-------------------------------
## #kreirajte podatke za crtanje
## x <- 1:10
## y <- 11:20
## z <- paste("p", 1:10, sep="_")
## p <- rep(1:2, 5)
## df<- data.frame(x,y,z,p)

#' 
#' 
#' 
## ----fig.width=8, fig.height=5,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Promjena grafièkoga parametra **mgp**; udaljenost izmeðu osi i teksta", cache=F----
#kreirajte podatke za crtanje
x <- 1:10
y <- 11:20 
z <- paste("p", 1:10, sep="_")
p <- rep(1:2, 5)
df<- data.frame(x,y,z,p)

#postavljanje grafièkih parametara
par(mfrow=c(1,3), mgp=c(3,1,0))

#prvi graf
plot(df$x, df$y, type="p", 
     xlab="x label", 
     ylab="y label", 
     main="mgp = c(3, 1, 0)")

#promjena grafièkih parametara
par(mgp=c(3,.1,0))

#drugi graf
plot(df$x, df$y, type="p", 
     xlab="x label", 
     ylab="y label", 
     main="mgp = c(3, 0.1, 0) \nlabele približene osi x")

#promjena grafièkih parametara
par(mgp=c(3,-2,0))

#treæi graf
plot(df$x, df$y, type="p", 
     xlab="x label", 
     ylab="y label", 
     main="mgp = c(3, -2, 0) \nlabele unutar podruèja crtanja ")

#' 
#' 
#' 
#' 
#' \newpage
#' 
#' 
#' 
#' ### Neke grafièke funkcije visoke razine (engl. high-level)
#' 
#' .
#' 
#' Kao što je veæ navedeno, "high-level" grafièke funkcije su one koje inicijaliziraju ili produciraju cjelokupan graf. Kasnije je moguæe, korištenjem funkcija niske razine, "low-level" funkcijama poboljšati napravljeni graf prema našim potrebama i željama. U nastavku teèaja cijelo æemo vrijeme koristiti mješavinu *high-level* i *low-level* funkcija kako bismo došli do željenog rezultata, a time i nauèili kako cijeli proces *base* grafike funkcionira. Kada se pojedina *low-level* funkcija poziva unutar neke *high-level* funkcije tada ju nazivamo parametrom *high-level* funkcije.
#' 
#' 
#' #### Funkcija **plot()**{graphics}(*high-level*)
#' 
#' Generièka funkcija za crtanje objekata u R-u. Više detalja o argumentima grafièkog parametra može se naæi pomoæu funkcije **par()**.
#' 
#' 
#' U primjeru æemo napraviti jednostavan graf, a tekst æemo dodati nakon kreiranja grafa pomoæu funkcije niske razine.
#' 
#' 
#' Kôd koji slijedi daje jednostavan primjer kako napraviti graf pomoæu R-a. Za tu svrhu æe se koristiti skup podataka **prices**. Skup podataka **prices** sadrži dvije numerièke varijable *price* i *size* zamišljenih kuæa.
#' 
## ----fig.width=7, fig.height=5,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Jednostavan graf; a) s predodreðenim vrijednostima; b) **pch** parametar i c) boja mijenjana; skup podataka iz sustava R - prices", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,3))

#struktura podataka
str(prices)

#prvi graf
plot(prices)

#drugi graf
plot(prices,
     pch=17)

#treæi graf
plot(prices, 
     pch=22, 
     col="yellow3")

#' 
#' 
#' 
#' 
#' \newpage
#' 
#' ### Poboljšanje rezultata dobivenoga funkcijama visoke razine funkcijama niske razine 
#' 
#' .
#' 
#' Mnoge funkcije crtanja visoke razine (plot, hist, boxplot,itd.) omoguæavaju da ukljuèite osi i opcije teksta (kao i druge grafièke parametre). Možemo mijenjati graf, pozvati dodatne funkcije niske razine, ili promijeniti grafièke parametre izravno u funkcijama visoke razine, sukladno našim potrebama/preferencijama. U primjeru:
#' 
#' a) popunite prazni graf osima - zadane vrijednosti (engl. default)
#' 
#' b) popunite taj prazni graf osima - precizirano od strane korisnika
#' 
#' c) dodajte razlièite elemente grafa npr. naslov, podnaslov.
#' 
#' 
#' 
#' 
#' 
#' 
#' Postoji mnogo moguænosti kako unaprijediti izgled grafa. U daljnjem tekstu uvodimo samo najznaèajnije funkcije niske razine koje dodaju odreðene elemente na postojeæi graf:
#' 
#' 
#'  * proizvoljne linije / krivulje pomoæu **lines()** / **curves()** 
#' 
#'  * poligoni s **polygon()** 
#' 
#'  * ravne linije s **ablines()** 
#' 
#'  * promjena izgleda osi / osi definirane od strane korisnika **axes()** 
#' 
#'  * legenda pomoæu **legend()**
#' 
#'  * tekst pomoæu **text()** 
#' 
#'  * tekst na preciziranoj margini pomoæu **mtext()**
#' 
#'  * nacrtati okvir oko grafa **box()** {graphics} 
#' 
#'  * naslovi pomoæu **title()** {graphics} funkcije
#' 
#'  * i još mnogo toga!
#' 
#' 
#' 
#' 
#' \newpage
#' 
#' #### Funkcija **lines()**/**curves()** {graphics}(*low-level*)
#' 
#' .
#' 
#' Funkcija **lines()** dodaje povezane segmente linija na graf, a funkcija **curve()** crta krivulju koja odgovara funkciji tijekom nekog zadanog intervala.
#' 
#' 
#' 
#' Ponekad želimo staviti odreðene vrste linija (krivulje) pored pravih linija na postojeæi graf. U ovom primjeru stavit æemo liniju koja je kreirana funkcijom **loweess()** {stats} koja radi izraèun za *lowess smoother* koji koristi lokalno ponderiranu polinomsku regresiju na podacima.
#' 
#' 
## ----fig.width=8, fig.height=6,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=T,fig.cap="Dodavanje linija na postojeæi graf a) funkcija izraèuna *lowess* iz **stats** paketa (Kernel), b) jednostavno povezivanje toèaka linijom", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,2))

#prvi graf
plot(cars, 
     main = "Duljina koèenja u odnosu na brzinu, lowess", 
     cex.main=0.8) 

#eksplicitno traženje funkcije drugog paketa za izraèun koordinata linije
lines(stats::lowess(cars), col="red")

#drugi graf
plot(cars, 
     main = "Duljina koèenja u odnosu na brzinu, spoj toèaka", 
     cex.main=0.8)

# linije kroz toèke
lines(cars, col="blue") 

#' 
#' 
#' 
#' \newpage
#' 
#' 
#' #### Funkcija  **rect()**/**polygon()**{graphics}(*low-level*)
#' 
#' Funkcija **rect()** crta pravokutnik (ili sekvencu pravokutnika) sa zadanim koordinatama. 
#' 
#' Funkcija **polygon** crta poligone èiji su èvorovi prikazani pomoæu x i y. Vrlo korisna funkcija za sjenèanje podruèja ispod krivulja, znaèajno u vizualiziranju tijekom procesa testiranja hipoteza, ali i u mnogim drugim primjenama. Funkcija uzima x i y vektor, definirajuæi skup koordinata koji se uzima kako bi se moglo pratiti podruèje koje æe se sjenèati.
#' 
#' Prije primjene funkcije(a), molimo pogledajte informacijske kartice funkcije:
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=F----------------------------
#pripremite koordinate poligona
x <- c(0, 1, 2, 3, 5, 4, 3, 2, 1,0)
y <- c(4, 2, 2, 1, 3, 0, 0, 1, 1,0)

#pripremite koordinate tri pravokutnika
z<- c(0.5, 1, 1.5, 2)
p<- c(2, 2.5, 3, 3.5)
q<- c(3.5, 4, 4.5, 5)
g<- c(2.5, 3, 3.3, 4)

#' 
#' 
#' 
## ----fig.width=7, fig.height=6,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcije **polygon()**/**rect()**", cache=F----
#postavljamo grafièke parametre
par(mfrow=c(1,2))

#prvi graf
plot(x,y, type="n", pch=22,  main="Prvo poligon, pravokutnici kasnije", ylim=c(-1, 5))

#crtamo poligon sa skupom koordinata
polygon(x,y,col="lightblue")

#crtamo pravokutnike na postojeæem grafu
rect(z, p, q, g,  
     col= c("lightpink3", "darkseagreen4", "lightblue2", "ivory3"))

#imanovanje toèaka
text (x,y ,labels = paste("t", 1:10, sep=""), pos=1)

#drugi graf
plot(x,y, type="n", pch=22,  main="Prvo pravokutnici, poligon kasnije",  ylim=c(-1, 5))

#crtamo pravokutnike na postojeæem grafu
rect(z, p, q, g,  
     col= c("lightpink3", "darkseagreen4", "lightblue2", "ivory3"))

#dodajemo poligon na zadanu koordinatu
polygon(x,y,col="lightblue")

#stavljamo labele
text (x,y ,labels = paste("t", 1:10, sep=""), pos=1)

#' 
#' U primjeru koji slijedi funkciju **polygon()** koristimo kako bismo naznaèili regiju odbacivanja hipoteze:
#' 
## ---- echo=T ,eval=T, message=F, comment=NA, cache=T---------------------
#pretpostavimo da poznajemo pravi populacijske parametare - srednja vrijednost
populacijska_sredina <- 400
populacijska_sd <- 50

#statistika izraèunata na reprezentativnom uzorku
srednja_vrijednost_uzorka <- 418

#parametri procesa testiranja hipoteze o populacijskom parametru
alpha <- 0.05; 

#velièina uzorka
n <- 50

#raspon za z
xmin <- -4; xmax <- 4

#sekvenca za koju crtamo
x <- seq(xmin, xmax, by=0.1)

#statistika izraèunata na uzorku (z statistika, uzorak velièine n)
z <- (srednja_vrijednost_uzorka - populacijska_sredina)/ (populacijska_sd/sqrt(n))

#funkcija d norm - gustoæa 
gustoca_x <- dnorm(x)

#' 
#' 
## ----fig.width=4, fig.height=4,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **polygon()** u procesu testiranje hipoteze; dvosmjerni z test", cache=F----
#crtamo
plot(x, gustoca_x, type="l", xlab="z vrijednosti", 
     ylab="Gustoæa",
     main="",
     axes=T)

#raèunamo kritiène vrijednosti za regiju odbacijavanja hipoteze
krit_lijeva <- -qnorm(1-alpha/2)   
krit_desna <- qnorm(1-alpha/2)   
i <- x >= krit_desna

#regija odbacivanja na desnoj strani
polygon(c(krit_desna, x[i], xmax),
        c(0, gustoca_x[i], 0), 
        col="lightblue")

#regija odbacivanja na lijevoj strani
j <- x <= krit_lijeva               
polygon(c(xmin, x[j], krit_lijeva), 
        c(0, gustoca_x[j], 0), 
        col="lightblue")

#crtamo z na uzorku
abline(v=z, lty=2, col="darkseagreen", lwd=2)

#dodatno oznaèimo kritiène vrijednosti

abline(v=krit_desna, lty=1, col="darkred", lwd=1)
abline(v=krit_lijeva, lty=1, col="darkred", lwd=1)

#' 
#' 
#' \newpage
#' 
#' 
#' #### Funkcija **legend()**{graphics} (*low-level*)
#' .
#' 
#' 
#' Legendu postavljamo na zadanu koordinatu na grafu koristeæi se funkcijom **legend()**. Kako biste otvorili informacijsku karticu funkcije i nauèili više o njoj, unesite **?legend** u R konzolu. 
#' 
#' 
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=F----------------------------
#stvaramo podatke
x <- seq(0,pi,0.1)
y1 <- cos(x)
y2 <- sin(x)

#' 
#' 
## ----fig.width=10, fig.height=3,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Dodavanje elemenata grafa - legenda", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,3))

#funkcija visoke razine koje stvara (inicira) graf, tj. koordinatni sustav
plot(c(0,3), 
     c(0,3), 
     type="n", xlab="x", ylab="y")

#dodavanje linija na postojeæi graf
lines(x, y1, col="red4", lwd=2)
lines(x, y2, col="darkblue", lwd=2)

#dodavanje legende na postojeæi graf
legend("topright",
       inset=.05,
       cex = 1,
       title="Legenda",
       c("kosinus","sinus"),
       horiz=TRUE,
       lty=c(1,1),
       lwd=c(2,2),
       col=c("red4","darkblue"),
       bg="lightgray")

#drugi graf
plot(c(0,3), c(0,3), type="n", xlab="x", ylab="y")

#dodavanje linija
lines(x, y1, col="red4", lwd=2)
lines(x, y2, col="darkblue", lwd=2)

#dodavanje legende
legend("topleft",
       inset=0.4,
       cex = 1,
       title="Legenda",
       c("Kosinus","Sinus"),
       horiz=TRUE,
       lty=c(1,1),
       lwd=c(2,2),
       col=c("red4","darkblue"),
       bg="white")

#treæi graf
plot(c(0,3), c(0,3), type="n", xlab="x", ylab="y")

#dodavanje linija
lines(x, y1, col="red4", lwd=2)
lines(x, y2, col="darkblue", lwd=2)

#dodavanje legende
legend("topright",
       inset=0,
       cex = 0.8,
       title="Drugaèija legenda",
       c("Kosinus","Sinus"),
       horiz=TRUE,
       lty=c(1,1),
       lwd=c(2,2),
       col=c("red4","darkblue"),
       bg="white")

#' 
#' Za interaktivnu specifikaciju položaja legende, koristite funkciju **locator()**. Kako biste nauèili o opcijama funkcije, unesite **?locator** u R konzolu.
#' 
#' 
#' 
#' 
#' 
#' **ZA SAMOSTALNI RAD** 
#' 
#' Korištenjem skupa podataka unutar sustava R *cars* grafièki prikažite podatake na naèin da:
#' 
#' 
#' 1) Podijelite grafièki ureðaj na jedan red s dva stupca;
#' 
#' 2) **Prvi** graf treba izgledati ovako:
#' 
#' 
#' - inicirajte crtanje uporabom generièke funkcije **plot()**, potisnite automatske anotacije
#' 
#' - definirajte proizvoljno x i y osi, neka x os bude oznaèena s "Brzina automobila"; neka y os bude oznaèena "Udaljenost"
#' 
#' - dodajte toèke dijagramu raspršenja
#' 
#' - stavite legendu na graf u gornji lijevi kut (engl. *topleft*)
#' 
#' - stavite naslov ("Prva slika - skup podataka mtcars"), cex za naslov neka bude 0.;
#' 
#' - stavite naslov ("Moj proizvoljni naslov") u plavoj boji; 90% *default* cex parametra.
#' 
#' 
#' 3) **Drugi** graf treba izgledati ovako:
#' 
#' 
#' - nacrtajte podatke sa zadanim osima
#' 
#' - neka x os bude oznaèena sa "Brzina"; neka y os bude oznaèena sa "Udaljenost" kao 90% zadane velièine
#' 
#' - stavite legendu na graf na poziciju u gornjem desnom kutu  (engl. *topright*) 
#' 
#' - stavite naslov grafa ("Prva slika - skup podataka mtcars"), cex za naslov treba biti 0.9
#' 
#' - stavite naslov grafa ("Moj proizvoljni naslov") u sivoj boji; 120% zadanoga cex parametra.
#' 
#' 
#' 
#' 
#' #### Funkcija **axis()**{graphics} (*low-level*)
#' .
#' 
#' Korisnik može napraviti prilagoðene osi korištenjem **axis()** funkcije. Otvorite informacijsku karticu funkcije i nauèite o njoj tako što æete unijeti **?axis** u R konzolu. 
#' 
#' Ima mnogo moguænosti kako unaprijediti izgled osi na dijagramu, npr. promjenom boje x osi, promjenom boje y osi; orijentacijom labela (oznaka) i još mnogo toga.
#' 
#' 
#' Pogledajte kôd koji slijedi i komentirajte!
#' 
#' 
## ----fig.width=8, fig.height=5,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Promjena izgleda  grafièkih osi", cache=F----
#odreðivanje grafièkih parametara
par(mfrow=c(1,3))

#prvi graf
plot(1:10,11:20, 
   type="b",
   axes=F,
   ann=T)

#dodavanje osi
axis(side=4, 
     pos=1, 
     lty=2, 
     col="darkgray", 
     las=1) 

#drugi graf
plot(1:10,11:20, 
   type="b",
   axes=FALSE,
   ann=FALSE)

#dodavanje osi
axis(side=4, 
     pos=1, 
     lty=2, 
     col="darkgray", 
     las=1) 

#treæi graf
plot(1:10,11:20, 
   type="b",
   axes=FALSE,
   ann=FALSE,
   xlim=c(1, 20),
   ylim = c(10,20))

#dodavanje osi
axis(side=1, 
     labels=, 
     pos=2, 
     lty=2, 
     col="red", 
     las=1) 
axis(side=2, 
     labels=, 
     pos=1, 
     lty=2, 
     col="blue", 
     las=2) 

#' 
#' 
#' 
#' 
#' \newpage
#' 
#' 
#' #### Funkcija **abline()**{graphics}(*low-level*)
#' .
#' 
#' Funkcija crta preciziranu liniju s moguænošæu definiranja vertikalne, horizontalne linije ili jednadžbe linije pravca korištenjem funkcije **abline()**. Informacijsku karticu moguæe je otvoriti i nauèiti više o funkciji unosom **?abline** u R konzolu.
#' 
#' 
#' 
## ----fig.width=10, fig.height=3,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Dodavanje elemenata grafa - ravna linija", cache=F, fig.keep='last'----
#postavljanje grafièkih parametara
par(mfrow=c(1,3))

#priprema podataka
x <- seq(0,pi,0.1)
y1 <- cos(x)
y2 <- sin(x)

#prvi graf
plot(c(0,3), c(0,3), type="n", xlab="x", ylab="y")

#dodajte linije postojeæem grafu
lines(x, y1, col="red4", lwd=2)
lines(x, y2, col="darkblue", lwd=2)

#dodavanje ravne linije ne postojeæi graf
abline(a = NULL, 
       b = NULL, 
       h = 1.5, 
       col="lightpink3",
       lwd=3, 
       lty=2) 

#drugi graf
plot(c(0,3), c(0,3), type="n", xlab="x", ylab="y")

#dodajte linije postojeæem grafu
lines(x, y1, col="red4", lwd=2)
lines(x, y2, col="darkseagreen", lwd=2)

#dodavanje ravne linije postojeæem grafu
abline(v = 1, 
       col="darkgray", 
       lty=3,
       lwd=3) 

#treæi grafu
plot(c(0,3), c(0,3), type="n", xlab="x", ylab="y")

#dodavanje ravne linije postojeæem grafu
lines(x, y1, col="darkseagreen", lwd=2)
lines(x, y2, col="darkblue", lwd=2)

#dodavanje pravca postojeæem grafu
abline(a = 1, 
       b = 1,  
       col="plum4", 
       lty=1) 

#' 
#' 
## ----fig.width=10, fig.height=3,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Dodavanje elemenata grafa kroz for petlju - ravna linija", cache=F, fig.keep='all'----
#postavljanje grafièkih paramateara
par(mfrow=c(1,1))

#poèetak generatora sluèajnih brojeva
set.seed(1)

#crtanje nasumiènih toèaka (10 toèaka generiranih iz standardne normalne distribucije)
plot(rnorm(10)) # dijagram visoke razine

##višestruke promjene niske razine u petlji (jedan R izraz)
for(i in 1:10) {
    abline(v = i, lty = 2, lwd=4, col="lightblue")
}

#' 
#' 
#' 
#' 
#' \newpage
#' 
#' #### Funkcija **text()**{graphics} (*low-level*)
#' 
#' Funkcijom stavljamo proizvoljan tekst na preciziranu koordinatu u grafu.  Kako biste otvorili informacijsku karticu funkcije i nauèili o funkciji, unesite **?text** u R konzolu. 
#' 
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=F----------------------------
#priprema podataka 
x <- seq(0,pi,0.1)
y1 <- cos(x)
y2 <- sin(x)

#' 
#' 
## ----fig.width=10, fig.height=3,echo=T,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Dodavanje elemenata grafa - tekst na zadanu koordinate", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,3))
#prvi graf
plot(c(0,3), c(0,3), type="n", xlab="x", ylab="y")

#dodavanje linija postojeæem grafu
lines(x, y1, col="red", lwd=2)
lines(x, y2, col="blue", lwd=2)

#dodati tekst na odreðenoj lokaciji postojeæem grafu
text(1.5,2, "Funkcije sinus i kosinus")

#drugi graf
plot(c(0,3), c(0,3), type="n", xlab="x", ylab="y")

#dodavanje linija postojeæem grafu
lines(x, y1, col="#00A600FF", lwd=2)
lines(x, y2, col="blue", lwd=2)


#dodati tekst na odreðenu lokaciju u postojeæem graf
text(1.5,2.5, "Funkcije sinus i kosinus", cex=0.6, col="orange")


#treæi graf
plot(c(0,3), c(0,3), type="n", xlab="x", ylab="y")

#dodavanje linija postojeæem grafu
lines(x, y1,  lwd=2, lty=3)
lines(x, y2,  lwd=2, lty=4)

#dodati tekst na odreðenu lokaciju u postojeæem graf
text(1.5,1.5, 
     "Funkcije sinus i kosinus", 
     cex=2, 
     col="lightblue")

#' 
#' U primjeru koji slijedi dodat æemo odreðene oznake na svaku toèku grafa. Oznake (labele) moraju biti tipa *character* ili u obliku izraza (ili se moraju moæi prebaciti u takav tip).
#' 
#' 
## ---- echo=T, warning=F, message=F---------------------------------------
#stvaramo podatke za crtanje
x <- 1:10
y <- 11:20 

#radimo labele
p <- rep(1:2, 5)
z <- paste("lab", 1:10, sep="_")

#stavljamo sve u data.frame
df<- data.frame(x,y,z,p)

#' 
#' 
#' 
#' 
## ----fig.width=10, fig.height=4,echo=T,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Dodavanje elemenata grafa - oznaka toèaka uz dodatnu prilagodbu položaja", cache=F----
#set graphical parameters
par(mfrow=c(1,3))

#prvi graf
plot(df$x, df$y, type="p", 
     xlab="x", 
     ylab="y", 
     main="Jednostavan graf - labele 1")

#dodavanje teksat na postojeæi graf
text(x=x, y=y, labels=as.character(z), adj=1)

#drugi graf
plot(df$x, df$y, type="p", 
     xlab="x", 
     ylab="y", 
     main="Jednostavan graf - labele 2")

text(x=x, y=y, labels=as.character(p), adj=1)

#treæi graf
plot(df$x, df$y, type="p", 
     xlab="x", 
     ylab="y", 
     main="Jednostavan graf - labele 1; \ndodatna prilagodba položaja")
#dodavanje teksat na postojeæi graf
text(x=x, y=y, labels=as.character(p), col.lab="blue", adj=2)

#' 
#' 
#' 
#' 
#' ####Funkcija **mtext()** {graphics}
#' .
#' 
#' Ova funkcija smiješta tekst na margine postojeæega dijagrama; oznaèava linije margina. Opcije funkcija se kao i za sve funkcije mogu naæi korištenjem funkcije **question**. Osi su numerirane na svakoj strani dijagrama (1=bottom, 2=left, 3=top, 4=right).
#' 
#' 
## ----fig.width=10, fig.height=5,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Dodavanje elemenata grafa - tekst na željenoj osi", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,2))

#prvi graf
plot(df$x, df$y, type="p", 
     xlab="x", 
     ylab="y", 
     main="Jednostavan graf - tekst na margini")

#dodavanje teksta na osi 3
mtext("Moj tekst za os 3",
      side=3, 
      line=0)

#drugi graf
plot(df$x, df$y, type="p", 
     xlab="x", 
     ylab="y", 
         main="Jednostavan graf - tekst na margini")

#dodavanje teksta na osi 4
mtext("Moj tekst za os 4", 
      side=4, 
      line=1, 
      adj=1, 
      col="red4") 

#' 
#' 
#' 
#' Preciziranje odreðenoga fonta specifièno je za grafièki ureðaj. Font pripada odreðenoj obitelji fontova (npr. Helvetica ili Courier) i predstavlja odreðeno "lice" u okviru te obitelji (npr. *bold* ili *italic*). Moguæe je specificirati i lice fonta koje mora biti cijeli broj, obièno izmeðu 1 i 4. Specijalna vrijednost 5 indicira da se treba koristiti font simbola. Dodatne detalje moguæe je pogledati na poveznici http://www.e-reading.club/bookreader.php/137370/C486x_APPb.pdf. Unutar sustava R postoje razlièiti paketi koji omoguæavaju korisniku da uveze dodatne fontove korištenjem paketa **extrafont**.
#' 
#' 
## ----fig.width=7, fig.height=4,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Dodavanje elemenata grafa - tekst", cache=F----
#stavljanje grafièkih parametara
par(mfrow=c(1,3))

#izraðivanje podataka
x <- seq(0,pi,0.1)
y1 <- cos(x)
y2 <- sin(x)

#prvi graf
plot(c(0,3), c(0,3), type="n", xlab="x", ylab="y")

#dodavanje linije na postojeæi graf
lines(x, y1, col="red", lwd=2)
lines(x, y2, col="blue", lwd=2)

#dodajte tekst na preciziranim koordinatama
text(x=1.5,
     y=2, 
     "Funkcija sinus i kosinus", 
     family="Helvetica")

#drugi graf
plot(c(0,3), c(0,3), type="n", xlab="x", ylab="y")

#dodajte linije postojeæem grafu
lines(x, y1, col="#00A600FF", lwd=2)
lines(x, y2, col="blue", lwd=2)

#dodavanje teksta na postojeæi graf; odreðene koordinate
text(1.5,2.5, "Funkcija sinusa i kosinusa", 
     cex=0.8, 
     col="orange", 
     family="Courier")


#treæi graf
plot(c(0,3), c(0,3), type="n", xlab="x", ylab="y")

#dodavanje linije na postojeæi graf
lines(x, y1,  lwd=2, lty=3)
lines(x, y2,  lwd=2, lty=4)

#dodavanje teksta na postojeæi graf; željene koordinate i font
text(1.5,1.5, 
     "Funkcija sinus i kosinus", 
     cex=2, 
     col="lightblue", 
     family="HersheySerif", 
     font=5)

#' 
#' 
#' \newpage
#' 
#' 
#' ####Funkcija **box()** {graphics}(*low-level*)
#' 
#' Ova funkcija crta okvir oko postojeæeg grafa u zadanoj boji i vrsti linije. Pogledajte kôd i komentirajte razlike.
#' 
## ----fig.width=10, fig.height=4,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Dodavanje elemenata grafa - okvir", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,3), oma=c(1,1,1,1))

#prvi graf
plot(df$x, df$y, type="p", 
     xlab="x", 
     ylab="y", 
     main="Jednostavan graf - okvir",
     cex.main=.75)

#dodajte okvir oko grafa
box(lty=2, 
    lwd=3,
    col="red")

#drugi graf
plot(df$x, df$y, type="p", 
     xlab="x", 
     ylab="y", 
     main="Jednostavan graf - okvir",
     cex.main=0.75)

#dodavanje okvira oko grafa
box(lty=3, 
    lwd=4, 
    which="figure", 
    col="green")


#treæi graf
plot(df$x, df$y, type="p", 
     xlab="x", 
     ylab="y", 
     main="Jednostavan graf - okvir",
     cex.main=0.75)

#dodavanje okvira oko grafa unutarne / vanjske podruèja
box(lty = '1373', 
    lwd=6, 
    which="inner", 
    col="purple3")

box(lty = 1, 
    lwd=2, 
    which="outer", 
    col="yellow3")


#' 
#' 
#' \newpage
#' 
#' #### Funkcija **title()/sub()**{graphics} (*low-level*)
#' .
#' 
#' Ova se funkcija može koristiti kako bi se dodao glavni naslov na dijagram.
#' 
## ----fig.width=10, fig.height=3,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Dodavanje elemenata grafa - glavni naslov / podnaslov", cache=F----
#postavite grafièki parametar
par(mfrow=c(1,3))

#izraðivanje podataka
x <- seq(0,pi,0.1)
y1 <- cos(x)
y2 <- sin(x)

#prvi graf
plot(c(0,3), c(0,3), type="n", xlab="x", ylab="y")

#dodavanje linije na postojeæi graf
lines(x, y1, col="red", lwd=2)
lines(x, y2, col="blue", lwd=2)

#dodavanje naslova na postojeæi graf
title(main = "Glavni naslov", 
      sub = NULL,
      col.main="orange")

#drugi graf
plot(c(0,3), c(0,3), type="n", xlab="x", ylab="y")

#dodavanje linije na postojeæi graf
lines(x, y1, col="red", lwd=2)
lines(x, y2, col="blue", lwd=2)

#dodavanje linije na postojeæi graf
title(main = "Vrlo dugaèak glavni naslov \n za koji je potreban novi redak", 
      lheight=2, #razmak izmeðu linija u naslovu
      sub = "Podnaslov",
      col.main="red",
      col.sub="darkgreen")

#treæi graf
plot(c(0,3), c(0,3), type="n", xlab="x", ylab="y")

#dodajte linije postojeæem dijagramu
lines(x, y1, col="red", lwd=2)
lines(x, y2, col="blue", lwd=2)

#dodavanje linije na postojeæi graf
title(main = "Moj glavni naslov", 
      sub = "Podnaslov željene velièine",
      col.main="red",
      col.sub="darkgreen",
      cex.main=2.2,
      cex.sub=0.6)

#' 
#' 
#' **ZA SAMOSTALNI RAD** Korištenjem skupa podataka iris, napravite dijagram raspršivanja (engl. scatterplot):
#' 
#' * koristite varijable Sepal.Length i Sepal.Width
#' 
#' * kao oznake toèki koristite varijablu Species
#' 
#' * napravite labele (oznake) 90% od zadane velièine fonta;
#' 
#' * stavite ih na lijevu stranu toèaka; 
#' 
#' * napravite neki proizvoljni *offset* od toèaka
#' 
#' * oznaèite oznake tamno sivom ili bilo kojom bojom koja Vam se sviða, osim crne
#' 
#' * zadajte font kao "mono" i napravite oznake podebljanim.
#' 
#' 
#' \newpage
#' 
#' ### Neke grafièke funkcije visoke razine - nastavak
#' 
#' U nastavku dajemo primjere za ranije navedene funkcije visoke razine unutar paketa *lattice*.
#' 
#' #### Funkcija **pairs()**{graphics}(*high-level*)
#' .
#' 
#' Funkcija rezultira matricom raspršivanja odabranih varijabli iz skupa podataka. Na primjer koristit æemo dobro poznati skup podataka iz sustava, skup iris (https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/iris.html).
#' 
#' Prisjetimo se strukture podataka.
#' 
#' 
#' 
## ---- echo=T , message=F, comment=NA,tab.caption="", cache=F-------------
#prvih 6 redova
head(iris)

#struktura podataka
str(iris)

#' 
#' U ovom primjeru, **pairs()** funkcija primjenjuje se na cijeli skup podataka:
#' 
## ----fig.width=10, fig.height=10,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Dijagram raspršenja  - skup podataka iris", cache=F----
#skup grafièkih parametara
par(mfrow=c(1,1))

#graf
pairs(iris, 
      main="Dijagram raspršenja - iris")

#' 
#' 
#' U slijedeæem primjeru, ista funkcija je primijenjena samo na dio skupa podataka:
#' 
#' 
## ----fig.width=10, fig.height=10,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Dijagram raspršenja za sve selektirane varijable", cache=F----
#postavljenje grafièkih parametara
par(mfrow=c(1,1))

#graf
pairs(~Sepal.Length+Sepal.Width+Petal.Length+Petal.Width, 
      data=iris, 
      main="Dijagram raspršenja \n selekcija varijabli")

#' 
#' 
#' #### Funkcija **boxplot()**{graphics}(*high-level*)
#' .
#' 
#' Jedan od najpopularnijih i informativnijih grafièkih prikaza distribucije jedne kvantitativne varijable je Box-Whisker dijagram. Ponovno, koristit æe se iris skup podataka iz sustava R. U ovom smo primjeru zainteresirani za varijablu duljine peteljki (Petal.Length).
#' 
#' 
#' 
#' Pogledajte primjer ispod i komentirajte rezultat funkcije. Što se može uoèiti u sljedeæa tri grafièka prikaza? Na koji naèin ove primjere mijenja argument *notch=T*?
#' 
#' 
## ----fig.width=7, fig.height=4,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Box-Whisker graf; a) jedna varijabla, b) tri varijable i c) jedna varijabla po nivoima faktora druge varijable (iris)", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,3))

#prvi graf
boxplot(iris$Petal.Length,
        main="Box_Whisker graf \n jedna varijabla",
        cex.main=.8)

#drugi graf
boxplot(iris$Petal.Length, 
        iris$Sepal.Width, 
        iris$Petal.Width,
        main="Box_Whisker graf \n tri varijable; jedna skala",
        cex.main=.9)

#treæi graf
boxplot(iris$Sepal.Width ~iris$Species,
        main="Box_Whisker plot jedna varijabla \n po nivoima faktora druge varijable",
        cex.main=.9)    

#' 
#' 
#' 
#' U ovom teèaju neæe biti govora o korištenju generièke funkcije **plot()** kao alata za vizualizaciju geografski referenciranih podataka ali svakako pogledajte primjer koji slijedi. Funkcijom **plot()**  vizualiziramo podatke o nadmorskoj visini dijela Republike Hrvatske, uèitanoga u sustav R putem *gdal* biblioteke za interoperabilnost geografskih podataka:
#' 
#' 
#' 
## ----fig.width=8, fig.height=6,echo=T,encoding = "ISO8859_2",warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **plot()**; generièka funkcija primijenjena na geografski referenciranim podacima", cache=F----
#uèitavamo sgrd/sdat SAGA GIS format u *sp* klasu
dem <- readGDAL("dem_ETRS_1k.sdat")
#vizualiziramo objekt klase SGDF, sp paket
plot(dem)

#' 
#' \newpage
#' 
## ----fig.width=8, fig.height=6,echo=T,encoding = "ISO8859_2",warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **heatmap()**", cache=F----
load("podaci_heatmap.RData")
#odreðivanje boja
moje_boje <- colorRampPalette(c('#f0f3ff','#0033BB'))(120)
#crtanje 
heatmap(podaci_heatmap, Rowv = NULL, Colv =NULL,  col=moje_boje)

#' 
#' 
#' \newpage
#' 
#' #### Funkcija **dotchart** (old:**dotplot()**) {graphics}(*high-level*)
#' 
#' .
#' 
#' Funkcija crta Cleveland toèkasti dijagram. Kako biste se upoznali prvo s funkcijom, unesite **?dotchart** u R konzolu i proèitajte informacijsku karticu o funkciji.
#' 
#' 
#' U slijedeæem primjeru uoèite korištenje parametra *gcolor*; za grupne oznake i vrijednosti koristit æe se jedna boja.
#' 
## ----fig.width=8, fig.height=6,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Dotplot; a) jednostavan dotplot, b) grupirani, sortiran i obojen prema nivoima faktora (mtcars)", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,2))

#prvi graf
dotchart(mtcars$mpg,labels=row.names(mtcars),cex=.7,
   main="Kilometraža po modelu automobila",
   xlab="Milja po galonu")


#sortiranje po mpg, group i color po cylinder
#izraðivanje nove varijable sa informacijama o boji
x <- mtcars[order(mtcars$mpg),] # sortiranje po mpg
x$cyl <- factor(x$cyl) # mora biti faktor
x$color[x$cyl==4] <- "red4"
x$color[x$cyl==6] <- "darkblue"
x$color[x$cyl==8] <- "darkseagreen4"

#drugi graf
dotchart(x$mpg,
         labels=row.names(x),
         cex=.7, 
         pch=22, 
         groups= x$cyl,
         main="Kilometraža po modelu automobila\ngrupirano po broju cilindara",
         xlab="Miles per gallon", gcolor="gray", color=x$color) 

#' 
#' 
#' \newpage
#' 
#' #### Funkcija **cotplot()**{graphics}(*high-level*)
#' .
#' 
#' Ova funkcija proizvodi dvije varijante uvjetovanih prikaza. Prije korištenja bitno je razumjeti sintakstu funkcije, stoga otvorite informacijsku karticu. 
#' 
#' Primjer s uvjetovanjem na jednoj varijabli:
#' 
## ----fig.width=8, fig.height=8,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Uvjetovani prikaz ovisnosti dvije numerièke varijable; uvjetovanje na jednoj varijabli (mtcars)", cache=F----
coplot(mpg ~ disp | as.factor(cyl), data = mtcars,
       panel = panel.smooth, rows = 1)

#' 
#' 
#' Primjer s uvjetovanjem na dvije varijable:
#' 
## ----fig.width=8, fig.height=6,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Uvjetovani prikaz; uvjetovanje po dvije varijable; panel.smooth (mtcars)", cache=F----
coplot(mpg ~ disp | as.factor(cyl)* as.factor(carb), data = mtcars, rows = 1)

#' 
#' 
#' 
#' 
#' 
#' **ZA SAMOSTALNI RAD**
#' 
#' Napravite grafièki prikaz skupa podataka iris na sljedeæi naèin:
#' 
#' 1) Kreirajte toèkasti dijagram Cleavland za varijablu Sepal.Length, grupirano po vrstama.
#' 
#' 2) Stavite odgovarajuæi naslov.
#' 
#' 
#' 
#' \newpage
#' 
#' 
#' #### Funkcija **pie()**{graphics}(*high-level*)
#' 
#' .
#' Funkcija crta pita dijagram. Prisjetite se da smo veæ koristili pita dijagrame za vizualiziranje shema boja te ih preporuèamo samo za takve potrebe.
#' 
#' U sljedeæim primjerima æemo izraditi pita dijagram s postotcima. Kako bismo to napravili, prvo moramo izraèunati postotke iz podataka i izraditi adekvatne oznake. Molimo pogledajte sljedeæi kôd i komentirajte.
#' 
## ---- echo=T , message=F, comment=NA,tab.caption="", cache=F-------------
#izraðivanje odreðenih podataka
pie_podaci <- c(20, 15, 3, 22, 11, 17)

#izraèun postotaka
postotak <- round(pie_podaci/sum(pie_podaci)*100)

#izraðivanje labela (Oznaka)
lab <- c("US", "UK", "HR", "DE", "FR", "IT")

#dodavanje postotka labelama
lab_1 <- paste(lab, postotak) 

#dodajemo oznaku % labelama
lab_2 <- paste(lab_1,"%",sep="") 

#' 
#' Sada, kada imamo sve komponente, možemo napraviti grafove:
#' 
## ----fig.width=7, fig.height=4,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Pita dijagram a) jednostavnja, b) s kreiranim labelama i c) korisnièke labele i boje", cache=F----
#postavljanje grafièkih parametaraset graphical parameters
par(mfrow=c(1,3), mar=c(0,0,3,1))

#prvi graf
pie(pie_podaci, 
    main="Pita graf; default")

#drugi graf
pie(pie_podaci,
    labels = lab_2,
    main="Pita graf; labele")

#treæi graf
pie(pie_podaci, 
    labels = lab_2,
    col= c("lightpink3", "darkseagreen4", "lightblue2", "ivory3", "lavender", "lightgray"),
    main="Pita graf; labele, korisnièke boje") 

#' 
#' 
#' \newpage
#' 
#' Moguæe je postaviti dodatne prilagodbe vezano za grafove, kao što to pokazuje sljedeæi primjer:
#' 
#' 
#' 
## ----fig.width=7, fig.height=4,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Pita graf; dodatne postavke; a) odreðivanje poèetnog kuta; b) odreðivanje visine, granica i prošaranosti i c) opoziv boja na grafu", cache=F----
#postavljanje grafièkih parametara 
par(mfrow=c(1,3), mar=c(0,0,3,1))

#prvi graf
pie(pie_podaci, 
    init.angle=90,
    main="Pita dijagram; zadan poèetni kut")

#drugi graf
pie(pie_podaci,
    init.angle=45,
    labels = lab_2,
    density= 20,
    col= c("lightpink3", "darkseagreen4", "lightblue2", "ivory3", "lavender", "lightgray"),
    main="Pita dijagram \n boje, labele, gustoæa, kut")

#treæi graf
pie(pie_podaci, 
    labels = lab_2,
    col=rep("white", length(pie_podaci)),
    main="Pita dijagram; oznaèen, bez boja \n prilagodba kuta i prošaranosti") 

#' 
#' 
#' \newpage
#' 
#' Molimo, gledajuæi primjere odgovorite na slijedeæe:
#' 
#' 1) Koji argument funkcije **pie** kontrolira smijer crtanja pita dijagrama?
#' 
#' 2) Kako su **default** kriške pita dijagrama organizirane? Što znaèi automatsko oznaèavanje?
#' 
#' 3) Opišite proces *supressing* boja u pita dijagramima?
#' 
#' 
#' Pita dijagrami su popularni, ali ih mnogi analitièari/statistièari ne smatraju pogodnim za prezentiranje podataka. Jedan od razloga je moguænost manipuliranja uèincima korištenjem boja, poèetnim kutom, sjenèanjem ili 3D vizualiziranjem pita dijagrama. Kao primjer, sljedeæi je dijagram pripremljen pomoæu **pie3D** funkcije iz *plotrix* paketa. U opisu **pie3D()** funkcije stoji sljedeæe: **"Pita dijagrami su loš naèin prikaza informacija. Èovjekovo oko je u moguænosti dobro  procijeniti linearne ovisnosti ali je loše u prosudbi relativnih podruèja. Za prikaz podataka koje ljudi obièno prikazuju pita dijagramom bolje je koristiti stupièasti dijagram (*barplot*) ili toèkasti dijagram (*dotplot*)."**
#' 
## ----fig.width=7, fig.height=4,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Pita dijagram; funkcija **pie3D** iz *plotrix* paketa, tri varijante", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,3), mar=c(0,0,1,1))

#prvi graf
pie3D(pie_podaci,
      radius=1.1,
      height=0.2,
      border="white",
      labels=lab_2,
      explode=0.1,
      theta=1.2,
      labelcex=0.6,
      col= c("lightpink3", "darkseagreen4", "lightblue2", "ivory3", "lavender", "lightgray"),
      main="3D pita dijagram; varijanta 1")

#drugi graf
pie3D(pie_podaci,
      radius=1.5,
      labels=lab_2,
      labelcex=0.8,
      labelcol="gray",
      col= c("lightpink3", "darkseagreen4", "lightblue2", "ivory3", "lavender", "lightgray"),
      main="3D pita dijagram; varijanta 2")

#treæi graf
pie3D(pie_podaci,
      radius=1.2,
      labels=lab_2,
      explode=0.3,
      labelcex=0.7,
      border="white",
      col= c("lightpink3", "darkseagreen4", "lightblue2", "ivory3", "lavender", "lightgray"),
      main="3D pita dijagram; varijanta 3")

#' 
#' 
#' 
#' 
#' \newpage 
#' 
#' 
#' #### Funkcija **hist()**{graphics}(*high-level*)
#' .
#' 
#' Generièka funkcija **hist()** raèuna histogram danih vrijednosti podataka. Ako je argument postavljen na *plot = TRUE*, rezultirajuæi objekt klase "histogram" crta se pomoæu **plot.histogram** metode.
#' 
#' 
#' U sljedeæem primjeru napravit æemo sljedeæe histograme: a) jednostavan histogram s predefiniranim (engl. *default*) vrijednostima za varijablu *Sepal.Length* iz skupa podataka iris i b) histogram iste varijable, ali æemo promijeniti broj razdioba/binova na 35 te æemo prikazati i vrijednosti iz skupa podataka korištenjem funkcije **rug()**; c) na treæem dijelu æemo funkcijom **hist()** nacrtati, ne prave frekvencije, veæ vjerojatnosti pojave opservacije u pojedinom rasponu (engl. *bin*) te na isome prikazu superponirati i normalnu razdiobu. Prije poèetka moramo se upoznati s funkcijom i pogledati njezinu informacijsku karticu.
#' 
#' Uvijek budite svjesni toga da je histogramski prikaz varijable loš za odreðivanje njezina oblika buduæi je veoma osjetljiv na broj intervala unutar kojih klasificiramo naše podatke, ali je veoma pogodan za vizualizaciju naših podataka (eksperimenata) u usporedbi s teorijskom distribucijom, kao što je pokazano na c dijelu slike.
#' 
#' 
#' 
#' 
## ----fig.width=10, fig.height=5,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija za crtanje histograma **hist**", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,3))

#prvi graf
hist(iris$Sepal.Length, 
     col="lightblue", 
     main="Histogram, default broj intervala",
     cex.main=1.2)  

#drugi graf
hist(iris$Sepal.Length, 
     col="lightblue", 
     main="Histogram, 35 intervala",
     cex.main=1.2,
     breaks=35)
rug(iris$Sepal.Length) #rug 

#treæi graf
h<- hist(iris$Sepal.Length, 
     col="lightblue", 
     main="Histogram duljine listiæa; vjerojatnosti \n superponirana normalna distribucija",
     cex.main=1.2,
     breaks=35, 
     freq=F)

#raèunamo vrijednosti normalne distribucije na zadanom intervalu
xfit<-seq(min(iris$Sepal.Length),max(iris$Sepal.Length),length=40)
yfit<-dnorm(xfit,mean=mean(iris$Sepal.Length),sd=sd(iris$Sepal.Length))
yfit <- yfit*diff(h$mids[1:2])*length(x)

#dodavanje linija - fit; normalna distribucija
lines(xfit, yfit, col="blue", lwd=2)

#' 
#' 
## ----fig.width=10, fig.height=5,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija za crtanje histograma **hist**; prikaz tri raspodjele na jednom grafu", cache=F----

#postavljanje grafièkih parametara
par(mfrow=c(1,1))

#poèetna vrijednost generatora sluèajnih brojeva
set.seed(113)

#generiramo sluèajne varijable iz razlièitih razdioba
v1 <-rnorm(n=5000, mean=4, sd=0.7)
v2 <-rnorm(n=5000, mean=6, sd=2)
v3 <-rnorm(n=5000, mean=5, sd=1)

#crtamo obje raspodjele na jednom grafu
#rgb parametar za transparentnost
hist(v1, col=rgb(0.1,0.1,0.1,0.5),
     xlim=c(0,10), 
     ylim=c(0,200), 
     main="Preklapajuæi histogrami")
hist(v2, col=rgb(0.8,0.8,0.8,0.5), add=T)
hist(v3, 
     col=col2rgb("lightblue")[1], 
     col2rgb("lightblue")[2], 
     col2rgb("lightblue")[3],0.5, add=T)

#' 
#' 
#' 
#' \newpage
#' 
#' 
#' #### Funkcija **barplot()**{graphics}(*high-level*) 
#' .
#' 
#' Funkcijom crtamo stupièasti dijagram s vertikalnim i horizontalnim oznakama; adekvatan grafièki prikaz za vizualiziranje jedne kategorijske varijable. U sljedeæem primjeru vizualizirat æemo kategorije (dobivene funkcijom **cut()**) raspona nadmorskih visina skupa podataka iz sustava *volcano*.
#' 
#' 
## ----fig.width=8, fig.height=5,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **barplot**; vertikalni i horizontalni stupièasti dijagram", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,2))

#priprema podataka; kategorije
volcano_categories <- cut(volcano, c(50,100, 150, 200))
                     
#dijagram 1
barplot(table(volcano_categories), col="lightblue", 
     main="Stupièasti dijagram \nskupa podataka o nadmorskoj visini vulkana",
     cex.main=0.9, sub="Vartikalni")

#dijagram 2
barplot(table(volcano_categories), col="lightblue", 
     main=NULL,
     cex.main=0.9,density=20,
     horiz=T, sub="Horizontalni",
     cex.sub=0.9,
     ylab= "Kategorije nadmorske visine", xlab="Frekvencija", cex.lab=.8)  

#' 
#' 
#' Pogledajte prethodne slike i komentirajte sve razlike izmeðu dva dijagrama. Pronaðite dijelove kôda koji kreiraju te razlike. Što æe se dogoditi ako izostavimo dio iz drugog grafa *main=NULL*? Isprobajte to u R konzoli i komentirajte.
#' 
#' 
#' 
#' 
#' \newpage
#' 
#' 
#' #### Funkcija **mosaicplot()**{graphics}(*high-level*) 
#' 
#' .
#' 
#' Mozaik dijagram je popularan graf za vizualiziranje dvije ili više kategorijskih varijabli.
#' 
#' 
#' Prvo æemo pripremiti odreðene podatke s kategorijskim varijablama.
#' 
## ---- echo=T, warning=F, message=F---------------------------------------
#kreirajte skup podataka s tri faktorske varijable

#reproducibilna simulacija
#poèetni broj za generator sluèajnih brojeva
set.seed(1)

moji_podaci <- data.frame (faktor1 = sample (c("A", "B", "C", "D"), 200, replace = TRUE), 
faktor2 = sample (c("HL", "PS",  "DS"), 200, replace = TRUE),
faktor3 = sample (c("Male", "Female"), 200, replace = TRUE))

#' 
#' 
## ----fig.width=10, fig.height=6,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Vizualizacija interakcije za više od jedne kategorijske varijable - mozaik dijagram tri kategorijske varijable", cache=F----
#postavke grafièkih parametara za dijagram
par(mfrow=c(1,2))

#izraðivanje grafa 

#mosaicplot(~ fact1 + fact2 + fact3, data=moji_podaci, col=T,
#main="Mosaicplot of three categorical variables")

#isto kao ovo
mosaicplot(table(moji_podaci),  
           col=T, 
           main="Mozaik dijagram tri kategorijske varijable")

#drugi graf

mosaicplot(~ faktor2 + faktor3, 
           data=moji_podaci, 
           col=c("red4", "darkgray"),
           main="Mozaik dijagram dvije kategorijske varijable")

#' 
#' 
#' 
#' 
#' Primjer koji slijedi nije iz sustava R, veæ podaci ankete djelatnika jedne kompanije. Pogledajmo prvo strukturu podataka koje æemo crtati:
#' 
## ---- echo=F, warning=F, message=F---------------------------------------
p <- pitanje_8_df[!is.na(pitanje_8_df$dovršeno),]
p2 <- pitanje_96_df[!is.na(pitanje_96_df$dovršeno),]
p3 <- pitanje_98_df[!is.na(pitanje_98_df$dovršeno),]
p_df <- cbind(p, p2, p3)
podaci_1 <- p_df[c("Imam osjeæaj da radim koristan i važan posao", "X2", "X4")]
names(podaci_1) <- c("Vazan_posao", "Zadovoljstvo", "Djelovanje")
podaci_1$Vazan_posao <- as.factor(as.numeric(as.factor(podaci_1$Vazan_posao)))

#' 
#' 
## ---- echo=T, warning=F, message=NA--------------------------------------
head(podaci_1)

#' 
#' 
#' Gotovo uvijek postoji više moguænosti kako nešto napraviti u R-u. Ima mnogo kontribuiranih paketa koji se bave razlièitim aspektima vizualiziranja podataka i/ili analize podataka. Na primjer paket **vcd** je paket specijaliziran za vizualiziranje kategorijskih podataka *citation(vcd)*.
#' 
#' \blandscape
#' 
#' 
## ----fig.width=15, fig.height=8,encoding = "ISO8859_2",echo=F, warning=FALSE,message=F,include=TRUE,fig.cap="Vizualizacija interakcije za više od jedne kategorijske varijable - mozaik dijagram tri kategorijske varijable, primjer 2", cache=F----
#postavke grafièkih parametara za dijagram
par(mfrow=c(1,1))

#plot
mosaicplot(~ Vazan_posao + Djelovanje + Zadovoljstvo,
           data=podaci_1, 
           col=c("red4", "darkgray", "lightpink3"),
           main="Mozaik dijagram tri kategorijske varijable",
           las=2)

#' 
#' \elandscape
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' \newpage
#' 
#' 
#' #### Funkcija **assocplot()**{graphics}(*high-level*) 
#' .
#' 
#' 
#' Asocijativni dijagram je popularan grafièki prikaz za vizualiziranje dvije ili više kategorijskih varijabli. Prije vizualizacije uvijek je dobro potrebno ispitati strukturu podataka. Zapamtite, veæ smo kreirali  skup podataka *moji_podaci*, klase *data.frame* koji sadrži kategorijske varijable.
#' 
#' 
## ---- echo=T, warning=F, message=F---------------------------------------
#sjetite se strukture moji_podaci data frame-a
str(moji_podaci)

#cijela tablica
moja_tablica <- table(moji_podaci)

#agregirani podaci
moja_marginalna_tablica <- margin.table (moja_tablica, c(1,3))

#' 
#' 
#' Kako je i navedeno, paket *vcd*  je specijaliziran za vizualiziranje kategorijskih podataka. Funkcija **assoc()** je fleksibilnija i iscrpnija primjena dijagrama asocijacije u grid grafièkom sustavu. 
#' 
## ----fig.width=8, fig.height=6,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Vizualizacija interakcije dviju kategorijskih varijabli - asocijativni dijagram", cache=F----
#postavka grafièkih parametara za dijagram
par(mfrow=c(1,1))

#dijagram
assocplot(moja_marginalna_tablica, 
          main="Asocijativni dijagram dvije kategorièke varijable", 
          col=c("lightpink3", "lightgray"))

#' 
#' 
## ---- echo=T, warning=F, message=F---------------------------------------
#struktura podataka
str(podaci_1)

#cijela tablica
moja_tablica_2 <- table(podaci_1)

#agregirani podaci
moja_marginalna_tablica_2<- margin.table (moja_tablica_2, c(1,3))

#' 
#' 
#' 
#' 
## ----fig.width=8, fig.height=6,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Vizualizacija interakcije dviju kategorijskih varijabli - asocijativni dijagram", cache=F----
#postavka grafièkih parametara za dijagram
par(mfrow=c(1,1))

#dijagram
assocplot(moja_marginalna_tablica_2, 
          main="Asocijativni dijagram dvije kategorièke varijable", 
          col=c("lightpink3", "lightgray"),
          xlab="Važnost posla",
          ylab="Zadovoljstvo na poslu")

#' 
#' 
#' 
#' 
#' 
#' \newpage
#' 
#' ####Funkcija **persp()**{graphics}(*high-level*)
#' .
#' 
#' Ova funkcija crta odgovarajuæe grafove površine preko x - y ravnine. Funkcija **persp()** je generièka funkcija. Ova vrsta grafa je, takoðer, poznata kao površina okvira. Prvo se upoznajmo s funkcijom. Molim da otvorite informacijsku karticu funkcije tako što æete u R konzolu unijeti **?persp**. 
#' 
#' U sljedeæem æemo primjeru izraditi odgovarajuæe dijagrame numerièkih matrica s topografskim podacima Maunga Whau vulkana iz Aucklanda, pomoæu skupa podataka *volcano* iz R sustava:
#' 
#' 
## ---- echo=T, warning=F, message=F---------------------------------------
#priprema podataka
dim(volcano)
x <- 1:87

#isto kao
#x <- 1:dim(volcano)[1]

y<- 1:61
#y <- 1:dim(volcano)[2]

x
y

#' 
#' 
## ----fig.width=10, fig.height=7,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Graf površine; *perspective plot* na skupu podataka volcano - numerièka matrica s vrijednostima topografskih visina za Maunga Whau vulkan.", cache=F----
par(mfrow=c(1,2))

#prvi graf
persp(x,y, volcano, 
      theta = 45, 
      phi = 15, 
      col = "green3", 
      scale = F,
      ltheta = -120, 
      shade = 0.75, 
      border = NA, 
      box = T, 
      main="Perspektiva vulkana 1") 

#drugi graf
persp(x,y, volcano, 
      theta = 145, 
      phi = 15, 
      col = "green3", 
      scale = F,
      ltheta = -120, 
      shade = 0.4, 
      border = NA, 
      box = T, 
      main="Perspektiva vulkana 2")  

#' 
#' 
#' 
#' \newpage
#' 
#' ####Funkcija **filled.contour()**{graphics}(*high-level*)
#' .
#' 
#' Ova funkcija proizvodi grafièki prikaz kontura (grafiku razine) s podruèjima izmeðu kontura koje popunjava puna boja. U slijedeæem primjeru, ponovno koristimo podatke iz skupa  *volcano* koji se nalaze u sustavu:
#' 
## ----fig.width=10, fig.height=7,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Prikaz kontura, engl. *contour plot*; plot na skupu podataka volcano - numerièka matrica s vrijednostima topografskih visina za Maunga Whau vulkan; tri nivoa; nlevels= 3", cache=F----
filled.contour(volcano, 
               color = topo.colors, nlevels=3,  
               main="Graf kontura, broj nivoa=3")

#' 
#' 
#' 
## ----fig.width=10, fig.height=7,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Prikaz kontura, *contour plot*; plot na skupu podataka volcano - numerièka matrica s vrijednostima topografskih visina za Maunga Whau vulkan; pet nivoa; nlevels= 5.", cache=F----
filled.contour(volcano, 
               color = terrain.colors, nlevels=5,  
                  main="Graf kontura, broj nivoa=5")

#' 
#' 
#' \newpage
#' 
#' 
#' 
#' #### Funkcija **image()**{graphics}
#' .
#' 
#' 
#' Funkcija prikazuje sliku boje. Ova funkcija zahtijeva listu x i y vrijednosti koje pokrivaju grid vertikalnih vrijednosti koje æe se koristiti kreiranje površine. Ovdje su visine precizirane kao tablica vrijednosti, što je, u našem sluèaju, saèuvano kao objekt z tijekom kalkulacija lokalnoga trenda površine. Uoèite korištenje parametra **add** - logical; ako je  postavljen na TRUE, dodaje sliku na postojeæi graf. Ovaj argument se rijetko koristi, buduæi da funkcija "crta" preko postojeæe grafike.
#' 
#' Pogledajte primjer na skupu podataka *volcano*:
#' 
#'         
## ----fig.width=8, fig.height=5,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **image()** koja prikazuje sliku u boji; skup podataka *volcano*", cache=F----
#postavljanje grafièkih parametara
par(mfrow=c(1,2))

#prvi graf
image(x,y, volcano,  
      col = heat.colors(12), 
      main="Image funkcija, heat.colors skup podataka volcano",
      cex.main=.9)  

#drugi graf
image(x,y, volcano,  
      col = topo.colors(12), 
           main="Image funkcija, topo.colors skup podataka volcano",
      cex.main=.9)  

#' 
#' 
#' 
#' 
#' \newpage
#' 
#' ## Grid grafika/Lattice grafika (temeljena na paketu *grid*)
#' 
#' *Grid* grafika je alternativni sustav grafike koji je naknadno postao sastavni dio sustava R. Velika razlika izmeðu *grid* i izvornoga sustava grafike, *base*, jest to što *grid* omoguæava izraðivanje višestrukih regija crtanja koje nazivamo pogledi (engl. *viewports*). Koncept pogleda/*viewports* bit æe kasnije u teèaju detaljnije obraðen.
#' 
#' 
#' 
#' ### Paket *grid* 
#' 
#' Paket *grid* je postao sastavnim dijelom instalacije R sustava i kao takav nije na raspolaganju kao samostalni paket na CRAN spremištu (https://cran.r-project.org/). Paket sadrži kolekciju alata niske razine za crtanje grafièkih prikaza. Paketi više razine kao što su *lattice* i *ggplot2* koriste funkcionalnosti paketa *grid* za svoje sofisticirane (engl. *high-level*) funkcije. 
#' 
#' Komentirajte sljedeæu liniju koda i ispis na konzoli. Na koji se naèin pravilno citira paketa *grid*?
#' 
## ---- echo=T , message=F, comment=NA, cache=T----------------------------
citation("grid")

#' 
#' 
#' Paket *grid* pruža nekoliko koncepata koji olakšavaju crtanje statistièkih prikaza. *Grid* grafièki prikaz sastoji se od:
#' 
#'  - osnovnih grafièkih objekata (*grob*)
#'  
#'  - jedinica, koordinata (*coordinate systems*) za lociranje i velièinu oblika
#'  
#'  - grafièkih parametara koji kontroliraju izgled grafièkih objekata (*gpar*) 
#' 
#'  - pogleda (*viewports*) i rasporeda (*layouts*) za stvaranje lokalnoga konteksta
#'  
#'  - ...
#' 
#' U ovom dijelu uvodimo nekoliko funkcija iz *grid* paketa koje su neophodne kako bi se razumio koncept *viewports* i *layouts* (predložaka) u sustavima koji se temelje na gridu kao što su *lattice* ili *ggplot*.
#' 
#' 
#' 
#' Upoznat æemo se s najvažnijim funkcijama za odreðivanje **hijerarhije u *grid* scenama** i grafièkim objekti (*grob*) paketa *grid*
#' 
#' Temeljni graditeljski blokovi *grid* scene su grafièki objekti (*grobs*), koji  opisuju oblike koji æe se crtati i ulazi/pogledi (engl. *viewports*), koji definiraju podpodruèja na stranici kao cjelini za crtanje. Svaki grafièki objekt sastoji se od definiranih lokacija i dimenzija u zadanom koordinatnom sustavu. Lokacije i dimenzije oblika su jedinice koje se sastoje od vrijednosti i informacija o koordinatnom sustavu. Svaki osnovni oblik ima **gp** argument koji omoguæava preciziranje grafièkih parametara. Glavni grafièki parametri su: boja (**col**); unutarnja popunjenost (**fill**); širina linije (**lwd**); vrsta linije (**lty**); multiplikator velièine teksta (**cex**).
#' 
#' Ovi graditeljski blokovi se mogu posložiti po hijerarhijama kako bi kreirali *stabla grafièkih objekata* *(gTrees)* and *trees of viewports* **(vpTrees)**. Na primjer os na grafu može biti jedan, roditeljski *gTree* koji sadrži nekoliko "djece" *grobs* kako bi se predstavila glavna linija osi, debele oznake i debele labele osi.
#' 
#' Bilo koji oblik koji je nacrtan pomoæu paketa *grid* grafike može imati pridruženo ime. Ako je ime dano, moguæe mu je pristupiti, ispitati i modificirati oblik kada je jednom nacrtan. Ove moguænosti pružaju priliku vrlo detaljne prilagodbe grafa, ali i vrlo opæih transformacija grafa koji su nacrtani pomoæu paketa koji se temelje na paketu *grid*. Kada se "scena" (prikaz, engl. *scene*) nacrta pomoæu grid grafike u R-u, èuva se informacija o svakom obliku koji je korišten da se taj prikaz nacrta. Ta se evidencija naziva *display list* i sastoji se od liste R objekata, jedne za svaki oblik u sceni.
#' 
#' U sluèaju grafike gdje postoji eksplicitan naziv za svaki oblik (engl. *grob*) koji crtamo pomoæu grida, omoguæavamo pristup na niskoj razini svakom objektu unutar scene. Ovo nam omoguæava da napravimo iscrpne prilagodbe scene, bez potrebe za dugim listama argumenata kao iz funkcija crtanja visoke razine te nam je omoguæeno da propitujemo i transformiramo scenu kroz širok spektar naèina. 
#' 
#' 
#' Važna razlika izmeðu grafike kako ju definira sustav kao što je R, nasuprot jednostavnih grafièkih paketa kao što su GIMP i/ili Inkscape je u tome što crtanje pomoæu paketa *grid* ukljuèuje definiranje **konteksta** za crtanje (engl. *viewports*) i samoga crtanja osnovnih grafièkih objekata (engl. *grobs*) u tim kontekstima (https://www.stat.auckland.ac.nz/~paul/useR2011-grid/gridHandout.pdf). Ovdje æemo spomenuti samo najznaèajnije funkcije koje je nužno razumjeti kako bi se što efikasnije iskoristile funkcionalnosti *lattice* i kasnije *ggplot* paketa. Funkcija **grid.ls()** se može koristiti kako bi se prikazala lista grafièkih elemenata *grobs* i  *viewports* u sceni. Kôd koji slijedi pokazuje što dobijemo nakon što nacrtamo scenu *A grob hierarchy*, koja sastoji se od samo roditeljske osi *grob* s kljuènom linijom, debele oznake, debele labele *grobs*-*ova* "djece". 
#' 
#'  ![Hijerarhija grafièkih objekata (engl. *grob*). Izvor: https://www.stat.auckland.ac.nz/~paul/Reports/ggplotSlider/ggplotSlider.html](grob_hierarchy.png) 
#'  
#' *Grid* scena koja se sastoji od višestrukih *viewports*-a koji definiraju regiju za crtanje dijagrama koji slièi trellis-tipu. Jedan roditeljski *viewport* može sadržati kolekciju dijagrama koji unutar sebe imaju nekoliko *viewports* djece. 
#'  
#'   ![Hijerarhija pogleda (engl. *viewports*). Izvor: https://www.stat.auckland.ac.nz/~paul/Reports/ggplotSlider/ggplotSlider.html](grid_hierarchy.png) 
#'   
#' 
#' 
#'   ![Dijagram kombinirane hijerarhije *vpTrees* i *gTrees* unutar *grid* scene koja se sastoji od roditeljskog *viewport*-a i èetiri *viewport*-a "djece" (engl. *child*), s pravokutnikom i tekstualnim grafièkim objektom (engl. *grob*) koji je nacrtan unutar svih pogleda (engl. *viewport*). Izvor: https://www.stat.auckland.ac.nz/~paul/Reports/ggplotSlider/ggplotSlider.html](grid_hierarchy2.png) 
#'   
#' 
#' 
#' Postoji moguænost korištenja nekoliko koordinatnih sustava za definiranje pozicija i velièina *lattice* *viewporta*. Tako je koordinate moguæe zadati putem sljedeæih koordinata:
#' 
#'  - **Koordinate normaliziranog roditelja (engl. *Normalised parent coordinates, NPC*)**: ishodište *viewporta* je postavljewno na koordinatama (0,0) a cijeli viewport ima širinu i visinu 1
#'  
#'  - **Fizièke koordinate (engl. *physical coordinates*)**: apsolutne, fizièke koordinate koje su definirane u inèima, centimetrima ili nekim drugim jedinicama
#'  
#'  - **Priroðene koordinate (engl. *native coordinates*)**: na osnovi raspona *viewporta* radi se skaliranje x i y osi. Ovo je stvarni koordinatni sustav koji se koristi za crtanje elemenata dijagrama
#'  
#'  - **Koordinate po osnovi karaketera, linije ili teksta (engl. *character, line or string based coordinates*)**:  koordinatni sustavi su umnošci 1) nominalne velièine fonta, ili 2) vertikalne udaljenosti izmeðu baznih linija dvije linije teksta ili širine/visine dijela teksta. Ove koordinate su korisne za definiranje relativne pozicije jednoga elementa grafa u odnosu na druge elemente.
#' 
#' #### Funkcija **viewport()** {grid}
#' Funkcija **viewport()** stvara pravokutnu regiju na stranici. Pogledi su opisani s lokacijom i velièinom koje se mogu specificirati u bilo kojem opisanom koordinatnom sustavu. 
#' 
#' Korištenjem funkcija napravljenih za rad s pogledima (engl. *viewports*) omoguæen je prelazak izmeðu regija na ureðaju (bez potrebe za ponovnim stvaranjem istih). Ovaj mehanizam korisniku pruža moguænost pristupa, prema potrebi, svim regijama koje su napravljene tijekom crtanja. 
#' 
#' 
#' 
#' Sam proces crtanja u konaènici nastaje pomoæu **pushviewport()** funkcije:
#' 
#' #### Funkcija **pushViewport** {grid}
#' 
## ----fig.width=4, fig.height=4,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Izraðivanje konteksta (*viewport*) za crtanje objekata (*grobs*)",comment=NA,  cache=F----

#izraðivanje viewport-a - kontekst za crtanje
plotvp <- viewport(x=unit(5, "lines"),
    y=unit(5, "lines"),
    width=unit(1, "npc") -
    unit(8, "lines"),
    height=unit(1, "npc") -
    unit(8, "lines"),
    just=c("left", "bottom"),
    xscale=c(0, 6),
    yscale=c(0, 6),
    name="plotRegion")

#izraðivanje konteksta za graf
pushViewport(plotvp)

#pravokutnik grafa
grid.rect(x=0.5, y=0.5, width=1, height=1)

#toèke grafa
grid.points(1:5, 1:5, default.units="native")

#osi grafa
grid.xaxis(at=0:6)
grid.yaxis(at=0:6)

#lista viewports-a/grobs-a
grid.ls(fullNames=TRUE)

#' 
#' 
#' \newpage
#' 
#' Kako je pokazano, veoma je važno shvatiti koncept  pogleda i grafièkih objekata (*viewports* i *grob*). Na ove  koncepte oslanjaju se sve *lattice* funkcije visoke razine rade; prvo stvore pogled/*viewports*, a onda crtaju grafièke objekte/*grob* u stvorenim pogledima. Usporedite sljedeæi primjer koji je dobiven funkcijom **xyplot()**, funkcijom visoke razine iz paketa *lattice*.
#' 
#' 
#' 
## ----fig.width=5, fig.height=5,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija visoke razine temeljena na* gridu* iz paketa *lattice* ", cache=F----
#funkcija visoke razine iz *lattice* grafike
xyplot(1:5 ~ 1:5 | 1)

#' 
#' 
#' \newpage
#' 
## ----fig.width=7, fig.height=8,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija visoke razine temeljena na *gridu* iz paketa *lattice* ",  comment=NA, message=F, cache=F----
barchart(yield ~ variety | site, data = barley,
         groups = year, layout = c(1,6), stack = TRUE,
         auto.key = list(space = "right"),
         ylab = "Urod jeèma",
         scales = list(x = list(rot = 45)))

#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=T----------------------------
grid.ls(viewports=T, grob=F,fullNames=F)

#' 
#' 
#' Kako je ranije reèeno, upravljanje i uporaba ove funkcije izvan su djelokruga ovog teèaja, ali postoji potreba za razumijevanje koncepta *grid* grafike kako bi se mogla istražiti i koristiti veæina grafièkih moguænosti grafièkih paketa koji se temelje na *grid* grafici u buduænosti. Èak i ako još nismo upoznati sa *lattice* grafikom, pružamo primjer upravljanja pogledima/*viewportima* od strane korisnika. U primjeru koji slijedi nacrtat æemo pravokutnik u velièini željenog pogleda te ga obojati prema željenoj boji. Najprije pogledajmo jedan grafièki prikaz napravljen funkcijom visoke rezolucije paketa *lattice*.
#' 
#' 
## ----fig.width=7, fig.height=8,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Primjer upravljenjima pogledima u funkciji visoke razine trellis u paketu *lattice* ", cache=F----
#crtanje podataka o urodu jeèma (engl. barley), funkcija viso
barchart(yield ~ variety | site, data = barley,
         groups = year, layout = c(1,6), stack = TRUE,
         auto.key = list(space = "right"),
         ylab = "Urod jeèma",
         scales = list(x = list(rot = 45)))

#specificiramo dio grafa na koji želimo nešto dodati
downViewport("plot_01.panel.1.3.vp")

#downViewport("plot_01.panel.1.4.vp")

#bojamo željeni dio grafa
grid.rect(gp=gpar(col=NA, fill=rgb(0,.1,0,.4, 0.6)))

#' 
#' 
#' 
#' 
#' 
#' #### Funkcija **current.viewport()** {grid}
#' 
#' .
#' Funkcijom **current.viewport()** daje se informacija o trenutaènom pogledu.
#' 
#' 
#' 
#' #### Funkcija **current.vpTree()** {grid}
#' 
#' 
#' Poglede je moguæe specificirati i odrediti im velièinu i korištenjem funkcije **layout()**, što je bolja opcija od davanja exsplicitnih koordinata velièine i položaja.
#' 
#' 
#' 
#' #### Funkcija **downViewport()** {grid}
#' 
#' Funkcija se koristi za povratak na neki od postojeæih pogleda na sceni.
#' 
#' #### Funkcija **grid.layout** {grid}
#' 
#' Funkcijom **layout()** dijelimo željeni pogled na retke i stupce. Visina i širina pojedinoga retka i/ili stupca može se zadati u bilo kojem opisanom koordinatnom sustavu uz dodatak specijalnog koordinatnog sustava, tzv. "null" koji postoji jedino u sustavima *layouta*.
#' 
#' 
#' 
#' Za sve koji žele znati nešto više ovoj temi mogu svoje znanje o upravljenjima pogledima u paketima temeljenim na *grid* paketu potražiti na https://stat.ethz.ch/R-manual/R-devel/library/grid/doc/viewports.pdf i službenoj dokumentaciji paketa.
#' 
#' 
#' I na kraju napomena, imenovati se može sve što crtamo pomoæu neke funkcije temeljene na *grid* paketu. Naèin imenovanja elemenata scene bio bi primjerice: sve što se nacrta unutar regije panela ima rijeè "panel" u nazivu, zajedno sa sufiksom u obliku i.j kako bi se identificirao redak i stupac panela. Jednako vrijedi i za sve ostale klase grafièkih objekata koji se pojavljuju. Nemojte se preplašiti dugaèkih ispisa strukture pojedinog grafa. Pažljivim èitanjem vidjet æete da su nazivi veoma intuitivni te æete se veæ nakon nekoliko primjera jednostavno snalaziti s popisima elemenata. Postoje i alati koji pomažu u prikazu imena objekata na postojeæoj sceni od kojih se veliki broj nalazi u paketu *gridDebug*.
#' 
#' 
#' Drugi, veoma popularan paket s kojim æemo se upoznati na teèaju S750 Grafièki sustavi u R-u 2, je *ggplot2* paket. Shema imenovanja elemenata grafièkoga prikaza u paketu *ggplot2* je donekle drugaèija: graf se stvara iz objekta klase  *gTrees*, ne iz jednostavnih grafièkih objekata (*grobova*). Ova razlika proizlazi iz èinjenice što *gTrees* veæ odražava strukturu cijeloga grafa. Imena pojedinih elemenata mogu biti dana kako bi reflektirala njihovu *lokalnu* ulogu u pojedinoj komponenti grafa.
#' 
#' 
#' U uvodu smo napomenuli da miješanje funkcija triju grafièkih sustava u R-u (*base*, *lattice* i *ggplot*) nije jednostavno. Ipak, posljednjih se godina intenzivno razvijaju paketi koji omoguæavaju interoperabilnost, kao izmeðu R grafièkih sustava tako i izmeðu R-a i grafièkih biblioteka pisanih u drugim programskim jezicima, primjerice Javi. S takvim æemo se paketima upoznati u teèaju S750 Grafièki sustavi u R-u 2. Ovdje samo spominjemo paket za kombiniranje funkcionalnosti paketa *grid* s *base* grafikom. Paket omoguæava kombinaciju definiranja *viewport*-ova s klasiènim, *base* sustavom. 
#' 
#' 
#' 
#' \newpage
#' 
#' Poznavanje svega i razvoj paketa *gridGraphics* koji omoguæava mješavinu dva sustava:
#' 
#' 
## ---- echo=T, warning=F, message=F---------------------------------------
#uèitavanje dodatne biblioteke
library(gridGraphics)

#izraðivanje funkcije
pf <- function() plot(mpg ~ disp, mtcars, pch=16)
pushViewport(viewport(x=0, y=0, width=2/3, height=2/3,
                      just=c("right", "bottom")))
#graf
grid.echo(pf, newpage=FALSE)

#' 
#' 
#' 
#' 
#'  ![Novi pristupi: kombiniranje sustava osnovne i *grid* grafike. Izvori: https://www.stat.auckland.ac.nz/~paul/Talks/useR2015/](gridGraphics.png)
#'  
#'  
#' 
#' \newpage
#' 
#' 
#' Takozvana *lattice* grafika je izgraðena na osnovi koncepta generièkoga podruèja crtanja koji nazivamo pogled (engl. *viewport*). Veæ smo se upoznali s konceptom pogleda prilikom upoznavanja s paketom *grid*. *Lattice viewport* je pravokutna regija koju odreðuje korisnik. Korisnik tako može odrediti lokaciju, margine/poravnanje i velièinu pojedinaènog podruèja crtanja/pogleda. Tako jedan pogled/regija/*viewport* može biti cijeli graf, nekoliko grafova, samo jedna margina grafa ili èak pojedinaèni simbol.
#' 
#' 
#' ### Paket(i) *lattice*/*latticeExtra*
#' 
#' 
#' *Lattice* je dodatak na okruženje za statistièko raèunanje u R-u a koje omoguæava skup grafika na razini korisnika i koje je alternativa osnovnim funkcijama R-a. Radi se o implementiranju *Trellis plots* sustava S putem paketa *lattice* koji je pripremio Deepayan Sarkar. Grafika *lattice* je neovisna od osnovnog, *base*  sustava grafike u R-u.
#' 
#' Paket *lattice* nazvan je tako zato što može generirati **Trellis* prikaze. *Trellis* prikaz oznaèava grafove na više panela koji su pogodni za ilustriranje multivarijatnih podataka. Ova naèela su oèita i u broju novih vrsta dijagrama u *Trellisu* i kroz zadani odabir boja, oblika simbola, stilova linija koje omoguæavaju *Trellis* dijagrami. Nadalje, *Trellis* dijagrami omoguæuju karakteristiku poznatu kao uvjetovanje na višestrukim panelima (engl. *multipanel conditioning*), èime se kreiraju višestruki grafièki prikazi podjelom podataka koji se crtaju sukladno razinama zadanih varijabli. Svaki panel grafièki prikazuje podskup podataka. Svi paneli u *Trellis* prikazu sadrže istu vrstu grafa. Podskupovi podataka se biraju na uobièajen naèin, uvjetovanjem u pogledu uvjeta ili diskretnih varijabli u podacima te, stoga, predstavljaju koordiniranu seriju pregleda višedimenzionalnih podataka.
#' 
#' Paket je konstruiran povrh *grid* paketa (*grid* je tzv. *dependency* za *lattice*) koji je pokretaèki stroj koji funkcionira u podlozi. Iz tog razloga je naslijedio i mnoga njegova svojstva. Buduæi da *lattice* grafika u R-u koristi *grid* grafiku u pozadini za stvaranje statistièkih grafika visoke razine on je nezavisan od tradicionalnih *base* funkcija. Dva sustava su u veæini sluèajeva nekompatibilni ali kao što smo veæ rekli, noviji paketi (*gridgraphics*) brišu granicu izmeðu ova dva sustava.
#' 
#' Kao i kod drugih paketa, potrebno je odati priznanje pravilnim citiranjem osoba koje su uložile svoje znanje i vrijeme izradu funkcija paketa. U sluèaju  *lattice* i *latticeExtra* paketa to je:
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=T----------------------------
citation("lattice")

#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=T----------------------------
citation("latticeExtra")

#' 
#' 
#' 
#' 
#' 
#' Unaprjeðenjem korisnièke kontrole nad grafikom, *Trellis* softver èini i da se grafièke funkcije ponašaju kao i bilo koje druge funkcije. Rezultat provoðenja *Trellis* naredbe je objekt klase *Trellis*. Osim ako mu nije dodijeljeno ime ili se koristi u daljnjem izraèunu, *Trellis* objekt se prikazuje (to je zadana opcija u R sustavu za sve klase objekata).
#' 
#' 
#' 
#' 
#' Kako je spomenuto, paket pod nazivom  *lattice* pruža funkcije Trellis grafike. Kada se koristi lattice znaèajno je navesti ureðaj koji koristimo **trellis.device()** prije davanja grafièkih naredbi. 
#' 
#' 
#' **Dobre strane lattice** grafièkoga sustava su:
#' 
#'  * manje potrebe za provoðenjem detaljne kontrole
#'  
#'  * izvrstan za izradu kohezivnih skupina dijagrama.
#' 
#' **Loše strane lattice**: 
#' 
#' * mnogima se sustav èini pretežak i/ili nepoznat kako bi proveli detaljnu kontrolu.
#' 
#' Problem proizilazi iz dizajna sustava koji stvara sve što je potrebno za dijagram u jednoj naredbi korštenjem *grid* paket funkcionalnosti koji su za veæinu korisnika neka vrsta "crne kutije". Ipak, glavni razlog zašto ljudi poènu koristiti *lattice*/*trellis* grafiku je spomenuta funkcionalnost kombiniranja veæega broja panela na razuman naèin. Uvjetovanje na više panela je, doista, veliki napredak u odnosu na osnovnu R grafiku.
#' 
#' 
#' ### Viewports/layouts (predlošci) u *lattice*-u 
#' 
#' Veæ smo se upoznali s konceptom *viewports*, *layouts* i *grobs*. U *lattice* grafici moguæe je definirati predloške (*layouts*) za specifiène poglede (*viewports*) - podjelu roditeljskoga (engl. *parent*) *viewport*-a na retke po stupcima  **razlièite** velièine. Neki podskup polja u predlošcima može se specifirati kao djeca. Dodatno, *viewport*-i se mogu smještati jedan unutar drugoga, te se tako kreira hijerarhijski dizajn. Ovaj sustav slaganja grafièkih objekata (strana - dijagram - podruèja dijagrama) po hijerarhijskom redu je od velike pomoæi u statistièkoj grafici, s obzirom na to da se statistièari koji rade s podacima èesto trude vizualizirati podatke koji sadrže uroðenu hijerarhiju. 
#' *Viewport*-i koje lattice kreira su dostupni korisniku preko **trellis.focus()** funkcije. Funkcije iz *grid* paketa se, takoðer, mogu izravno koristiti.
#' 
#' 
#' Buduæi da je ovaj teèaj odreðena vrsta uvoda, pokušat æemo pružiti pregled neophodnih funkcija, postavki i koncepta kako bi se poèeo rad s paketom *lattice*, ali paket nudi znatno više moguænosti za prilagodbu grafièkih prikaza. Svatko tko se želi više informirati može to uèiniti putem velikoga broja knjiga, tutorijala, primjera i vježbi koje su dostupne putem interneta.
#' 
#' 
#' 
#' ### Lattice ureðaji
#' 
#' Paket *lattice* zadržava svoj vlastiti skup postavki grafièkih parametara koji kontrolira izgled grafa na svakom grafièkom ureðaju. To su parametri poput boje linija, korištenih paleta, fonta teksta, velièine i još dosta toga. 
#' 
#' Zadane postavke za ureðaj ovise o vrsti ureðaja koji se otvara (npr. PostScript,PDF, JPG, PNG ili slièno). Kod jednostavne uporabe to ne uzrokuje probleme zato što lattice automatski inicira ove postavke prvi put kada se producira izlazni rezultat iz *lattice* sustava na ureðaju. Ako je potrebno kontrolirati inicijalne vrijednosti ovih postavki, funkcija **trellis.device()** se koristi kako bi se ureðaj otvorio s odreðenim postavkama *lattice* grafièkih parametara.
#' 
#' 
#' 
## ---- echo=T ,eval=F, message=F, comment=NA, cache=T---------------------
trellis.device()

#' 
#' 
#' 
#' 
#' ### Lattice plot prikazi
#' 
#' *Trelllis* grafika iz *lattice* paketa ima brojne funkcije visoke razine za prikaz razlièitih vrsta podataka. Slijedi podjela vezano za broj varijabli koje se prikazuju na prikazu. Kako je naèelo podskupova podataka ili uvjetovanoga prikaza više panela nešto što na isti naèin funkcionira u svim prikazima  *lattice* pokazat æemo koncept samo na odabranom prikazu. Zbog spomenutoga, za neke prikaze neæemo ni davati primjere.
#' 
#'  
#' Vrste prikaza dostupnih u paketu *lattice* su:
#' 
#' **1) Za jednu varijablu - univarijatni**
#' 
#' * **barchart()** - bar dijagram
#' 
#' * **bwplot()** - komparativni box-i-whisker dijagrami
#' 
#' * **densityplot()** - kernel dijagram gustoæe
#' 
#' * **dotplot()** - Cleveland toèkasti dijagram
#' 
#' * **histogram()** - histogram
#' 
#' * **piechart()** - pita dijagram (statistièari  **NE** preporuèaju uopæe ovaj prikaz!)
#' 
#' * **qqmath()** - teoretski dijagram kvantila
#' 
#' 
#' * **stripplot()** - strip dijagramchart (usporedni 1-D dijagrami raspršenja)
#' 
#' 
#' **2) Dvije varijable, bivarijatni - *bivariate***
#' 
#' * **qq()** - kvantilni dijagram dva uzorka
#' 
#' * **timeplot()** - dijagram vremenskih nizova
#' 
#' * **xyplot()** - dijagram raspršenja
#' 
#' 
#' **3) Tri varijable, trivarijatni - *trivariate***
#' 
#' * **contourplot()** - konturni dijagram površina
#' 
#' * **levelplot()** - dijagrami razina
#' 
#' * **splom()** - dijagram raspršivanja matrice
#' 
#' 
#' **4) 3_D prikazi**
#' 
#' * **wireframe()** - trodimenzionalni dijagram perspektive površina
#' 
#' * **cloud()** - trodimenzionalni dijagram raspršenja
#' 
#' * **parallel()** - dijagram paralelnih koordinata.
#' 
#' 
#' Tijekom ovog teèaja upoznat æemo se samo s nekima od spomenutih prikaza. Dodatne funkcije visoke razine (prikazi) pripremljene su i dostupne kroz paket *latticeExtra*. Za dodatne informacije pogledati: (https://cran.r-project.org/web/packages/latticeExtra/latticeExtra.pdf).
#' 
#' 
#' 
#' 
#' ### Opæe karakteristike prikaza u *latticeu*
#' 
#' Svaki spomenuti tip prikaza u *latticeu* povezan je s odgovarajuæom funkcijom visoke razine (poput histograma). Prikaz se sastoji od razlièitih elemenata koji se koordiniraju sa zadanim parametrima kako bi pružili smislene rezultate, ipak, svaki element korisnik može kontrolirati neovisno od drugih. Kljuèni elementi prikaza su:
#' 
#' * **primarni prikaz** - panel
#' 
#' * **oznaka osi**
#' 
#' * **oznaka trake** (procesa uvjetovanja)
#' 
#' * **legende** (proces grupiranja).
#' 
#' 
#' Svaka vrsta prikaza povezuje se s odgovarajuæom funkcijom visoke razine (histogram, dijagram gustoæe itd). Dodatno, trellis prikazi su definirani ulogama varijabli:
#' 
#' 
#' * **primarne varijable:** one koje definiraju primarni prikaz
#' 
#' * **uvjetujuæe varijable:** dijele podatke na podskupine, od kojih se svaka prikazuje u razlièitim panelima
#' 
#' * **grupirajuæe varijable:** podskupine su suprotstavljene unutar panela tako što su postavljene na odgovarajuæim prikazima.
#' 
#' 
#' Za kontrolu i prilagodbu stvarnoga prikaza u svakom panelu, stranica pomoæi odgovarajuæe zadane funkcije panela èesto æe biti informativnija. Posebno, stranice pomoæi opisuju brojne argumente koji se, opæenito, koriste kada se poziva odgovarajuæa funkcija visoke razine ali koje su specifiène za te konkretne panele.
#' 
#' U svakom sluèaju, dodatni argumenti pozivanja funkcija visoke razine mogu se koristiti kako bi se aktivirali opæi varijeteti, dozvoljena je potpuna fleksibilnost putem proizvoljnih funkcija koje definira korisnik. Ovo je posebno korisno za kontroliranje primarnoga prikaza putem panel funkcija (http://lattice.r-forge.r-project.org/Vignettes/src/lattice-intro/lattice-intro.pdf). Jedna od funkcija koje su dostupne u  *latticeExtra*, a koja je od velike pomoæi u statistièkoj vizualizaciji je funkcija za izraðivanje *trellis* prikaza za funkciju empirijske kumulativne distribucije **ecdfplot()**.
#' 
#' 
#' 
#' *Lattice* prikaz se sastoji od razlièitih elemenata koji su koordinirani razlièitim parametrima kako bi dali smislene rezultate. Kljuèni elementi *lattice* prikaza su:
#' 
#' * **primarni prikaz** - panel
#' 
#' * **oznaka osi**
#' 
#' * **oznaka trake** (opisuje proces uvjetovanja)
#' 
#' * **legende** (tipièno opisuju proces grupiranja).
#' 
#' Korisnik može kontrolirati svaki element kao je to potrebno. Postoji moguænost pružanja dodatnih argumenata pozivanjima funkcija visoke razine kako bi se aktivirale zadane vrijednosti ili putem kreiranja funkcija koje korisnik proizvoljno definira.
#' 
#' 
#' Trellis prikazi su definirani vrstom grafike i ulogom koju razlièite varijabe u njoj igraju. Svaka vrsta prikaza povezana je s odgovarajuæom funkcijom visoke razine (histogram, dijagram gustoæe itd.). Moguæe uloge ovise o vrsti prikaza ali, su tipiène: 
#' 
#' * **primarne varijable:** one koje definiraju primarni prikaz
#' 
#' * **uvjetujuæe varijable:** dijele podatke na podskupine, svaka od njih predstavlja razlièite panele
#' 
#' * **grupirajuæe varijable:** podskupine se porede unutar panela tako da se prikazuju u odgovarajuæim prikazima.
#' 
#' 
#' Sjetimo se od ranije da su dva kljuèna cilja statistièke grafike: 
#' 
#'  1) olakšati usporedbe
#' 
#'  2) identificirati trendove. 
#' 
#' Mnogi smatraju *lattice* grafiku boljom od tradicionalne u postizanju spomenutih ciljeva.
#' 
#' 
#' **graph_type(formula, data=)**
#' 
#' gdje je graph_type odabran iz prethodno navedenih. Formula precizira varijablu(e) koje æe se prikazati i bilo koje uvjetujuæe varijable. Na primjer:
#' 
#' * **~x|A** - prikaz numerièke varijable x za svaku razinu faktora A
#' 
#' * **y~x | A*B** - prikaz odnosa izmeðu numerièkih varijabli y i x odvojeno za svaku kombinaciju razine faktora A i B
#' 
#' * **~x** znaèi prikaz same numerièke varijable x. 
#' 
#' 
#' 
#' Dodatno æemo objasniti ulogu  uvjetujuæih varijabli i dodatnih grafièkih prikaza u razlièitim funkcijama visoke razine. Naèin kreiranja višestrukih panela i ostale postavke panela su slièni su u svim drugim prikazima u paketu. 
#' 
#' 
#' Nakon preciziranja formule za lattice prikaz, moguæe je dati dodatne argumente poput podataka, podskupa i mnogo drugoga. Prije korištenja bilo koje od funkcija za izraðivanje prikaza, upoznajte se s funkcijom kroz njenu informacijsku karticu.
#' 
#' 
#' Lattice, funkcije visoke razine, ne crtaju graf, one samo kreiraju objekt tipa trellis. Taj objekt sadrži sve elemente grafa. Kada pozovemo funkciju trellis implicitno dajemo naziv objekta R-u. Zapamtite da je zadano ponašanje R-a da pokuša nacrtati objekt. Alternativno, možemo precizno dodijeliti rezultat trellis funkcije odreðenom objektu poput g1 <- histogram (~x).
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' ### Grafièki parametri za *Trellis* prikaze
#' 
#' Postoji mnogo moguænosti u *lattice* paketu za prilagodbu grafa kroz pripremljene funkcije postavki, ali i kroz moguænost prilagodbe kroz funkcije koje definira korisnik.
#' 
#' Razlièiti grafièki parametri (boja, vrsta linije, podloga itd.) koji kontroliraju izgled trellis prikaza, vrlo su podložni prilagodbi ali to nije uvijek lako za korisnika. Takoðer, R može proizvesti grafove na nizu ureðaja i oèekuje se da razlièiti skupovi parametara bolje odgovaraju nekim razlièitim ureðajima. Ovi se parametri pohranjuju interno u varijabli koja se naziva *lattice.theme*, koja predstavlja listu onih komponenti koje definiraju postavke za odreðene ureðaje. Komponente se identificiraju nazivom ureðaja koji predstavljaju. Ako nismo sigurni koji nam je zadani grafièki ureðaj možemo unijeti **.Device** u R konzolu da dobijemo odgovor.
#' 
#' 
#' Inicijalne postavke svakoga ureðaja imaju zadane vrijednosti koje odgovaraju tom ureðaju. Kada je ureðaj jednom otvoren, njegove æe se postavke mijenjati. Kada se drugom prilikom isti ureðaj otvori kasnije uporabom *trellis.device*, postavke za taj ureðaj æe se resetirati na polazne, osim ako nije drugaèije precizirano u pozivanju *trellis.device*. Postavke za razlièite ureðaje se tretiraju odvojeno tako da otvaranje PDF ureðaja sa zadanim postavkama neæe promijeniti postavke postScript-a, koje æe ostati kad god je ureðaj aktivan.
#' 
#' Ako želimo saèuvati svoj dijagram *lattice*/*trellis* na odreðenom ureðaju, na primjer PNG, proces je isti kao i ranije opisani za R *osnovnu* grafiku: 1) inicirate (otvorite) željeni grafièki ureðaj; 2) crtajte u ureðaju i 3) zatvorite ureðaj.
#' 
#' 
#' 
#' 
#' 
#' ### Kontroliranje grafièkih parametara u grafici temeljenoj na *grid/lattice* 
#' 
#' U ovom dijelu uvodimo najznaèajnije parametre za kontroliranje izgleda grafike koja se priprema pomoæu funkcija iz *lattice* paketa.
#' 
#' 
#' 
#' 
#' #### Funkcija **show.settings()** {lattice}
#' 
#' 
#' Mnogi aspekti *lattice* grafike su odreðeni trenutaènom temom. Tema je velika lista grafièkih parametara koji pružaju detaljnu kontrolu grafike u lattice-u. Mnogi od naziva se sami objašnjavaju, posebno kada se vide uz izlazni rezultat **show.settings()**. Kako biste dobili vizualni pregled postavki, unesite:
#' 
#' 
#' 
#' 
## ----fig.width=7, fig.height=4,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Trenutaèno važeæe postavke za *Trellis* ureðaj", cache=F----
show.settings()

#' 
#' 
#' 
#' Ako želimo promijeniti grafièke postavke otvorenog ureðaja, jedna od opcija koju imamo je sljedeæa:
#' 
#' 
## ---- echo=T , eval=T, message=F, comment=NA, cache=F--------------------
trellis.device('png', color=FALSE) 

#' 
#' 
#' Vizualiziranje rezultata promjena:
#' 
#' 
#' 
## ----fig.width=7, fig.height=4,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Postavljanje postavki *Trellis* ureðaja na crno-bijelu opciju", cache=F----
show.settings()

#' 
#' 
#' Komentirajte rezultat!
#' 
## ---- echo=F , eval=T, message=F, comment=NA, cache=F--------------------
trellis.device('png', color=T) 

#' 
#' 
#' 
#' 
#' #### Functions **trellis.par.get()** / **trellis.par.set()**{lattice}
#' 
#' Ove dvije funkcije omoguæavaju postavku grafièkih parametara dijagrama *lattice* (*trellis*). Na neki naèin, **trellis.par.get** i **trellis.par.set** su zajedno zamjena za **par()** funkciju iz tradicionalne R grafike. Posebno, promjena par postavki ima malo (ako imalo) utjecaja na *lattice* ispis. Buduæi da se lattice dijagrami implementiraju pomoæu *grid* grafike, sustav njegovih parametara nemaju utjecaja osim ako ih ne "pregazi" odgovarajuæa postavka *lattice* parametra. Ovi parametri mogu se specificirati dijelom kao *lattice* tema (engl. *lattice theme*) unutar *grid.pars* komponente. Za detaljnije informacije pogledati *gpar()* listu validnih imena grafièkih parametara.
#' 
#' 
#' 
#' Sve elemente lattice grafa kontroliraju *trellis* postavke. Korisnicima rijetko treba da se izravno dotièu i mijenjaju *trellis* postavke, jer do veæine parametara mogu doæi i izravno i promijeniti ih putem opæe funkcije prikaza (engl. *general display function*) ili panel funkcije. Odreðeni parametri (npr., "brkovi" u box dijagramu) mogu se promijeniti samo kroz *Trellis* postavke.
#' 
#' Za dodatne informacije o funkcijama unesite:
#' 
## ---- echo=T ,eval=F, message=F, comment=NA, cache=T---------------------
?trellis.par.get

#' 
#' 
#' 
#' #### Funkcija **trellis.par.get()**
#' 
#' Kada se funkcija poziva bez ikakvih argumenata, ispis je potpuni popis postavki za aktivni ureðaj. Kada je prisutan argument imena, povratno æe ispisati samo tu komponentu. Kako biste vidjeli detalje Vaše trenutaène teme, koristite **trellis.par.get()** funkciju. 
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=T----------------------------
str(trellis.par.get(), max.level = 1)

#' 
#' 
#' 
#' 
#' #### Funkcija **trellis.par.set()** 
#' 
#' 
#' 
#' Izmjene parametara mogu se provesti od strane korisnika pomoæu **trellis.par.set()** funkcije što se, tipièno, radi na sljedeæi naèin (primjer za parametar *add.line*). Funkcija **trellis.par.set()** može se koristiti za modifikaciju *trellis* postavki unutar aktivne R sesije.
#' 
#' 1) Postojeæe postavke parametara ispitujemo:
#' 
## ---- echo=F , message=F, comment=NA, cache=F----------------------------
old_theme <- trellis.par.get()

#' 
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=T----------------------------
str(trellis.par.get("plot.line"))

#' 
#' Uoèite da je linija definirana s 4 parametra: **alpha**, **col**, **lty** and **lwd**. Veæ smo upoznati sa svim ovim parametrima iz **base** grafike, grafièkim parametrima iz paketa **graphics**. Ako želimo promijeniti odreðeni element ili elemente s te liste, npr. širinu i boje za linije, trebamo napraviti sljedeæe:
#' 
#' 
## ----fig.width=6, fig.height=4,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Promjena nekih postavki Trellis ureðaja", cache=F----

#izraðivanje podataka
x <- rnorm(100, 20, 3)

#postavljanje grafièkih parametara za aktivnu R sesiju
trellis.par.set(plot.line = list(lwd=4, col = "darkred"))

#crtanje dijagrama
densityplot(x) 

#' 
#' 
#' Ako želimo postavke *trellis* grafike vratiti na prvobitno stanje, ponovno koristimo funkciju **trellis.par.set()**.
#' 
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=T----------------------------
#povratak na stare postavke
trellis.par.set(plot.line = list(lwd=1, col = "#0080ff"))

#' 
#' 
#' 
#' 
#' Buduæi da postoji moguænost promjene grafièkoga izgleda na razini specifiènoga grafa visoke razine, najuobièajeniji (najlakši) naèin rada u *lattice* grafici je poput ovoga u sljedeæem primjeru. Na taj smo naèin promijenili funkciju generalnoga izgleda (engl. *general display function*).
#' 
#' 
## ----fig.width=6, fig.height=4,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Promjena nekih postavki *Trellis* ureðaja", cache=F----
#postavljanje grafièkih parametara
x <- rnorm(100, 20, 3)

#zapamtiti da su neki parametri isti kao i u  par() {graphics}
#plot
densityplot(x, 
            lty=2, 
            lwd=3, 
            col="black", 
            plot.symbol=22) 

#' 
#' 
#' 
#' 
#' \newpage
#' 
#' 
#' 
#' 
#' Primjeri za korištenje  *par.settings*:
#' 
#' 
#' Zapamtiti: grafièki parametri za elemente u *Trellis* dijagramima mogu se mijenjati (primijeniti) samo u jednom pozivanju naredbe, uporabom *par.settings()** argumenta za bilo koje pozivanje visoke razine *latticea*. Drugi naèin je promjena globalnih postavki, što æe se primijeniti na sve funkcije visoke razine u *latticeu* putem **trellis.par.set()** funkcije kojom se daju argumenti željenih postavki za lattice dijagrame. Jedan primjer je kada æemo definirati boje, vrste linija, boju pozadine za trake panela i staviti sve u objekt *my.settings*. 
#' 
#' 
#' Prvo nacrtamo zadane grafièke parametre za *Trellis* ureðaj:
#' 
## ---- echo=T , message=F, comment=NA, cache=T----------------------------
trellis.par.set(old_theme)

#' 
#' 
## ----fig.width=6, fig.height=7,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Zadane postavke za trellis funkciju visoke razine; bw dijagram za podatke bugs_data", cache=F----
#plot high-level Box-Whisker plot

bwplot(COUNT ~ A_L_P | POS_lab, data = bugs_data[bugs_data$OBJ=="2",],
               layout = c(1,3), stack = F, drop.unused.levels = F,
               auto.key = list(space = "right"),
               main="Zadane grafièke postavke",
               ylab = "NO")

#' 
#' 
#' \newpage
#' 
#' Sada æemo promijeniti neke grafièke parametre, a te æe se promjene primijeniti samo na *lattice* funkciju unutra; u našem primjeru smo kreirali **temu** (bit æe objašnjeno u narednom odjeljku) grafièkih parametara koji æe se mijenjati. Molim komentirajte svaku liniju kôda koji slijedi:
#' 
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=F----------------------------
#definira se lista grafièkih postavki koje æe se promijeniti u prikazu 
my.settings <- list(
      plot.symbol  =list(col=c("black"),pch=c(20), cex=0.5),  
      box.umbrella=list(col= c("dark gray"),lwd=1, lty=1),
      box.dot=list(col= c("lightpink3"), cex=0.8, pch=22),
      box.rectangle = list(col= c("black"),lwd=1),
      superpose.polygon=list(col="lightpink3", border="transparent"),
      strip.background=list(col="lightpink4"),
      strip.border=list(col="black")
                    ) #zatvaramo listu postavki koje mijenjamo


#' 
#' Sada, primijenit æemo definirane postavke na dijagram tipa Box-Whisker. Možemo primijeniti postavke svaki put kada koristimo Box-Whisker dijagrame bez potrebe za promjenom *general display function*.  
#' 
## ----fig.width=6, fig.height=7,echo=FALSE,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Grafièke postavke definirane od strane korisnika unutar trellis funkcije visoke razine", cache=F----
bwplot(COUNT ~ A_L_P | POS_lab, data = bugs_data[bugs_data$OBJ=="2",],
              layout = c(1,3), stack = F, drop.unused.levels = F,
              auto.key = list(space = "right"),
              main="Postavke koje je korisnik definirao",
              ylab = "NO",
              par.settings = my.settings)

#' 
#' 
#' 
#' #### Teme u *lattice* grafici {Lattice/LatticeExtra}
#' 
#' 
#' Prije nego isprobamo napraviti dodatne prilagodbe grafièkih prikaza u *latticeu*, kljuèno je razumjeti koncept **theme** u *lattice*/trellis postavkama. Kako smo veæ vidjeli, možemo doæi do potpunog popisa grafièkih parametara za odreðeni ureðaj putem **trellis.par.get()** funkcije. Moguæe je promijeniti svaki element sa tog popisa. Korisnici obièno mijenjaju te postavke putem mijenjanja *general display function* izravno kad pozivaju neku funkciju visoke razine, kao što se vidi iz prethodnog primjera. Ali, ponekad želimo promijeniti više elemenata i koristiti iste postavke u cijeloj R sesiji. Tada je korisno definirati koji elementi od onih opisanih na popisu grafièkih elemenata želimo promijeniti, zajedno sa definiranim promjenama u postavkama. Svi grafièki parametri koji se mijenjaju u **otvorenom ureðaju** mogu se saèuvati kao  teme (engl. *theme* u *latticeu*.  Dakle, **theme** je popis grafièkih parametara koji se trebaju promijeniti **ili** funkcija koja, kada je pozvana, proizvodi takav popis. Ako  postoje grafièki parametri koji nisu navedeni u *temi* (ili koje funkcija generira), ti se parametri neæe promijeniti i koristi æe se zadane vrijednosti. Izraðivanje korisnièke funkcije za temu jako je korisno kada se sliène postavke žele primijeniti u veæem broju grafièkih prikaza.
#' 
#' 
#' Rad s temama: ovo je, uglavnom, opcija za korisnika, ali u primjeru koji slijedi pokazat æemo jedan od najlakših naèina. Saèuvat æemo zadane postavke u objektu pod nazivom old_theme da ih ponovno možemo pozvati kasnije. To napravimo unosom:
#' 
#' 
#' 
## ---- echo=T ,eval=T, message=F, comment=NA, cache=F---------------------
#u ovom sluèaju trellis postavka za otvoreni ureðaj - RStudioGD
old_theme <-trellis.par.get()

#' 
#' Sada imamo popis 35 grafièkih elemenata (duljina 35 za grafièki ureðaj RStudioG) u objektu **old_theme**. Možemo napraviti novu kopiju liste parametara i pohraniti je u objekt pod nazivom **new_theme** (ili bilo koje proizvoljno ime poput **my_bw_theme**, **theme_for_phd**, **theme_my_colors**) i promijeniti elemente u skladu sa svojim preferencijama.
#' 
#' 
## ---- echo=T ,eval=T, message=F, comment=NA, cache=F---------------------
#u ovom sluèaju postavka za otvoreni trellis ureðaj - RStudioGD
#izraðivanje objekta (liste) koji æe se mijenjati
new_theme <-trellis.par.get()

#' 
#' 
#' Možemo koristiti bilo koji od tih popisa kada to želimo. Promijenit æemo izgled simobola na grafu (**plot.symbol**), boju pozadine (engl. *background*) i širinu/vrste linija (**plot.line**). U narednim primjerima æemo promijeniti izgled rezultirajuæega grafièkog prikaza na nekoliko naèina. Najznaèajnije je razumjeti kôd i dobiti oèekivani rezultat. Naèin na koji æe neki mijenjati postavke ovisi o ukusu i preferencijama osobe.
#' 
#' 
## ---- echo=T ,eval=T, message=F, comment=NA, cache=F---------------------
#mijenja se pozadina
new_theme$background$col <- "lightgray"

#promjena širine linije na dijagramu
new_theme$plot.line$lwd <- 4

#promjena vrste linije na dijagramu
new_theme$plot.line$lty <- 2

#promjena boje linije
new_theme$plot.line$col <- "darkblue"

#promjena boje simbola na dijagramu
new_theme$plot.symbol$color<- "darkseagreen"

#promjena velièine simbola na dijagramu
new_theme$plot.symbol$cex<- 1.3

#promjena izgleda naslova
new_theme$par.main.text.col<-"darkred"

#promjena skupine fonta
new_theme$par.main.text.fontfamily <- "Arial"

#' 
#' 
#' Sada æemo primijeniti nove postavke, prikazati postavke i nacrtati jednostavni dijagram raspršivanja koristeæi stare i nove postavke:
#' 
## ----fig.width=6, fig.height=4,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Nove grafièke postavke *trellis.par.set*", cache=F----
#new settings
trellis.par.set(new_theme)
show.settings()

#' 
## ----fig.width=6, fig.height=4,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Nove grafièke postavke; nekoliko elemenata uporabom popisa parametara koji æe se mijenjati - *theme*", cache=F----
densityplot(x, main="Nove postavke s parametrima new_theme") 

#' 
#' 
#' 
## ---- echo=T ,eval=T, message=F, comment=NA, cache=F---------------------
trellis.par.set(old_theme)

#' 
#' 
#' 
#' Sada æemo se vratiti na izvorne, stare postavke, pogledajte:
#' 
## ----fig.width=6, fig.height=4,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Nove postavke", cache=F----
densityplot(x, main="Povratak postavki na parametre old_theme") 

#' 
#' 
#' Opisani naèin je jedan od mnogih kojima se može manevrirati popisom grafièkih parametara. U dijelu koji slijedi promijenit æemo nekoliko elemenata u **new_theme** i pokušati prelaziti s jednog na drugi od dva popisa  grafièkih parametara. 
#' 
#' 
#' Toènije, lakše bi bilo staviti sve željene promjene odjednom, zajedno na listu grafièkih parametara koji æe se mijenjati, *theme*, kada se pozove. Moguæe je definirati vlastite teme u *latticeu* i prelaziti izmeðu te vlastite teme i one koja je zadana "u letu" (engl. "on-the-fly"):
#' 
## ---- echo=T ,eval=F, message=F, comment=NA, cache=F---------------------
#zadana tema
trellis.device(new = FALSE, theme = NULL)

#funkcija moje definirane teme
#trellis.device(new = FALSE, theme = my_theme)

#povratak na zadanu kada se želi
trellis.device(new = FALSE, theme = NULL)

#' 
#' 
#' Postoje pripremljena suèelja za izraðivanje prilagoðenih preferiranih tema, kao što je **simpletheme()** funkcija koja omoguæava promjenu podskupa parametara, jednostavnija je u strukturi, s obzirom na to da traži vektorske vrijednosti umjesto popisa za preciziranje **theme**. Dodatna funkcija koja pomaže izraditi *lattice* **theme** je **custom.theme()** funkcija. Funkcija kreira **theme** dajuæi nekoliko boja. Dodatno, postoji moguænost uporabe dodatnih, pripremljenih tema poput **col.whitebg()** ili **theme.mosaic()**. Kako smo spomenuli integraciju *base* i *lattice* grafike, tako postoje i funkcije koje, primjerice, *latticeExtra* paketom oponašaju *ggplot* grafiku putem temom **ggplot2like()**.
#' 
#' U narednom primjeru dajemo primjer stvaranja korisnièke teme s *BuPu* paletom *RColorBrewer* paketa. Tijekom ovog primjera dodatno  æemo se upoznati/podsjetiti na naèin *updatea* postojeæega *Trellis* objekta dodijeljenoga varijabli p, za što trebamo funkcionalnosti paket *LatticeExtra*:
#' 
#' 
## ---- echo=T ,eval=T, message=F, warning=FALSE, comment=NA, cache=F------
#u ovom sluèaju postavka za otvoreni trellis ureðaj - RStudioGD
trellis.par.get(old_theme)

#' 
#' 
## ----fig.width=7, fig.height=6,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Izraðivanje *lattice* dijagrama za kasnije ažuriranje pomoæu *custom.theme* bojanja", cache=F----

#cijeli *Trellis* objekt dodjeljujemo varijabli p
p <- xyplot(lifeExp ~ gdpPercap | continent,
  data=lattice_data,
  grid = TRUE,
  group= country,
  scales = list(x = list(log = 10, equispaced.log = FALSE)),
  type = c("p"), lwd = 4, alpha = 0.5)

#crtamo varijablu p - Trellis objekt  
p

#' 
## ----fig.width=7, fig.height=6,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Osvježenje postojeæeg trellis objekta s *custom.theme*", cache=F----
update(p, par.settings =  canonical.theme(color = FALSE))

#' 
#' 
#' Nakon nekoliko primjera vratit æemo se na skup podataka *lattice_data*, ponovno, i prezentaciji podataka dati konaèni izgled. Prilagodit æemo svaki element grafa odvojeno, ali prije toga važno je upoznati se sa definicijom i konceptom panela (engl. *panels*) u *lattice* grafici.
#' 
#' 
#' 
#' 
#' 
#' ### Panel funkcije u *lattice* grafici {LatticeExtra}
#' 
#' Stvaranje *Trellis* grafièkoga prikaza je proces od dva koraka:
#' 
#' 
#'  U prvom koraku, *high-level* funkcija aktivira tzv. *funkciju generalnog prikaza* (engl. *general display function*) te kreira vanjske komponente prikaza kao što su okvir, osi, labele i drugi elementi grafa. U drugom koraku *general display function* poziva funkciju panela (engl. *panel function*) koja je odgovorna za sve što se crta u pojedinom panelu.
#' 
#' Svaki grafièki prikaz u *lattice* grafici ima svoju predodreðenu (engl. *default*) panel funkciju. Ime te funkcije je uvijek ime grafièkoga prikaza s prefiksom *panel*. Na taj naèin za funkciju **barchart()** postoji **panel.barchart()** panel funkcija; za **xyplot()** adekvatna **panel.xyplot()** i tako dalje redom za ostale prikaze. Panel funkcija prikaza poziva se uz pomoæ *panel* argumenta opæega prikaza (engl. *general display*). Pogledajmo sintaksu za **xyplot()**:
#' 
## ---- eval=F,  echo=T, warning=F, message=F------------------------------
## xyplot(y ~x, data=my_data,
##              panel=panel.xyplot)

#' 
#' Svaki argument koji promijenimo u *general display function* utjecat æe na sve na cjelokupnom grafièkom prikazu; izravno se prenose na *panel* funkciju. U sljedeæem primjeru mijenjamo *general display function*:
#' 
#' 
## ---- eval=T,  echo=T, warning=F, message=F------------------------------
#pripremamo podatke za crtanje
x <- seq(0,pi,0.1)
y1 <- cos(x)
y2 <- sin(x)
my_data <- data.frame(x, y1, y2)

#' 
## ----fig.width=6, fig.height=5,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Grafièki parametri promijenjeni putem *general display function*", cache=F----
#graf
xyplot(y1~x, data=my_data,
       main="Parametri mijenjani kroz *general display function*",
       col="darkred", pch=22)

#' 
#' Argumenti poput *col*, *cex* i *pch* uvijek mijenjaju *general display function* (u našem primjeru histogram) i izravno su dani *panel.histogram* funkciji i kao takvi æe bit primijenjeni na cjelokupan prikaz.
#' 
#' Drugi naèin promjene elemenata lattice prikaza je pozivom i modifikacijom *panel* funkcije izravno, pripremajuæi novu panel funkciju kojom æemo zamijeniti staru.
#' 
#' 
#' 
## ----fig.width=6, fig.height=5,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Grafièki parametri mijenjuæi *panel* funkciju izravno", cache=F----
#graf
xyplot(y2~x, data=my_data,
       main="Promjena parametara kroz panel funkciju",
            panel = function (x, y) {
            panel.xyplot (x, y, 
                          col="lightblue", 
                          pch=16, 
                          cex=3)   
                               }
       )

#' 
#' 
#' Treæi naèin promjene elemenata grafièkog prikaza je definiranje izgleda pojedinog parametra korištenjem  **trellis.par.set()** funkcije. Na ovaj naèin postavke ostaju aktivne tijekom cijele R sesije. U sljedeæem primjeru na ovaj æemo naèin promijeniti neke grafièke parametre te ih zatim vratiti na *default* vrijednosti.
#' 
## ----fig.width=6, fig.height=5,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Grafièki parametri za pojedinu R sesiju", cache=F----
#postavljanje grafièkih parametara za R sesiju
trellis.par.set(plot.symbol = list(pch = 19, 
                                   cex = 2,
                                   col = "darkseagreen"),
                plot.line = list(alpha = 0.8, 
                                   lwd = 3,
                                   col  = "red4"),
                strip.background = list(col="lightgray"))
#graf
xyplot(y2~x, data=my_data,
       type = c("p", "smooth"),
       main="Promjena grafièkih parametara koja vrijedi tijekom R sesije")

#' 
#' Višestruke panel funkcije se èesto koriste simultano. Dodatno, panel funkcije mogu se koristiti i za dodavanje pojedinih elemenata grafièkoga prikaza:
#' 
#'  - *panel.abline* - crta ravnu liniju na zadanom položaju
#'  
#'  - *panel.lmline* - crta regresijsku liniju na diajgram raspršenja (engl. *scatterplot*)
#'  
#'  - *panel.loess* - crta *loess fit* na dijagram raspršenja 
#'  
#'  - *panel.text* - dodaje tekst.
#'  
#' Jedna veoma korisna karakteristika panel funkcija je moguænost selektivne modifikacije elemenata grafièkog prikaza prema nekom zadanom pravilu. U sljedeæem primjeru definiramo razlièitu boju toèaka prema zadanom pravilu:
#' 
#' 
#' 
## ---- fig.width=6, fig.height=5,eval=T,  echo=T, warning=F, fig.cap="Grafièki parametri za razlièit podskup podataka - zadovoljenje uvjeta za podskup podataka",message=F, cache=F----
#graf
xyplot(y1 ~ x, data = podaci_1,
  col = "black",
  panel = function (x, y) {
  panel.xyplot(x[x <= mean(x)], y[x <= mean(x)], col = "darkred")
  panel.xyplot(x[x > mean(x)], y[x > mean(x)], col = "gray")
}
)

#' 
#' 
#' Pažljivo pogledajte gornji primjer i odgovorite na koji je naèin definirana vrijednost parametra **cex**? Na koji naèin možete promijeniti vrijednost parametra na *default* vrijednost?
#' 
#' 
#' ### Multi-panel uvjet u paketu *lattice*
#' 
#' Lattice grafika je veoma korisna ako želimo raditi zasebne panele prema nivoima faktora neke varijable.
#' 
#' 
#' Postoji nekoliko funkcija u *lattice* paketu koje su stvorene za prikaz odnosa izmeðu nekoliko varijabli. Predstavljanje odnosa u multivarijatnim skupovima podataka veæ je dugo vremena izazov. 3D dijagrami raspršenja (engl. *3D scatterplots*) su još uvijek prikladna vizualizacija za podatke do maksimalno tri varijable, ali ovaj pristup je nemoguæ kada je broj dimenzije (varijabli) veæi od tri. *Lattice* grafika koristi strategiju višestrukih panela. Koncept višestrukih panela temelji se na održavanju potencijalno važnih varijabli konstantama. Za ilustraciju ovoga koncepta, pokušajte zamisliti skup podataka s tri varijable, var1, var2 i var3 na kojem želimo pokazati odnos (engl. *scatterplot*) var1 i var2 u nekom intervalu varijable var3. Lattice grafika æe proizvesti takav podskup grafova za svaki interval varijable var3 rasporeðenih u pravokutni uzorak (zbog toga je naziv  *trelllis*/rešetke). Na ovaj naèin izlaganja još moguæe otkriti i prikazati složenu multivarijatnu strukturu podataka.
#' 
#' 
#' 
#' **Rješenja za preklapanja podataka na grafu**
#' 
#' 
#' Ovisno o tome nastojimo li predoèiti jednu ili više varijabli na istom grafu, statistièari se èesto suoèavaju s problemom preklapanja podataka kada više od jednog grafièkog objekta treba nacrtati na istim koordinatama, što skriva dio informacije. U univarijantnom okruženju, možemo takav problem riješiti uz pomoæ *jitter* argumenta (na primjer u funkciji **stripplot()**). U dijagramima raspršenja rješenje za preklapanje može biti korištenje argumenta *alfa*; transparentnosti toèaka ili putem argumenta odgovarajuæega panela, primjerice, panel = **panel.smoothScatter()**. Usporedite rješenja u sljedeæa dva primjera. Važno: ne podržavaju svi grafièki ureðaji **alfa** transparentnost.
#' 
#' 
#' 
## ----fig.width=10, fig.height=8,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Razdvajanje podataka prema nivou faktorske varijable; podaci za jednu godinu", cache=F----
xyplot(lifeExp ~ gdpPercap | continent, 
       data=lattice_data[lattice_data$year=="2007",], 
       grid = TRUE, 
       scales = list(x = list(log = 10, equispaced.log = FALSE)),
       type = c("p", "smooth"), lwd = 4, alpha = 0.5)

#' 
#' 
#' \newpage
#' 
#' Pronaðite u sljedeæem primjeru parametar koji mijenja izgled prikaza:
#' 
#' 
## ----fig.width=10, fig.height=8,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Rješenja za preklapajuæe podatke kroz *panel*", cache=F----
xyplot(lifeExp ~ gdpPercap | continent, 
       data=lattice_data[lattice_data$year=="2007",], 
       grid = TRUE,
       scales = list(x = list(log = 10, equispaced.log = FALSE)),
       panel = panel.smoothScatter)

#' 
#' Usporedite i komentirajte prethodni i sljedeæi primjer. Kao što smo ranije onemoguæili boju na otvorenom grafièkom ureðaju, sada mijenjamo izgled pojedinoga grafièkog elementa. Želimo drugaèiju boju simbola za svaki nivo faktora *country*. Ovo je uobièajen naèin definiranja boja za razine nekih faktora varijable u R-u; èuvaju se podatci o željenoj boji za svaki element zajedno s mjerenjima (engl. *data*) u istom objektu, u našem sluèaju **data.frame** klasa naziva *lattice_data*. 
#' 
## ---- eval=T,  echo=T, warning=F, message=F------------------------------
trellis.par.set(superpose.symbol = list(pch = 19, cex = 1,
                                        col = lattice_data$country_color))

#' 
#' 
#' 
## ----fig.width=10, fig.height=8,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Razlièiti podskupovi podataka za nivoe faktora; promjena kroz *general display function* ", cache=F----
xyplot(lifeExp ~ gdpPercap | continent, 
       data=lattice_data, 
       grid = TRUE, 
       group= country,
       scales = list(x = list(log = 10, equispaced.log = FALSE)),
       type = c("p"), lwd = 4, alpha = 0.5)

#' 
#' 
#' Ovaj rezultat je veæ blizu onoga što smo željeli. Jedino što još uvijek nije kako želimo jest parametar/element grafa *strip.background* i mi æemo ga promijeniti na dva naèina: 1) izravno u funkciji visoke razini (engl. *high-level*) **xyplot()** funkcije i 2) definiranjem **trellis.par.set()** stvaranjem xy_plt_setting popisa za daljnje korištenje.
#' 
#' 
#' 
#' 
## ----fig.width=10, fig.height=8,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Razlièiti podskupovi podataka za nivoe faktora; promjena kroz *general display function*", cache=F----
xyplot(lifeExp ~ gdpPercap | continent, 
       data=lattice_data, 
       grid = TRUE, 
       group= country,
       scales = list(x = list(log = 10, equispaced.log = FALSE)),
       type = c("p"), lwd = 4, alpha = 1/2, 
       strip.background=list(col="lightpink4"))
                                  

#' 
#' I drugo rješenje, funkcija **trellis.par.get()** koji æe se primjenjivati na sve *stripe.background* tijekom aktivne R sesije.
#' 
#' 
#' 
#' 
## ----fig.width=10, fig.height=8,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Razlièiti podskupovi podataka za nivoe faktora; **trellis.par.set()**", cache=F----
#grafièke postavke za aktivnu R sesiju
xy_plt_setting <- trellis.par.set(strip.background=list(col="mistyrose3"))

#plot the data
xyplot(lifeExp ~ gdpPercap | continent, 
       data=lattice_data, 
       grid = TRUE, 
       group= country,
       scales = list(x = list(log = 10, equispaced.log = FALSE)),
       type = c("p"), lwd = 4, alpha = 1/2,
       par.settings = xy_plt_setting)                              

#' 
#' 
#' 
#' 
#' ### Grafièki parametri koji kotroliraju regiju crtanja
#' 
#' U ovom æemo dijelu nastojati pokazati kako postiæi dodatnu kontrolu nad *lattice* grafièkim prikazima.
#' 
#' 
#' 
#' Primjer koji slijedi pokazuje kako, izmeðu ostalih naèina, organizirati nekoliko dijagrama u jednoj "sceni" - rezultat je slièan kao kad se koristi par(**mfrow=c(2,2)**) u *base* grafici. Zapamtite kako R radi -pokušava spojiti klasu objekata s adekvatnom metodom. U ovom primjeru **generic** funkcija ispisa primijenjena na *Trellis* objekt uparena je s **print.trellis()** metodom. Argument *split* ima èetiri parametra. Zadnja dva odnose se na velièinu okvira, prisjetite se grafièkoga parametra *base* grafike **mfrow()**, gdje prva dva parametra pozicioniraju Vaš dijagram u nx sa ny okvir.
#' 
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=F----------------------------
#radimo podatke
w <- as.matrix(dist(Loblolly))
x <- as.matrix(dist(HairEyeColor))
y <- as.matrix(dist(rock))/100
z <- as.matrix(dist(women))

#grafovi dodijeljeni varijabli
#skale argumenta uklanjaju se osi
pw <- levelplot(w, col.regions=terrain.colors(25), scales = list(draw = FALSE))  
px <- levelplot(x, col.regions=terrain.colors(25), scales = list(draw = FALSE))
py <- levelplot(y, col.regions=terrain.colors(25), scales = list(draw = FALSE))
pz <- levelplot(z, col.regions=terrain.colors(25), scales = list(draw = FALSE))

#' 
#' 
#' 
#' 
## ----fig.width=12, fig.height=12,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Organizacija crtanja grafova za *Trellis* ureðaj", cache=F----
# dijagram se ispisuje
print(pw, split = c(1, 1, 2, 2), more = TRUE)
print(px, split = c(2, 1, 2, 2), more = TRUE)
print(py, split = c(1, 2, 2, 2), more = TRUE)
print(pz, split = c(2, 2, 2, 2), more = FALSE)  

#' 
#' 
#' 
#' 
#' \newpage
#' 
#' ### Najznaèajnije funkcije visoke razine iz paketa *lattice*
#' 
#' #### Funkcija **xyplot()**{lattice)}
#' 
#' Sve funkcije visoke razine u lattice paketu su generièke. Funkcija **xyplot()** je vjerojatno najpopularnija i najkorištenija funkcija iz paketa *lattice*; funkcija kreira opæe bivarijatne *Trellis* dijagrame. Veæina smještanja panela æe se objasniti kroz korištenje ove funkcije ali je isto moguæe i kod svih drugih ranije spomenutih funkcija.
#' 
#' Unutar ove funkcije moguæe je primijeniti sve ranije spomenute postavke grafièkih parametara. 
#' 
#' 
#' 
#' Kao i obièno, prije primjene nove funkcije, potrebno se s njom upoznati èitanjem informacijske kartice.
#' 
## ---- echo=T , eval=F, message=F, comment=NA, cache=F--------------------
?lattice::xyplot

#' 
#' 
#' 
#' Kako je spomenuto, funkcije *Trellis* grafike mogu proizvesti višestruke panel prikaze, takoðer su izvrsne za izradu osnovnih grafikona jednoga panela. U ovom primjeru æemo koristiti veæ opisane podatke *lattice_data*. Ovaj grafièki prikaz, dijagramima raspršenja, najpopularniji je prikaz dviju kontinuiranih varijabli. Dijagram raspršenja konceptualno je jednostavna, ali ipak moæna prezentacija podataka. Slijedi primjer:
#' 
## ---- echo=T ,eval=T, message=F, comment=NA, cache=F---------------------
trellis.par.set(old_theme)

#' 
#' 
## ----fig.width=7, fig.height=5,echo=T,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **xyplot()**; jednostavan dijagram raspršenja", cache=F----
xyplot(lifeExp ~ gdpPercap, 
       data=lattice_data, 
       main="Jednostavni dijagram raspršenja dvije numerièke varijable")

#' 
#' 
#' Sada æemo izraditi isti, jednostavni dijagram raspršenja za varijable oèekivane životne dobi i BDP-a korištenjem funkcije **xyplot()**, uz dodatnu promjenu grafièkih parametara: uoèite novi parametar *grid*.
#' 
## ----fig.width=7, fig.height=5,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **xyplot()**; dijagram raspršenja dvije kvantitativne varijable, postavka dodatnih grafièkih parametara i postavljena horizontalna mreža pozadine", cache=F----
p2 <-xyplot(lifeExp ~ gdpPercap, 
            lattice_data,
            pch=16,
            col="red4",
            grid="h")
p2

#' 
#' \newpage
#' 
#' U sljedeæim æemo primjerima nacrtati samo podskup podataka, jednu godinu, te naglasiti labele osi grafa:
#' 
## ----fig.width=7, fig.height=5,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **xyplot()**; dijagram raspršenja dviju kvantitativnih varijabli, a) odabir jedne godine", cache=F----
xyplot(lifeExp ~ gdpPercap, 
       lattice_data[lattice_data$year=="2007",], #usporediti s argumentom *subset* - kasnije
      #subset= year== "2007",
       pch=16,
       col="red4",
       grid=T)

#' 
#' Molim komentirajte razliku u gridovima pozadine u zadnja dva prikaza.
#' 
#' 
#' Ako želimo koristiti vrijednosti jedne varijable na logaritamskoj skali, možemo prilagoditi os "ruèno" ili primjenom **scales** argumenta unutar **xyplot()** funkcije. Za dodatne prilagodbe osi trebamo koristiti funkcije *latticeExtra* paketa što je izvan djelokruga našega teèaja.
#' 
#' 
#' 
## ----fig.width=7, fig.height=5,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **xyplot()**; dijagram raspršenja dviju kvantitativnih varijabli; ruèno podešena log skala osi", cache=F----
xyplot(lifeExp ~ log10(gdpPercap), 
       lattice_data[lattice_data$year=="2007",],
       pch=16,
       col="red4",
       grid=T,
       xlab = "BDP", 
       ylab = "Oèekivana životna dob")

#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' ### Poboljšanje rezultata kreiranog *high-level* funkcijom funkcijama niske razine (*low-level*)
#' 
#' #### Argument *scales*
#' 
#' Korištenje argumenta *scales* radimo pravilno skaliranje vrijedosti osi kako je prikazano primjerom:
#' 
#' 
## ----fig.width=7, fig.height=5,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **xyplot()**; dijagram raspršenja dvije kvantitativne varijable; *scale* argument", cache=F----
xyplot(lifeExp ~ gdpPercap, 
       lattice_data, 
       subset = year == "2007" ,
       pch=16,
       col="red4",
       grid=T,
       xlab = "BDP", 
       ylab = "Oèekivana životna dob",
       scales = list(x = list(log = 10)))

#' 
#' 
#' #### Argument *type*
#' 
#' 
#' Argument **type** koristi se za promjene parametara reprezentacije podataka. *Default* vrijednost funkcije **type** = "p", što oznaèava da æe na grafièkom prikazu podaci biti prikazani kao toèke u koordinatnom sustavu. Dodatno je moguæe raditi i kombinacije kao što je primjerice **type** = c("p", "r") koji kao rezultat daje i toèke i regresijsku liniju. 
#' 
#' 
#' U sljedeæem primjeru slièno kao i u *base grafici graf radimo na naèin crtanja a) samo toèaka i b) fitamo regresijsku liniju na toèke; parametar **type**.
#' 
#' 
## ----fig.width=7, fig.height=5,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **xyplot()**; dijagram raspršenja (engl. *scatterplot*) dviju kvantitativnih varijabli; **type** argument - *equispaced.log* za pravilno skaliranje osi", cache=F----
xyplot(lifeExp ~ gdpPercap, 
       lattice_data, 
       pch=16,
       col="red4",
       grid=T,
       subset = year == "2007",
       scales = list(x = list(log = 10, equispaced.log = FALSE)),
       type = "p")

#' 
#' 
#' 
#' 
## ----fig.width=7, fig.height=5,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **xyplot()**; dijagram raspršenja (engl. *scatterplot*) dviju kvantitativnih varijabli; *type* argument - p r", cache=F----
xyplot(lifeExp ~ gdpPercap, 
       lattice_data, 
       subset = year == "2007",
       pch=16,
       col="red4",
       grid=T,
       scales = list(x = list(log = 10, equispaced.log = FALSE)),
       type = c("p", "r"))

#'  
#' 
#' Dodatno se može grafièki prikaz poboljšati dodatnim grafièkim parametrima prema želji, u primjeru koji slijedi mijenjemo izgled regresijske linije.
#' 
## ----fig.width=7, fig.height=5,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **xyplot()**; dijagram raspršenja (engl. *scatterplot*) dvije kvantitativne varijable;; type argument - p, smooth; dodatni grafièki parametri za kontrolu izgleda regresijske linije", cache=F----
xyplot(lifeExp ~ gdpPercap, 
       lattice_data, 
       subset = year == "2007",
       pch=16,
       col="red4",
       grid=T,
       scales = list(x = list(log = 10, equispaced.log = FALSE)),
       type = c("p", "smooth"), 
       col.line = "darkseagreen4", 
       lwd = 3)

#' 
#' 
#' Moguæe opcije prilikom crtanjadijagrama raspršenja korištenjem funkcije **xyplot()** su:
#' 
#'  - **p** - crtanje toèaka
#'  
#'  - **l** - spajanje toèaka linijom
#'  
#'  - **b** - crtanje i toèaka i linije koja ih spaja
#'  
#'  - **o** - crtanje toèaka i linije koja ih preklapa
#'  
#'  - **S**, **s** - crtanje step funkcije
#'  
#'  - **h** - linije s ishodišta, slièno histogram prikazu
#'  
#'  - **a** - spajanje toèaka linijom nakon uprosjeèavanja (panel: **panel.average()**)
#'  
#'  - **r** - crtanje regresijske linije (panel: **panel.lmline()**)
#'  
#'  - **smooth** - crtanje polinomijalne lokalne kernel funkcije *LOESS smooth* (panel: **panel.loess()**)
#'  
#'  - **g** crtanje referentne mreže.
#'  
#' **ZA SAMOSTALAN RAD:** poigrajte se promjenom argumenta **type** na prethodnim primjerima i komentirajte dobiveni rezutat.
#'  
#'  
#'  
#' #### Argument *group*
#' 
#' 
#' 
#' U *lattice* grafici moguæe je pojedine podskupove podataka predstaviti, grupirati, na naèin da na panele dodamo novu informaciju: svaku grupu obojimo razlièito ili prikažemo razlièitim simbolom. Prouèite primjer na našim podacima *lattice_data*. Ono što definiramo argumentom *group* obièno stavimo i u legendu radi snalaženja na grafikonu (**key()** i/ili **auto.key()** argumenti).
#' 
#'  
## ----fig.width=7, fig.height=5,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **xyplot()**;  dijagram raspršenja dvije kvantitativne varijable; argument **group**", cache=F----
xyplot(lifeExp ~ gdpPercap, 
       lattice_data, 
       subset = year == "2007",
       pch=16,
       grid=T,
       scales = list(x = list(log = 10, equispaced.log = FALSE)),
       group = continent)

#' 
#' 
#' U sljedeæem primjeru crtamo svaki nivo faktora varijable posebnom bojom, a za vježbu koristimo podatke *lattice_data* na naèin da se podaci iscrtaju za svaku godinu u zasebnom panelu.
#' 
#' 
## ----fig.width=10, fig.height=10,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **xyplot()**; dijagram raspršenja dvije kvantitativne varijable; **group** argument", cache=F----
xyplot(lifeExp ~ gdpPercap | year, 
       lattice_data, 
      #fill.color = lattice_data$continent_color,
       pch=16,
       grid=T,
       scales = list(x = list(log = 10, equispaced.log = FALSE)),
       group = continent)

#' 
#' Argumenti *group* i *subset* vrlo su moæno oruðe u vizualizaciji multivarijatnih podAtaka kada se koriste u kombinaciji. U primjeru koji slijedi fitamo regresijsku liniju za podskupove podataka za svaki kontinent, podaci za jednu godinu.
#' 
#' 
#' 
## ----fig.width=7, fig.height=5,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Function **xyplot()**; dijagram raspršenja dvije kvantitativne varijable; *type*/*group* argument; ; dodatni parametri za regresijsku liniju *smooth*", cache=F----
xyplot(lifeExp ~ gdpPercap, 
       lattice_data, 
       subset = year == "2007",
       pch=16,
       grid=T,
       scales = list(x = list(log = 10, equispaced.log = FALSE)),
       type = c("p", "smooth"), 
       lwd=3,
       group = continent)

#' 
#' 
#' 
#' U primjeru koji slijedi bojamo podatke prema nivoima faktorske varijable za što æemo ponovno koristiti, poznatI nam skup podataka, *iris*. Kao dodatnu funkcionalnost, koja ponekad znatno doprinosi jasnoæi grafièkogA prikaza koristimo argument *jitter* koji za zadanu vrijednost razmièe preklapajuæe podatke.
#' 
## ----fig.width=8, fig.height=3,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija  **xyplot() - primjer bojanja faktorske varijable prema nivoima faktora", cache=T----
xyplot(Sepal.Width ~ Sepal.Length, 
       group=Species, 
       data=iris, 
       auto.key=list(space="right"), 
       jitter.x=TRUE, 
       jitter.y=TRUE)

#' 
#' **ZA SAMOSTALAN RAD:**
#' 
#' Na skupu podataka iz sustava R *diamonds* paketa *ggplot2* napravite dijagram raspršenja na naèin da su podaci obojani prema nivou faktora varijable *cut* ili *clarity*.
#' 
#' 
#' 
#' 
#' 
#' 
#' #### Argument  *key*/*auto.key*
#' Ako grafièki prikaz koji radimo u sebi sadržava podskupove objekata, obièno definirani argumentom *subset*, argument *key* se može dodati kroz generalnu funkciju prikaza (*general display function*) na grafièki prikaz kao pojašnjenje gledatelju. Argument *key* kontrolira izgled i položaj legende dodane grafièkom prikazu dok *auto.key* dodaje legendu automatski. Parametri koje možemo proslijediti argumentu *key* su u formatu liste koja sadrži elemente kao što su  *text*, *points* ili *lines* u ovisnosti o informaciji na grafièkom prikazu. Takoðer, proizvoljno je i odreðivanje položaja legende na prikazu te razmaka putem argumenta *space* i *border* argumenta.
#' 
#' 
#' 
## ----fig.width=9, fig.height=5,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **xyplot()** - argument **auto.key**", cache=T----
xyplot(lifeExp ~ gdpPercap, 
       lattice_data, 
       subset = year == "2007",
       pch=16,
       grid=T,
       scales = list(x = list(log = 10, equispaced.log = FALSE)),
       type = c("p", "smooth"),
       auto.key=T, 
       lwd=3,
       group = continent) 

#' 
#' 
#' Primjer koji slijedi je primjer redefiniranja panel funkcije *on-the-fly*. Ovo je vrlo èest naèin kontroliranja grafièkih prikaza unutar *lattice* grafike. Dodatne primjere moguæe je pronaæi na sljedeæoj poveznici: https://www.r-project.org/conferences/useR-2007/program/presentations/sarkar.pdf
#' 
#' 
#' 
#' Od ovoga trenutka grafièke postavke vraæamo na *default* vrijednosti.
#' 
#' 
#' 
#' 
#' 
#' #### Argument *subset*
#' 
#' Moguæe je izraditi prikaze koji prikazuju samo podskup podataka - podatke koji zadovoljavaju neka logièka pravila koja je korisnik definirao, poput primjera koji slijedi gdje je nacrtan samo podskup podataka za 2007. godinu:
#' 
#' 
## ----fig.width=9, fig.height=5,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Argument **subset** - histogram", cache=T----
histogram( ~ lifeExp,
       lattice_data, 
       subset = year == "2007",
       col="lightgray")

#' 
#' Primijetite daje jednak prikaz kao i sljedeæe:
#' 
## ---- echo=T ,eval=F, message=F, comment=NA, cache=F---------------------
histogram( ~ lifeExp,
       lattice_data[lattice_data$year=="2007",],
       col="lightgray")

#' 
#' 
#' #### Argument *layout*
#' .
#' 
#' Predložak panela u *Trellis* prikazu je posebno važan za toèno shvaæanje grafièkih informacija. Argument *layout* precizira kako æe paneli biti organizirani. Vrijednost ovog argumenta je vektor od dva elementa koji daje broj stupaca i redaka koji æe se koristiti u prikazu. Opcionalno, može se dodati i treæi element vektoru, kojim æe se zadati broj strana. Zadano (engl. *default*) je da *lattice* sustav izlaže panele polazeæi od donjeg lijevog kuta, kreæuæi se na desno i na gore. Logièki argument, *as.table* se može koristiti kako bi se ovo promijenilo, tako da *lattice* poèinje od gornjeg lijevog kuta i  ide prema desno i prema dolje.
#' 
#' 
## ---- echo=T , eval=T, message=F, comment=NA, cache=F--------------------
trellis.device('pdf', color=FALSE) 

#' 
## ----fig.width=12, fig.height=12,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **bwplot()** iza paketa *lattice* - Box-Whisker plot s uvjetovanjem; argument *layout default*", cache=T----
xyplot( lifeExp ~ gdpPercap | continent, 
        data=lattice_data)

#' 
#' Usporedite s donjim primjerom.
#' 
#' .
#' 
## ----fig.width=12, fig.height=12,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **bwplot()** iza paketa *lattice* - Box-Whisker plot s uvjetovanjem; novi *layout* argument", cache=T----
xyplot( lifeExp ~ gdpPercap | continent, 
        data=lattice_data, layout = c(3,2))

#' 
#' 
#' 
## ----fig.width=12, fig.height=12,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **bwplot()** iza paketa *lattice* - Box-Whisker plot s uvjetovanjem; argument *layout*", cache=T----
xyplot( lifeExp ~ gdpPercap | continent, 
        data=lattice_data, 
        layout = c(2,3))

#' 
#' 
#' \newpage
#' 
#' ###Najznaèajnije funkcije visoke razine (*high-level*) iz paketa *lattice*  - nastavak
#' 
#' 
#' #### Function **histogram()**(*high-level*){lattice}
#' 
#' Kao i obièno, prije primjene nove funkcije, unesite **?histogram** (ili **?lattice::histogram**) u R konzolu kako bi se otvorila informacijska kartica o funkciji. Na drugom grafu je simulirani primjer, postavljeni su histogram i Kernell gustoæe (engl. *kernel density*).
#' 
## ---- echo=T , eval=T, message=F, comment=NA, cache=F--------------------
trellis.device('pdf', color=FALSE) 

#' 
#' 
## ---- echo=T ,eval=T, message=F, comment=NA, cache=F---------------------
#trellis postavl+ke za otvoreni grafièki ureðej - RStudioGD
trellis.par.get(old_theme)

#' 
#' 
## ----fig.width=10, fig.height=10,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Histogram napravljen funkcijom paketa *lattice*; modifikacijom odgovarajuæe panel funkcije; **panel.histogram()**", cache=T----

#izraðivanje dijagrama
histogram(~lattice_data$gdpPercap | lattice_data$continent, data=lattice_data,
          type = "density", 
          panel = function(x, ...) {
              panel.histogram(x, col = "gray",...) 
              panel.densityplot(x, col = "DarkOliveGreen", lwd=2,  plot.points = FALSE)
          })

#' 
#' 
#' \newpage
#' 
#' #### Funkcija **densityplot()**(high-level){lattice}
#' 
#' Funkcija konstruira i prikazuje na grafu neparametarske procjene gustoæe, moguæno uvjetovane faktorom. Primjer o gustoæi potpune varijable *mpg* iz *mtcars* skupa podataka kao i pripadajuæe razine faktora varijable *gear*. 
#'  
#' 
## ---- echo=F , message=F, comment=NA, cache=T----------------------------
trellis.device("pdf", color=F)  #trellis graph bez boje

#' 
#' 
#' Funkcija crta Kernel density prikaz. U jednostavnom primjeru koji slijedi, histogram i kernel gustoæe su procijenjene i preklopljene/superponirane: 
#' 
## ----fig.width=7, fig.height=7,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Kernell gustoæe s paketom lattice, funkcija **densityplot()**", cache=T----
densityplot(~ lattice_data$gdpPercap)

#' 
#' 
#' Kako æe se kasnije objasniti, lattice je izvrstan sustav za prikaz dijela podataka na odvojenim panelima, gdje je neka druga varijabla (u sluèaju koji slijedi cyl je konstanta):
#' 
#' 
#' 
## ----fig.width=12, fig.height=12,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Kernell gustoæe paketom *lattice*, funkcija **densityplot()**; uvjetovanje po nivoima varijable *continent*", cache=T----
densityplot(~ lattice_data$gdpPercap | lattice_data$continent)

#' 
#' 
#' 
## ---- echo=F , message=F, comment=NA, cache=T----------------------------
trellis.device("pdf", color=F) 

#' 
#' 
#' **ZA SAMOSTALAN RAD:** Napravite graf gustoæe jedne varijable *mpg* za svaki nivo faktora varijable *gear* za skup podataka *mtcars*.
#' 
## ----eval=F,encoding = "ISO8859_2",echo=F, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **densityplot()** iz *lattice* paketa - primjer po razinama faktorske varijable", cache=F----
## densityplot(~ mpg | gear, data = mtcars, col="darkgray")

#' 
#' 
#' \newpage
#' 
#' 
#' #### Funkcija **dotplot()**(*high-level*){lattice)}
#' 
#' .
#' 
#' Funkcija crtanja Cleveland toèkastog dijagrama. U primjeru koji slijedi koristit æe se podaci o prioritetima državnih politika iz 1992. godine.
#' 
#' 
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=T----------------------------
#uèitavanje podataka
policy <- read.table("policy.txt", header = T)

#upoznavanje s podacima
str(policy)

#kopiranje u novi objekt za sortiranje (redanje/poredak)
policy_o <- policy

#poredani skup podataka prema varijabli priority
policy_o$state <- reorder(policy_o$state, policy_o$priority)

#crtamo neporedane podatke
p1 <- dotplot(state ~ priority, data = policy,
   aspect = 1.5,
   xlab = "Neporedani podaci",
   scales = list(cex = .6),
   panel = function (x, y) {
   panel.abline(h = as.numeric(y), col = "gray", lty = 1)
   panel.xyplot(x, as.numeric(y), col = "black", pch = 21)})


#plot ordered data
p2 <- dotplot(state ~ priority, data = policy_o,
   aspect = 1.5,
   xlab = "Podaci poredani po prioritetu",
   scales = list(cex = .6),
   panel = function (x, y) {
   panel.abline(h = as.numeric(y), col = "gray", lty = 3)
   panel.xyplot(x, as.numeric(y), col = "black", pch = 16)})

#' 
#' 
#' Nakon što smo pripremili poredane podatke, možemo ih nacrtati pomoæu funkcije **dotplot()**:
#' 
## ----fig.width=10, fig.height=20,echo=FALSE,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Toèkasti dijagram za a) neporedane i b) poredane podatke uz dodatnu prilagodbu; lattice paket, podaci o politikama", cache=T----
#ispis dva dijagrama metodom print.lattice
print (p1, split=c(1,1,1,2), more=T)
print (p2, split=c(1,2,1,2), more=F)

#' 
#' 
#' 
#' Sljedeæi primjer korištenja funkcije **dotplot()** napravit æemo na skupu podataka spremljenom na disku raèunala, ***"spending.txt"*** koji nosi informacije o potrošnji države za pojedinog studenta s nekoliko dodatnih varijabli kao što su država (*state*) i godina (*year*). 
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=T----------------------------
#uèitavanje podataka
spending <- read.table("spending.txt", header = T)

#upoznavanje s podacima
str(spending)

#sortiramo (poredamo) podatke prema educ.per.cap
spending$state <- reorder(spending$state, spending$educ.per.cap)

#' 
#' 
## ----fig.width=10, fig.height=10,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Cleveland dotplot 3; *lattice* paket", cache=T----
dotplot(state ~ educ.per.cap, data = spending,
   aspect = 1.5,
   scales = list(cex = .6),
   xlim = c(-100, 2300),
   xlab = "Državna ulaganja u edukaciju, 2000. godina",
   panel = function (x, y) {
   panel.segments(rep(0, length(x)), as.numeric(y),
     x, as.numeric(y), lty = 2, col = "gray")
   panel.xyplot(x, as.numeric(y), pch = 16, col = "black")} )

#' 
#' 
#' 
#' 
#' 
#' 
#' **ZA SAMOSTALNI RAD **
#' 
#' 1) Kreirajte Cleveland *dotplot* na objektu *lattice_data* na naèin da je:
#' 
#'  - varijabla koja nas interesira *gdpPercap*
#'  
#'  - uvjetujuæa varijabla *continent* i 
#'  
#'  - varijabla skupine je *year*.
#' 
#' 
#' 2) Kreirajte Box-Whisker dijagram na objektu *bugs_data* na naèin da je:
#' 
#'  - varijabla koja nas interesira *COUNT*
#'  
#'  - uvjetujuæa varijabla je *A_L_P* i 
#'  
#'  - varijabla skupine je *POS*
#' 
#'  - postavite automatiziranu legendu s desne strane.
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' \newpage
#' 
#' #### Funkcija **bwplot()** (*high-level*) {lattice}
#' 
#' Lattice funkcija visoke razine za izradu Box-Whisker dijagrama.
#' 
#' 
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=T----------------------------
trellis.device("pdf", color=F)  
trellis.device(retain=T) 

#' 
## ----fig.width=8, fig.height=3,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **bwplot()** *lattice* paket - primjer Box-Whisker prikaz s uvjetovanom varijablom", cache=T----
bwplot( ~ lifeExp | continent, data=lattice_data)

#' 
#' 
#' 
#' 
## ---- echo=F , message=F, comment=NA, cache=T----------------------------
trellis.device(color=FALSE) 
trellis.device(retain=T) #keep our settings

#' 
## ----fig.width=6, fig.height=6,echo=T,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Box-Whisker dijagram; paket lattice; grafièki parametri putem *general display function*", cache=T----

bwplot(~ lifeExp | continent, data = lattice_data,
              layout = c(2,3), stack = F, drop.unused.levels = F,
              auto.key = list(space = "right"),
              main="Oèekivano trajanje života / godina / kontinent",
              ylab = "Kontinent",
              par.settings = list(
        plot.symbol  =list(col=c("black"),pch=c(20), cex=0.5),
        box.umbrella=list(col= c("dark gray"),lwd=1, lty=1), 
        box.dot=list(col= c("black"), cex=0.9, pch=16), 
        box.rectangle = list(col= c("black"),
        box.rectangle=list(lwd=2))))   

#' 
#' 
#' 
#' \newpage
#' 
#' #### Function **levelplot()**{lattice}
#' 
#' 
#' Lattice grafièki paket sadrži funkciju **levelplot()** za ovu vrstu grafièkoga prikaza. Funkcija koristi gradijent boje kako bi se pokazale varijacije jedne varijable, po rasponima druge dvije. Raspon boja koje se koriste u lattice level plot-u može se precizirati kao vektor boja u *col.regions* argumentu funkcije. Koristimo funkciju *terrian.colors* kako bi kreirali ovaj vektor èiji je spektar od 100 boja manje upeèatljiv od onih koje su prethodno korištene u osnovnoj grafici.
#' 
#' 
#' 
#' Veæ poznajemo podatke *volcano*. U primjerima koji slijede producirat æemo *levelplot* za matricu *volcano*:
#' 
#' 
#' 
## ----fig.width=8, fig.height=6,echo=FALSE,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Levelplot matrice **volcano** iz sustava R; *lattice* paket", cache=T----
levelplot(volcano, 
          colorkey = list(space = "top"),
          sub = "Maunga Whau vulkan", 
          aspect = "iso")

#' 
#' U primjeru koji slijedi koristimo podatke pohranjene u objektu *elevation* kako bismo nacrtali graf pomoæu *lattice* grafike.
#' 
#' 
## ---- echo=F, message=F, comment=NA, cache=T-----------------------------
#pripremamo podatke
elevation.df <- data.frame(x = 50 * elevation$coords[,"x"],
                           y = 50 * elevation$coords[,"y"], z = 10 * elevation$data)
elevation.loess <- loess(z ~ x*y, data = elevation.df, degree = 2, span = 0.25)
elevation.fit <- expand.grid(list(x = seq(10, 300, 1), y = seq(10, 300, 1)))
z <- predict(elevation.loess, newdata <- elevation.fit)
elevation.fit$Height <- as.numeric(z)*3.28084


#' 
#' 
#' Pogledajmo strukturu podataka koje bismo željeli vizualizirati:
#' 
#' 
#' 
## ---- echo=T , message=F, comment=NA, cache=T----------------------------
str(elevation.fit)

#' 
#' 
#' 
## ----fig.width=8, fig.height=6,echo=FALSE,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Levelplot podataka **elevation**; lattice paket", cache=T----
levelplot(Height ~ x*y, data = elevation.fit,
          xlab = "X koordinata", ylab = "Y koordinata",
          main = "Podaci o nadmorskoj visini",
          col.regions = terrain.colors(100))

#' 
#' \newpage
#' 
#' I na kraju jedan primjer vizualizacije nadmorske visine podruèja u Hrvatskoj, Lika i dio Velebita, siva paleta:
#' 
#' 
## ----fig.width=8, fig.height=6,echo=FALSE,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Levelplot nadmorske visine dijela Hrvatske, stara tzv. 2.5 projekcija", cache=T----
levelplot(Height ~ x*y, data = dem_df,
          xlab = "X koordinata Hr1630", ylab = "Y koordinata Hr1630",
          main = "Podaci o nadmorskoj visini HR",
          col.regions =  gray((0:100/100), alpha=0.6))

#' 
#' 
#' 
#' \newpage
#' 
#' 
#' #### Funkcija **wireframe()**{lattice} 
#' 
#' Funkcija **wireframe()** crta graf trodimenzionalne perspektive; dijagram kontinuiranih varijabli u tri dimenzije.
#' 
#' Pošto su prikazi površine uèinkoviti samo kada se podaci redovno prikupljaju na grid-u, ova funkcija pruža rezultat koji je slièan **persp()** funkciji iz osnovne grafike. Isti skup podataka æemo vizualizirati na prikazu iz odreðene perspektive, u osnovnoj grafici, na skupu podataka *volcano*.
#' 
#' 
#' 
#' 
#' 
## ---- echo=T, warning=F, message=F---------------------------------------
#koordinate skupa podataka volcano
dim(volcano)
x <- 1:87

#x <- 1:dim(volcano)[1]
y<- 1:61
#y <- 1:dim(volcano)[2]

x
y
xy <- expand.grid(x,y)
names(xy) <- c("x", "y")
volcano_data <- data.frame(volcano, xy)

#' 
#' 
## ----fig.width=25, fig.height=25,echo=FALSE,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Wireframe prikaz podataka **volcano**; *lattice* paket", cache=T----
wireframe(volcano ~ x*y, data = volcano_data,
  xlab = "X koordinata", ylab = "Y koordinata",
  main = "Wireframe prikaz površine, nadmorske visine",
  drape = T,
  colorkey = TRUE,
  screen = list(z = -60, x = -60)
)

#' 
#' 
## ----fig.width=20, fig.height=20,echo=FALSE,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Wireframe prikaz podataka nadmorske visine; lattice paket, podaci *elevation.fit*", cache=F----
#postavljanje grafièkih parametara
par(mar=c(1, 4.1, 4.1, 2.1))

wireframe(Height ~ x*y, data = elevation.fit,
   xlab = "X coord", ylab = "Y coord",
   main = "POdaci o nadmorskoj visini",
   drape = TRUE,
   colorkey = TRUE,
   screen = list(z = -60, x = -60),
   cex=3,
   col.regions=heat.colors(100, alpha=0.6)
  )

#' 
## ----fig.width=25, fig.height=25,echo=FALSE,encoding = "ISO8859_2", warning=FALSE,message=F,include=TRUE,fig.cap="Wireframe prikaz podataka nadmorske visine; lattice paket, dio Hrvatske", cache=F----
#postavljanje grafièkih parametara
par(mar=c(1, 4.1, 4.1, 2.1))
elevation.fit <- dem_df

#garf
wireframe(Height ~ x*y, data = elevation.fit,
   xlab = "X coord", ylab = "Y coord",
   main = "POdaci o nadmorskoj visini",
   drape = TRUE,
   colorkey = TRUE,
   screen = list(z = -45, x = -45),
   col.regions=heat.colors(100, alpha=0.6)
  )

#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' #### Function **cloud()** {lattice}
#' 
#' 
#' 
#' Funkcija **cloud()** proizvodi trodimenzionalne dijagrame raspršivanja. Mnogi od argumenata kao što su *pch* i *col*, **cloud()** funkcije identièni su onima koji se koriste u **xyplot()** ali neki funkcioniraju drugaèijie (npr. *scales* - ovdje se koriste da se uklone strelice koje su zadano (engl. *default*) nacrtane duž osi i da se zamijene debelim oznakama i skaliranjem vrijednosti za tri varijable). Pogledajte informacijsku karticu funkcije i pokušajte zakljuèiti kako koristiti *distance* i *screen*. Pokušajmo promijeniti te izraze u slijedeæem kôdu i komentirajte.
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' \newpage
#' 
#' #### Function **qqmath()** {lattice}
#' 
#' Funkcija **qmath()** je dio skupine standardnih statistièkih grafika kojima je namjera da se vizualizira distribucija kontinuirane sluèajne varijable. Veæ smo vidjeli histograme i dijagrame gustoæe, koji su procjene vjerojatnosti funkcije gustoæe kontinuirane varijable. Funkcija **qqmath()** rezultira kvantil-kvantil (Q-Q) dijagrame uzorka u odnosu na teorijske distribucije, moguæe uvjetovano drugim varijablama. Zadano ponašanje **qqmath()** slièno je funkciji **qqnorm()**. 
#' 
#' 
## ---- echo=F , message=F, comment=NA, cache=T----------------------------
trellis.device("pdf", color=F)  #trellis graphs without colors

#' 
#' 
#' 
#' Kao što nam je veæ poznato, možemo izraditi i uvjetovane grafove, u sljedeæm prikazu uvjetujemo (držimo konstantom) dvije varijable:
#' 
## ----fig.width=20, fig.height=20,encoding = "ISO8859_2",echo=T, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **qqmath()** iz *lattice* paketa - primjer uvjetovanja po nivou faktorske varijable kontinent", cache=F----
qqmath(~  lifeExp | continent * year, data = lattice_data)

#' 
#' 
#' 
#' \newpage
#' 
#' #### Funkcija **barchart()**(*high-level*){lattice}
#' .
#' 
#' Funkcija koja kreira barplot prikaz, adekvatan grafièki prikaz za kategorijske varijable.
#' 
#' 
## ---- echo=F , message=F, comment=NA, cache=F----------------------------
trellis.device("pdf", color=F)  #trellis graphs without colors

#' 
#' 
#' 
## ---- echo=t , eval=F,  message=F, comment=NA, cache=F-------------------
barchart(lifeExp  ~ country , 
         lattice_data[lattice_data$year=="2007",], 
         horizontal=F, 
         col="lightblue",
         xlab="Country",
         ylab="Life exepctancy",
         scales = list(x = list(rot = 90)))

#' 
#' 
#' \blandscape
#' 
## ----fig.width=35, fig.height=20,encoding = "ISO8859_2",echo=F, warning=FALSE,message=F,include=TRUE,fig.cap="Funkcija **barchart()** iz *lattice* paketa", cache=F----
barchart(lifeExp  ~ country , 
         lattice_data[lattice_data$year=="2007",], 
         horizontal=F, 
         col="lightblue",
         xlab="Zemlja",
         ylab="Oèekivani životni vijek",
         scales = list(x = list(rot = 90)))

#' 
#' 
#' \elandscape
#' 
#' 
#' 
#' 
#' \newpage
#' 
#' 
#' # Literatura
#' 
#' * Becker, R. A., Chambers, J. M. and Wilks, A. R. 1988. The New S Language. Wadsworth & Brooks/Cole.
#' 
#' * Brewer C.A. 1999. Color Use Guidelines for Data Representation." In Proceedings of the Section on Statistical Graphics, American Statistical Association, pp. 55-60. Alexandria, VA. http://www.personal.psu.edu/faculty/c/a/cab38/ColorSch/ASApaper.html.
#' 
#' * Cleveland W. S. 1993 Visualizing Data. Summit, New Jersey: Hobart. 
#' 
#' * Cleveland, W. S. 1985. The Elements of Graphing Data. Monterey, CA: Wadsworth.
#' 
#' * Cox N 2007. The Grammar of Graphics." Journal of Statistical Software, Book Reviews, 17(3), 1{7. URL http://www.jstatsoft.org/v17/b03/.
#' 
#' 
#' * Deepayan Sarkar (2008) Lattice: Multivariate Data Visualization with R, Springer.
#' 
#' * ggplot2: Elegant Graphics for Data Analysis
#' 
#' * Harrower M.A., Brewer C.A. 2003. ColorBrewer.org: An Online Tool for Selecting Color Schemes for Maps." The Cartographic Journal,40, 27-37. http://ColorBrewer.org/.
#' 
#' * http://eeecon.uibk.ac.at/~zeileis/papers/Zeileis+Hornik+Murrell-2009.pdf
#' 
#' * http://lattice.r-forge.r-project.org/Vignettes/src/lattice-intro/lattice-intro.pdf
#' 
#' * http://lmdvr.r-forge.r-project.org/figures/figures.html
#' 
#' * http://polisci.msu.edu/jacoby/icpsr/graphics/lattice/Lattice,%20ICPSR%202016%20Outline,%20Ver%201.pdf
#' 
#' * http://www.ggplot2-exts.org/
#' 
#' * https://cran.r-project.org/web/packages/lattice/lattice.pdf
#' 
#' * https://en.wikipedia.org/wiki/HSL_and_HSV
#' 
#' * https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/iris.html
#' 
#' * https://stat.ethz.ch/R-manual/R-devel/library/grid/doc/viewports.pdf
#' 
#' * https://www.r-project.org/conferences/useR-2007/program/presentations/sarkar.pdf
#' 
#' * https://www.stat.auckland.ac.nz/~paul/RGraphics/rgraphics.html
#' 
#' * http://ms.mcmaster.ca/~bolker/misc/ggplot2-book.pdf
#' 
#' * Ihaka R. 2003. Colour for Presentation Graphics."In K Hornik,  F Leisch,  A Zeileis (eds.),Proceedings of the 3rd International Workshop on Distributed Statistical Computing, Vienna, Austria.  ISSN 1609-395X, (http://www.ci.tuwien.ac.at/Conferences/DSC-2003/Proceedings/).
#' 
#' * Jacoby, William G. 2006. "The Dot Plot: A Graphical Display for Labeled Quantitative Values." The Political Methodologist 14(1): 6-14.
#' 
#' * Meyer D., Zeileis A., and Hornik K. 2005 The strucplot framework: Visualizing multi-way contingency tables with vcd. Report 22, Department of Statistics and Mathematics, Wirtschaftsuniversität Wien, Research Report Series. http://epub.wu.ac.at/dyn/openURL?id=oai:epub.wu-wien.ac.at:epub-wu-01_8a1
#' 
#' * Munsell A.H. 1905. A Color Notation. Munsell Color Company, Boston, Massachusetts.
#' 
#' * Murrell, P. 2005. R Graphics. Chapman & Hall/CRC Press.
#' 
#' * Smith A.R. 1978). Color Gamut Transform Pairs."Computer Graphics,12(3),12-19. ACM SIGGRAPH 78 Conference Proceedings, http://www.alvyray.com/.
#' 
#' * Yu D., Smith D.K., Zhu H., Guan Y., Lam T.T.Y*. ggtree: an R package for visualization and annotation of phylogenetic trees with their covariates and other associated data. Methods in Ecology and Evolution. doi:10.1111/2041-210X.12628.
#' 
#' * Zeileis,A., Hornik K., Murrell P. 2009. Escaping RGBland: Selecting Colors for Statistical Graphics. Computational Statistics & Data Analysis, 53(9), 3259-3270.
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
