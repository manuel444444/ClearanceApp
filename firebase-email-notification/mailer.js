const nodemailer = require('nodemailer');
require('dotenv').config()
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env['GMAIL_ADDRESS'],
    pass: process.env['GMAIL_PASSWORD']
  }
});
const fs = require('fs');
const PDFDocument = require('pdfkit');
const { PassThrough } = require('stream');

async function sendMail(name, email, status, message){

    const htmlContent = `
      <div style="font-family: Arial, sans-serif; color: #333;">
          <h2>Hello ${name},</h2>
          <p>We wanted to inform you about the current status of your clearance process.</p>
          <p><strong>Status:</strong> ${status}</p>
          <p>${message}</p>
          <div style="margin-top: 20px;">
              <img src="https://1.bp.blogspot.com/-xtgOdfpjEXI/U1qjuMUDdTI/AAAAAAAAAW0/WXe-PkVqyvs/s1600/KNUST_logo.png" alt="KNUST Logo" style="width: 120px; height: 120px;">
          </div>
          <p>Thank you for your attention.</p>
          <p>Best regards,</p>
          <p>Your School Clearance Office</p>
      </div>
    `;

    console.log('HTML Content:', htmlContent);
    const info = await transporter.sendMail({
        from:process.env['GMAIL_ADDRESS'], // sender address
        to:email, // list of receivers
        subject: "Clearance Status Update", // Subject line
        html: htmlContent
      });
}

async function sendPdfMail(name, email) {
//    const htmlContent = `
//      <div style="font-family: Arial, sans-serif; color: #333;">
//          <h2>Hello ${name},</h2>
//          <p>We wanted to inform you about the current status of your clearance process.</p>
//          <p><strong>Status:</strong> ${status}</p>
//          <p>${message}</p>
//          <div style="margin-top: 20px;">
//              <img src="https://1.bp.blogspot.com/-xtgOdfpjEXI/U1qjuMUDdTI/AAAAAAAAAW0/WXe-PkVqyvs/s1600/KNUST_logo.png" alt="KNUST Logo" style="width: 120px; height: 120px;">
//          </div>
//          <p>Thank you for your attention.</p>
//          <p>Best regards,</p>
//          <p>Your School Clearance Office</p>
//      </div>
//    `;

    // Read the PDF file from the provided path
     const doc = new PDFDocument();

        // Create a stream to hold the PDF data
        const pdfStream = new PassThrough();
        const buffers = [];

        // Listen for 'data' events to collect the PDF chunks
        pdfStream.on('data', (chunk) => buffers.push(chunk));
        pdfStream.on('end', async () => {
            // Convert the collected chunks into a buffer
            const pdfBuffer = Buffer.concat(buffers);

    const info = await transporter.sendMail({
        from: process.env['GMAIL_ADDRESS'], // sender address
        to: email, // list of receivers
        subject: "Clearance Status Update", // Subject line
        html: htmlContent, // HTML body content
        attachments: [
            {
                filename: 'clearance_invoice.pdf', // Name of the file in the email
                content: pdfBuffer, // File buffer
                contentType: 'application/pdf' // MIME type
            }
        ]
    });

    try {
                const info = await transporter.sendMail(mailOptions);
                console.log('Email sent:', info.response);
            } catch (error) {
                console.error('Error sending email:', error);
            }

doc.pipe(pdfStream);
    doc.fontSize(25).text('This is your invoice for clearance.', 100, 100);
    doc.end();
}
module.exports = {
    sendMail,
    sendPdfMail
}