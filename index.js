require('dotenv').config()


const express = require('express')
const cors = require('cors')
const cookieParser = require('cookie-parser')
const mysql = require('mysql2/promise')
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const emailValidator = require('node-email-verifier');
const multer = require('multer')
const path = require('path');
const validator = require('validator');

///config
const PORT = process.env.PORT
const HOST = process.env.HOST
const JWT_SECRET = process.env.JWT_SECRET
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN
const COOKIE_NAME = 'auth_token'

///cookie beallitas
const COOKIE_OPTS = {
    httpOnly: true,
    secure: true,
    sameSite: 'none',
    path: '/',
    maxAge: 7 * 24 * 60 * 60 * 1000,
}

const db = mysql.createPool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
})

//app
const app = express();
app.use(express.json())
app.use(cookieParser())
app.use(cors({
    origin: '*',
    credentials: true
}))

app.use('/uploads', express.static(path.join(__dirname, 'uploads')))

const storage = multer.diskStorage({
    destination: "./uploads/",
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname))
    }
})

const upload = multer({ storage })

///middleware
function auth(req, res, next) {
    const token = req.cookies[COOKIE_NAME];
    if (!token) {
        return res.status(409).json({ message: "Nincs bejelentkezes" })
    }
    try {
        req.user = jwt.verify(token, JWT_SECRET)
        next();
    } catch (error) {
        return res.status(410).json({ message: "nincs érvenyes token" })
    }
}

//végpontok


app.post('/regisztracio', upload.single('kep_neve'), async (req, res) => {
    const { email, felhasznalonev, jelszo } = req.body;
    const kep = req.file ? req.file.filename : null;

    if (!email || !felhasznalonev || !jelszo || !kep) {
        return res.status(400).json({ message: "hianyzo bementi adatok" });
    }

    if (!validator.isEmail(email)) {
        return res.status(401).json({ message: "nem valos emailt adtal meg" });
    }

    try {
        const [exists] = await db.query('SELECT * FROM felhasznalok WHERE Email =? OR Felhasznalo_nev =?', [email, felhasznalonev]);
        if (exists.length) {
            return res.status(402).json({ message: "email vagy felhszanalonev foglalt" });
        }
        const hash = await bcrypt.hash(jelszo, 10);
        const regisztracioSQL = 'INSERT INTO felhasznalok (Email, Felhasznalo_nev, jelszo, kep) VALUES (?,?,?,?)';
        const [result] = await db.query(regisztracioSQL, [email, felhasznalonev, hash, kep]);

        return res.status(200).json({
            message: "Sikeres regisztracio",
            id: result.insertId
        });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Szerverhiba" });
    }
});

app.post('/belepes', async (req, res) => {
    const { felhasznalonevVagyEmail, jelszo } = req.body;
    if (!felhasznalonevVagyEmail || !jelszo) {
        return res.status(400).json({ message: "hianyos belepesi adatok" });
    }

    try {
        const isValid = await emailValidator(felhasznalonevVagyEmail)
        let hashJelszo = "";
        let user = {}
        if (isValid) {
            const sql = 'SELECT * FROM felhasznalok  WHERE Email =?'
            const [rows] = await db.query(sql, [felhasznalonevVagyEmail]);
            if (rows.length) {
                user = rows[0];
                hashJelszo = user.jelszo;
            } else {
                return res.status(401).json({ message: "nincs ilyen fiok  " });
            }
        } else {
            const sql = 'SELECT * FROM felhasznalok  WHERE Felhasznalo_nev =?'
            const [rows] = await db.query(sql, [felhasznalonevVagyEmail]);
            if (rows.length) {
                user = rows[0];
                hashJelszo = user.jelszo;
            } else {
                return res.status(402).json({ message: "ezzel a felhasznalonevvel meg nem regisztraltak" });
            }
        }

        const ok = await bcrypt.compare(jelszo, hashJelszo)
        if (!ok) {
            return res.status(403).json({ message: "rossz jelszot adtál meg" })
        }
        const token = jwt.sign(
            { felhasznalo_id: user.felhasznalo_id, jelszo: user.jelszo, email: user.Email, felhasznalonev: user.Felhasznalo_nev, angol: user.angol, kep: user.kep },
            JWT_SECRET,
            { expiresIn: JWT_EXPIRES_IN }
        )

        res.cookie(COOKIE_NAME, token, COOKIE_OPTS)
        res.status(200).json({ message: "Sikeres belépés" })

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "szerverhiba" })
    }
})

