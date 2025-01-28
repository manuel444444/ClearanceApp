const express = require('express');
const {sendMail} = require('./mailer');
const cors = require('cors')
const morgan = require('morgan')
const app = express();
const PORT = process.env.PORT || 4600;
app.use(morgan('short'))
app.use(cors({
    origin:'*'
}));
app.use(express.json());

app.post('/send-mail', async (req, res) => {
    try {
    const {name, email, status, message} = req.body
    if(!name){
        return res.status(403).send('no name include')
    }else{
    sendMail(name, email, status, message);
      res.send("Email sent successfully");
    }

    } catch (error) {
        console.log(error)
    }
});

app.post('/send-mailpdf', async (req, res) => {
    try {
    const {name, email} = req.body
    if(!name){
        return res.status(403).send('no name include')
    }else{
    sendPdfMail(name, email);
      res.send("Pdf invoice sent successfull");
    }

    } catch (error) {
        console.log(error)
    }
});
// Listen for Firestore chat
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});