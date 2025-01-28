/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


const functions = require('firebase-functions');
const admin = require('firebase-admin');
const Mailgun = require('mailgun.js');
const formData = require('form-data');

admin.initializeApp();

const mailgun = new Mailgun(formData);
const mg = mailgun.client({
  username: 'api',
  key:  process.env.MAILGUN_API_KEY || 'key-afce6020-729f8813'
});

exports.sendEmailOnStatusChange = functions.firestore
    .document('ClearanceForms_Collection/{formId}')
    .onUpdate(async (change, context) => {
      // Get the data from the updated document
      const before = change.before.data();
      const after = change.after.data();
      const formId = context.params.formId;

      // Check if the status field has changed
      if (before.hodStatus === after.hodStatus) {
        console.log('Status has not changed.');
        return null;
      }

      // Get the user ID associated with this form
      const userId = after.userId; // Adjust this based on your schema

      // Fetch user details from the Users collection
      const userSnapshot = await admin.firestore().collection('Users').doc(userId).get();
      const userData = userSnapshot.data();
      const email = userData.email; // Adjust this based on your schema

      // Compose and send the email
      const emailData = {
        from: "Excited User <mailgun@sandbox199cc1de07e641c28600932c2535a494.mailgun.org>",
        to: email,
        subject: 'Status Update for Your Clearance Form',
        text: `Hello, the status of your clearance form with ID ${formId} has changed to ${after.status}.`
      };

      try {
        await mg.messages.create('https://app.mailgun.com/app/sending/domains/sandbox199cc1de07e641c28600932c2535a494.mailgun.org', emailData);
        console.log('Email sent successfully.');
      } catch (error) {
        console.error('Error sending email:', error);
      }

      return null;
    });