//vedett
app.put('/felhasznalonev', auth, async (req, res) => {
    const { ujfelhasznalonev } = req.body
    if (!ujfelhasznalonev) {
        return res.status(401).json({ message: "uj email megadasa kotelezo" })
    }
    try {
        const sql1 = 'SELECT * FROM felhasznalok WHERE Felhasznalo_nev = ?'
        const [result] = await db.query(sql1, [ujfelhasznalonev])
        if (result.length) {
            return res.status(402).json({ message: "a felhasznalonev foglalt" })
        }
        const sql = 'UPDATE felhasznalok SET Felhasznalo_nev = ? WHERE felhasznalo_id = ?'
        await db.query(sql, [ujfelhasznalonev, req.user.felhasznalo_id])

        res.status(200).json({ message: "sikeres felhasznalonev valtoztatas" })
    } catch (error) {
        console.log(error)
        res.status(500).json({ message: "szerverhiba" })
    }
})
//vedett
app.put('/email', auth, async (req, res) => {
    const { ujEmail } = req.body;
    if (!ujEmail) {
        return res.status(401).json({ message: "az uj email megadasa kotelezo" })
    }
    const isValid = await emailValidator(ujEmail)
    if (!isValid) {
        return res.status(402).json({ message: "nem valos emailt adtal meg" })
    }
    try {
        const sql1 = 'SELECT * FROM felhasznalok WHERE Email=?'
        const [result] = await db.query(sql1, [ujEmail])
        if (result.length) {
            return res.status(402).json({ message: "az email cim mar foglalt" })
        }
        const sql2 = 'UPDATE felhasznalok SET Email=? WHERE felhasznalo_id=?'
        await db.query(sql2, [ujEmail, req.user.felhasznalo_id])
        console.log(req.user.felhasznalo_id)
        return res.status(200).json({ message: "sikeres modosult a email" })
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: "szerverhiba" })
    }
})
// GET /kovetes/status - returns list of followed user IDs for current user
app.get('/kovetes/status', auth, async (req, res) => {
    try {
        const sql = 'SELECT felhasznalo_2_id FROM ismerosok WHERE felhasznalo_1_id = ?';
        const [rows] = await db.query(sql, [req.user.felhasznalo_id]);
        const followedUserIds = rows.map(row => row.felhasznalo_2_id);
        res.status(200).json({ result: true, followedUserIds });
    } catch (error) {
        console.error(error);
        res.status(500).json({ result: false, message: 'Szerverhiba' });
    }
});


app.put('/profilkep', auth, upload.single('ujProfilkep'), async (req, res) => {
    if (!req.file) {
        return res.status(400).json({ message: "Az új profilkép megadása kötelező!" });
    }
    try {
        const filePath = req.file.filename;
        await db.query('UPDATE felhasznalok SET kep = ? WHERE felhasznalo_id = ?', [filePath, req.user.felhasznalo_id]);
        return res.status(200).json({ message: "A profilkép módosítás végrehajtása sikeres" });
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: "Szerver Hiba" });
    }
});

//VÉDETT
//JELSZO
app.put('/jelszo', auth, async (req, res) => {
    const { jelenlegiJelszo, ujJelszo } = req.body

    if (!jelenlegiJelszo || !ujJelszo) {
        return res.status(400).json({ message: "hianyzó bemeneti adatok" })
    }
    try {
        const sql = 'SELECT * FROM felhasznalok WHERE felhasznalo_id=?'
        const [rows] = await db.query(sql, [req.user.felhasznalo_id])
        const user = rows[0]

        const ok = await bcrypt.compare(jelenlegiJelszo, user.jelszo)

        if (!ok) {
            return res.status(401).json({ message: "hibas jelszo" })
        }

        const hashUjJelszo = await bcrypt.hash(ujJelszo, 10)

        const sql2 = 'UPDATE felhasznalok SET jelszo=? WHERE felhasznalo_id=?'
        await db.query(sql2, [hashUjJelszo, req.user.felhasznalo_id])

        res.status(200).json({ message: "sikeres jelszo valtoztatas" })

    } catch (error) {
        console.log(error)
        res.status(500).json({ message: "szerverhiba" })
    }
})
//post bejegyzes
app.post('/bejegyzes', auth, upload.single("kep"), async (req, res) => {

    const tartalom = req.body.tartalom;
    const kep = req.file ? req.file.filename : null;

    if (!tartalom && !kep) {
        return res.status(400).json({ message: "hianyzo bementi adatok" });
    }

    try {
        const sql = `
        INSERT INTO bejegyzesek 
        (felhasznalo_id , tartalom, kep, feltoltesi_ido) 
        VALUES(?,?,?,NOW())
        `;

        await db.query(sql, [
            req.user.felhasznalo_id,
            tartalom,
            kep
        ]);

        res.status(200).json({
            message: "Sikeres bejegyzes létrehozás"
        });

    } catch (error) {
        console.log(error);
        res.status(500).json({ message: "Szerverhiba" });
    }
});

