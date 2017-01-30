@isTest
public class TestEncryptionandDecryption {
	public static Testmethod void Testencryptionanddecryption()
    {
          // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        string key = EncryptionandDecryption.getKey();
        // Call the method that invokes a callout
        String encrypted_output = EncryptionandDecryption.Encrypt('Mock response',key);
        
        string Decrypted_output = EncryptionandDecryption.Decrypt(encrypted_output, key);
        
        // Verify that a fake result is returned
        System.assertEquals('Mock response', Decrypted_output);
    }
}