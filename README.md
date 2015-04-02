# VLSI PROJEKAT 2014/2015. #

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

1. GPR File: Registarski fajl sa mogucnoscu cetiri istovremena citanja i cetiri (valjda) upisa. Nije "thread-safe", tj ne daje nikakve garancije u slucaju vise istovremenih upisa u isti registar.
2. Jedinica za rasporedjivanje: kombinaciona mreza koja treba da prosledi odgovarajucu instrukciju na odgovarajucu funkcionalnu jedinici, tj da u zavisnosti od op_coda instrukcije da saglasnost za aktiviranje neke funck jedinice, njenih jedinica za prosledjivanje i sl.
3. Jedinica za detekciju hazarda: Samo ime kaze, detektuje kada se mora zaustaviti pipeline. Signal da je doslo do harazda se vodi na Stall generator koji je zaduzen za generisanje stall signala. Signal da je doslo do hazarda ce ucestvovati i u logici aktiviranja funkc jedinica.
4. Stall generator: Ovo je u osnovi SM sa tri stanja. Stanja su: "Inicijalno", "Kasnjenje jedan takt", "Cekanje na MEM". U inicjalnom stanju stall signal je neaktivan. U stanju "Kasnjenje jedan takt" SM se zadrzava jedan takt i za to stall signal je aktivan. Ovo se koristi za vecinu hazarda gde je potrebno nesto sacekati. U stanju "Cekanje na MEM" se ostaje dok MEM blok ne zavrsi svoj posao i odmah moze da prosledi vrednost koju je ucitao iz memorije. Ova SM ce verovatno biti koriscena i za invalidiranje odradjenih instrukcija dok se ceka na drugu, npr prva instrukcija iz ID je odradjena, i ova SM u slucaju cekanja uslova za drugu instrkucija treba da invalidira prvu (odradjenu instrukciju) jer je ona i dalje na izlazu ID faze.
5. Jedinica za prosledjivanje: Detektuje kada je moguce proslediti izlaz neke funkc. jedinice na ulaz neke funkc. jedinice. Ovih jedinica postoji vise, tj ispred ALU funkc jedinica po jedna za svaki operand. Uprosceno to je samo jedan multiplekser i komb mreza za generisanje signala SEL tog mux-a. Ispred MEM ce postojati nesto drugacija jedinica za prosledjivanje od one ispred ALU, jer MEM moze da primi i prvu i drugu instrukciju iz ID faze i tu je potrebna dodatka logika pri izboru i proveri.

## Treci deo (BACKEND): ##
Ovaj deo cine funcionalne jedinice (ALU, MEM, Branch) kao i kombinaciona mreza koja radi sinhronizaciju upisa u reg fajl. 

Sadrzaj:

1. Funkcionalne jedinice su opisane u tekstu projekta. Rade tako sto imaju buffere na ulazu, srednji deo procesora upise u ove buffere i na sledeci takst se izvrsi operacija. 
2. Komb. mreza za sinhronizaciju upisa: Ideja je da ako postoje dve alu instrkucije (ili slicno) koje generisu neku vrednost i za destinaciju imaju isti registar npr. R3, tada jedna instrukcija nema smisla i treba videti koja ima veci PC i njenu vrednost upisati a instrukciju sa manjim PC zanemariti.