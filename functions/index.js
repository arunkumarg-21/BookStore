const functions = require('firebase-functions');
 admin = require('firebase-admin');

 admin.initializeApp();

exports.messageTrigger = functions.firestore.document('Messages/{messageId}').onCreate(async (snapshot,context) => {
if(snapshot.empty){
console.log('no message');
return;
}

var tokens = [];

 const deviceTokens = await admin.firestore().collection('DeviceTokens').get();

 for(var token of deviceTokens.docs){
    tokens.push(token.data().device_token);
 }

newData = snapshot.data();
var payload = {
  notification : {title:'Message From BookStore',body:newData.message},
  data: {click_action:'FLUTTER_NOTIFICATION_CLICK', message: newData.message},
};

try{
    const response = await admin.messaging().sendToDevice(tokens,payload);
    console.log('Notification Sent Successfully');
}catch (err){
     console.log('Notification failed to send$');
     console.log(err);
}
} );
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
