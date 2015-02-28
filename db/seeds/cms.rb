puts "Creating content pages"
CmsBlock.delete_all
CmsBlock.create!  name: "home",
                  content:  <<-PAGE.strip_heredoc
                  ### Tervetuloa nauttimaan koiravaljakkokilpailuista kauniissa ympäristössä Taivalkoskella!

                  Taivalvaaran uudistettu hiihtostadion tarjoaa sprinttikisoille upeat puitteet- tule koko perheen kanssa, aktiviteetteja löytyy kaikille!

                  **Lapsille oma kilpailu!**

                  Järjestävänä seurana toimii [Metsä-Veikot 85](http://www.metsaveikot85.fi/fi/Mets%C3%A4-Veikot85.html)
                  yhteistyössä Rovaniemen palveluskoirakerhon kanssa!
                  PAGE

CmsBlock.create!  name: "info",
                  content:  <<-PAGE.strip_heredoc
                  Kisoihin ilmoittautuminen tapahtuu ilmoittautumislomakkeen kautta.

                  Maksu suoritetaan Metsä-Veikot 85 tilille FI1054550740011704, viite 4019. Maksukuitti liitetään ilmoittautumislomakkeelle!

                  Osallistumismaksut: Valjakkoajo 60€/2pv, hiihtoluokat 30€/pv, harrastussarja 10€/pv + tarvittava lisenssi 10€/pv.

                  Viimeinen ilmoittautumispäivä on 28.2.2015. Harrastussarjoihin voi ilmoittautua myös paikan päällä!

                  **Sarjat ja matkat lauantai 7.3:**

                  - SM Sp4 & Sp4j 7,2km
                  - Sp6 12km
                  - SM Sp814km
                  - Spu 22km
                  - NMS1 A 11km, B 7,2km
                  - NWS1 A 11km, B 5,5km
                  - NMSJ & NWMJ A&B 5,5km
                  - Veteraanimiehet ja -naiset A&B 5,5km
                  - Harrastussarja hiihto 5,5km
                  
                  **Sarjat ja matkat sunnuntai 8.3:**

                  - SM Sp4 & Sp4j 7,2km
                  - Sp6 12km
                  - SM Sp8 14km (2 kierrosta)
                  - Spu 22km (2 kierrosta)
                  - NMC A 11km
                  - NWC A 11km
                  - Harrastussarja hiihto 5,5km
                  - Lapsille järjestetään oma sarja aikataulujen puitteissa joko lauantaina tai sunnuntaina!
                  PAGE

CmsBlock.create!  name: "start-list-not-ready-info",
                  content:  <<-PAGE.strip_heredoc
                  Lähtölista julkistetaan tällä sivulla, kun kaikki ilmoittautumiset on käsitelty.
                  PAGE
CmsBlock.create!  name: "venue",
                  content:  <<-PAGE.strip_heredoc
                  Kilpailupaikkana toimii Taivalvaaran hiihtostadion. Stadion on kokenut mittavan uudistumisen viime vuosien aikana.
                  Alueelle on rakennettu uusi hiihtostadion sekä monitoimitalo.

                  Metsä-Veikot ovat järjestäneet hiihtostadionilla nuorten SM hiihdot vuonna 2013 ja tulevat järjestämään siellä vuonna 2016 yleisen sarjan SM hiihdot.
                  PAGE
CmsBlock.create!  name: "location",
                  content:  <<-PAGE.strip_heredoc
                  ### Sijainti

                  Taivalkosken kunta sijaitsee Pohjois-Pohjanmaan maakunnassa Koillismaalla. Kunta rajoittuu lännessä Pudasjärven,
                  idässä Kuusamon, pohjoisessa Posion ja etelässä Suomussalmen kuntiin.

                  Tärkeimpiä etäisyyksiä maanteitse:

                  - Helsinki 777 km
                  - Oulu 154 km
                  - Kajaani 210 km
                  - Kemijärvi 196 km
                  - Kuusamo 64 km
                  - Rovaniemi 216 km

                  ### Majoitus

                  Taivalkosken majoituskohteet löytyvät [matkailusivustolta](http://www.visittaivalkoski.fi/majoitus). Muita
                  majoituskohteita alle 40km päästä löytyy [Pikku-Syötteellä](http://www.pikkusyote.fi/fi/hotelli) sekä
                  [Iso-Syötteellä](http://www.syote.fi/fi/etusivu/).

                  Samaan aikaan järjestettävä Rajalta rajalle hiihto vie ison osan Hotelli Herkon sekä Hotelli Pikku-Syötteen petipaikoista.

                  # Aktiviteetteja

                  **[Taivalvaara](www.taivalvaara.fi)** on ennen kaikkea perinteinen talviurheilukeskus, josta löytyy laskettelurinteet,
                  välinevuokraus, hyppyrimäet, hiihtoladut ja kahvila, mutta tekemistä löytyy ympäri vuoden.

                  **[Frisbeegolfpuisto](http://www.visittaivalkoski.fi/frisbee-golf/frisbeegolfpuisto-seikkailupuisto).** 18-väylää ja 9-väylää rata.
                  **Seikkailupuisto:** Kesällä käytössä on 13,5 metriä korkea kiipeilyseinä, 16 m köysilaskeutumispiste, sekä kolme eritasoista
                  seikkailurataa.

                  **[Sauvakävelypuisto](http://www.visittaivalkoski.fi/vaellus-sauvakavely/sauvakavelypuisto-taivalvaara).** Taivalvaaralla ei panna
                  kesälläkään sauvoja naulaan. Suomen ensimmäinen sauvakävelypuisto löytyy Taivalkoskelta. Taivalvaaran maastossa on 6 reittiä,
                  joiden vaatimustaso vaihtelee helposta vaikeaan.

                  **[Melontakeskus.](http://www.visittaivalkoski.fi/melonta/melontakeskus).** Taivalkosken melontakeskus on monipuolinen vesiurheilukeskus.
                  Melontakeskuksessa on mahdollista harrastaa kanoottipujottelua, freestylemelontaa, opetella melonnan alkeita tai laskea riverboogielaudalla.

                  **[Muita aktiviteetteja:](http://www.visittaivalkoski.fi/aktiviteetit).** Husky safarit, lumikenkäily, moottorikelkkailu, maastopyöräily.

                  ### Nähtävyydet

                  Vapaana virtaava komea Iijoki värittää Taivalkosken maisemat jylhiksi. Se tarjoaa luonnon rauhaa ja eräkokemuksia läpi vuoden.
                  Luonnosta, elämästä sen äärellä ja aidoista kokemuksista on myös imetty inspiraatiota paikallisiin tapahtumiin. Taivalkoskella
                  on kulttuuritapahtumia, luonnonrauhaa ja eräkokemuksia jokaiseen makuun.

                  Kulttuurinähtävyyksiä: Jalavan Kauppa, Kallioniemi - Kalle Päätalon lapsuudenkoti, Kenttärata,
                  [Lisätietoja.](http://www.visittaivalkoski.fi/nahtavyydet/kulttuurinahtavyydet)

                  Luonnon nähtävyydet: Kylmäluoman retkeily- ja aarnialue, Pahkakuru, Pyhitys, Soiperoinen,
                  Syötteen kansallispuisto. [Lisätietoja.](http://www.visittaivalkoski.fi/nahtavyydet/luonnon-nahtavyydet)
                  PAGE
