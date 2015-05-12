# VLSI PROJEKAT 2014/2015. #

Poslednja izmena: **12.05.2015.** Filip Petrovic.

Verzija dokumenta: 2.3

Tekst projekta: [http://home.etf.rs/~vm/os/vlsi/projekat/januar2015.pdf](http://home.etf.rs/~vm/os/vlsi/projekat/januar2015.pdf)

Trenutna zamisao je da procesor bude podeljen u tri dela.
[Slika (organizacija 2.0)](https://drive.google.com/file/d/0BwMJvMt6otSRUlVQNjQzVHNuMWc/view?usp=sharing)

## Prvi deo (FRONTEND): ##
prvi deo cine faze IF i ID. Te faze imaju registre na svojim krajevima.

Sadrzaj:

1. IF Stage: komunicira sa instrukcijskim kesom, vodi racuna o PC i prosledjuje nedekodovane instrkucje i pc dalje u ID fazu.
2. ID Stage: prihvata nedekodovane instrukcije od IF, dekoduje ih i salje dalje.

## Drugi deo (MIDDLE-CONTROL): ##
Ovaj deo sadrzi registarski fajl i zaduzen je da instrukcije koje dolaze iz fronenda prosledi na odgovarajucu funckionalnu jedinicu (ALU, MEM, BRANCH), tj da je prosledi u backend procesora.
ovaj deo osim prosledjivanja vodi racuna o hazardima i prosledjivanju vrednosti (da bi izbegli stall pipelinea). U slucaju da ne moze izbeci hazard stopira frontend signalom stall. 

Sadrzaj:

1. GPR File: Registarski fajl sa mogucnoscu cetiri istovremena citanja i cetiri upisa. Nije "thread-safe", tj ne daje nikakve garancije u slucaju vise istovremenih upisa u isti registar.
2. Switch: kombinaciona mreza koja treba da, na osnovu op_coda instrukcije, njene validnosti i trenutnog hazarda, aktivira odgovarajucu funkcionalnu jedinici (kao i jzp i slicno) i prosledi dekodovani instrukciju na tj func jedinicu.
3. Jedinica za detekciju hazarda: Samo ime kaze, detektuje kada se mora zaustaviti pipeline. Signal da je doslo do harazda se vodi na Stall generator koji je zaduzen za generisanje stall signala. Signal da je doslo do hazarda ce ucestvovati i u logici aktiviranja funkc jedinica. Ova jedinica za izlaz ima enum koji oznaca tip hazarda (za sada su to tip A, B i C). U uslovima za proveru postojanja hazarda TREBA proveriti da li je instrukcija validna i po uslovima iz SM (da li je signal ready aktivan).
4. Stall generator ([SM Dijagram](https://drive.google.com/file/d/0BwMJvMt6otSRREVFNXFKZXg4dVk/view?usp=sharing)): Ovo je u osnovi SM sa cetiri stanja. Stanja su: "Inicijalno", "Kasnjenje jedan takt" i dva tipa "Cekanje na MEM". U inicjalnom stanju stall signal je neaktivan. U stanju "Kasnjenje jedan takt" SM se zadrzava jedan takt i za to stall signal je aktivan. Ovo se koristi za vecinu hazarda gde je potrebno nesto sacekati. U stanju "Cekanje na MEM" se ostaje dok MEM blok ne zavrsi svoj posao i odmah moze da prosledi vrednost koju je ucitao iz memorije. Ova SM se prevodu iz inicijalnog stanja u stanje hazarda izlaznim signalima "Jedinice za detekciju hazarda", tj tip hazarda odredjuje u koje se stanje prelazi. Svako stanje ima pridruzena dva bita koja oznacavaju da li je instrukcija na izlazima ID faze i dalje validna, npr. par bitova "01" oznacava da gornja "Fica" instrukcija vise nije validna (obradjena je) dok je donja "Fedja" instrukcija validna (treba je obraditi).
5. Jedinica za prosledjivanje: Detektuje kada je moguce proslediti izlaz neke funkc. jedinice na ulaz neke funkc. jedinice. Ovih jedinica postoji vise, tj ispred ALU funkc jedinica po jedna za svaki operand. Uprosceno to je samo jedan multiplekser i komb mreza za generisanje signala SEL tog mux-a. Ispred MEM ce postojati nesto drugacija jedinica za prosledjivanje od one ispred ALU, jer MEM moze da primi i prvu i drugu instrukciju iz ID faze i tu je potrebna dodatna logika pri izboru i proveri.

## Treci deo (BACKEND): ##
Ovaj deo cine funcionalne jedinice (ALU, MEM, Branch) kao i kombinaciona mreza koja radi sinhronizaciju upisa u reg fajl. 

Sadrzaj:

1. Funkcionalne jedinice su opisane u tekstu projekta. Rade tako sto imaju buffere na ulazu, srednji deo procesora upise u ove buffere i na sledeci takst se izvrsi operacija. 
2. Komb. mreza za sinhronizaciju upisa: Ideja je da ako postoje dve alu instrkucije (ili slicno) koje generisu neku vrednost i za destinaciju imaju isti registar npr. R3, tada jedna instrukcija nema smisla i treba videti koja ima veci PC i njenu vrednost upisati a instrukciju sa manjim PC zanemariti.

## Otvorena pitanja: ##
 
1. Gde staviti PSW? Sinhronizacija PSW?
2. [Stall_generator_test](https://drive.google.com/file/d/0BwMJvMt6otSRdWNGSnBoWFJjYnc/view?usp=sharing). Na slici je crvenom strelicom oznaceno kada switch treba da propusti i drugu instrukciju (Fedju) na func jedinicu. Trenutno switch to ne radi, treba razmisliti kako to resiti. Moguce je staviti signal od SM ka Switch, koji ce na skok mem_done da signalizira switcu da propusti drugu instrukciju.