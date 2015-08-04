# VLSI PROJEKAT 2014/2015. #

Poslednja izmena: **28.06.2015.** Filip Petrovic.

Verzija dokumenta: 2.7

Folder sa slikama u koji se ubacuju sve slike. Lakse za sinhronizaciju :)
[https://drive.google.com/folderview?id=0BwMJvMt6otSRflIzZ3FKampVeENsWGFCaEoxWC1adFQ4NW8zUjc0ZHNCVlhibVNOVGl2dTQ&usp=sharing](https://drive.google.com/folderview?id=0BwMJvMt6otSRflIzZ3FKampVeENsWGFCaEoxWC1adFQ4NW8zUjc0ZHNCVlhibVNOVGl2dTQ&usp=sharing)

Tekst projekta: [http://home.etf.rs/~vm/os/vlsi/projekat/januar2015.pdf](http://home.etf.rs/~vm/os/vlsi/projekat/januar2015.pdf)

Trenutna zamisao je da procesor bude podeljen u tri dela. Pogledati sliku nove organizacije u folderu.

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
2. Switch: kombinaciona mreza koja treba da, na osnovu op_coda instrukcije, njene validnosti i signala iz SM, aktivira odgovarajucu funkcionalnu jedinicu i prosledi dekodovanu instrukciju na tu func jedinicu. Posto jedinica za detekciju hazarda obezbedjuje da switch u jednom trenutku moze da prosledi samo validne instrukcije, onda mozemo reci da ce switch uvek da izbaci samo jednu MEM instrukciju. Ovo je iskorisceno da se na izlaz switch-a dodaju dva signala koji oznacavaju r1 i r3 MEM instrukcije (koja je prosledjena po bilo kojoj liniji, bilo da je Fica bilo da je Fedja). Ova dva r1 i r3 se dovode na dva JZP (r3 na jednu JZP, r3 na drugu JZP) ispred MEM, i pomocu njih JZP moze da vrsi slekciju vrednosti registra iz WSU. Ovim je omoguceno da su JZP ispred ALU i JZP ispred MEM identicne. MEM instrukcije ne koriste r2. U slucaju LOAD instrukcije se takodje radi prosledjivanje operanda r3, iako to nije potrebno, ali ne smeta pri izvrsavanju.
3. Jedinica za detekciju hazarda: Samo ime kaze, detektuje kada se mora zaustaviti pipeline. Signal da je doslo do hazarda se vodi na Stall generator koji je zaduzen za generisanje stall signala. Ova jedinica za izlaz ima enum koji oznaca tip hazarda (za sada su to tip A, B i C). U uslovima za proveru postojanja hazarda TREBA proveriti da li je instrukcija validna i po uslovima iz SM (da li je signal ready aktivan).
4. Stall generator (za SM dijagram pogledati folder sa slikama): Ovo je u osnovi SM sa cetiri stanja. Stanja su: "Inicijalno", "Kasnjenje jedan takt" i dva tipa "Cekanje na MEM". U inicjalnom stanju stall signal je neaktivan. U stanju "Kasnjenje jedan takt" SM se zadrzava jedan takt i za to stall signal je aktivan. Ovo se koristi za vecinu hazarda gde je potrebno nesto sacekati. U stanju "Cekanje na MEM" se ostaje dok MEM blok ne zavrsi svoj posao i odmah moze da prosledi vrednost koju je ucitao iz memorije. Ova SM se prevodi iz inicijalnog stanja u stanje hazarda izlaznim signalima "Jedinice za detekciju hazarda", tj. tip hazarda odredjuje u koje se stanje prelazi. Na svaki prelaz (ukljucujuci iz istog stanja u isto) se postavljaju dva izlazna signala inst_go(0) i inst_go(1). Oni se vode na ulaz switch-a i switch na osnovu njih prosledju inst u func jedinicu ili ne ('1' oznacava da instrukciju treba proslediti na func jedincu). Postoje i ready biti (njihova semantika je validnost, tj. ako je prva instrukcija propustena, onda ona vise nije validna). Ovi biti su vazni za detekciju hazarda i vode se na hazard detektor. U pslednjoj verziji SM su dodati i prelazi iz C stanja u stanja A i B. Hazardi su opisani u dokumentu u folderu na google drive.
5. Jedinica za prosledjivanje: Detektuje kada je moguce proslediti izlaz neke funkc. jedinice na ulaz neke funkc. jedinice. Ovih jedinica postoji vise, tj ispred ALU funkc jedinica po jedna za svaki operand. Uprosceno to je samo jedan multiplekser i komb mreza za generisanje signala SEL tog mux-a. JZP ispred MEM i ALU su iste.
6. Stopko - Entitet koji detektuje kada treba zaustaviti procesor. U osnovi to je SM sa 3 stanja. Prvo stanje je inicijalno, WORK, u kome procesor radi. Kada je Fica stop instrukcija znaci da procesor treba da se zaustavi, ovo izizaziva prelazak u STOP stanje. U STOP stanju se generise stop signal, koji je negacija mem_busy signala, tj. ceka se da mem blok zavrsi. U slucaju da je Fedja stop, znaci da prva instrukcija treba da se izvrsi, i zato se prva instrukcija propusta (ovo je nezavisno od stopka). Ovo se realizuje prelaskom iz WORK u CHECK stanje. U CHECK stanju, se razmatra da li je stop instrukcija i dalje validna (ako je Fica bio BR onda se moze destiti da ne treba zaustavljati procesor). Ukoliko je stop validna prelazi se u STOP stanje, a u suprotnom se prelazi u WORK stanje. Postoji slika SM u folderu.

## Treci deo (BACKEND): ##
Ovaj deo cine funcionalne jedinice (ALU, MEM, Branch) kao i kombinaciona mreza koja radi sinhronizaciju upisa u reg fajl. PSW se takodje nalazi u trecem delu.

Sadrzaj:

1. Funkcionalne jedinice su opisane u tekstu projekta. Rade tako sto imaju buffere na ulazu, srednji deo procesora upise u ove buffere i na sledeci takst se izvrsi operacija. 
2. Komb. mreza za sinhronizaciju upisa: Ideja je da ako postoje dve alu instrkucije (ili slicno) koje generisu neku vrednost i za destinaciju imaju isti registar npr. R3, tada jedna instrukcija nema smisla i treba videti koja ima veci PC i njenu vrednost upisati a instrukciju sa manjim PC zanemariti.
3. PSW entitet cuva vrednosti za bite N, Z, C i V i vrsi sinhronizaciju upisa u sam registar. Sinhronizacija je ista kao kod GPR, prednost se daje instrukciji sa vecim PC. U slicaju ALU jedinica, uvek ce druga imati instrukciju sa vecim PC (Fica ide u prvu, Fedja u drugu). Znaci logika bi trebala da glasi ovako: "ako je samo jedna func jedinica generisala PSW onda upisati u PSW, ako su obe func jedinice generisale PSW onda prioritet ima druga (ona sa vecim PC)". Takodje treba uociti da samo neke ALU instrkuciju generisu PSW vrednosti.

## Otvorena pitanja: ##
 
1. Treba uraditi upit u GPR na osnovu r1 i r2 sa izlaza switch-a. Ili neko slicno resenje koje obezbedjuje da se na JZP ispred MEM, dovede odgovarajuca vrednost registra iz GPR. (Trenutno je problem sto ne znamo da li je Fica ili je Fedja MEM instrukcija)
2. Jedinica za detekciju hazarda mora biti svesna da je u MEM jedinici neka instrukcija koja dovlaci npr r1, i da detektuje hazard ako neka instrukcija koristi r1 dok se on jos uvek dovlaci iz memorije.

## Resena pitanja: ##

1. [Stall_generator_test](https://drive.google.com/file/d/0BwMJvMt6otSRdWNGSnBoWFJjYnc/view?usp=sharing). Na slici je crvenom strelicom oznaceno kada switch treba da propusti i drugu instrukciju (Fedju) na func jedinicu. Trenutno switch to ne radi, treba razmisliti kako to resiti. Moguce je staviti signal od SM ka Switch, koji ce na skok mem_done da signalizira switcu da propusti drugu instrukciju. 
(Opis resenja): Dodati su novi signali (niz duzine 2) koji se vode na switch i koji mu govore da li da prosledi instrkicju. Signali validnosti su zadrzani, zovu se ready signali.
1. Gde staviti PSW? Sinhronizacija PSW? (Opis resenja): PSW ce biti poseban entitet u trecem delu. Taj entitet bi mogao i da radi sinhronizaciju. Posto 2 alu jedinice mogu da generisu novi sadrzaj PSW onda bi na osnovu PC moglo da se odluci koji da se upise u PSW. Dakle sinhronizacija isto kao kod GPR, samo sto sada to moze biti sastavni deo entiteta gde je PSW. Iz PSW se biti N,Z,C i V vode direktno u BR jedinicu (ne preko ulaznih bafera vec direktno). Pokusao sam da sagledam situaciju i ne vidim problem zasto ne bi moglo ovako (druga ideja je da postoji jedinica za prosledjivanje i da se nova vrednost PWS prosledjuje na ulazne bafere BR). Dakle ako imamo Ficu i Fedju da budu ALU i BR (recimo da ova ALU instrukcija generise PSW) onda postoji hazard tipa A. ALU inst ulazi u func jedinicu, BR ceka. U sledecm taktu ALU func je odradila instrukciju, na ulazima u GPR i PSW su nove vrednosti (i cekaju sledeci takt da se upisu), takodje na ulazima u BR je BR instrukcija (i ceka sledeci takt da se upise). U sledecem taktu PSW je upisan i na izlazima iz PSW je aktuelna vrednost, BR instrukcija je upisana u ulazne bafere BR jedinice i izvrsava se, znaci imamo validnu vrednost PSW za izvrsavanje.
3. Nacrtati novu sliku organizacije. Trenutna slika je crtana pre nego sto je bilo sta implementirano pa je slika pomalo zastarila. (Opis resenja): Slika nacrtana i smestena u folder.