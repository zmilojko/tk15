puts "Creating content pages"
CmsBlock.delete_all
CmsBlock.create!  name: "home",
                  content:  <<-PAGE.strip_heredoc
                  ### Tervetuloa nauttimaan koiravaljakkokilpailuista kauniissa ympäristössä Taivalkoskella!

                  Taivalvaaran uudistettu hiihtostadion tarjoaa sprinttikisoille upeat puitteet- tule koko perheen kanssa, aktiviteetteja löytyy kaikille!

                  Lapsille oma kilpailu!

                  Järjestävänä seurana toimii Metsä-Veikot 85 yhteistyössä Rovaniemen palveluskoirakerhon kanssa!
                  PAGE

CmsBlock.create!  name: "info",
                  content:  <<-PAGE.strip_heredoc
                  Kisoihin ilmoittautuminen tapahtuu ilmoittautumislomakkeen kautta.

                  Maksu suoritetaan Metsä-Veikot 85 tilille FI1054550740011704, viite 4019. Maksukuitti liitetään ilmoittautumislomakkeelle!

                  Osallistumismaksut: Valjakkoajo 60€/2pv, hiihtoluokat 30€/pv, harrastussarja 10€/pv + tarvittava lisenssi 10€/pv.

                  Viimeinen ilmoittautumispäivä on 28.2.2015. Harrastussarjoihin voi ilmoittautua myös paikan päällä!

                  **Sarjat ja matkat lauantai 7.3.:**

                  - SM Sp4 & Sp4j 7,2km
                  - Sp6 12km
                  - SM Sp814km
                  - Spu 22km
                  - NMS1 A 11km, B 7,2km
                  - NWS1 A 11km, B 5,5km
                  - NMSJ & NWMJ A&B 5,5km
                  - Veteraanimiehet ja -naiset A&B 5,5km
                  - Harrastussarja hiihto 5,5km
                  
                  **Sarjat ja matkat sunnuntai 8.3.:**

                  - SM Sp4 & Sp4j 7,2km
                  - Sp6 12km
                  - SM Sp8 14km (2 kierrosta)
                  - Spu 22km (2 kierrosta)
                  - NMC A 11km
                  - NWC A 11km
                  - Harrastussarja hiihto 5,5km
                  - Lapsille järjestetään oma sarja aikataulujen puitteissa joko lauantaina tai sunnuntaina!
                  PAGE
