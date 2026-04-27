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

## Technológiai verem

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

Telepítés
1. Klónozd a repository-t

git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name

2. Telepítsd a csomagokat

npm install

3. Hozd létre a .env fájlt
Add meg a saját környezeti változóidat a fenti példa alapján. 
4. Indítsd el a szervert

npm run dev 
CORS beállítás
A backend jelenleg az alábbi origin-ekről engedélyezi a kéréseket:
http://localhost:5173
https://csetli.netlify.app
Ha a frontendet máshová telepíted, frissítsd a CORS beállítást a forráskódban.

Statikus fájlok
A feltöltött képek a /uploads útvonalon érhetők el.
Példa:

http://localhost:3000/uploads/filename.jpg

Hitelesítés
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

API végpontok
Hitelesítés
Regisztráció
POST /regisztracio
Form-data:
email
felhasznalonev
jelszo
kep_neve (file)
Login / Belépés
POST /belepes
Body:
{
  "felhasznalonevVagyEmail": "example@email.com",
  "jelszo": "password123"
}

Logout / Kijelentkezés
POST /kijelentkezes

User / Felhasználó
Saját adatok lekérése
GET /adataim
Felhasználónév módosítása
PUT /felhasznalonev
```bash
{
  "ujfelhasznalonev": "newUsername"
}
```

E-mail módosítása
```bash
email
{
  "ujEmail": "new@email.com"
}
```

Jelszó módosítása
PUT /jelszo
```bash
{
  "jelenlegiJelszo": "oldPassword",
  "ujJelszo": "newPassword"
}
```

Profilkép módosítása
PUT /profilkep
Form-data:
ujProfilkep (file)
Fiók törlése
DELETE /fiokom

Bejegyzések
Bejegyzés létrehozása
a kép és a szöveg opcionális,de nem lehet üres posztot létrehozni
POST /bejegyzes
Form-data: 
tartalom (opcionális)
kep ( opcionális fájl)
Összes bejegyzés lekérése
GET /bejegyzesek
Delete post / Bejegyzés törlése
DELETE /bejegyzes/:bejegyzes_id

Kommentek
Add comment / Komment hozzáadása
POST /komment
```bash
{
  "tartalom": "Nice post!",
  "bejegyzes_id": 1
}
```

Kommentek lekérése egy bejegyzéshez
GET /kommentek/:bejegyzes_id
GET /kommentSzam
Bejegyzéshez
GET /kommentSzamBejegyzes/:bejegyzes_id

Reakciók
Emoji reakció váltása
POST /emoji/:bejegyzes_id
```bash
{
  "emoji1": 1
}
```

Emoji darabszám lekérése
GET /emojiCount/:bejegyzes_id

Ismerősök
Követés / Ismerős hozzáadása
POST /kovetes/:felhasznalo_id
Ismerős törlése / Követés megszüntetése
DELETE /kovetes/:ismeros_id
Ismerős állapot ellenőrzése
GET /koveti/:felhasznalo_id
Ismerősök lekérése
GET /ismerosok
Összes felhasználó lekérése
GET /emberek

Chat / Chat
POST /szobaCsinalas/:ismerosId
Üzenet küldése
POST /uzenetkuldes/:szobaId
```bash
{
  "szoveg": "Hello!"
}
```

Üzenetek lekérése
GET /uzenetek/:szobaId

Database / Adatbázis
A projekt egy MySQL adatbázist használ felhasználók, ismerős kapcsolatok, chat szobák, üzenetek, bejegyzések, kommentek és reakciók tárolására.
Adatbázis séma kép:
Adatbázis séma

Példa válaszok
Sikeres belépés
```bash
{
  "message": "Sikeres belépés"
}
```

Sikeres bejegyzés létrehozása
```bash
{
  "message": "Sikeres bejegyzes létrehozás"
}
```

Megjegyzések
A jelszavak bcrypt segítségével vannak hashelve
A hitelesítés JWT-vel történik
A fájlfeltöltést a multer kezeli
A védett végpontokhoz érvényes hitelesítési cookie szükséges
Az útvonalnevek és sok válaszüzenet magyar nyelvű

Lehetséges fejlesztések
A backend több része tovább fejleszthető:
jobb hibakezelés és pontosabb státuszkódok
egységesebb bemeneti validáció
feltöltött fájlok típus- és méretellenőrzése
kapcsolódó fájlok törlése a háttértárból adat törlésekor
erősebb jogosultság-ellenőrzések
jobb adatbázis constraint-ek és indexek
egységesebb névadás az útvonalaknál és oszlopoknál

Jövőbeli tervek
többféle emoji támogatása
értesítési rendszer
felhasználókeresés
refresh token alapú hitelesítés
felhő alapú képtárolás

Készítette: 

-Plébán Tamás  
-Kincses László 
-Tömöri Gábor

Frontend repository:
https://github.com/FreyaNahIdwin/CSSETLI_FRONTEND 
