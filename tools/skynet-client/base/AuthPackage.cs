namespace Skynet.DotNetClient
{
    public class LoginwReqPack
    {
        public string module = "login_auth";
        public string method = "login";
        public string server_ca = "hDJ^54D@!&DHkkdh095hj";
        public string parms = "'";
    }
    
    public class AuthPackageReq
    {
        public string openId = "1";
        public string sdk = "2";
        public string pf = "1";
        public string serverId = "1";
        public string protocol = "tcp";
        public string userData = "userData";
    }

    public class AuthChallenge
    {
        public  byte[] clientkey = new byte[8];
        public  byte[] challenge = new byte[8];
        public  byte[] secret = new byte[8];
    }
    
    public class AuthPackageResp
    {
        public string gate = "";
        public int port = 0;
        public string uid = "";
        public string subid = "";
        public string secret = "";
    }
    
    public enum Login_Auth_State : int
    {
        NIL, //无效
        GET_CHALLENGE,
        GET_SECRET,
        SEND_LOGIN,
        LOGIN_RESULT,
        LOGIN_FINISHED,
    }
    
}