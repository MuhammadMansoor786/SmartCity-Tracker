const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const multer = require('multer'); // File upload ke liye
const fs = require('fs');
const path = require('path');

const app = express();
const uploadDir = process.env.NETLIFY === 'true'
    ? '/tmp/uploads'
    : path.join(__dirname, 'uploads');

fs.mkdirSync(uploadDir, { recursive: true });

app.use(express.json());
app.use(cors());
app.use(express.static(__dirname));

// Tasweerein dikhane ke liye uploads folder ko public karna
app.use('/uploads', express.static(uploadDir));

// MySQL Database Connection
const db = mysql.createPool({
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT) || 21621,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    ssl: { rejectUnauthorized: false },
    waitForConnections: true,
    connectionLimit: 5
});

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, uploadDir); // Folder jahan images save hongi
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname)); // Unique image filename
    }
});
const upload = multer({ storage: storage });

// APIs for Auth
app.post('/api/signup', (req, res) => {
    const { name, email, password } = req.body;
    const sql = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
    db.query(sql, [name, email, password], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ error: 'Database error', details: err.message });
        }
        res.status(201).json({ message: "Account kamyabi se ban gaya!" });
    });
});

app.post('/api/login', (req, res) => {
    const { email, password } = req.body;
    const sql = "SELECT * FROM users WHERE email = ? AND password = ?";
    db.query(sql, [email, password], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ error: 'Database error', details: err.message });
        }
        if (results.length > 0) res.status(200).json({ message: "Login successful!", user: results[0] });
        else res.status(401).json({ message: "Email ya password ghalat hai!" });
    });
});

app.post('/api/issues', upload.single('image'), (req, res) => {
    const { user_id, title, description, location } = req.body;
    const image_url = req.file ? `/uploads/${req.file.filename}` : null; // Save image URL when present
    
    const sql = "INSERT INTO issues (user_id, title, description, location, image_url) VALUES (?, ?, ?, ?, ?)";
    db.query(sql, [user_id, title, description, location, image_url], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ error: 'Database error', details: err.message });
        }
        res.status(201).json({ message: "Aapki complaint successfully darj ho gayi hai!" });
    });
});

app.get('/api/issues/:userId', (req, res) => {
    const sql = "SELECT * FROM issues WHERE user_id = ? ORDER BY created_at DESC";
    db.query(sql, [req.params.userId], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ error: 'Database error', details: err.message });
        }
        res.status(200).json(results);
    });
});

app.get('/api/admin/issues', (req, res) => {
    const sql = "SELECT issues.*, users.name AS citizen_name FROM issues JOIN users ON issues.user_id = users.id ORDER BY issues.created_at DESC";
    db.query(sql, (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ error: 'Database error', details: err.message });
        }
        res.status(200).json(results);
    });
});

app.put('/api/admin/issues/:id', (req, res) => {
    const sql = "UPDATE issues SET status = ? WHERE id = ?";
    db.query(sql, [req.body.status, req.params.id], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ error: 'Database error', details: err.message });
        }
        res.status(200).json({ message: "Status update ho gaya!" });
    });
});

if (require.main === module) {
    app.listen(3000, () => {
        console.log('🚀 Server is running on http://localhost:3000');
    });
}

module.exports = app;