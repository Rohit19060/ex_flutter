
<?php
require "vendor/autoload.php";
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->safeLoad();
class PaytmChecksum
{
    private static $iv = "@@@@&&&&####$$$$";
    static public function encrypt($input, $key)
    {
        $key = html_entity_decode($key);
        if (function_exists("openssl_encrypt")) {
            $data = openssl_encrypt($input, "AES-128-CBC", $key, 0, self::$iv);
        } else {
            $size = mcrypt_get_block_size(MCRYPT_RIJNDAEL_128, "cbc");
            $input = self::pkcs5Pad($input, $size);
            $td = mcrypt_module_open(MCRYPT_RIJNDAEL_128, "", "cbc", "");
            mcrypt_generic_init($td, $key, self::$iv);
            $data = mcrypt_generic($td, $input);
            mcrypt_generic_deinit($td);
            mcrypt_module_close($td);
            $data = base64_encode($data);
        }
        return $data;
    }
    static public function decrypt($encrypted, $key)
    {
        $key = html_entity_decode($key);
        if (function_exists("openssl_decrypt")) {
            $data = openssl_decrypt($encrypted, "AES-128-CBC", $key, 0, self::$iv);
        } else {
            $encrypted = base64_decode($encrypted);
            $td = mcrypt_module_open(MCRYPT_RIJNDAEL_128, "", "cbc", "");
            mcrypt_generic_init($td, $key, self::$iv);
            $data = mdecrypt_generic($td, $encrypted);
            mcrypt_generic_deinit($td);
            mcrypt_module_close($td);
            $data = self::pkcs5Unpad($data);
            $data = rtrim($data);
        }
        return $data;
    }
    static public function generateSignature($params, $key)
    {
        if (!is_array($params) && !is_string($params)) {
            throw new Exception("string or array expected, " . gettype($params) . " given");
        }
        if (is_array($params)) {
            $params = self::getStringByParams($params);
        }
        return self::generateSignatureByString($params, $key);
    }
    static public function verifySignature($params, $key, $checksum)
    {
        if (!is_array($params) && !is_string($params)) {
            throw new Exception("string or array expected, " . gettype($params) . " given");
        }
        if (isset($params["CHECKSUMHASH"])) {
            unset($params["CHECKSUMHASH"]);
        }
        if (is_array($params)) {
            $params = self::getStringByParams($params);
        }
        return self::verifySignatureByString($params, $key, $checksum);
    }
    static private function generateSignatureByString($params, $key)
    {
        $salt = self::generateRandomString(4);
        return self::calculateChecksum($params, $key, $salt);
    }
    static private function verifySignatureByString($params, $key, $checksum)
    {
        $paytm_hash = self::decrypt($checksum, $key);
        $salt = substr($paytm_hash, -4);
        return $paytm_hash == self::calculateHash($params, $salt) ? true : false;
    }
    static public function generateRandomString($length)
    {
        $random = "";
        srand((float) microtime() * 1000000);
        $data = "9876543210ZYXWVUTSRQPONMLKJIHGFEDCBAabcdefghijklmnopqrstuvwxyz!@#$&_";
        for ($i = 0; $i < $length; $i++) {
            $random .= substr($data, (rand() % (strlen($data))), 1);
        }
        return $random;
    }
    static private function getStringByParams($params)
    {
        ksort($params);
        $params = array_map(function ($value) {
            return ($value !== null && strtolower($value) !== "null") ? $value : "";
        }, $params);
        return implode("|", $params);
    }
    static private function calculateHash($params, $salt)
    {
        $finalString = $params . "|" . $salt;
        $hash = hash("sha256", $finalString);
        return $hash . $salt;
    }
    static private function calculateChecksum($params, $key, $salt)
    {
        $hashString = self::calculateHash($params, $salt);
        return self::encrypt($hashString, $key);
    }
    static private function pkcs5Pad($text, $blocksize)
    {
        $pad = $blocksize - (strlen($text) % $blocksize);
        return $text . str_repeat(chr($pad), $pad);
    }
    static private function pkcs5Unpad($text)
    {
        $pad = ord($text[strlen($text) - 1]);
        if ($pad > strlen($text))
            return false;
        return substr($text, 0, -1 * $pad);
    }
}
if (isset($_POST["amount"])) {
    $amount = $_POST["amount"];
    if (!$amount || $amount <= 0 || $amount > 100000 || !is_numeric($amount)) {
        echo json_encode(["success" => false,
            "message" => "Amount is required"
        ]);
    } else {
        $orderID = PaytmChecksum::generateRandomString(20);
        $payTMParams = array();
        $environment = false;
        if ($environment) {
            // Production
            $key = $_ENV["PAYTM_PROD_MERCHANT_KEY"];
            $mid = $_ENV["PAYTM_PROD_MERCHANT_MID"];
            $website = $_ENV["PAYTM_PROD_WEBSITE"];
            $callbackUrl = "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderID";
            $url = "https://securegw.paytm.in/theia/api/v1/initiateTransaction?mid=$mid&orderId=$orderID";
            $isStaging = false;
        } else {
            // Development
            $key = $_ENV["PAYTM_DEV_MERCHANT_KEY"];
            $mid = $_ENV["PAYTM_DEV_MERCHANT_MID"];
            $website = $_ENV["PAYTM_DEV_WEBSITE"];
            $callbackUrl = "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderID";
            $url = "https://securegw-stage.paytm.in/theia/api/v1/initiateTransaction?mid=$mid&orderId=$orderID";
            $isStaging = true;
        }
        $payTMParams["body"] = array(
            "requestType" => "Payment",
            "mid" => $mid,
            "websiteName" => $website,
            "orderId" => $orderID,
            "callbackUrl" => $callbackUrl,
            "txnAmount" => array(
                "value" => $amount,
                "currency" => "INR",
            ),
            "disablePaymentMode" => array(
                array("mode" => "EMI"),
                array("mode" => "PAYTM_DIGITAL_CREDIT"),
            ),
            "userInfo" => array(
                "custId" => "01",
            ),
        );
        $checksum = PaytmChecksum::generateSignature(json_encode($payTMParams["body"], JSON_UNESCAPED_SLASHES), $key);
        $payTMParams["head"] = array(
            "signature" => $checksum
        );
        $post_data = json_encode($payTMParams, JSON_UNESCAPED_SLASHES);
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array("Content-Type: application/json"));
        $response = curl_exec($ch);
        $var = json_decode($response, true);
        if ($var["body"]["resultInfo"]["resultStatus"] == "S") {
            echo json_encode(["success" => true,
                "txnToken" => $var["body"]["txnToken"],
                "orderId" => $orderID,
                "mid" => $mid,
                "callbackUrl" => $callbackUrl,
                "isStaging" => $isStaging,
                "amount" => $amount,
                "message" => "Payment Initiated"
            ]);
        } else {
            echo json_encode(["success" => false, "message" => "PayTm Server Error! Please Try Again"
            ]);
        }
    }
} else {
    echo "Not a Right Request";
}
