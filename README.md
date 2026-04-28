# Csetli Backend API 

 
Egy közösségi média jellegű alkalmazás backend API-ja, amely **Node.js**, **Express.js**, **MySQL**, **JWT hitelesítés** és **Multer** használatával készült képfeltöltéshez.

## Áttekintés

Ez a backend kezeli a felhasználói hitelesítést, profilkezelést, bejegyzéseket, kommenteket, reakciókat, ismerős kapcsolatokat, chatszobákat és az üzenetküldést.

### Fő funkciók

- regisztráció és belépés
- JWT hitelesítés cookie-val
- profil adatok módosítása
- bejegyzések létrehozása és törlése
- kommentek és reakciók
- ismerős-követés rendszer
- privát chat szobák és üzenetküldés
-  fiók törlése

---

## Technológiák

- **Node.js**
- **Express.js**
- **MySQL**
- **mysql2**
- **jsonwebtoken**
- **bcryptjs**
- **cookie-parser**
- **cors**
- **multer**
- **validator**
- **dotenv**
- **node-email-verifier**

---

## Funkciók

### Hitelesítés 
 - Regisztráció e-mail címmel, felhasználónévvel, jelszóval és profilképpel
- Belépés felhasználónévvel vagy e-mail címmel
- JWT alapú hitelesítés
- Biztonságos cookie-kezelés
- Kijelentkezési végpont  

### Felhasználókezelés
- Felhasználónév módosítása
- E-mail cím módosítása
- Jelszó módosítása
- Profilkép módosítása
- Bejelentkezett felhasználó adatainak lekérése
- Saját fiók törlése

### Bejegyzések
- Bejegyzés létrehozása szöveggel és opcionális képpel
- Összes bejegyzés lekérése
- Saját bejegyzés törlése

### Kommentek
- Komment hozzáadása bejegyzéshez
- Egy bejegyzés kommentjeinek lekérése
- Kommentek teljes számának lekérése
- Kommentek számának lekérése bejegyzésenként

### Reakciók
- Emoji reakció hozzáadása vagy eltávolítása
- Egy bejegyzés reakció számának lekérése

### Ismerősök / Követés
- Másik felhasználó követése / ismerősnek jelölése
- Ismerős törlése / követés megszüntetése
- Ismerős állapot ellenőrzése
- Ismerősök listázása
- Az aktuális felhasználón kívüli összes felhasználó lekérése

### Chat
- Privát chat szoba létrehozása vagy lekérése
- Üzenet küldése chatszobában
- Chatszoba üzeneteinek lekérése

— 

##  Projektstruktúra 
```bash
backend/
│── uploads/
│── .env
│── server.js
│── package.json
```
Környezeti változók
Hozz létre egy .env fájlt a backend projekt gyökerében.
PORT=3000
HOST=localhost

JWT_SECRET=your_jwt_secret
JWT_EXPIRES_IN=7d

DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=a_jelszavad
DB_NAME=adatbazisod_neve

## Telepítés
1. Klónozd a repository-t

```
git clone https://github.com/FreyaNahIdwin/CSETLI_BACKEND.git
cd CSETLI_BACKEND
```

2. Telepítsd a csomagokat

```
npm install
```

3. Hozd létre a .env fájlt

```
Add meg a saját környezeti változóidat a fenti példa alapján. 
```

5. Indítsd el a szervert

```
npm run dev 
CORS beállítás
A backend jelenleg az alábbi origin-ekről engedélyezi a kéréseket:
http://localhost:5173
https://csetli.netlify.app
Ha a frontendet máshová telepíted, frissítsd a CORS beállítást a forráskódban.
```

## Statikus fájlok
A feltöltött képek a /uploads útvonalon érhetők el.
Példa: http://localhost:3000/uploads/filename.jpg

## Hitelesítés
A védett útvonalak az auth_token cookie-t használják.
A JWT egy HTTP-only cookie-ban kerül tárolásra az alábbi beállításokkal:
httpOnly: true
secure: true
sameSite: 'none'
path: '/'
Fontos!
a frontend kéréseknek credentials opcióval kell menniük
a backend CORS-nak engedélyeznie kell a credentials használatát
éles környezetben HTTPS szükséges a secure cookie miatt

## API végpontok

Ez a dokumentum az alkalmazás backend végpontjait és azok használatát részletezi.

## 1. Hitelesítés (Authentication)

| Végpont | Metódus | Leírás | Paraméterek / Body |
| :--- | :--- | :--- | :--- |
| `/regisztracio` | **POST** | Új felhasználó regisztrálása | `Form-data`: email, felhasznalonev, jelszo, kep_neve (file) |
| `/belepes` | **POST** | Bejelentkezés a rendszerbe | `JSON`: `{"felhasznalonevVagyEmail": "...", "jelszo": "..."}` |
| `/kijelentkezes` | **POST** | Aktuális munkamenet lezárása | - |

---

## 2. Felhasználó (User)

