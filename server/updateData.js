import {db, storage} from './lib/firebase.js'
import banks from './lib/banks/banks.js'
import fs from 'fs'
console.log(Object.keys(banks))

async function getDownloadUrl(filename) {
    var metadata = await storage.file(filename).getMetadata()
    var token = metadata[0].metadata.firebaseStorageDownloadTokens
    return "https://firebasestorage.googleapis.com/v0/b/" + storage.name + "/o/" + encodeURIComponent(filename) + "?alt=media&token=" + token
}

async function updateData() {
    const bankList = Object.values(banks)
    for (let index = 0; index < bankList.length; index++) {
        const bank = bankList[index];
        const iconurl = await getDownloadUrl(bank.name + '.png');
        const redirecturl = bank.auth.redirect.url
        db.collection('banks').doc(bank.name).set({namn: bank.name, icon: iconurl, redirecturl: redirecturl});
    }
}

updateData()