//post kovetes
app.post('/kovetes/:felhasznalo_id', auth, async (req, res) => {
    const felhasznalo_id = req.params.felhasznalo_id;
    const currentUserId = req.user.felhasznalo_id;

    try {
        // Check if connection already exists in either direction
        const checkSql = `
      SELECT 1 FROM ismerosok 
      WHERE (felhasznalo_1_id = ? AND felhasznalo_2_id = ?)
         OR (felhasznalo_1_id = ? AND felhasznalo_2_id = ?)
      LIMIT 1
    `;
        const [rows] = await db.query(checkSql, [currentUserId, felhasznalo_id, felhasznalo_id, currentUserId]);

        if (rows.length > 0) {
            // Connection already exists
            return res.status(400).json({ message: "Már követed ezt a felhasználót vagy már ismerősök vagytok." });
        }

        // Insert new connection
        const insertSql = 'INSERT INTO ismerosok (felhasznalo_1_id, felhasznalo_2_id) VALUES (?, ?)';
        await db.query(insertSql, [currentUserId, felhasznalo_id]);

        return res.status(200).json({ message: "Sikeres követés" });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: "Szerverhiba" });
    }
});

//komment
app.post('/komment', auth, async (req, res) => {
    const { tartalom, bejegyzes_id } = req.body;

    if (!tartalom) {
        return res.status(400), express.json({ message: "hianyzo bemeneti adatok" })
    }
    try {
        const kommentsql = 'INSERT INTO kommentek (kuldo_felhasznalo_id,bejegyzes_id, tartalom,kuldes_ideje) VALUES (?,?,?,NOW())'
        await db.query(kommentsql, [req.user.felhasznalo_id, bejegyzes_id, tartalom])
        return res.status(200).json({ message: "Sikeres komenteles" })
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Szerverhiba" })
    }
})
//szoba keszites
app.post('/szobaCsinalas/:ismerosId', auth, async (req, res) => {
    const ismerosId = req.params.ismerosId;

    const [rows] = await db.query(
        `SELECT szoba_id FROM Chat_szoba 
         WHERE (felhasznalo1_id = ? OR felhasznalo2_id = ?)
         AND (felhasznalo1_id = ? OR felhasznalo2_id = ?)`,
        [req.user.felhasznalo_id, req.user.felhasznalo_id, ismerosId, ismerosId]
    );

    if (rows.length > 0) {
        return res.status(200).json({
            szobaId: rows[0].szoba_id
        });
    }

    try {
        const [result] = await db.query(
            `INSERT INTO Chat_szoba (felhasznalo1_id, felhasznalo2_id) VALUES (?, ?)`,
            [req.user.felhasznalo_id, ismerosId]
        );

        return res.status(200).json({
            szobaId: result.insertId
        });

    } catch (error) {
        console.log(error);
        res.status(500).json({ message: "Szerverhiba" });
    }
});

