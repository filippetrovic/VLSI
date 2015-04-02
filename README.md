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
ovaj deo sadrzi registarski fajl i zaduzen je da instrukcije koje dolaze iz fronenda prosledi na odgovarajucu funckionalnu jedinicu (ALU, MEM, BRANCH), tj da je prosledi u backend procesora.
ovaj deo osim prosledjivanja vodi racuna o hazardima i prosledjivanju vrednosti (da bi izbegli stall pipelinea). U slucaju da ne moze izbeci hazard stopira frontend signalom stall. 

Sadrzaj:

1. GPR File: Registarski fajl sa mogucnoscu cetiri istovremena citanja i cetiri (valjda) upisa.
2. Jedinica za prosledjivanje: kombinaciona mreza koja treba da prosledi odgovarajucu instrukciju na odgovarajucu funkcionalnu jedinici.
3. Jedinica za detekciju hazarda: Samo ime kaze, detektuje kada se mora zaustaviti pipeline.
4. Jedinica za prosledjivanje: Detektuje kada je moguce proslediti izlaz neke funkc. jedinice na ulaz neke funkc. jedinice.

## Treci deo (BACKEND): ##
Ovaj deo cine funcionalne jedinice (ALU, MEM, Branch) kao i kombinaciona mreza koja radi sinhronizaciju upisa u reg fajl. 

Sadrzaj:

1. Funkcionalne jedinice su opisane u tekstu projekta. Rade tako sto imaju buffere na ulazu, srednji deo procesora upise u ove buffere i na sledeci takst se izvrsi operacija. 
2. Komb. mreza za sinhronizaciju upisa: Ideja je da ako postoje dve alu instrkucije (ili slicno) koje generisu neku vrednost i za destinaciju imaju isti registar npr. R3, tada jedna instrukcija nema smisla i treba videti koja ima veci PC i njenu vrednost upisati a instrukciju sa manjim PC zanemariti.