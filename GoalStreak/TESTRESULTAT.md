# ✅ Testsammanfattning - ProfilePage (Redigera Profil)

## 📱 Test Environment
- **App Version**: v1
- **Device**: iPhone (simulator), Pixel 2 (simulator), Pixel 7a (fysisk enhet)
- **OS Version**: 18.3
- **Tester**: Jonas
- **Test Date**: 11-12.02.2026

---

## Testresultat

| Kategori                          | Godkända | Underkända | Ej testade | Totalt |
|-----------------------------------|----------|------------|------------|--------|
| 1. Profilvisning                  | 15       | 0          | 0          | 15     |
| 2. Redigeringsläge               | 9        | 1          | 0          | 10     |
| 3. Personlig Information          | 17       | 1          | 0          | 18     |
| 4. E-post och Telefon            | 22       | 1          | 0          | 23     |
| 5. Adressinformation             | 18       | 1          | 0          | 19     |
| 6. Profilbildsuppladdning        | 17       | 1          | 2          | 20     |
| 7. Formulärvalidering            | 10       | 0          | 2          | 12     |
| 8. Sparfunktion                  | 12       | 0          | 0          | 12     |
| 9. Åtgärdsknappar                | 16       | 6          | 4          | 26     |
| 10. Tangentbordshantering        | 16       | 0          | 0          | 16     |
| 11. Pull-to-Refresh              | 7        | 0          | 0          | 7      |
| 12. Layout och Responsivitet     | 12       | 0          | 4          | 16     |
| **Totalt**                        | **171**  | **11**     | **12**     | **194**|

- **Godkända**: 171 (88%)
- **Underkända**: 11 (6%)
- **Ej testade / Ej verifierade**: 12 (6%)

---

## 🔴 Kritiska buggar funna

### BUG-1: Tillbaka-knapp på Kontakta oss-sidan fungerar inte (Test 9.2.1, 9.2.2, 9.2.3)
- **Allvarlighetsgrad**: Kritisk
- **Beskrivning**: Efter att ha navigerat till "Kontakta oss"-sidan och tryckt på "Skicka meddelande" med tomma fält, eller efter att ha interagerat med "Andra sätt nå oss"-sektionen, slutar tillbaka-knappen att fungera. Användaren kan inte navigera tillbaka utan att starta om appen.
- **Steg att reproducera**:
  1. Gå till Profil → Kontakta oss
  2. Lämna fältet tomt och tryck på "Skicka meddelande"
  3. Försök trycka på tillbaka-knappen
- **Förväntat resultat**: Användaren navigeras tillbaka till profil-sidan
- **Faktiskt resultat**: Tillbaka-knappen reagerar inte, appen måste startas om
- **Påverkan**: Användaren fastnar på sidan och måste starta om appen

### BUG-2: E-post- och Telefonknappar på Kontakta oss-sidan reagerar inte (Test 9.2.2)
- **Allvarlighetsgrad**: Kritisk
- **Beskrivning**: Knapparna "E-post" och "Telefon" i "Andra sätt nå oss"-sektionen på kontaktsidan reagerar inte vid tryck.
- **Steg att reproducera**:
  1. Gå till Profil → Kontakta oss
  2. Scrolla till "Andra sätt nå oss"
  3. Tryck på "E-post" eller "Telefon"
- **Förväntat resultat**: E-postklient respektive telefonapp öppnas
- **Faktiskt resultat**: Ingenting händer
- **Påverkan**: Användaren kan inte kontakta support via e-post eller telefon

### BUG-3: Formulärvalidering saknas vid "Skicka meddelande" på Kontakta oss (Test 9.2.1)
- **Allvarlighetsgrad**: Kritisk
- **Beskrivning**: Inget felmeddelande visas när användaren trycker på "Skicka meddelande" med tomma fält på kontaktsidan.
- **Steg att reproducera**:
  1. Gå till Profil → Kontakta oss
  2. Lämna meddelandefältet tomt
  3. Tryck på "Skicka meddelande"
- **Förväntat resultat**: Felmeddelande visas som informerar att fältet är obligatoriskt
- **Faktiskt resultat**: Inget felmeddelande visas

---

## 🟡 Mindre buggar funna

### BUG-4: Specialtecken i namn kapitaliseras inte korrekt (Test 3.1)
- **Allvarlighetsgrad**: Låg
- **Beskrivning**: Namn med bindestreck (t.ex. "Anna-Maria") accepteras men kapitaliseras inte korrekt. Delen efter bindestrecket bör också börja med stor bokstav.
- **Steg att reproducera**:
  1. Öppna redigeringsläge
  2. Skriv "anna-maria" i förnamn-fältet
  3. Tryck på nästa fält
- **Förväntat resultat**: "Anna-Maria"
- **Faktiskt resultat**: Kapitalisering efter bindestreck fungerar inte korrekt

### BUG-5: Telefonfältet tillåter inte bindestreck (-) som inputtecken (Test 4.2)
- **Allvarlighetsgrad**: Låg
- **Beskrivning**: Telefonfältet filtrerar bort bindestreck trots att format som "070-123 45 67" bör accepteras. Filtret tillåter siffror, + och mellanslag men saknar bindestreck.
- **Steg att reproducera**:
  1. Öppna redigeringsläge
  2. Gå till telefonfältet
  3. Försök skriva "070-1234567"