//uzenet kudes
app.post('/uzenetkuldes/:ismerosId', auth, async (req, res) => {
    const ismerosId = req.params.ismerosId;
    const { szoveg } = req.body;

    try {
        const [sorok] = await db.query(
            `SELECT szoba_id, felhasznalo1_id, felhasznalo2_id FROM Chat_szoba 
             WHERE (felhasznalo1_id = ? AND felhasznalo2_id = ?) 
             OR (felhasznalo1_id = ? AND felhasznalo2_id = ?)`,
            [req.user.felhasznalo_id, ismerosId, ismerosId, req.user.felhasznalo_id]
        );

        if (sorok.length === 0) {
            return res.status(404).json({ message: "Nincs chat szoba" });
        }

        const szoba_id = sorok[0].szoba_id;

        const [insertResult] = await db.query(
            `INSERT INTO Uzenetek (szoba_id, szoveg, felhasznalo_id, kuldes_ideje)
             VALUES (?, ?, ?, NOW())`,
            [szoba_id, szoveg, req.user.felhasznalo_id]
        );

        const insertedId = insertResult.insertId;

        const [newMessageRows] = await db.query(
            `SELECT szoveg, kuldes_ideje, felhasznalo_id FROM Uzenetek WHERE id = ?`,
            [insertedId]
        );

        if (newMessageRows.length === 0) {
            return res.status(500).json({ message: "Nem sikerült lekérni az új üzenetet" });
        }

        const newMessage = newMessageRows[0];

        const recipientId = (newMessage.felhasznalo_id === sorok[0].felhasznalo1_id)
            ? sorok[0].felhasznalo2_id
            : sorok[0].felhasznalo1_id;

        res.status(200).json({
            message: "Sikeres uzenet kuldes",
            uzenet: {
                szoveg: newMessage.szoveg,
                kuldes_ideje: newMessage.kuldes_ideje,
                felhasznalo_id: newMessage.felhasznalo_id,
                cimzett_id: recipientId,
            }
        });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Szerverhiba" });
    }
});


//bejegyzesek
app.get('/bejegyzesek', async (req, res) => {
    try {
        const query = `
      SELECT 
        b.bejegyzes_id,
        b.felhasznalo_id,
        b.tartalom,
        b.kep AS bejegyzes_kep,
        b.feltoltesi_ido,
        f.Felhasznalo_nev AS felhasznalonev,
        f.kep AS profilkep
      FROM bejegyzesek b
      JOIN felhasznalok f ON b.felhasznalo_id = f.felhasznalo_id
      ORDER BY b.feltoltesi_ido DESC
    `;

        const [rows] = await db.query(query);

        res.status(200).json({ posts: rows });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "szerverhiba" });
    }
});



//vedett
app.get('/ismerosok', auth, async (req, res) => {
    try {
        const [rows] = await db.query(`
      SELECT f.felhasznalo_nev, f.kep,f.felhasznalo_id
      FROM Ismerosok i
      JOIN felhasznalok f 
        ON f.felhasznalo_id = CASE 
          WHEN i.felhasznalo_1_id = ? THEN i.felhasznalo_2_id
          ELSE i.felhasznalo_1_id
        END
      WHERE i.felhasznalo_1_id = ? OR i.felhasznalo_2_id = ?
    `, [req.user.felhasznalo_id, req.user.felhasznalo_id, req.user.felhasznalo_id]);

        console.log("Friends found:", rows); // Debug log

        res.status(200).json({ result: true, ismerosok: rows });
    } catch (error) {
        console.error(error);
        res.status(500).json({ result: false, message: "Szerverhiba" });
    }
});


//vedett
app.get('/uzenetek/:szobaId', auth, async (req, res) => {

    const szobaId = req.params.szobaId;
    const felhasznaloid = req.user.felhasznalo_id;

    try {

        const [uzenetek] = await db.query(
            `SELECT szoveg, kuldes_ideje, felhasznalo_id 
             FROM uzenetek 
             WHERE szoba_id = ? 
             ORDER BY kuldes_ideje ASC`,
            [szobaId]
        );

        res.status(200).json({
            uzenetek,
            szobaId,
            sajatid: felhasznaloid
        });

    } catch (error) {
        console.log(error);
        res.status(500).json({ message: "szerverhiba" });
    }
});

app.post('/emoji/:bejegyzes_id', auth, async (req, res) => {
    const bejegyzes_id = req.params.bejegyzes_id
    const { emoji1, emoji2, emoji3 } = req.body
    try {
        const vanEemoji = await db.query(`SELECT * FROM emoji 
        WHERE (emoji1=1 OR emoji2=1 OR emoji3=1) AND felhasznalo_id=? 
        AND bejegyzes_id=?`, [req.user.felhasznalo_id, bejegyzes_id])
        if (vanEemoji.length > 0) {
            await db.query(`UPDATE emoji SET emoji1=?, emoji2=?, emoji3=? 
                WHERE felhasznalo_id=? AND bejegyzes_id=?
            `, [emoji1, emoji2, emoji3, req.user.felhasznalo_id, bejegyzes_id])
            res.status(200).json({ message: "sikeres reagálás" })
        } else {
            await db.query(`
                INSERT INTO emoji (felhasznalo_id, emoji1, emoji2, emoji3, bejegyzes_id)
                VALUES (?, ?, ?, ?, ?)`, [req.user.felhasznalo_id, emoji1, emoji2, emoji3, bejegyzes_id])
            res.status(200).json({ message: "sikeres reagálás" })
        }
    } catch (error) {
        console.log(error)
        res.status(500).json({ message: "szerverhiba" })
    }
})


