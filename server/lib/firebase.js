/*
import firebase from 'firebase';
import 'firebase/storage/dist/index.cjs.js'
import 'firebase/firestore/dist/index.cjs.js'

const firebaseConfig = {
    apiKey: "AIzaSyD_tNteaK19DIIufWoSGn2SLvIIsmURDCM",
    authDomain: "bankon-1337.firebaseapp.com",
    databaseURL: "https://bankon-1337.firebaseio.com",
    projectId: "bankon-1337",
    storageBucket: "bankon-1337.appspot.com",
    messagingSenderId: "1088214492222",
    appId: "1:1088214492222:web:254368f3696f88ba0b5d6f"
};
  // Initialize Firebase
firebase.initializeApp(firebaseConfig);


export const storage = firebase.storage()
export const db = firebase.firestore()
*/
import admin from 'firebase-admin';
import serviceAccount from './firebase_account.js'
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://bankon-1337.firebaseio.com"
});

export const storage = admin.storage().bucket('gs://bankon-1337.appspot.com')
export const db = admin.firestore()