| Végpont | Metódus | Leírás | Paraméterek / Body |
| :--- | :--- | :--- | :--- |
| `/adataim` | **GET** | Saját profiladatok lekérése | - |
| `/felhasznalonev` | **PUT** | Felhasználónév módosítása | `JSON`: `{"ujfelhasznalonev": "newUsername"}` |
| `/email` | **PUT** | E-mail cím módosítása | `JSON`: `{"ujEmail": "new@email.com"}` |
| `/jelszo` | **PUT** | Jelszó módosítása | `JSON`: `{"jelenlegiJelszo": "...", "ujJelszo": "..."}` |
| `/profilkep` | **PUT** | Profilkép cseréje | `Form-data`: `ujProfilkep` (file) |
| `/fiokom` | **DELETE** | Felhasználói fiók törlése | - |

---

## 3. Bejegyzések (Posts)

| Végpont | Metódus | Leírás | Paraméterek / Body |
| :--- | :--- | :--- | :--- |
| `/bejegyzes` | **POST** | Új bejegyzés létrehozása | `Form-data`: `tartalom` (opc.), `kep` (opc.) |
| `/bejegyzesek` | **GET** | Összes bejegyzés lekérése | - |
| `/bejegyzes/:id` | **DELETE** | Adott bejegyzés törlése | URL paraméter: `bejegyzes_id` |

---

## 4. Kommentek (Comments)

| Végpont | Metódus | Leírás | Paraméterek / Body |
| :--- | :--- | :--- | :--- |
| `/komment` | **POST** | Hozzászólás írása | `JSON`: `{"tartalom": "...", "bejegyzes_id": 1}` |
| `/kommentek/:id` | **GET** | Bejegyzéshez tartozó kommentek | URL paraméter: `bejegyzes_id` |
| `/kommentSzam` | **GET** | Rendszerszintű kommentszám | - |
| `/kommentSzamBejegyzes/:id` | **GET** | Egy poszt kommentjeinek száma | URL paraméter: `bejegyzes_id` |

---

## 5. Reakciók (Reactions)

| Végpont | Metódus | Leírás | Paraméterek / Body |
| :--- | :--- | :--- | :--- |
| `/emoji/:id` | **POST** | Emoji reakció küldése/váltása | `JSON`: `{"emoji1": 1}` |
| `/emojiCount/:id` | **GET** | Reakciók száma egy poszton | URL paraméter: `bejegyzes_id` |

---

## 6. Ismerősök (Friends)

| Végpont | Metódus | Leírás | Paraméterek / Body |
| :--- | :--- | :--- | :--- |
| `/kovetes/:id` | **POST** | Felhasználó követése | URL paraméter: `felhasznalo_id` |
| `/kovetes/:id` | **DELETE** | Követés megszüntetése | URL paraméter: `ismeros_id` |
| `/koveti/:id` | **GET** | Követési állapot ellenőrzése | URL paraméter: `felhasznalo_id` |
| `/ismerosok` | **GET** | Saját ismerősök listája | - |
| `/emberek` | **GET** | Összes felhasználó listázása | - |

---

## 7. Chat

| Végpont | Metódus | Leírás | Paraméterek / Body |
| :--- | :--- | :--- | :--- |
| `/szobaCsinalas/:id` | **POST** | Chat szoba létrehozása | URL paraméter: `ismerosId` |
| `/uzenetkuldes/:id` | **POST** | Üzenet küldése | `JSON`: `{"szoveg": "Hello!"}` |
| `/uzenetek/:id` | **GET** | Üzenetek lekérése | URL paraméter: `szobaId` |

## Adatbázis
A projekt egy MySQL adatbázist használ felhasználók, ismerős kapcsolatok, chat szobák, üzenetek, bejegyzések, kommentek és reakciók tárolására.
DrawSQL adatbáris kép:
<img width="2882" height="1876" alt="drawSQL-image-export-2025-09-18 (1)" src="https://github.com/user-attachments/assets/d25eba6f-ccd0-4972-9235-96324eabe7ea" />

## Biztonság
- A jelszavak bcrypt segítségével vannak hashelve
- A hitelesítés JWT-vel történik
- A fájlfeltöltést a multer kezeli
- A védett végpontokhoz érvényes hitelesítési cookie szükséges
- Az útvonalnevek és sok válaszüzenet magyar nyelvű

## Lehetséges fejlesztések
- A backend több része tovább fejleszthető:
- jobb hibakezelés és pontosabb státuszkódok
- egységesebb bemeneti validáció
- feltöltött fájlok típus- és méretellenőrzése
- kapcsolódó fájlok törlése a háttértárból adat törlésekor
- erősebb jogosultság-ellenőrzések
- jobb adatbázis constraint-ek és indexek
- egységesebb névadás az útvonalaknál és oszlopoknál

## Jövőbeli tervek
- többféle emoji támogatása
- értesítési rendszer
- felhasználókeresés
- refresh token alapú hitelesítés
- felhő alapú képtárolás

## Készítette: 
- [Plébán Tamás](https://github.com/FreyaNahIdwin)  
- [Kincses László](https://github.com/T3KK3NHU)
- [Tömöri Gábor](https://github.com/Tomorigabor440)

## Frontend repository:
https://github.com/FreyaNahIdwin/CSSETLI_FRONTEND 