//vedett
app.post('/kijelentkezes', auth, async (req, res) => {
    res.clearCookie(COOKIE_NAME, { httpOnly:true,secure:true,sameSite:'none',   path: '/' });
    res.status(200).json({ message: "sikeres kijelentkezes" })
})


//vedett
app.get('/adataim', auth, async (req, res) => {
    res.status(200).json(req.user)
})

//Védett
app.delete('/fiokom', auth, async (req, res) => {
    try {
        //törölni kell a felhasználót
        await db.query("DELETE FROM felhasznalok WHERE felhasznalo_id = ?", [req.user.felhasznalo_id])
        //utolsó lépés
        res.clearCookie(COOKIE_NAME, { path: '/' })
        res.status(200).json({ message: "sikeres fiok torles" })
    } catch (error) {
        console.log(error)
        res.status(500).json({ message: "szerverhiba" })
    }
})

app.delete('/kovetes/:ismeros_id', auth, async (req, res) => {
    const ismeros_id = req.params.ismeros_id
    try {
        const [sorok] = await db.query(`SELECT szoba_id FROM Chat_szoba WHERE
        (felhasznalo1_id = ? OR felhasznalo2_id = ?) 
        AND (felhasznalo1_id = ? OR felhasznalo2_id = ?)
        `, [req.user.felhasznalo_id, req.user.felhasznalo_id, ismeros_id, ismeros_id])

        const szoba_id = sorok[0]?.szoba_id
        await db.query('DELETE FROM ismerosok WHERE felhasznalo_1_id = ? AND felhasznalo_2_id=?', [req.user.felhasznalo_id, ismeros_id])
        await db.query('DELETE FROM chat_szoba WHERE szoba_id=?', [szoba_id])
        res.status(200).json({ message: "sikeres ismeros torles" })
    } catch (error) {
        console.log(error)
        res.status(500).json({ message: "szerverhiba" })
    }
})


app.put('/bejegyzes/:bejegyzes_id', auth, async (req, res) => {
    const bejegyzes_id = req.params.bejegyzes_id
    const { tartalom, kep } = req.body
    try {
        await db.query('UPDATE bejegyzesek SET tartalom=?,kep=? WHERE bejegyzes_id=?', [tartalom, kep, bejegyzes_id])
        res.status(200).json({ message: "sikeres bejegyzes modositas" })

    } catch (error) {
        console.log(error)
        res.status(500).json({ message: "szerverhiba" })
    }
})


app.delete('/bejegyzes/:bejegyzes_id', auth, async (req, res) => {
    const bejegyzesId = req.params.bejegyzes_id
    try {
        await db.query("DELETE FROM bejegyzesek WHERE bejegyzes_id=?", [bejegyzesId])
        res.status(200).json({ message: "Sikeres bejegyzes törlés" })
    } catch (error) {
        console.log(error)
        res.status(500).json({ message: "szerverhiba" })
    }
})

app.get('/emberek', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT felhasznalo_nev, kep, felhasznalo_id FROM felhasznalok');
        res.status(200).json({ users: rows });
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: "szerverhiba" });
    }
})

/// get komment
app.get('/kommentek/:bejegyzes_id', async (req, res) => {
    const bejegyzes_id = req.params.bejegyzes_id
    try {
        const kommentek = await db.query('SELECT tartalom AND felhasznalo_id AND kuldes_ideje FROM kommentek WHERE bejegyzes_id', [bejegyzes_id])
        res.status(200).json(kommentek)
    } catch (error) {
        res.status(500).json({ message: "szerverhiba" })
    }
})


//szerver elinditas
app.listen(PORT, HOST, () => {
    console.log(`API fut: http://${HOST}:${PORT}/`);
})
