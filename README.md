# VLSI PROJEKAT 2014/2015. #

Poslednja izmena: **24.06.2015.** Filip Petrovic.

Verzija dokumenta: 2.4

Folder sa slikama u koji se ubacuju sve slike. Lakse za sinhronizaciju :)
[https://drive.google.com/folderview?id=0BwMJvMt6otSRflIzZ3FKampVeENsWGFCaEoxWC1adFQ4NW8zUjc0ZHNCVlhibVNOVGl2dTQ&usp=sharing](https://drive.google.com/folderview?id=0BwMJvMt6otSRflIzZ3FKampVeENsWGFCaEoxWC1adFQ4NW8zUjc0ZHNCVlhibVNOVGl2dTQ&usp=sharing)

Tekst projekta: [http://home.etf.rs/~vm/os/vlsi/projekat/januar2015.pdf](http://home.etf.rs/~vm/os/vlsi/projekat/januar2015.pdf)

Trenutna zamisao je da procesor bude podeljen u tri dela.
[Slika (organizacija 2.0)](https://drive.google.com/file/d/0BwMJvMt6otSRUlVQNjQzVHNuMWc/view?usp=sharing)

## Prvi deo (FRONTEND): ##
Prvi deo cine faze IF i ID. Te faze imaju registre na svojim krajevima.

Sadrzaj:

1. IF Stage: komunicira sa instrukcijskim kesom, vodi racuna o PC i prosledjuje nedekodovane instrkucje i pc dalje u ID fazu.
2. ID Stage: prihvata nedekodovane instrukcije od IF, dekoduje ih i salje dalje.

## Drugi deo (MIDDLE-CONTROL): ##
Ovaj deo sadrzi registarski fajl i zaduzen je da instrukcije koje dolaze iz fronenda prosledi na odgovarajucu funckionalnu jedinicu (ALU, MEM, BRANCH), tj da je prosledi u backend procesora.
ovaj deo osim prosledjivanja vodi racuna o hazardima i prosledjivanju vrednosti (da bi izbegli stall pipelinea). U slucaju da ne moze izbeci hazard stopira frontend signalom stall. 

Sadrzaj:

1. GPR File: Registarski fajl sa mogucnoscu cetiri istovremena citanja i cetiri upisa. Nije "thread-safe", tj ne daje nikakve garancije u slucaju vise istovremenih upisa u isti registar.
2. Switch: kombinaciona mreza koja treba da, na osnovu op_coda instrukcije, njene validnosti i signala iz SM, aktivira odgovarajucu funkcionalnu jedinici (kao i jzp i slicno) i prosledi dekodovani instrukciju na tj func jedinicu. Posto jedinica za detekciju hazarda obezbedjuje da switch u jednom trenutko moze da prosledi samo validne instrukcije, onda mozemo reci da ce switch uvek da izbaci samo jednu MEM instrukciju. Ovo je iskorisceno da se na izlaz switch-a dodaju dva signala koji oznacavaju r1 i r2 MEM instrukcije (koja je prosledjena po bilo kojoj liniji). Ova dva r1 i r2 se dovode na dva JZP (r1 na jednu JZP, r2 na drugu JZP) ispred MEM, i pomocu njih JZP moze da vrsi slekciju vrednosti registra iz WSU. Ovim je omoguceno da su JZP ispred ALI i JZP ispred MEM identicne.
3. Jedinica za detekciju hazarda: Samo ime kaze, detektuje kada se mora zaustaviti pipeline. Signal da je doslo do harazda se vodi na Stall generator koji je zaduzen za generisanje stall signala. Signal da je doslo do hazarda ce ucestvovati i u logici aktiviranja funkc jedinica. Ova jedinica za izlaz ima enum koji oznaca tip hazarda (za sada su to tip A, B i C). U uslovima za proveru postojanja hazarda TREBA proveriti da li je instrukcija validna i po uslovima iz SM (da li je signal ready aktivan).
4. Stall generator (za SM dijagram pogledati folder sa slikama): Ovo je u osnovi SM sa cetiri stanja. Stanja su: "Inicijalno", "Kasnjenje jedan takt" i dva tipa "Cekanje na MEM". U inicjalnom stanju stall signal je neaktivan. U stanju "Kasnjenje jedan takt" SM se zadrzava jedan takt i za to stall signal je aktivan. Ovo se koristi za vecinu hazarda gde je potrebno nesto sacekati. U stanju "Cekanje na MEM" se ostaje dok MEM blok ne zavrsi svoj posao i odmah moze da prosledi vrednost koju je ucitao iz memorije. Ova SM se prevodi iz inicijalnog stanja u stanje hazarda izlaznim signalima "Jedinice za detekciju hazarda", tj tip hazarda odredjuje u koje se stanje prelazi. Na svaki prelaz (ukljucujuci iz istog stanja u isto) se postavljaju dva izlazna signala inst_ready(0) i inst_ready(1). Oni se vode na ulaz switch-a i switch na osnovu njih prosledju inst u func jedinicu ili ne ('1' oznacava da instrukciju treba proslediti na func jedincu).
5. Jedinica za prosledjivanje: Detektuje kada je moguce proslediti izlaz neke funkc. jedinice na ulaz neke funkc. jedinice. Ovih jedinica postoji vise, tj ispred ALU funkc jedinica po jedna za svaki operand. Uprosceno to je samo jedan multiplekser i komb mreza za generisanje signala SEL tog mux-a. JZP ispred MEM i ALU su iste.

## Treci deo (BACKEND): ##
Ovaj deo cine funcionalne jedinice (ALU, MEM, Branch) kao i kombinaciona mreza koja radi sinhronizaciju upisa u reg fajl. 

Sadrzaj:

1. Funkcionalne jedinice su opisane u tekstu projekta. Rade tako sto imaju buffere na ulazu, srednji deo procesora upise u ove buffere i na sledeci takst se izvrsi operacija. 
2. Komb. mreza za sinhronizaciju upisa: Ideja je da ako postoje dve alu instrkucije (ili slicno) koje generisu neku vrednost i za destinaciju imaju isti registar npr. R3, tada jedna instrukcija nema smisla i treba videti koja ima veci PC i njenu vrednost upisati a instrukciju sa manjim PC zanemariti.

## Otvorena pitanja: ##
 
1. Gde staviti PSW? Sinhronizacija PSW?
2. Treba uraditi upit u GPR na osnovu r1 i r2 sa izlaza switch-a. Ili neko slicno resenje koje obezbedjuje da se na JZP ispred MEM, dovede odgovarajuca vrednost registra iz GPR. (Trenutno je problem sto ne znamo da li je Fica ili je Fedja MEM instrukcija)
3. Nacrtati novu sliku organizacije. Trenutna slika je crtana pre nego sto je bilo sta implementirano pa je slika pomalo zastarila.

## Resena pitanja: ##

1. [Stall_generator_test](https://drive.google.com/file/d/0BwMJvMt6otSRdWNGSnBoWFJjYnc/view?usp=sharing). Na slici je crvenom strelicom oznaceno kada switch treba da propusti i drugu instrukciju (Fedju) na func jedinicu. Trenutno switch to ne radi, treba razmisliti kako to resiti. Moguce je staviti signal od SM ka Switch, koji ce na skok mem_done da signalizira switcu da propusti drugu instrukciju. 
(Opis resenja): Izbaceni su signali za validnost instrukcije iz SM, tj promenjenja im je semantika, sada imamo dva signala, za svaku instrikciju po jedan, koji oznacavaju da li instrukciju treba proslediti na func ili ne. Ovaj deo posla ce odraditi switch, tj ova dva signala se vode sa SM na switch.