- **Förväntat resultat**: Bindestreck ska kunna skrivas in
- **Faktiskt resultat**: Bindestreck filtreras bort

### BUG-6: Osparade ändringar återställs när redigeringsläge stängs (Test 2.2)
- **Allvarlighetsgrad**: Låg
- **Beskrivning**: När användaren stänger redigeringsläget (X-knappen) utan att spara, återställs alla fält till sina ursprungliga värden istället för att behålla de ändrade värdena.
- **Steg att reproducera**:
  1. Öppna redigeringsläge
  2. Ändra ett eller flera fält
  3. Tryck på stäng-ikonen (X)
  4. Öppna redigeringsläget igen
- **Förväntat resultat**: Ändrade värden bör finnas kvar i fälten
- **Faktiskt resultat**: Fälten återställs till originalvärden

### BUG-7: Land-fältet saknar validering för tomt fält (Test 5.4)
- **Allvarlighetsgrad**: Medel
- **Beskrivning**: Land-fältet visar inget felmeddelande ("Land är obligatoriskt") när det lämnas tomt.
- **Steg att reproducera**:
  1. Öppna redigeringsläge
  2. Lämna land-fältet tomt
  3. Försök spara
- **Förväntat resultat**: Felmeddelande "Land är obligatoriskt" visas
- **Faktiskt resultat**: Ingen validering sker

### BUG-8: Uppladdningsfel vid profilbild — "An unexpected error occurred while uploading image" (Test 6.2, 6.3)
- **Allvarlighetsgrad**: Medel
- **Beskrivning**: Vid uppladdning av profilbild (både från kamera och galleri) uppstår ibland felet "An unexpected error occurred while uploading image". Loading-spinner fungerar inte korrekt vid galleriuppladdning.
- **Steg att reproducera**:
  1. Öppna redigeringsläge
  2. Tryck på kamera-ikonen
  3. Välj "Ta foto" eller "Välj från galleri"
  4. Ta/välj ett foto
- **Förväntat resultat**: Bilden laddas upp och visas korrekt med loading-spinner
- **Faktiskt resultat**: Felmeddelande "An unexpected error occurred while uploading image" visas

---

## ⬜ Ej testade / Ej verifierade

| # | Test | Anledning |
|---|------|-----------|
| 1 | Test 6.6: Filstorleksbegränsning (>10MB) | Testbild var 7,6 MB, för liten för att trigga begränsningen |
| 2 | Test 6.6: Ogiltig filtyp (PDF) | Ej testat — oklart om filtypsfiltrering finns |
| 3 | Test 7.1: Felmeddelanden visas/döljs dynamiskt | Ej helt verifierat |
| 4 | Test 7.3: Felmeddelanden vid misslyckad validering innan spara | Ej verifierat |
| 5 | Test 9.4: Radera konto — fullständigt flöde | Kunde inte verifiera — verifieringsmail skickades inte och det finns ingen möjlighet att skicka om verifiering |
| 6 | Test 12.3: iPad-layout | Ej testat — ingen iPad tillgänglig |
| 7 | Test 12.4: Dark mode | Ej testat — funktionen stöds inte |

---

## 💡 Förbättringsförslag

1. **Implementera dark mode-stöd**: Appen stöder för närvarande inte dark mode. Att lägga till stöd för mörkt tema förbättrar användarupplevelsen, särskilt vid användning i mörka miljöer.

2. **Lägg till "Skicka verifiering igen"-funktion**: Vid kontoregistrering saknas möjlighet att skicka om verifieringsmailet, vilket gör det omöjligt att verifiera kontot om det första mailet inte når fram.

3. **Förbättra felmeddelanden vid bilduppladdning**: Felmeddelandet "An unexpected error occurred while uploading image" är för generiskt. Mer specifika felmeddelanden (nätverksfel, filstorlek, serverfel) bör implementeras.

4. **Lägg till filstorleksbegränsning**: Implementera tydlig kontroll och feedback för maximal bildstorlek vid profilbildsuppladdning.

5. **Förbättra navigering på Kontakta oss-sidan**: Tillbaka-navigering måste fungera konsekvent i alla lägen, och E-post/Telefon-knapparna måste vara funktionella.

6. **Lägg till land-validering**: Implementera saknad obligatorisk validering för land-fältet.

7. **Testa på iPad**: Planera in testning på iPad för att säkerställa korrekt layout och responsivitet på större skärmar.

---

## 📝 Övriga kommentarer

- Majoriteten av ProfilePage-funktionaliteten fungerar väl (88% godkänt).
- De mest kritiska buggarna rör kontaktsidans navigering där användaren fastnar och måste starta om appen.
- Formulärvalidering fungerar generellt bra men saknar validering på land (tomt fält).
- Sparfunktionen (Section 8) fungerar mycket bra med korrekt hantering av nätverksfel, laddningsindikator och framgångsmeddelande.
- Tangentbordshantering (Section 10) och pull-to-refresh (Section 11) fungerar felfritt.
- Kontoradering kunde inte helt verifieras på grund av problem med verifieringsmailet.

---

**Signatur Tester**: Jonas  
**Datum**: 12.02.2026
