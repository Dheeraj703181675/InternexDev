global class EncryptionandDecryption {
    webservice static String Encrypt(String StringforEncryption,string cryptoKey)
    {
        Blob Data =  Blob.valueOf(StringforEncryption);
        Blob key = Encodingutil.base64Decode(cryptoKey);
        Blob encryptedData = Crypto.encryptWithManagedIV('AES256',key, Data);
        return EncodingUtil.base64Encode(encryptedData);
    }
    public static string getKey()
    {
        return  EncodingUtil.base64Encode(crypto.generateAesKey(256));
    }
    webservice static String Decrypt(String StringforDecryption,string cryptoKey)
    {
        Blob key = Encodingutil.base64Decode(cryptoKey);
        Blob Data = Encodingutil.base64Decode(StringforDecryption);
        Blob decrypted = Crypto.decryptWithManagedIV('AES256', Key, Data);
        return decrypted.toString();
    }
}