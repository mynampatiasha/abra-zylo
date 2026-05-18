<?php
if (file_exists(DIR_APPLICATION . '../vendor/autoload.php')){
    require DIR_SYSTEM . '../vendor/autoload.php';
}
class ControllerApiWkrestapiCustomer extends Controller
{

    /**
     * Logins a customer
     * @param  json $data contains username and password of customer
     * @return json       contains the details of customer
     */
    public function customerLogin()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $postData = array();

            foreach ($post as $key => $value) {
                $postData[$key] = $value;
            }

            if (isset($postData['username']) && isset($postData['password'])) {
                $this->load->model('wkrestapi/customer');

                $loginData = $this->model_wkrestapi_customer->customerLogin($postData);
                 
                if ($loginData) {
                    $this->response->addHeader('Content-Type: application/json');
                    $this->response->setOutput(json_encode($loginData));
                } else {
                    $return_array = array(
                            'error'        => 1
                        );
                    $this->response->addHeader('Content-Type: application/json');
                    $this->response->setOutput(json_encode($return_array));
                }
            } else {
                $return_array = array(
                    'error'        => 1 ,
                    'message'    => $this->language->get('text_customer_login_message')
                );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }

    public function getStoreLocation() {
      $this->load->language('account/api');

      $post = $this->request->post;

      //Accepting data in json format / raw data

      $raw_data = json_decode(file_get_contents("php://input"), true);

      if ($raw_data) {
          foreach ($raw_data as $key => $value) {
              $post[$key] = $value;
          }
      }

      //Get wk_token from header
      if (isset(getallheaders()['wk_token'])) {
        $post['wk_token'] = getallheaders()['wk_token'];
      } elseif (isset(getallheaders()['Wk-Token'])) {
        $post['wk_token'] = getallheaders()['Wk-Token'];
      }

      if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
          $this->response->addHeader('Content-Type: application/json');
          $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
      } else {
        $return_array['error'] = 0;
        if ($this->config->get('config_image')) {

          $this->load->model('tool/image');
    			$return_array['image'] = $this->model_tool_image->resize($this->config->get('config_image'), 200, 200);

          $return_array['image_width'] = 200;
          $return_array['image_height'] = 200;
    		} else {
    			$return_array['image'] = '';
          $return_array['width'] = '';
          $return_array['height'] = '';
    		}
        $return_array['store'] = $this->config->get('config_name') ? $this->config->get('config_name') : '';
    		$return_array['address'] = $this->config->get('config_address') ? $this->config->get('config_address') : '';
        if($this->config->get('config_geocode')) {
          $return_array['geolocation'] = "https://maps.google.com/maps?q=" . urlencode($this->config->get('config_geocode')) . "&hl=" . $this->config->get('config_language') . "&t=m&z=15";
        } else {
          $return_array['geolocation'] = "";
        }
    		$return_array['telephone'] = $this->config->get('config_telephone') ? $this->config->get('config_telephone') : '';
            $return_array['store_email'] = $this->config->get('config_email') ? $this->config->get('config_email') : '';

    		$return_array['fax'] = $this->config->get('config_fax') ? $this->config->get('config_fax') : '';
    		$return_array['open'] = $this->config->get('config_open') ? $this->config->get('config_open') : '';
    		$return_array['comment'] = $this->config->get('config_comment') ? $this->config->get('config_comment') : '';

        $this->response->addHeader('Content-type: application/json');
        $this->response->setOutput(json_encode($return_array));
      }
    }

    public function contactUs() {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $this->load->language('information/contact');
            if ($this->validateContactUs($post)['error'] == 0) {
                if (version_compare(VERSION, '3.0.0.0', '>=')) {
                    $mail = new Mail($this->config->get('config_mail_engine'));
                } else {
                    $mail = new Mail();
                }
                $mail->protocol = $this->config->get('config_mail_protocol');
                $mail->parameter = $this->config->get('config_mail_parameter');
                $mail->smtp_hostname = $this->config->get('config_mail_smtp_hostname');
                $mail->smtp_username = $this->config->get('config_mail_smtp_username');
                $mail->smtp_password = html_entity_decode($this->config->get('config_mail_smtp_password'), ENT_QUOTES, 'UTF-8');
                $mail->smtp_port = $this->config->get('config_mail_smtp_port');
                $mail->smtp_timeout = $this->config->get('config_mail_smtp_timeout');

                $mail->setTo($this->config->get('config_email'));
                $mail->setFrom($this->config->get('config_email'));
                $mail->setReplyTo($post['email']);
                $mail->setSender(html_entity_decode($post['name'], ENT_QUOTES, 'UTF-8'));
                $mail->setSubject(html_entity_decode(sprintf($this->language->get('email_subject'), $post['name']), ENT_QUOTES, 'UTF-8'));
                $mail->setText($post['enquiry']);
                $mail->send();

                if (version_compare(VERSION, '3.0.3.7', '>=')) {
                  $return_array = array(
                    'error'        => 0,
                    'message'   => strip_tags($this->language->get('text_message'))
                  );
                } else {
                  $return_array = array(
                    'error'        => 0,
                    'message'   => strip_tags($this->language->get('text_success'))
                  );
                }
            } else {
                $return_array = array(
                    'error'        => 1 ,
                    'message'    => $this->validateContactUs($post)['message']
                );
            }
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }
    protected function validateContactUs($data = array()) {
      $json['error'] = 0;
      if (!isset($data['name']) || (utf8_strlen($data['name']) < 3) || (utf8_strlen($data['name']) > 32)) {
        $json['error'] = 1;
        $json['message'] = $this->language->get('error_name');
      }

      if (!isset($data['email']) || !filter_var($this->request->post['email'], FILTER_VALIDATE_EMAIL)) {
        $json['error'] = 1;
        $json['message'] = $this->language->get('error_email');
      }

      if (!isset($data['enquiry']) || (utf8_strlen($this->request->post['enquiry']) < 10) || (utf8_strlen($this->request->post['enquiry']) > 3000)) {
        $json['error'] = 1;
        $json['message'] = $this->language->get('error_enquiry');
      }
      return $json;
    }

    /**
     * [registerDeviceToken] API uses for register IOS/Android device token returned by firebase server
     * @param  [type] $post['android_device_id']   [POST param for android device ID]
     * @param  [type] $post['ios_device_id']       [POST param for ios device ID]
     * @return json       json response error/success case
     */
    public function registerDeviceToken() {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
          if (!isset($post['android_device_id']))
          $post['android_device_id'] = '';

          if (!isset($post['ios_device_id']))
          $post['ios_device_id'] = '';

          $this->load->model('wkrestapi/customer');
          $this->model_wkrestapi_customer->registerDeviceToken($post['android_device_id'], $post['ios_device_id']);
          $this->response->addHeader('Content-type: application/json');
          $this->response->setOutput(json_encode(array("error" => 0)));
        }
    }

    /**
     * [sendNotificationForOrderStatus] send push notification on order status update
     * @param  array $data   contains order details like customer id, order it
     * @return null
     */
     public function sendNotificationForOrderStatus($data) {      
    
        if (isset($data['customer_id']) && isset($data['order_id'])) {
        
        $this->load->model('wkrestapi/customer');
        $language = $this->model_wkrestapi_customer->languageName($data['language_id']);      
        $language_code = new Language($language['code']);       
        $language_code->load('account/api');
         
         $saved_devices = $this->model_wkrestapi_customer->getDeviceIdByCustomerId($data['customer_id']);
         if(isset($data['order_status_id'])) {
           $order_status = $this->model_wkrestapi_customer->getOrderStatusById($data['order_status_id'],$data['language_id']);
           $title = sprintf($language_code->get('order_notification_title'), $data['order_id']);
           $desc = sprintf($language_code->get('order_notification_desc'), $order_status);
         
           if (isset($saved_devices['android_device_id']) && $saved_devices['android_device_id']) {

             $this->executeCurl($saved_devices['android_device_id'], $title, $desc, $data['comment']);
           }

           if (isset($saved_devices['ios_device_id']) && $saved_devices['ios_device_id']) {
             $this->executeCurl($saved_devices['ios_device_id'], $title, $desc, $data['comment']);
           }
         } else {
           $title = sprintf($this->language->get('order_notification_order_placed'), $data['order_id']);
           $desc = $this->language->get('order_notification_order_placed_desc');
           if (isset($saved_devices['android_device_id']) && $saved_devices['android_device_id']) {
             $this->executeCurl($saved_devices['android_device_id'], $title, $desc, '');
           }

           if (isset($saved_devices['ios_device_id']) && $saved_devices['ios_device_id']) {
             $this->executeCurl($saved_devices['ios_device_id'], $title, $desc, '');
           }
         }
       }
     }

    /**
     * [executeCurl] method for exucuting Curl for sending notification on android/ios device id
     * @param  string $device_id   ios/android device id
     * @param  string $order_id   order id
     * @param  string $order_status   changed status name
     * @param  string $comment   admin comment
     * @return null
     */
    protected function executeCurl($device_id, $title, $desc, $comment) {
        $accessToken = $this->generateToken();
		if($accessToken){
            $filepath = file_get_contents(DIR_SYSTEM .'mobikul_fcm_file/fcm_credentials.json');
            $json = json_decode($filepath, true); 
            $project_id = isset($json['project_id']) ? $json['project_id'] : '';
            $url = 'https://fcm.googleapis.com/v1/projects/' . $project_id . '/messages:send';

            $this->load->language('account/api');
     
            $data = array(
                'title'						=> html_entity_decode($title, ENT_QUOTES, 'UTF-8'),
                'image' => '',
                'body'						=> html_entity_decode($desc, ENT_QUOTES, 'UTF-8'),
                'type' => '',
                'type_data' => '',
                'sound' => 'default',
                'notification_id' => "1",
                'content'					=> html_entity_decode($desc, ENT_QUOTES, 'UTF-8'),
                'comment'         => $comment ? $comment : '',
                'mutable_content' =>  true
            );

            $notification = array(
                'body' => html_entity_decode($desc, ENT_QUOTES, 'UTF-8'),
                'image' => '',
                'title' => html_entity_decode($title, ENT_QUOTES, 'UTF-8'),
				
            );
     
            $fields = array(
                "message" => array(
                    'token' => $device_id,
                    'data' => $data,
                    'notification' => $notification,
					
                ),
            );
     
            $headers = array(
                'Authorization: Bearer ' . $accessToken,
                'Content-Type: application/json; UTF-8',
            );
     
           // Open connection
           $ch = curl_init();
     
           // Set the url, number of POST vars, POST data
           curl_setopt($ch, CURLOPT_URL, $url);
     
           curl_setopt($ch, CURLOPT_POST, true);
           curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
           curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
     
           // Disabling SSL Certificate support temporarly
           curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
     
           curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));
     
           // Execute post
           $result = curl_exec($ch);
     
           curl_close($ch);
        }
    }

    public function generateToken(){
        $filename = $this->config->get('module_mobikul_gcm_key');
        if ($filename) {
            $filepath = DIR_SYSTEM .'mobikul_fcm_file/fcm_credentials.json';
            putenv('GOOGLE_APPLICATION_CREDENTIALS=' . $filepath);
            $scope = 'https://www.googleapis.com/auth/firebase.messaging';
            $client = new Google\Client();
            $client->setScopes($scope);
            $client->useApplicationDefaultCredentials();
            $accessTokenDetails = $client->fetchAccessTokenWithAssertion();
            return $accessTokenDetails['access_token'];
        }
        return false;
    }

    public function reorder() {

      $this->load->language('account/api');

      $post = $this->request->post;

      //Accepting data in json format / raw data

      $raw_data = json_decode(file_get_contents("php://input"), true);

      if ($raw_data) {
          foreach ($raw_data as $key => $value) {
              $post[$key] = $value;
          }
      }

      //Get wk_token from header
      if (isset(getallheaders()['wk_token'])) {
        $post['wk_token'] = getallheaders()['wk_token'];
      } elseif (isset(getallheaders()['Wk-Token'])) {
        $post['wk_token'] = getallheaders()['Wk-Token'];
      }

      if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
          $this->response->addHeader('Content-Type: application/json');
          $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
      } else {
        $this->load->language('account/order');

        if (isset($post['order_id'])) {
          $order_id = $post['order_id'];
        } else {
          $order_id = 0;
          $error['error'] = 1;
          $error['message'] = $this->language->get('text_order_id_error');
        }

        if (isset($post['order_product_id'])) {
          $order_product_id = $post['order_product_id'];
        } else {
            $order_product_id = 0;
          $error['error'] = 1;
          $error['message'] = $this->language->get('text_product_message');
        }

        $this->load->model('account/order');

        $order_info = $this->model_account_order->getOrder($order_id);

        if(!isset($error)) {
          if ($order_info) {
            $order_product_info = $this->model_account_order->getOrderProduct($order_id, $order_product_id);

            if ($order_product_info) {
              $this->load->model('catalog/product');

              $product_info = $this->model_catalog_product->getProduct($order_product_info['product_id']);

              if ($product_info) {
                $option_data = array();

                $order_options = $this->model_account_order->getOrderOptions($order_product_info['order_id'], $order_product_id);

                foreach ($order_options as $order_option) {
                  if ($order_option['type'] == 'select' || $order_option['type'] == 'radio' || $order_option['type'] == 'image') {
                    $option_data[$order_option['product_option_id']] = $order_option['product_option_value_id'];
                  } elseif ($order_option['type'] == 'checkbox') {
                    $option_data[$order_option['product_option_id']][] = $order_option['product_option_value_id'];
                  } elseif ($order_option['type'] == 'text' || $order_option['type'] == 'textarea' || $order_option['type'] == 'date' || $order_option['type'] == 'datetime' || $order_option['type'] == 'time') {
                    $option_data[$order_option['product_option_id']] = $order_option['value'];
                  } elseif ($order_option['type'] == 'file') {
                    $option_data[$order_option['product_option_id']] = $this->encryption->encrypt($order_option['value']);
                  }
                }

                $this->cart->add($order_product_info['product_id'], $order_product_info['quantity'], $option_data);

                $return_array['error'] = 0;
                $return_array['message'] = strip_tags(sprintf($this->language->get('text_success'),'', html_entity_decode($product_info['name'],ENT_QUOTES,"UTF-8"), ''));

                unset($this->session->data['shipping_method']);
                unset($this->session->data['shipping_methods']);
                unset($this->session->data['payment_method']);
                unset($this->session->data['payment_methods']);
              } else {
                $return_array['error'] = 1;
                $return_array['message'] = strip_tags(sprintf($this->language->get('error_reorder'), $order_product_info['name']));
              }
            } else {
              $return_array['error'] = 1;
              $return_array['message'] = $this->language->get('text_verify');
            }
          } else {
            $return_array['error'] = 0;
            $return_array['message'] = $this->language->get('text_verify');
            $return_array['total'] = $this->cart->countProducts();

          }
          $this->response->addHeader('Content-Type: application/json');
          $this->response->setOutput(json_encode($return_array));
        } else {
          $this->response->addHeader('Content-Type: application/json');
          $this->response->setOutput(json_encode($error));
        }
      }

    }

    /**
     * Logouts a customer
     * @param  json $data contains session id of the customer
     * @return json       contains the text after logout
     */
    public function customerLogout()
    {
        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $postData = array();

            foreach ($post as $key => $value) {
                $postData[$key] = $value;
            }

            $this->load->model('wkrestapi/customer');

            $logoutData = $this->model_wkrestapi_customer->customerLogout();

            if ($logoutData) {
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($logoutData));
            } else {
                $return_array = array(
                        'error'        => 1
                    );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }
  /**
     * Delete a customer account or delete only customer personal information only.
     * @param  wk_token  contains session data of the customer     
     */
    public function deleteAccount()
    {
        $post = $this->request->post;
        $this->load->language('account/api');
        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
           
            $this->load->model('wkrestapi/customer');
          
            $status = $this->model_wkrestapi_customer->deleteAccount( (int)$this->customer->getId() );
              
            if ($status) {
                $return_array = array(
                    'error'        => 0,
                    'message'=>$this->language->get('text_account_delete')
                );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            } else {
                $return_array = array(
                        'error'        => 1
                    );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }
    /**
     * Fetches the account detail of a customer
     * @param  json $data contains the session ID
     * @return json       return the data of a customer
     */
    public function myAccount()
    {
        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (isset($post['custom_field']) && $post['custom_field'] && !is_array($post['custom_field'])) {
			$post['custom_field'] = stripslashes(html_entity_decode($post['custom_field']));
			$post['custom_field'] = json_decode($post['custom_field'],true);
		}

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $postData = array();

            foreach ($post as $key => $value) {
                $postData[$key] = $value;
            }

            $this->load->model('account/customer');
            if (version_compare(VERSION,'2.0.0.0','>=')){
             $this->load->model('account/custom_field');
            }
            $query = $this->model_account_customer->getCustomer($this->customer->getId());

            if (version_compare(VERSION,'2.0.0.0','>=')){
                $custom_fields = $this->model_account_custom_field->getCustomFields($this->config->get('config_customer_group_id'));
            }
            if (isset($query['custom_field'])) {
                if (version_compare(VERSION, '2.1.0.0', '>=')) {
                    $customField = json_decode($query['custom_field'], true);
                } else {
                    $customField = unserialize($query['custom_field']);
                }
            }

            $customData = array();
            if (version_compare(VERSION,'2.0.0.0','>=')){
            foreach ($custom_fields as $custom_field) {
                if ($custom_field['location'] == 'account') {
                    $customData[] = array(
                            'custom_field_id'        => $custom_field['custom_field_id'],
                            'custom_field_value'    => $custom_field['custom_field_value'],
                            'name'                    => $custom_field['name'],
                            'type'                    => $custom_field['type'],
                            'value'                    => $custom_field['value'],
                            'required'                => $custom_field['required'],
                            'customerValue'            => isset($customField[$custom_field['custom_field_id']]) ? $customField[$custom_field['custom_field_id']] : ''
                        );
                }
            }
        }
            if (isset($query['status'])) {
                $return_array = array(
                        'firstname'            => html_entity_decode($query['firstname'],ENT_QUOTES,'UTF-8'),
                        'lastname'            => html_entity_decode($query['lastname'],ENT_QUOTES,'UTF-8'),
                        'email'                => $query['email'],
                        'telephone'            => $query['telephone'],
                        'customField'        => $customData
                    );
            } else {
                $return_array = array(
                        'status'    => 0
                    );
            }

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Edits customer details
     * @param  json $data contains customer data
     * @return json       return error and message if exist
     */
    public function editCustomer()
    {
        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (isset($post['custom_field']) && $post['custom_field'] && !is_array($post['custom_field'])) {
			$post['custom_field'] = stripslashes(html_entity_decode($post['custom_field']));
			$post['custom_field'] = json_decode($post['custom_field'],true);
		}

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $data = array();

            foreach ($post as $key => $value) {
                $data[$key] = $value;
            }

            $this->load->model('wkrestapi/customer');

            if ($this->customer->isLogged()) {
                $this->load->model('account/customer');
                $this->load->language('account/edit');

                $error = array();

                //validations to put here

                if (!isset($data['firstname']) || (utf8_strlen(trim($data['firstname'])) < 1) || (utf8_strlen(trim($data['firstname'])) > 32)) {
                    $error['message'] = $this->language->get('error_firstname');
                }

                if (!isset($data['lastname']) || (utf8_strlen(trim($data['lastname'])) < 1) || (utf8_strlen(trim($data['lastname'])) > 32)) {
                    $error['message'] = $this->language->get('error_lastname');
                }

                if (!isset($data['email']) || (utf8_strlen($data['email']) > 96) || !preg_match('/^[^\@]+@.*.[a-z]{2,15}$/i', $data['email'])) {
                    $error['message'] = $this->language->get('error_email');
                }

                if (!isset($data['email']) || ($this->customer->getEmail() != $data['email']) && $this->model_account_customer->getTotalCustomersByEmail($data['email'])) {
                    $error['message'] = $this->language->get('error_exists');
                }

                if (!isset($data['telephone']) || (utf8_strlen($data['telephone']) < 3) || (utf8_strlen($data['telephone']) > 32)) {
                    $error['message'] = $this->language->get('error_telephone');
                }

                if (!$error) {
                    if (version_compare(VERSION,'3.0.0.0','>=')) {
                        $this->model_account_customer->editCustomer($this->customer->getId(),$data);
                    }else{
                        $this->model_account_customer->editCustomer($data);
                    }
                    if (version_compare(VERSION,'2.0.0.0','>=')) {
                    // Add to activity log
                    $this->load->model('account/activity');

                    $activity_data = array(
                        'customer_id' => $this->customer->getId(),
                        'name'        => $this->customer->getFirstName() . ' ' . $this->customer->getLastName()
                    );

                    $this->model_account_activity->addActivity('edit', $activity_data);
                    }
                    $return_array = array(
                            'error'        => 0,
                            'message'    => $this->language->get('text_success')
                        );
                } else {
                    $return_array = array(
                            'error'        => 1,
                            'message'    => $error['message']
                        );
                }

                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            } else {
                $return_array = array(
                            'error'        => 1
                    );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }

    /**
     * Edits customer's password
     * @param  json $data contains customer password
     * @return json       return error and message if exist
     */
    public function editPassword()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $data = array();

            foreach ($post as $key => $value) {
                $data[$key] = $value;
            }

            if ($this->customer->isLogged()) {
                $this->load->model('account/customer');

                $this->load->language('account/password');

                if (!isset($data['password']) || (utf8_strlen($data['password']) < 4) || (utf8_strlen($data['password']) > 20)) {
                    $error = $this->language->get('error_password');
                }

                if (!isset($error) || !$error) {
                    $this->model_account_customer->editPassword($this->customer->getEmail(), $data['password']);
                    if (version_compare(VERSION,'2.0.0.0','>=')) {
                    // Add to activity log
                    $this->load->model('account/activity');

                        $activity_data = array(
                        'customer_id' => $this->customer->getId(),
                        'name'        => $this->customer->getFirstName() . ' ' . $this->customer->getLastName()
                        );

                        $this->model_account_activity->addActivity('password', $activity_data);
                    }
                    $return_array = array(
                            'error'        => 0,
                            'message'    => $this->language->get('text_success')
                        );
                } else {
                    $return_array = array(
                            'error'        => 1,
                            'message'    => $error
                        );
                }

                $this->response->addHeader('Content-Type: application/json');

                $this->response->setOutput(json_encode($return_array));
            } else {
                $return_array = array(
                            'error'        => 1 ,
                            'message'    => $this->language->get('text_edit_password_message'),
                    );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }

    /**
     * returns customer addresses
     * @param  json $data session ID
     * @return json       return formatted addresses and address IDs
     */
    public function getAddresses()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            if ($this->customer->isLogged()) {
                $this->load->model('account/address');

                $addresses_data = array();

                $results = $this->model_account_address->getAddresses();

                foreach ($results as $result) {
                    if ($result['address_format']) {
                        $format = $result['address_format'];
                    } else {
                        $format = '{firstname} {lastname}' . "\n" . '{company}' . "\n" . '{address_1}' . "\n" . '{address_2}' . "\n" . '{city} {postcode}' . "\n" . '{zone}' . "\n" . '{country}';
                    }

                    $find = array(
                        '{firstname}',
                        '{lastname}',
                        '{company}',
                        '{address_1}',
                        '{address_2}',
                        '{city}',
                        '{postcode}',
                        '{zone}',
                        '{zone_code}',
                        '{country}'
                    );

                    $replace = array(
                        'firstname' => $result['firstname'],
                        'lastname'  => $result['lastname'],
                        'company'   => $result['company'],
                        'address_1' => $result['address_1'],
                        'address_2' => $result['address_2'],
                        'city'      => $result['city'],
                        'postcode'  => $result['postcode'],
                        'zone'      => $result['zone'],
                        'zone_code' => $result['zone_code'],
                        'country'   => $result['country']
                    );

                    $addresses_data[] = array(
                        'address_id' => $result['address_id'],
                        'value'      => str_replace(array("\r\n", "\r", "\n"), '<br />', preg_replace(array("/\s\s+/", "/\r\r+/", "/\n\n+/"), '<br />', trim(str_replace($find, $replace, $format))))
                    );
                }

                if ($addresses_data) {
                    $return_array = array(
                            'error'            => 0,
                            'addressData'    => $addresses_data,
                            'default'        => $this->customer->getAddressId()
                        );
                } else {
                    $return_array = array(
                            'error'        => 1,
                            'message'     => $this->language->get('text_no_address')
                        );
                }

                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            } else {
                $return_array = array(
                    'error'        => 1 ,
                    'message'    => 'Please login to get addresses',
                );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }

    /**
     * Fetches a particular address based on its ID
     * @param  json $data contains address and session ID
     * @return json       returns address data and country data
     */
    public function getAddress()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $data = array();

            foreach ($post as $key => $value) {
                $data[$key] = $value;
            }

            if ($this->customer->isLogged() || (isset($this->session->data['customer_id']) && $this->session->data['customer_id'])) {
                $this->load->model('wkrestapi/customer');
                $countries = $this->model_wkrestapi_customer->getCountryData();

                if (isset($data['address_id']) && $data['address_id']) {
                    $this->load->model('account/address');

                    $address_id = $data['address_id'];

                    $address_info = $this->model_account_address->getAddress($address_id);

                    foreach($address_info as $fkey => $fvalue) {
                      if(isset($address_info[$fkey]) && !is_array($address_info[$fkey]))
                      $address_info[$fkey] = html_entity_decode($address_info[$fkey],ENT_QUOTES,'UTF-8');
                    }

                    $customData = array();
                    if (version_compare(VERSION,'2.0.0.0','>=')) {
                      $this->load->model('account/custom_field');
                      $custom_fields = $this->model_account_custom_field->getCustomFields($this->config->get('config_customer_group_id'));
                      foreach ($custom_fields as $custom_field) {
                          $customData[] = array(
                                      'custom_field_id'        => $custom_field['custom_field_id'],
                                      'custom_field_value'    => $custom_field['custom_field_value'],
                                      'name'                    => $custom_field['name'],
                                      'type'                    => $custom_field['type'],
                                      'value'                    => isset($address_info['custom_field'][$custom_field['custom_field_id']]) ? $address_info['custom_field'][$custom_field['custom_field_id']] : '',
                                      'required'                => $custom_field['required'],
                                      'location'                => $custom_field['location']
                                  );
                      }
                    }
                    $address_info['customField'] = $customData;
                    unset($address_info['custom_field']);

                    $return_array = array(
                            'error'            => 0,
                            'data'            => $address_info,
                            'default'        => ($address_id == $this->customer->getAddressId()) ? 1 : 0,
                            'countryData'    => $countries,
                            'store_country_id'   => $this->config->get('config_country_id')
                        );
                } else {
                  $customData = array();
                  if (version_compare(VERSION,'2.0.0.0','>=')) {
                    $this->load->model('account/custom_field');
                    $custom_fields = $this->model_account_custom_field->getCustomFields($this->config->get('config_customer_group_id'));
                    foreach ($custom_fields as $custom_field) {
                        $customData[] = array(
                                    'custom_field_id'        => $custom_field['custom_field_id'],
                                    'custom_field_value'    => $custom_field['custom_field_value'],
                                    'name'                    => $custom_field['name'],
                                    'type'                    => $custom_field['type'],
                                    'value'                    => $custom_field['value'],
                                    'required'                => $custom_field['required'],
                                    'location'                => $custom_field['location']
                                );
                    }
                  }
                    $return_array = array(
                        'error'            => 0,
                        'customField'    => $customData,
                        'countryData'    => $countries,
                        'store_country_id'   => $this->config->get('config_country_id')
                    );
                }
            } else {
                $return_array = array(
                    'error'        => 1 ,
                    'message'    => $this->language->get('text_login_error'),
                );
            }

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Adds and edit a address
     * @param json $data contains address data
     */
    public function addAddress()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (isset($post['custom_field']) && $post['custom_field'] && !is_array($post['custom_field'])) {
    			$post['custom_field'] = stripslashes(html_entity_decode($post['custom_field']));
    			$post['custom_field'] = json_decode($post['custom_field'],true);
		    }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $data = array();

            foreach ($post as $key => $value) {
                $data[$key] = $value;
            }

            $this->load->model('wkrestapi/customer');

            if ($this->customer->isLogged()) {
                $this->load->language('account/address');

                $this->load->model('account/address');
                $this->load->model('localisation/country');

                $error = array();

                if ((utf8_strlen(trim($data['firstname'])) < 1) || (utf8_strlen(trim($data['firstname'])) > 32)) {
                    $error['firstname'] = $this->language->get('error_firstname');
                }

                if ((utf8_strlen(trim($data['lastname'])) < 1) || (utf8_strlen(trim($data['lastname'])) > 32)) {
                    $error['lastname'] = $this->language->get('error_lastname');
                }

                if ((utf8_strlen(trim($data['address_1'])) < 3) || (utf8_strlen(trim($data['address_1'])) > 128)) {
                    $error['address_1'] = $this->language->get('error_address_1');
                }

                if ((utf8_strlen(trim($data['city'])) < 2) || (utf8_strlen(trim($data['city'])) > 128)) {
                    $error['city'] = $this->language->get('error_city');
                }

                $this->load->model('localisation/country');

                $country_info = $this->model_localisation_country->getCountry($data['country_id']);

                if ($country_info && $country_info['postcode_required'] && (utf8_strlen(trim($data['postcode'])) < 2 || utf8_strlen(trim($data['postcode'])) > 10)) {
                    $error['postcode'] = $this->language->get('error_postcode');
                }

                if ($data['country_id'] == '' || !is_numeric($data['country_id'])) {
                    $error['country'] = $this->language->get('error_country');
                }

                if (!isset($data['zone_id']) || $data['zone_id'] == '' || !is_numeric($data['zone_id'])) {
                    $error['zone'] = $this->language->get('error_zone');
                }

                // Custom field validation
                // if (version_compare(VERSION,'2.0.0.0','>=')) {
                // $this->load->model('account/custom_field');

                //     $custom_fields = $this->model_account_custom_field->getCustomFields($this->config->get('config_customer_group_id'));

                //     foreach ($custom_fields as $custom_field) {
                //         if (($custom_field['location'] == 'address') && $custom_field['required'] && empty($data['custom_field'][$custom_field['custom_field_id']])) {
                //             $error['custom_field'][$custom_field['custom_field_id']] = sprintf($this->language->get('error_custom_field'), $custom_field['name']);
                //         } elseif (($custom_field['type'] == 'text' && !empty($custom_field['validation']) && $custom_field['location'] == 'address') && !filter_var($data['custom_field'][$custom_field['custom_field_id']], FILTER_VALIDATE_REGEXP, array('options' => array('regexp' => $custom_field['validation'])))) {
                //             $error['custom_field'][$custom_field['custom_field_id']] = sprintf($this->language->get('error_custom_field_validate'), $custom_field['name']);
                //         }
                //     }
                // }
                if (!$error) {
                    if (isset($data['address_id'])) {
                        $address_id = $data['address_id'];

                        $this->model_account_address->editAddress($address_id, $data);
                        if (version_compare(VERSION,'2.0.0.0','>='))
                            $success = $this->language->get('text_edit');
                        else
                            $success = $this->language->get('text_update');

                        if (version_compare(VERSION,'2.0.0.0','>=')) {
                            // Add to activity log
                            $this->load->model('account/activity');

                            $activity_data = array(
                                'customer_id' => $this->customer->getId(),
                                'name'        => $this->customer->getFirstName() . ' ' . $this->customer->getLastName()
                            );

                            $this->model_account_activity->addActivity('address_edit', $activity_data);
                        }
                    } else {
                        if (version_compare(VERSION,'3.0.0.0','>=')) {
                            $address_id = $this->model_account_address->addAddress($this->customer->getId(),$data);
                        }else{
                            $address_id = $this->model_account_address->addAddress($data);
                        }
                        if (version_compare(VERSION,'2.0.0.0','>='))
                            $success = $this->language->get('text_add');
                        else
                           $success = $this->language->get('text_insert');

                        if (version_compare(VERSION,'2.0.0.0','>=')) {
                            // Add to activity log
                            $this->load->model('account/activity');

                            $activity_data = array(
                                'customer_id' => $this->customer->getId(),
                                'name'        => $this->customer->getFirstName() . ' ' . $this->customer->getLastName()
                            );

                            $this->model_account_activity->addActivity('address_add', $activity_data);
                        }
                    }

                    $return_array = array(
                        'error'        => 0,
                        'message'    => $success
                    );
                } else {
                    $return_array = array(
                        'error'        => 1,
                        'message'    => $error
                    );
                }
            } else {
                $return_array = array(
                    'error'        => 1
                );
            }
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Deletes an address of a customer
     * @param  json $data contains address ID
     * @return json       error and message if exist
     */
    public function deleteAddress()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $address_data = array();

            foreach ($post as $key => $value) {
                $address_data[$key] = $value;
            }

            if (isset($address_data['address_id']) && $address_data['address_id']) {
                if ($this->customer->isLogged()) {
                    $this->load->model('account/address');

                    $this->load->language('account/address');

                    $error = array();

                    if ($this->model_account_address->getTotalAddresses() == 1) {
                        $error['warning'] = $this->language->get('error_delete');
                    }

                    if ($this->customer->getAddressId() == $address_data['address_id']) {
                        $error['warning'] = $this->language->get('error_default');
                    }

                    if (!$error) {
                        $this->model_account_address->deleteAddress($address_data['address_id']);

                        $success = $this->language->get('text_delete');
                        if (version_compare(VERSION,'2.0.0.0','>=')) {
                            // Add to activity log
                            $this->load->model('account/activity');

                            $activity_data = array(
                                'customer_id' => $this->customer->getId(),
                                'name'        => $this->customer->getFirstName() . ' ' . $this->customer->getLastName()
                            );

                            $this->model_account_activity->addActivity('address_delete', $activity_data);
                        }
                        $return_array = array(
                                'error'        => 0,
                                'message'    => $success
                            );
                    } else {
                        $return_array = array(
                                'error'        => 1,
                                'message'    => $error['warning']
                            );
                    }
                } else {
                    $return_array = array(
                        'error'        => 1 ,
                        'message'    => $this->language->get('text_login_error')
                    );
                }
            } else {
                $return_array = array(
                    'error'        => 1,
                    'message'    => $this->language->get('text_address_id_error')
                );
            }
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Fetches the data of customer's wishlist
     * @param  json $data contains session ID
     * @return json       return data containing list of products in wishlist
     */
    public function getWishlist()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $post_data = array();

            foreach ($post as $key => $value) {
                $post_data[$key] = $value;
            }

            if (isset($post_data['width'])) {
                $width = $post_data['width'];
            } else {
                $width = 100;
            }

            if ($this->customer->isLogged()) {
                $this->load->model('wkrestapi/catalog');

                $this->load->model('catalog/product');

                $this->load->model('tool/image');

                $this->load->language('account/wishlist');

                $results = $this->model_wkrestapi_catalog->getDBWishlist();

                $product_data = array();

                if ($results) {
                  foreach ($results as $result) {
                      if (version_compare(VERSION, '2.1.0.0', '>=')) {
                          $product_info = $this->model_catalog_product->getProduct($result['product_id']);
                      } else {
                          $product_info = $this->model_catalog_product->getProduct($result);
                      }

                      if ($product_info) {
                          if ($product_info['image']) {
                              $image = $this->model_tool_image->resize($product_info['image'], $width/2, $width/2);
                          } else {
                              $image = false;
                          }

                          if (isset($product_info['image']) && is_file(DIR_IMAGE.$product_info['image']))
                					$dc_image = DIR_IMAGE.$product_info['image'];
                					elseif (is_file(DIR_IMAGE.'placeholder.png'))
                					$dc_image = DIR_IMAGE.'placeholder.png';
                					else
                					$dc_image = '';

                					$this->load->model('wkrestapi/catalog');
                					$dominant_color = $this->model_wkrestapi_catalog->getDominantColor($dc_image);

                          if ($product_info['quantity'] <= 0) {
                              $stock = $product_info['stock_status'];
                          } elseif ($this->config->get('config_stock_display')) {
                              $stock = $product_info['quantity'];
                          } else {
                              $stock = $this->language->get('text_instock');
                          }

                          if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
                              $price = $this->currency->format($this->tax->calculate($product_info['price'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
                          } else {
                              $price = false;
                          }

                          if ((float)$product_info['special']) {
                  					$formatedSpecial = $this->currency->format($this->tax->calculate($product_info['special'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
                  					$special = $product_info['special'];
                  				} else {
                  					$formatedSpecial = '';
                  					$special = 0.00;
                  				}

                          $product_data[] = array(
                              'product_id' => $product_info['product_id'],
                              'thumb'      => $image,
                              'dominant_color' => $dominant_color,
                              'name'       => html_entity_decode($product_info['name'],ENT_QUOTES,"UTF-8"),
                              'model'      => $product_info['model'],
                              'quantity'      => $product_info['quantity'],
                              'stock'      => $stock,
                              'price'      => $price,
                              'special' 	 => (float) $special,
                    					'formatted_special' => $formatedSpecial,
                              'hasOption'     => $this->model_wkrestapi_catalog->productOption($product_info['product_id'])
                          );
                      } else {
                        $this->load->model('wkrestapi/customer');
                        $this->model_wkrestapi_customer->removeFromWishlist($result['product_id']);
                      }
                    }
                }

                if ($product_data) {
                    $return_array = array(
                        'wishlistData'    => $product_data,
                        'error'            => 0
                        );
                } else {
                    $return_array = array(
                            'error'        => 1,
                            'message'    => $this->language->get('text_empty')
                        );
                }
            } else {
                $return_array = array(
                    'error'        => 1
                );
            }

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Removes an item from the wishlist
     * @param  json $data contains product ID
     * @return json       returns error and message if exist
     */
    public function removeFromWishlist()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $product_id = 0;

            if (isset($post['product_id']) && $post['product_id']) {
                $product_id = $post['product_id'];
            }

            $this->load->model('wkrestapi/customer');

            if ($this->customer->isLogged()) {
                $removeFromWishlist = $this->model_wkrestapi_customer->removeFromWishlist($product_id);

                if ($removeFromWishlist) {
                    $return_array = array(
                        'error'        => 0,
                        'message'    => $removeFromWishlist
                    );
                    $this->response->addHeader('Content-Type: application/json');
                    $this->response->setOutput(json_encode($return_array));
                } else {
                    $return_array = array(
                            'error'        => 1
                        );
                    $this->response->addHeader('Content-Type: application/json');
                    $this->response->setOutput(json_encode($return_array));
                }
            } else {
                $return_array = array(
                            'error'        => 1
                    );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }

    /**
     * Calls the register page
     * @param  json $data null
     * @return json       return country and zone data
     */
    public function registerAccount()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $post = array();

            foreach ($post as $key => $value) {
                $post[$key] = $value;
            }
            if (version_compare(VERSION,'2.0.0.0','>='))
                $this->load->model('account/custom_field');

            $this->load->model('wkrestapi/customer');

            if (version_compare(VERSION,'2.0.0.0','>='))
                 $custom_fields = $this->model_account_custom_field->getCustomFields($this->config->get('config_customer_group_id'));
         
            $customData = array();

            if (version_compare(VERSION,'2.0.0.0','>=')) {
                foreach ($custom_fields as $custom_field) {
                    $customData[] = array(
                                'custom_field_id'        => $custom_field['custom_field_id'],
                                'custom_field_value'    => $custom_field['custom_field_value'],
                                'name'                    => $custom_field['name'],
                                'type'                    => $custom_field['type'],
                                'value'                    => $custom_field['value'],
                                'required'                => $custom_field['required'],
                                'location'                => $custom_field['location']
                            );
                }
            }

           // $countryData = $this->model_wkrestapi_customer->getCountryData();

            if($this->config->get('config_account_id')) {
              $account_id = $this->config->get('config_account_id');
            } else {
              $account_id = "3";
            }

            if ($account_id) {
                $this->load->model('catalog/information');
                $this->load->language('account/register');

                $information_info = $this->model_catalog_information->getInformation($account_id);

                if (isset($information_info['description']) && $information_info['description']) {
                  $information_info['description'] = html_entity_decode($information_info['description']);
                }

                if ($information_info) {
                    $agreeInfo = array(
                            'text'    => $this->language->get('text_agree'),
                            'data'    => $information_info
                        );
                } else {
                    $agreeInfo = (object) array();
                }
            } else {
                $agreeInfo = (object) array();
            }

            $customerGroup = array();

            if (is_array($this->config->get('config_customer_group_display'))) {
                $this->load->model('account/customer_group');

                $customer_groups = $this->model_account_customer_group->getCustomerGroups();

                foreach ($customer_groups as $customer_group) {
                    if (in_array($customer_group['customer_group_id'], $this->config->get('config_customer_group_display'))) {
                        $customerGroup[] = $customer_group;
                    }
                }
            }

            if($this->config->get('module_marketplace_status') && $this->config->get('marketplace_becomepartnerregistration')) {
              $this->load->language('account/customerpartner/become_partner');
              $become_seller = true;
              $text_becomepartner = $this->language->get('text_register_douwant');
              $text_shop = $this->language->get('text_shop_name');
            } else {
              $become_seller = false;
              $text_becomepartner = null;
              $text_shop = null;
            }

            if ($customData || $agreeInfo || $customerGroup) {
                $return_array = array(
                        'error'                => 0,
                        'text_becomepartner'   => $text_becomepartner,
                        'text_shop'            => $text_shop,
                        'become_seller'       => $become_seller,
                        'agreeInfo'            => $agreeInfo,
                        'customerGroup'        => $customerGroup,
                        'customField'        => $customData,
                    //    'countryData'        => $countryData,
                        'store_country_id'   => $this->config->get('config_country_id')
                    );
            } else {
                $return_array = array(
                        'error'        => 1
                    );
            }

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Registers a customer
     * @param json $data contains customer data
     */
    public function addCustomer()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (isset($post['custom_field']) && $post['custom_field'] && !is_array($post['custom_field'])) {
			$post['custom_field'] = stripslashes(html_entity_decode($post['custom_field']));
			$post['custom_field'] = json_decode($post['custom_field'],true);
		}

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $data = array();

            foreach ($post as $key => $value) {
                $data[$key] = $value;
            }

            $this->load->model('account/customer');
            $this->load->model('wkrestapi/customer');


            $this->load->language('account/register');

            $return_array = $this->validateRegister($data);
           
            if (!$return_array) {
                if (!isset($data['customer_group_id']) || !$data['customer_group_id']) {
                    $data['customer_group_id'] = $this->config->get('config_customer_group_id');
                }

                if (!isset($data['fax'])) {
                    $data['fax'] = '';
                }

                if (!isset($data['company'])) {
                    $data['company'] = '';
                }

                if (!isset($data['address_1'])) {
                    $data['address_1'] = '';
                }

                if (!isset($data['address_2'])) {
                    $data['address_2'] = '';
                }

                if (!isset($data['postcode'])) {
                    $data['postcode'] = '';
                }

                if (!isset($data['city'])) {
                    $data['city'] = '';
                }

                if (!isset($data['zone_id'])) {
                    $data['zone_id'] = '';
                }

                if (!isset($data['country_id'])) {
                    $data['country_id'] = '';
                }

                if (!isset($data['tax_id'])) {
                    $data['tax_id'] = '';
                }
              
                if (isset($post['newsletter']) && $post['newsletter']) {
                    $data['newsletter'] = $post['newsletter'];
                } else {
                    $data['newsletter'] = '';
                }

                if (version_compare(VERSION,'2.0.0.0','<')) {
                    if (isset($data['email'])) {
                        $loginData['username'] = $data['email'];
                        $loginData['password'] = $data['password'];
                    }
                }
  
                if (version_compare(VERSION,'2.0.0.0','<')){
                    $this->model_account_customer->addCustomer($data);
                    $login = $this->model_wkrestapi_customer->customerLogin($loginData);
                    $customer_id = $login['customer_id'];
                } else {
                    $customer_id = $this->model_account_customer->addCustomer($data);
                }

                if ($customer_id) {

                  if($this->config->get('module_marketplace_status') && $this->config->get('marketplace_becomepartnerregistration')){
                      if (isset($data['tobecomepartner']) && (int)$data['tobecomepartner'] == 1 && isset($data['shoppartner'])) {
                          $this->load->model('account/customerpartner');
                          $this->model_account_customerpartner->becomePartner($data['shoppartner'],$data['country_id'],$customer_id);
                      }
                  }

                    if (version_compare(VERSION,'2.0.0.0','>=')) {
                        // Add to activity log
                        $this->load->model('account/activity');

                        $activity_data = array(
                            'customer_id' => $customer_id,
                            'name'        => $data['firstname'] . ' ' . $data['lastname']
                        );

                        $this->model_account_activity->addActivity('register', $activity_data);
                    }

                    $this->load->language('account/success');

                        $this->load->model('account/customer_group');
                        $customer_group_info = $this->model_account_customer_group->getCustomerGroup($this->config->get('config_customer_group_id'));

                        if ($customer_group_info && !$customer_group_info['approval']) {
                            // Clear any previous login attempts for unregistered accounts.

                            if(version_compare(VERSION,'2.0.0.0','>='))
                                $this->model_account_customer->deleteLoginAttempts($data['email']);

                            // login the customer by putting customer id in session
                            $this->session->data['customer_id'] = $customer_id;

                            if (!isset($data['android_device_id']))
                            $data['android_device_id'] = '';

                            if (!isset($data['ios_device_id']))
                            $data['ios_device_id'] = '';

                            $this->load->model('wkrestapi/customer');
                            $this->model_wkrestapi_customer->registerDeviceToken($data['android_device_id'], $data['ios_device_id'], $customer_id);

                            $partner = 0;
                            $partner_approve_required = false;

                            if ($this->config->get('marketplace_status') || $this->config->get('module_marketplace_status')) {
                              if ($this->model_wkrestapi_customer->chkIsPartner($customer_id)) {
                                $partner = 1;
                              }
                              if ($partner == 0) {
                                $hasApplied = $this->model_wkrestapi_customer->IsApplyForSellership($customer_id);
                                if ($hasApplied) {
                                  $partner_approve_required = true;
                                }
                              }
                            }

                            $return_array = array(
                                    'error'        => 0,
                                    'customer_id'    => $customer_id,
                                    'approve_required' => false,
                                    'message'        => strip_tags(html_entity_decode($this->language->get('text_message'))),
                                    'partner'       => $partner,
                                    'partner_approve_required'  => $partner_approve_required
                                );
                        } else {
                            $return_array = array(
                                    'error'        => 1,
                                    'approve_required' => true,
                                    'customer_id'    => $customer_id,
                                    'message'        => strip_tags(html_entity_decode($this->language->get('text_approval')))
                                );
                        }
                } else {
                    $return_array = array(
                            'error'        => 1
                        );
                }
            }

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_array));
        }
    }

    public function becomeSeller() {
      $this->load->language('account/api');

      $post = $this->request->post;

      //Accepting data in json format / raw data

      $raw_data = json_decode(file_get_contents("php://input"), true);

      if ($raw_data) {
          foreach ($raw_data as $key => $value) {
              $post[$key] = $value;
          }
      }

      //Get wk_token from header
      if (isset(getallheaders()['wk_token'])) {
        $post['wk_token'] = getallheaders()['wk_token'];
      } elseif (isset(getallheaders()['Wk-Token'])) {
        $post['wk_token'] = getallheaders()['Wk-Token'];
      }

      if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
          $this->response->addHeader('Content-Type: application/json');
          $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
      } else {
        $return_array['error'] = 1;
        $this->language->load('account/customerpartner/become_partner');
        if (!$this->customer->getId()) {
          $return_array['message'] = $this->language->get('text_login_error');
        } elseif(!isset($post['shoppartner'])) {
            $return_array['message'] = $this->language->get('error_validshop');
        } elseif(!isset($post['description'])) {
            $return_array['message'] = $this->language->get('error_message');
        } else {
            $this->load->model('customerpartner/master');
              if($this->model_customerpartner_master->getShopData($post['shoppartner'])) {
                  $return_array['message'] = $this->language->get('error_noshop');
              }
        }
        $this->load->model('wkrestapi/customer');

        $hasApplied = $this->model_wkrestapi_customer->IsApplyForSellership($this->customer->getId());
        if (!isset($return_array['message']) && $hasApplied) {
          $return_array['message'] = strip_tags($this->language->get('text_delay'));
        }

        if (!isset($return_array['message'])) {
          if (!isset($post['description'])) $post['description'] = '';
          $return_array['error'] = 0;

          $this->load->model('account/customerpartner');
          $this->model_account_customerpartner->becomePartner($post['shoppartner'],$customer_country_id='',$this->customer->getId(),$post['description']);

          $return_array['partner'] = 0;
          if ($this->config->get('marketplace_status') || $this->config->get('module_marketplace_status')) {
            if ($this->model_wkrestapi_customer->chkIsPartner($this->customer->getId())) {
              $return_array['partner'] = 1;
            }
          }

          $return_array['partner_approve_required'] = false;
          if (($this->config->get('module_marketplace_status') || $this->config->get('marketplace_status')) && $return_array['partner'] == 0) {
            $hasApplied = $this->model_wkrestapi_customer->IsApplyForSellership($this->customer->getId());
            if ($hasApplied) {
              $return_array['partner_approve_required'] = true;
            }
          }
          $return_array['message'] = $this->language->get('text_success');

        }
        $this->response->addHeader('Content-Type: application/json');
        $this->response->setOutput(json_encode($return_array));
      }
    }

    /**
     * Fetches order history of a customer
     * @param  json $data contains data of customer
     * @return json       returns the order data of a customer
     */
    public function getOrders()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            if (isset($post['page'])) {
                $page = $post['page'];
            } else {
                $page = 1;
            }

            $this->load->model('account/order');
            $this->load->language('account/order');

            $getTotalOrders = $this->model_account_order->getTotalOrders();

            if (!$getTotalOrders) {
                $return_array = array(
                        'error'        => 0,
                        'message'    => $this->language->get('text_empty')
                );
            } else {
                $getOrders = $this->model_account_order->getOrders(($page - 1) * 10, 10);

                $order_data = array();

                foreach ($getOrders as $order) {
                    $product_total = $this->model_account_order->getTotalOrderProductsByOrderId($order['order_id']);
                    $voucher_total = $this->model_account_order->getTotalOrderVouchersByOrderId($order['order_id']);
                    $order_data[] = array(
                            'orderId'    => $order['order_id'],
                            'name'        => html_entity_decode($order['firstname'] .' '. $order['lastname'],ENT_QUOTES,'UTF-8'),
                            'status'    => html_entity_decode($order['status'],ENT_QUOTES,"UTF-8"),
                            'dateAdded'    => date('d/m/Y', strtotime($order['date_added'])),
                            'products'   => ($product_total + $voucher_total),
                            'total'        => $this->currency->format($order['total'], $order['currency_code'], $order['currency_value'])
                        );
                }

                if ($order_data && $getTotalOrders) {
                    $return_array = array(
                        'orderData'        => $order_data,
                        'orderTotals'    => $getTotalOrders,
                        'error'            => 0
                    );
                } else {
                    $return_array = array(
                        'error'        => 1
                    );
                }
            }

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Fetches order information of particular order ID
     * @param  json $data contains order ID
     * @return json       returns order information
     */
    public function getOrderInfo()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $order_id = 0;

            if (isset($post['order_id']) && $post['order_id']) {
                $order_id = $post['order_id'];
            }

            $this->load->model('account/order');

            $this->load->language('account/order');

            $order_info = $this->model_account_order->getOrder($order_id);

            if (isset($order_info['invoice_no'])) {
                $invoice_no = $order_info['invoice_prefix'] . $order_info['invoice_no'];
            } else {
                $invoice_no = '';
            }
            
            $date_added = date($this->language->get('date_format_short'), strtotime($order_info['date_added']));

            if (isset($order_info['payment_address_format'])) {
                $format = $order_info['payment_address_format'];
            } else {
                $format = '{firstname} {lastname}' . "\n" . '{company}' . "\n" . '{address_1}' . "\n" . '{address_2}' . "\n" . '{city} {postcode}' . "\n" . '{zone}' . "\n" . '{country}';
            }

            $find = array(
                '{firstname}',
                '{lastname}',
                '{company}',
                '{address_1}',
                '{address_2}',
                '{city}',
                '{postcode}',
                '{zone}',
                '{zone_code}',
                '{country}'
            );

            $replace = array(
                'firstname' => isset($order_info['payment_firstname']) ? $order_info['payment_firstname'] : '',
                'lastname'  => isset($order_info['payment_lastname']) ? $order_info['payment_lastname'] : '',
                'company'   => isset($order_info['payment_company']) ? $order_info['payment_company'] : '',
                'address_1' => isset($order_info['payment_address_1']) ? $order_info['payment_address_1'] : '',
                'address_2' => isset($order_info['payment_address_2']) ? $order_info['payment_address_2'] : '',
                'city'      => isset($order_info['payment_city']) ? $order_info['payment_city'] : '',
                'postcode'  => isset($order_info['payment_postcode']) ? $order_info['payment_postcode'] : '',
                'zone'      => isset($order_info['payment_zone']) ? $order_info['payment_zone'] : '',
                'zone_code' => isset($order_info['payment_zone_code']) ? $order_info['payment_zone_code'] : '',
                'country'   => isset($order_info['payment_country']) ? $order_info['payment_country'] : '',
            );

            $payment_address = str_replace(array("\r\n", "\r", "\n"), '<br />', preg_replace(array("/\s\s+/", "/\r\r+/", "/\n\n+/"), '<br />', trim(str_replace($find, $replace, $format))));

            $payment_method = isset($order_info['payment_method']) ? $order_info['payment_method'] : '';

            if (isset($order_info['shipping_address_format']) && $order_info['shipping_address_format']) {
                $format = $order_info['shipping_address_format'];
            } else {
                $format = '{firstname} {lastname}' . "\n" . '{company}' . "\n" . '{address_1}' . "\n" . '{address_2}' . "\n" . '{city} {postcode}' . "\n" . '{zone}' . "\n" . '{country}';
            }

            $find = array(
                '{firstname}',
                '{lastname}',
                '{company}',
                '{address_1}',
                '{address_2}',
                '{city}',
                '{postcode}',
                '{zone}',
                '{zone_code}',
                '{country}'
            );

            $replace = array(
                'firstname' => isset($order_info['payment_firstname']) ? $order_info['payment_firstname'] : '',
                'lastname'  => isset($order_info['payment_lastname']) ? $order_info['payment_lastname'] : '',
                'company'   => isset($order_info['payment_company']) ? $order_info['payment_company'] : '',
                'address_1' => isset($order_info['payment_address_1']) ? $order_info['payment_address_1'] : '',
                'address_2' => isset($order_info['payment_address_2']) ? $order_info['payment_address_2'] : '',
                'city'      => isset($order_info['payment_city']) ? $order_info['payment_city'] : '',
                'postcode'  => isset($order_info['payment_postcode']) ? $order_info['payment_postcode'] : '',
                'zone'      => isset($order_info['payment_zone']) ? $order_info['payment_zone'] : '',
                'zone_code' => isset($order_info['payment_zone_code']) ? $order_info['payment_zone_code'] : '',
                'country'   => isset($order_info['payment_country']) ? $order_info['payment_country'] : '',
            );

            $shipping_address = str_replace(array("\r\n", "\r", "\n"), '<br />', preg_replace(array("/\s\s+/", "/\r\r+/", "/\n\n+/"), '<br />', trim(str_replace($find, $replace, $format))));

            $shipping_method = isset($order_info['shipping_method']) ? $order_info['shipping_method'] : '';

            $this->load->model('catalog/product');
            if (version_compare(VERSION,'2.0.0.0','>='))
               $this->load->model('tool/upload');

            // Products
            $products = array();

            $products_data = $this->model_account_order->getOrderProducts($order_id);

            foreach ($products_data as $product) {
                $option_data = array();

                $options = $this->model_account_order->getOrderOptions($order_id, $product['order_product_id']);

                foreach ($options as $option) {
                    if ($option['type'] != 'file') {
                        $value = $option['value'];
                    } else {

                        if (version_compare(VERSION,'2.0.0.0','>=')) {
                            $upload_info = $this->model_tool_upload->getUploadByCode($option['value']);
                            if($upload_info)
                                $upload_info_value = $upload_info['name'];
                            else
                                $upload_info_value = '';
                        } else {
                            $filename = $this->encryption->decrypt($option['option_value']);
                            $upload_info_value = utf8_substr($filename, 0, utf8_strrpos($filename, '.'));
                        }

                        if ($upload_info_value) {
                            $value = $upload_info_value;
                        } else {
                            $value = '';
                        }
                    }

                    $option_data[] = array(
                        'name'  => $option['name'],
                        'value' => (utf8_strlen($value) > 20 ? utf8_substr($value, 0, 20) . '..' : $value)
                    );
                }

                $product_info = $this->model_catalog_product->getProduct($product['product_id']);

                $products[] = array(
                    'product_id' => $product['product_id'],
                    'name'     => html_entity_decode($product['name'],ENT_QUOTES,"UTF-8"),
                    'order_product_id' => $product['order_product_id'],
                    'model'    => html_entity_decode($product['model'],ENT_QUOTES,"UTF-8"),
                    'option'   => $option_data,
                    'quantity' => $product['quantity'],
                    'price'    => $this->currency->format($product['price'], $this->config->get('config_currency')),

                    'total'    => $this->currency->format($product['total'], $this->config->get('config_currency'))
                );
            }

            // Voucher
            $vouchers = array();

            $vouchers = $this->model_account_order->getOrderVouchers($order_id);

            foreach ($vouchers as $voucher) {
                $data['vouchers'][] = array(
                    'description' => $voucher['description'],
                    'amount'      => $this->currency->format($voucher['amount'], $this->config->get('config_currency'))
                );
            }

            // Totals
            $totals = array();

            $order_totals = $this->model_account_order->getOrderTotals($order_id);

            foreach ($order_totals as $order_total) {
                $totals[] = array(
                    'title' => $order_total['title'],
                    'text'  => $this->currency->format($order_total['value'], $this->config->get('config_currency')),
                );
            }

            $comment = nl2br(isset($order_info['comment']) ? $order_info['comment'] : '');

            // History
            $histories = array();

            $results = $this->model_account_order->getOrderHistories($order_id);

            foreach ($results as $result) {
                $histories[] = array(
                    'date_added' => date($this->language->get('date_format_short'), strtotime($result['date_added'])),
                    'status'     => html_entity_decode($result['status'],ENT_QUOTES,"UTF-8"),
                    'comment'    => $result['notify'] ? nl2br($result['comment']) : ''
                );
            }

            if ($order_id) {
                $return_array = array(
                    'invoice_no'        => $invoice_no,
                    'order_id'            => $order_id,
                    'date_added'        => $date_added,
                    'payment_address'    => $payment_address,
                    'payment_method'    => strip_tags($payment_method),
                    'shipping_address'    => $shipping_address,
                    'shipping_method'    => strip_tags($shipping_method),
                    'products'            => $products,
                    'vouchers'            => $vouchers,
                    'totals'            => $totals,
                    'comment'            => $comment,
                    'histories'            => $histories,
                    'error'                => 0
                );
            } else {
                $return_array = array(
                    'error'        => 1 ,
                    'message'    => 'Missing / Invalid  order_id'
                );
            }

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Fetches reward information
     * @param  json $data contains customer info
     * @return json       returns the reward information of a customer
     */
    public function getRewardInfo()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            if (isset($post['page'])) {
                $page = $post['page'];
            } else {
                $page = 1;
            }

            $this->load->model('account/reward');

            $this->load->language('account/reward');

            $reward_data = array();

            $filter_data = array(
                'sort'  => 'date_added',
                'order' => 'DESC',
                'start' => ($page - 1) * 10,
                'limit' => 10
            );

            $reward_total = $this->model_account_reward->getTotalRewards();

            if (!$reward_total) {
                $return_array = array(
                    'error'        => 1,
                    'message'    => $this->language->get('text_empty')
                );
            } else {
                $results = $this->model_account_reward->getRewards($filter_data);

                foreach ($results as $result) {
                    $reward_data[] = array(
                        'order_id'    => $result['order_id'],
                        'points'      => $result['points'],
                        'description' => strip_tags(html_entity_decode($result['description'],ENT_QUOTES,'UTF-8')),
                        'date_added'  => date($this->language->get('date_format_short'), strtotime($result['date_added']))
                    );
                }

                if ($reward_data && $reward_total) {
                    $return_array = array(
                        'error'                => 0,
                        'rewardData'        => $reward_data,
                        'rewardsTotal'        => $reward_total,
                        'rewardText'        => $this->language->get('text_total').(int)$this->customer->getRewardPoints(),
                        'totalPoints'        => (int)$this->customer->getRewardPoints()
                    );
                } else {
                    $return_array = array(
                        'error'        => 1
                    );
                }
            }

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Fetches transaction information
     * @param  json $data contains customer info
     * @return json       returns the transaction information of a customer
     */
    public function getTransactionInfo()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            if (isset($post['page'])) {
                $page = $post['page'];
            } else {
                $page = 1;
            }

            $this->load->model('account/transaction');

            $this->load->language('account/transaction');

            $transaction_data = array();

            $filter_data = array(
                'sort'  => 'date_added',
                'order' => 'DESC',
                'start' => ($page - 1) * 10,
                'limit' => 10
            );

            $transaction_total = $this->model_account_transaction->getTotalTransactions();

            if (!$transaction_total) {
                $return_array = array(
                    'error'        => 1,
                    'message'    => $this->language->get('text_empty')
                );
            } else {
                $results = $this->model_account_transaction->getTransactions($filter_data);

                foreach ($results as $result) {
                    $transaction_data[] = array(
                        'amount'      => $this->currency->format($result['amount'], $this->config->get('config_currency')),
                        'description' => html_entity_decode($result['description'],ENT_QUOTES,"UTF-8"),
                        'date_added'  => date($this->language->get('date_format_short'), strtotime($result['date_added']))
                    );
                }

                if ($transaction_data && $transaction_total) {
                    $return_array = array(
                        'error'                    => 0,
                        'transactionData'        => $transaction_data,
                        'transactionsTotal'        => $transaction_total,
                        'transactionText'        => $this->language->get('text_total').' <b>'. $this->currency->format($this->customer->getBalance(), $this->session->data['currency']) .'</b>',
                        'totalBalance'            => $this->currency->format($this->customer->getBalance(), $this->session->data['currency'])
                    );
                } else {
                    $return_array = array(
                        'error'        => 1
                    );
                }
            }

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Fetches return history of a customer
     * @param  json $data contains data of customer
     * @return json       returns the return data of a customer
     */
    public function getReturns()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            if (isset($post['page'])) {
                $page = $post['page'];
            } else {
                $page = 1;
            }

            $this->load->model('account/return');

            $this->load->language('account/return');

            $return_data = array();

            $return_total = $this->model_account_return->getTotalReturns();

            if (!$return_total) {
                $return_array = array(
                    'error'        => 1,
                    'message'    => $this->language->get('text_empty')
                );
            } else {
                $results = $this->model_account_return->getReturns(($page - 1) * 10, 10);

                foreach ($results as $result) {
                    $return_data[] = array(
                        'return_id'  => $result['return_id'],
                        'order_id'   => $result['order_id'],
                        'name'       => html_entity_decode($result['firstname'],ENT_QUOTES,'UTF-8') . ' ' . html_entity_decode($result['lastname'],ENT_QUOTES,'UTF-8'),
                        'status'     => $result['status'],
                        'date_added' => date($this->language->get('date_format_short'), strtotime($result['date_added']))
                    );
                }

                if ($return_data && $return_total) {
                    $return_array = array(
                        'error'            => 0,
                        'returnData'    => $return_data,
                        'returnTotals'    => $return_total
                    );
                } else {
                    $return_array = array(
                        'error'        => 1
                    );
                }
            }

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Fetches return information of particular return ID
     * @param  json $data contains return ID
     * @return json       returns return information
     */
    public function getReturnInfo()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $return_id = 0;

            if (isset($post['return_id']) && $post['return_id']) {
                $return_id = $post['return_id'];
            }

            $this->load->model('account/return');

            $this->load->language('account/return');

            $return_info = $this->model_account_return->getReturn($return_id);

            $return_data = array();

            if ($return_info) {
                $return_data['return_id'] = $return_info['return_id'];
                $return_data['order_id'] = $return_info['order_id'];
                $return_data['date_ordered'] = date($this->language->get('date_format_short'), strtotime($return_info['date_ordered']));
                $return_data['date_added'] = date($this->language->get('date_format_short'), strtotime($return_info['date_added']));
                $return_data['firstname'] = html_entity_decode($return_info['firstname'], ENT_QUOTES, 'UTF-8');
                $return_data['lastname'] = html_entity_decode($return_info['lastname'], ENT_QUOTES, 'UTF-8');
                $return_data['email'] = $return_info['email'];
                $return_data['telephone'] = $return_info['telephone'];
                $return_data['product'] = html_entity_decode($return_info['product'], ENT_QUOTES, 'UTF-8');
                $return_data['model'] = html_entity_decode($return_info['model'], ENT_QUOTES, 'UTF-8');
                $return_data['quantity'] = $return_info['quantity'];
                $return_data['reason'] = $return_info['reason'];
                $return_data['opened'] = $return_info['opened'] ? $this->language->get('text_yes') : $this->language->get('text_no');
                $return_data['comment'] = nl2br($return_info['comment']);
                $return_data['action'] = $return_info['action'];

                $return_data['histories'] = array();

                $results = $this->model_account_return->getReturnHistories($return_id);

                foreach ($results as $result) {
                    $return_data['histories'][] = array(
                        'date_added' => date($this->language->get('date_format_short'), strtotime($result['date_added'])),
                        'status'     => $result['status'],
                        'comment'    => nl2br($result['comment'])
                    );
                }
            } else {
                $return_data = array(
                    'error'        => 1 ,
                    'message'    => 'Missing / invalid return_id'
                );
            }

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_data));
        }
    }

    /**
     * Fetches download information
     * @param  json $data contains customer info
     * @return json       returns the download information of a customer
     */
    public function getDownloadInfo()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
          if (isset($post['page']) && $post['page']) {
              $page = $post['page'];
          } else {
              $page = 1;
          }

          if (isset($post['limit']) && $post['limit']) {
              $limit = $post['limit'];
          } else {
              $limit = 10;
          }

            $this->load->model('account/download');

            $this->load->language('account/download');

            $download_data = array();

            $download_total = $this->model_account_download->getTotalDownloads();

            if (!$download_total) {
                $return_array = array(
                    'error'        => 1,
                    'message'    => $this->language->get('text_empty')
                );
            } else {
                $results = $this->model_account_download->getDownloads(($page - 1) * $limit, $limit);

                foreach ($results as $result) {
                    if (file_exists(DIR_DOWNLOAD . $result['filename'])) {
                        $size = filesize(DIR_DOWNLOAD . $result['filename']);

                        $i = 0;

                        $suffix = array('B','KB','MB','GB','TB','PB','EB','ZB','YB');

                        while (($size / 1024) > 1) {
                            $size = $size / 1024;
                            $i++;
                        }

                        $download_info = $this->model_account_download->getDownload($result['download_id']);

                        $file = DIR_DOWNLOAD . $download_info['filename'];
                        $mask = basename($download_info['mask']);

                        $extension = mime_content_type($file);

                        $download_data[] = array(
                            'order_id'   => $result['order_id'],
                            'date_added' => date($this->language->get('date_format_short'), strtotime($result['date_added'])),
                            'name'       => html_entity_decode($result['name'], ENT_QUOTES, 'UTF-8'),
                            'size'       => round(substr($size, 0, strpos($size, '.') + 4), 2) . $suffix[$i],
                            'download_id'=> $result['download_id'],
                            'file'         => $mask,
                            'extension'     => $extension,
                            'url'         => html_entity_decode($this->url->link('api/wkrestapi/customer/downloadProduct', 'customer_id=' . $this->customer->getId() . '&download_id=' . $result['download_id'], 'SSL'),ENT_QUOTES,'UTF-8')
                        );
                    }
                }

                if ($download_data && $download_total) {
                    $return_array = array(
                        'error'                => 0,
                        'downloadData'        => $download_data,
                        'downloadsTotal'    => $download_total
                    );
                } else {
                    $return_array = array(
                        'error'        => 1,
                        'message'    => $this->language->get('text_empty')
                    );
                }
            }

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Fetches recurring history of a customer
     * @param  json $data contains data of customer
     * @return json       returns the recurring data of a customer
     */
    public function getRecurrings()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            if (isset($post['page'])) {
                $page = $post['page'];
            } else {
                $page = 1;
            }

            $this->load->model('account/recurring');

            $this->load->language('account/recurring');

            if (version_compare(VERSION, '2.2.0.0', '>=')) {
                $recurring_total = $this->model_account_recurring->getTotalOrderRecurrings();
            } else {
                $recurring_total = $this->model_account_recurring->getTotalRecurring();
            }

            if (!$recurring_total) {
                $return_array = array(
                    'error'        => 1,
                    'message'    => $this->language->get('text_empty')
                );
            } else {
                if (version_compare(VERSION, '2.2.0.0', '>=')) {
                    $results = $this->model_account_recurring->getOrderRecurrings(($page - 1) * 10, 10);
                } else {
                    $results = $this->model_account_recurring->getAllProfiles(($page - 1) * 10, 10);
                }

                $recurring_data = array();

                if ($results) {
                    foreach ($results as $result) {
                        $recurring_data[] = array(
                            'id'                    => $result['order_recurring_id'],
                            'name'                  => $result['product_name'],
                            'status'                => $result['status'],
                            'date_added'            => date($this->language->get('date_format_short'), strtotime($result['date_added']))
                        );
                    }
                }

                $status_types = array(
                    1 => $this->language->get('text_status_inactive'),
                    2 => $this->language->get('text_status_active'),
                    3 => $this->language->get('text_status_suspended'),
                    4 => $this->language->get('text_status_cancelled'),
                    5 => $this->language->get('text_status_expired'),
                    6 => $this->language->get('text_status_pending'),
                );

                if ($recurring_data && $recurring_total) {
                    $return_array = array(
                        'error'                => 0,
                        'recurringData'        => $recurring_data,
                        'recurringsTotal'    => $recurring_total,
                        'statusTypes'        => $status_types
                    );
                } else {
                    $return_array = array(
                        'error'        => 1
                    );
                }
            }

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Fetches recurring information of particular recurring ID
     * @param  json $data contains recurring ID
     * @return json       returns recurring information
     */
    public function getRecurringInfo()
    {
        $this->load->language('account/api');

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $recurring_id = 0;

            if (isset($post['recurring_id']) && $post['recurring_id']) {
                $recurring_id = $post['recurring_id'];
            }

            $this->load->model('account/recurring');

            $this->load->language('account/recurring');

            $recurring_data = array();

            if (version_compare(VERSION, '2.2.0.0', '>=')) {
                $recurring = $this->model_account_recurring->getOrderRecurring($recurring_id);
            } else {
                $recurring = $this->model_account_recurring->getProfile($recurring_id);
            }

            $status_types = array(
                1 => $this->language->get('text_status_inactive'),
                2 => $this->language->get('text_status_active'),
                3 => $this->language->get('text_status_suspended'),
                4 => $this->language->get('text_status_cancelled'),
                5 => $this->language->get('text_status_expired'),
                6 => $this->language->get('text_status_pending'),
            );

            $transaction_types = array(
                0 => $this->language->get('text_transaction_date_added'),
                1 => $this->language->get('text_transaction_payment'),
                2 => $this->language->get('text_transaction_outstanding_payment'),
                3 => $this->language->get('text_transaction_skipped'),
                4 => $this->language->get('text_transaction_failed'),
                5 => $this->language->get('text_transaction_cancelled'),
                6 => $this->language->get('text_transaction_suspended'),
                7 => $this->language->get('text_transaction_suspended_failed'),
                8 => $this->language->get('text_transaction_outstanding_failed'),
                9 => $this->language->get('text_transaction_expired'),
            );

            if ($recurring) {
                $recurring_data['transactions'] = $this->model_account_recurring->getProfileTransactions($recurring_id);

                $recurring_data['date_added'] = date($this->language->get('date_format_short'), strtotime($recurring['date_added']));
            }

            if ($recurring_data) {
                $return_array = array(
                    'error'                => 0,
                    'recurringInfo'        => $recurring_data,
                    'recurring'            => $recurring,
                    'statusTypes'        => $status_types,
                    'transactionTypes'    => $transaction_types
                );
            } else {
                $return_array = array(
                    'error'        => 1 ,
                    'message'    => 'Missing / invalid recurring_id' ,
                );
            }

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Fetches the newsletter info of a customer
     * @param  json $data contains customer data
     * @return json       return newsletter info of a customer
     */
    public function getNewsletter()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $newsletter = $this->customer->getNewsletter();

            if (isset($newsletter)) {
                $return_array = array(
                    'error'                => 0,
                    'newsletter'        => $newsletter
                );
            } else {
                $return_array = array(
                    'error'        => 1
                );
            }

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Sets the newsletter of a customer
     * @param json $data contains newletter info
     */
    public function setNewsletter()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $newsletter = 0;

            if (isset($post['newsletter']) && $post['newsletter']) {
                $newsletter = $post['newsletter'];
            }

            $this->load->model('account/customer');

            $this->load->language('account/newsletter');

            $this->model_account_customer->editNewsletter($newsletter);

            if (isset($newsletter)) {
                $return_array = array(
                    'error'                => 0,
                    'newsletter'        => $newsletter,
                    'message'            => $this->language->get('text_success')
                );
            } else {
                $return_array = array(
                    'error'        => 1
                );
            }

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Forgot password process
     * @param  json $data contains customer data
     * @return json       returns error if exists
     */
    public function forgotPassword()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            $postData = array();

            foreach ($post as $key => $value) {
                $postData[$key] = $value;
            }

            $this->load->model('wkrestapi/customer');

            //$forgotUpdate = $this->model_wkrestapi_customer->forgotPassword($postData);
            
            $this->load->model('account/customer');
            $this->load->language('account/forgotten');
    
            $error = array();          

            if( isset($postData['email']) && $postData['email'] ){
                $email = $postData['email'];
            }else{
                $email = '';
            }

            if (!isset($email) || empty( $email) ) {
                $error['warning'] = $this->language->get('error_email');
            } elseif (!$this->model_account_customer->getTotalCustomersByEmail($email)) {
                $error['warning'] = $this->language->get('error_email');
            }
    
            if (!$error) {
                $this->load->language('mail/forgotten');
                $code = token(40);
                $this->model_account_customer->editCode($email, $code);
               
                // Add to activity log
                $customer_info = $this->model_account_customer->getCustomerByEmail($email);

                if ($customer_info) {
                    if (version_compare(VERSION,'2.0.0.0','>=')) {
                        $this->load->model('account/activity');
    
                        $activity_data = array(
                            'customer_id' => $customer_info['customer_id'],
                            'name'        => $customer_info['firstname'] . ' ' . $customer_info['lastname']
                        );
    
                        $this->model_account_activity->addActivity('forgotten', $activity_data);
                    }
                }
    
                $return_array = array(
                        'error'				=> 0,
                        'message'			=> $this->language->get('text_success')
                    );

                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));

            }else{
                $return_array = array(
					'error'		=> 1,
					'message'	=> $error['warning']
				);
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
            }
            
           
           
        }
    }

    public function downloadProduct()
    {
        $this->load->language('account/api');

        $this->load->model('wkrestapi/customer');

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        $post = array();

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (isset($this->request->get['download_id'])) {
            $download_id = $this->request->get['download_id'];
        } elseif (isset($this->request->post['download_id'])) {
            $download_id = $this->request->post['download_id'];
        } elseif (isset($post['download_id'])) {
            $download_id = $post['download_id'];
        } else {
            $download_id = 0;
        }

        if (isset($this->request->get['customer_id'])) {
            $customer_id = $this->request->get['customer_id'];
        } elseif (isset($this->request->post['customer_id'])) {
            $customer_id = $this->request->post['customer_id'];
        } elseif (isset($post['customer_id'])) {
            $customer_id = $post['customer_id'];
        } else {
            $customer_id = 0;
        }

        $download_info = $this->model_wkrestapi_customer->getDownload($download_id, $customer_id);

        if ($download_info) {
            $file = DIR_DOWNLOAD . $download_info['filename'];
            $mask = basename($download_info['mask']);

            if (!headers_sent()) {
                if (file_exists($file)) {
                    header('Content-Type: application/octet-stream');
                    header('Content-Disposition: attachment; filename="' . ($mask ? $mask : basename($file)) . '"');
                    header('Expires: 0');
                    header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
                    header('Pragma: public');
                    header('Content-Length: ' . filesize($file));

                    if (ob_get_level()) {
                        ob_end_clean();
                    }

                    readfile($file, 'rb');

                    exit();
                } else {
                    exit('Error: Could not find file ' . $file . '!');
                }
            } else {
                exit('Error: Headers already sent out!');
            }
        } else {
            $return_array = array(
                'error'        => 1,
                'message'    => 'Download Not Available',
            );
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * validates the details passed by the customer
     * @param  array $data contains customer details
     * @return array       returns error array if exist
     */
    private function validateRegister($data)
    {
        $error = array();

        if (isset($data['firstname'])) {
            if ((utf8_strlen(trim($data['firstname'])) < 1) || (utf8_strlen(trim($data['firstname'])) > 32)) {
                $error['firstname'] = $this->language->get('error_firstname');
            }
        } else {
            $error['firstname'] = $this->language->get('error_firstname');
        }

        $this->load->language('account/customerpartner/become_partner');

        if($this->config->get('module_marketplace_status') && $this->config->get('marketplace_becomepartnerregistration') && isset($data['tobecomepartner']) && isset($data['tobecomepartner'])) {
          if(utf8_strlen($data['shoppartner']) <= 3 && (int)$data['tobecomepartner'] == 1) {
              $error['message'] = $this->language->get('error_validshop');
          } else if(utf8_strlen($data['shoppartner']) >1 && (int)$data['tobecomepartner'] == 1) {
              $this->load->model('customerpartner/master');
              if($this->model_customerpartner_master->getShopData($data['shoppartner'])) {
                $error['message'] = $this->language->get('error_noshop');
              }
          }
        }

        if (isset($data['lastname'])) {
            if ((utf8_strlen(trim($data['lastname'])) < 1) || (utf8_strlen(trim($data['lastname'])) > 32)) {
                $error['lastname'] = $this->language->get('error_lastname');
            }
        } else {
            $error['lastname'] = $this->language->get('error_lastname');
        }

        if (isset($data['email'])) {
            if ((utf8_strlen($data['email']) > 96) || !preg_match('/^[^\@]+@.*.[a-z]{2,15}$/i', $data['email'])) {
                $error['email'] = $this->language->get('error_email');
            }

            if ($this->model_account_customer->getTotalCustomersByEmail($data['email'])) {
                $error['warning'] = $this->language->get('error_exists');
            }
        } else {
            $error['email'] = $this->language->get('error_email');
        }

        if (isset($data['telephone'])) {
            if ((utf8_strlen($data['telephone']) < 3) || (utf8_strlen($data['telephone']) > 32)) {
                $error['telephone'] = $this->language->get('error_telephone');
            }
        } else {
            $error['telephone'] = $this->language->get('error_telephone');
        }

        // if (isset($data['address_1'])) {
        //     if ((utf8_strlen(trim($data['address_1'])) < 3) || (utf8_strlen(trim($data['address_1'])) > 128)) {
        //         $error['address_1'] = $this->language->get('error_address_1');
        //     }
        // } else {
        //     $error['address_1'] = $this->language->get('error_address_1');
        // }

        // if (isset($data['city'])) {
        //     if ((utf8_strlen(trim($data['city'])) < 2) || (utf8_strlen(trim($data['city'])) > 128)) {
        //         $error['city'] = $this->language->get('error_city');
        //     }
        // } else {
        //     $error['city'] = $this->language->get('error_city');
        // }

        // $this->load->model('localisation/country');

        // if (isset($data['country_id'])) {
        //     $country_info = $this->model_localisation_country->getCountry($data['country_id']);
        //     if ($data['country_id'] == '') {
        //         $error['country'] = $this->language->get('error_country');
        //     }
        //     if (isset($data['postcode'])) {
        //         if ($country_info && $country_info['postcode_required'] && (utf8_strlen(trim($data['postcode'])) < 2 || utf8_strlen(trim($data['postcode'])) > 10)) {
        //             $error['postcode'] = $this->language->get('error_postcode');
        //         }
        //     } else {
        //         $error['postcode'] = $this->language->get('error_postcode');
        //     }
        // } else {
        //     $error['country'] = $this->language->get('error_country');
        // }

        // if (isset($data['zone_id'])) {
        //     if (!isset($data['zone_id']) || $data['zone_id'] == '' || !is_numeric($data['zone_id'])) {
        //         $error['zone'] = $this->language->get('error_zone');
        //     }
        // } else {
        //     $error['zone'] = $this->language->get('error_zone');
        // }

       // Customer Group

        if (isset($data['customer_group_id']) && is_array($this->config->get('config_customer_group_display')) && in_array($data['customer_group_id'], $this->config->get('config_customer_group_display'))) {
            $customer_group_id = $data['customer_group_id'];
        } else {
            $customer_group_id = $this->config->get('config_customer_group_id');
        }

        // Custom field validation
        // if (version_compare(VERSION,'2.0.0.0','>=')) {
        //      $this->load->model('account/custom_field');

        //     $custom_fields = $this->model_account_custom_field->getCustomFields($customer_group_id);

        //     foreach ($custom_fields as $custom_field) {
        //         if ($custom_field['required'] && empty($data['custom_field'][$custom_field['location']][$custom_field['custom_field_id']])) {
        //             $error['custom_field'][$custom_field['custom_field_id']] = sprintf($this->language->get('error_custom_field'), $custom_field['name']);
        //         }
        //     }
        // }
        if (isset($data['password'])) {
            if ((utf8_strlen($data['password']) < 4) || (utf8_strlen($data['password']) > 20)) {
                $error['password'] = $this->language->get('error_password');
            }
        } else {
            $error['password'] = $this->language->get('error_password');
        }

        // Captcha removed

        // Agree to terms
        if ($this->config->get('config_account_id')) {
            $this->load->model('catalog/information');

            $information_info = $this->model_catalog_information->getInformation($this->config->get('config_account_id'));

            if ($information_info && !isset($data['agree'])) {
                $error['warning'] = sprintf($this->language->get('error_agree'), $information_info['title']);
            }
        }

        if ($error) {
            $error['error'] = 1;
            foreach ($error as $value) {
                $error['message'] = $value;
                break;
            }
        }

        return $error;
    }

    public function checkEmail()
    {
        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
           } else {

               if(!isset($post['email']))
               $post['email'] = '';

               $this->load->model('account/customer');
               if ($this->model_account_customer->getTotalCustomersByEmail($post['email'])) {
                   $return_array = array(
                       'error'        => 1
                   );
                   $this->response->addHeader('Content-Type: application/json');
                   $this->response->setOutput(json_encode($return_array));
               } else {
               $return_array = array(
                       'error'        => 0
                   );
                    $this->response->addHeader('Content-Type: application/json');
                    $this->response->setOutput(json_encode($return_array));
               }
           }
    }


    public function addReturnData()
    {
        $post = $this->request->post;
        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            if(isset($post['order_id']) && isset($post['product_id'])){

               $this->load->model('account/order');

               $order_info = $this->model_account_order->getOrder($post['order_id']);

               $this->load->model('catalog/product');

               $product_info = $this->model_catalog_product->getProduct($post['product_id']);

               $this->load->model('localisation/return_reason');

               $return_reasons = $this->model_localisation_return_reason->getReturnReasons();

               // Captcha
               if ($this->config->get($this->config->get('config_captcha') . '_status') && in_array('return', (array)$this->config->get('config_captcha_page'))) {
                   $captcha = $this->load->controller('extension/captcha/' . $this->config->get('config_captcha'), $this->error);
               } else {
                   $captcha = '';
               }

               if ($this->config->get('config_return_id')) {
                   $this->load->model('catalog/information');
                   $this->load->language('account/return');

                   $information_info = $this->model_catalog_information->getInformation($this->config->get('config_return_id'));

                   if (isset($information_info['description']) && $information_info['description']) {
                     $information_info['description'] = html_entity_decode($information_info['description']);
                   }

                   if ($information_info) {
                       $agreeInfo = array(
                               'text'    => $this->language->get('text_agree'),
                               'data'    => $information_info
                           );
                   } else {
                       $agreeInfo = '';
                   }
               } else {
                   $agreeInfo = '';
               }

               $return_array = array(
                   'error'          => 0,
                   'order_id'       => isset($order_info['order_id']) ? $order_info['order_id'] : '',
                   'date_ordered'   => date('Y-m-d', strtotime(isset($order_info['date_added'])?$order_info['date_added']:'')),
                   'firstname'      => html_entity_decode(isset($order_info['firstname'])?$order_info['firstname']:'', ENT_QUOTES, 'UTF-8'),
                   'lastname'       => html_entity_decode(isset($order_info['lastname'])?$order_info['lastname']:'', ENT_QUOTES, 'UTF-8'),
                   'email'          => isset($order_info['email']) ? $order_info['email'] : '',
                   'telephone'      => isset($order_info['telephone']) ? $order_info['telephone'] : '',
                   'product'        => html_entity_decode($product_info['name'], ENT_QUOTES, 'UTF-8'),
                   'model'          => html_entity_decode($product_info['model'], ENT_QUOTES, 'UTF-8'),
                   'return_reasons' => $return_reasons,
                   'captcha'        => $captcha,
                   'agree'          => $agreeInfo,
               );
               $this->response->addHeader('Content-Type: application/json');
               $this->response->setOutput(json_encode($return_array));
             } else {
               $return_array = array(
                       'error'        => 1
                   );
               $this->response->addHeader('Content-Type: application/json');
               $this->response->setOutput(json_encode($return_array));
           }
        }
    }


     /**
    * send the data for returning the order and product
    * @param  array $post contains order id and product id
    * @return array returns detail of the order
    */

    public function addReturn()
    {
      $this->load->language('account/api');
        $post = $this->request->post;
        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
          $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
          $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
        } else {
            if(isset($post['order_id'])){

                $this->load->model('account/return');
                $this->load->language('account/return');
                $order_id = isset($post['product_id']) ? $post['product_id'] : 0;
                
                $getQuantity = $this->db->query("SELECT quantity FROM ". DB_PREFIX ."order_product WHERE order_id = " .$post['order_id']. " AND product_id = ". $order_id)->row['quantity'];
                $postQuantity = isset($post['quantity']) ? $post['quantity'] : 0;
                if((int)$getQuantity == (int)$postQuantity){
                    $return_id = $this->model_account_return->addReturn($post);
                    if($return_id){
                        // Add to activity log
                        if ($this->config->get('config_customer_activity')) {
                            $this->load->model('account/activity');
    
                            if ($this->customer->isLogged()) {
                                $activity_data = array(
                                    'customer_id' => $this->customer->getId(),
                                    'name'        => $this->customer->getFirstName() . ' ' . $this->customer->getLastName(),
                                    'return_id'   => $return_id
                                );
    
                                $this->model_account_activity->addActivity('return_account', $activity_data);
                            } else {
                                $activity_data = array(
                                    'name'      => $this->request->post['firstname'] . ' ' . $this->request->post['lastname'],
                                    'return_id' => $return_id
                                );
    
                                $this->model_account_activity->addActivity('return_guest', $activity_data);
                            }
                        }
    
                        $return_array = array(
                            'error'        => 0,
                            'message'      => strip_tags($this->language->get('text_message'))
                        );
                    } else {
                        $return_array = array(
                            'error'        => 1,
                            'message'      => $this->language->get('text_verify')
                        );
                    }
                }else{
                    $return_array = array(
                        'error'        => 1,
                        'message'      => 'Not match product ordered quantity'
                    );
                }

               $this->response->addHeader('Content-Type: application/json');
               $this->response->setOutput(json_encode($return_array));
             } else {
               $return_array = array(
                       'error'        => 1,
                       'message'     => $this->language->get('text_order_id_error')
                   );
               $this->response->addHeader('Content-Type: application/json');
               $this->response->setOutput(json_encode($return_array));
           }
        }
    }

    public function addUserProfile(){
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {
            $customer_id = isset($post['customer_id']) ? $post['customer_id'] : '';
            $image = isset($_FILES['image']) ? date("d-m-yy-h:m:s").'_'.$_FILES['image']['name'] : '';
            $banner = isset($_FILES['banner']) ? date("d-m-yy-h:m:s").'_'.$_FILES['banner']['name'] : '';
            $imagetmp = isset($_FILES["image"]["tmp_name"]) ? $_FILES["image"]["tmp_name"] : '';
            $bannertmp = isset($_FILES["banner"]["tmp_name"]) ? $_FILES["banner"]["tmp_name"] : '';
            if (!is_dir( DIR_IMAGE."user")) {
                mkdir(DIR_IMAGE."user");
            }

            $imageType = isset($_FILES["image"]["type"]) ? $_FILES["image"]["type"] : '';
            $bannerType = isset($_FILES["banner"]["type"]) ? $_FILES["banner"]["type"] : '';

            // check image format
            if($imageType && ($imageType != 'image/png' && $imageType != 'image/jpeg')){ 
                $return_array = [
                    'error' => 1,
                    'message' => "Please select JPEG/PNG image"
                ];
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
                return ;
            }

            if($bannerType && ($bannerType != 'image/png' && $bannerType != 'image/jpeg')){
                $return_array = [
                    'error' => 1,
                    'message' => "Please select JPEG/PNG image"
                ];
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
                return;
            }

            $sql = $this->db->query("SELECT * FROM ". DB_PREFIX ."mobikul_customer_image WHERE customer_id='".$customer_id."'");
            
            // delete image from folder when update
            $image_file = isset($sql->row['image'])? DIR_IMAGE . 'user/' .$sql->row['image'] : '';
            $banner_file = isset($sql->row['banner'])? DIR_IMAGE . 'user/' . $sql->row['banner'] : '';
            $files = glob(DIR_IMAGE . 'user/*'); //get all file names
            foreach($files as $file){
                if($image_file == $file){
                    if(is_file($image_file)){
                        unlink($image_file); //delete file
                    }
                }
                if($banner_file == $file){
                    if(is_file($banner_file)){
                        unlink($banner_file); //delete file
                    }
                }
            }

            // upload image in the folder
            $imagepath = DIR_IMAGE . 'user/' .$image;
            $bannerpath = DIR_IMAGE . 'user/' . $banner;
            move_uploaded_file($imagetmp,$imagepath);
            move_uploaded_file($bannertmp,$bannerpath);

            if($sql->num_rows > 0){
                $update_image = $image == '' ? $sql->row['image'] : $image;
                $update_banner = $banner == '' ? $sql->row['banner'] : $banner;
                $query = $this->db->query("UPDATE ". DB_PREFIX ."mobikul_customer_image SET image='".$update_image."', banner='".$update_banner."', date_added=NOW() WHERE customer_id='".$customer_id."'");
            }else{
                $query = $this->db->query("INSERT INTO ". DB_PREFIX ."mobikul_customer_image (customer_id, image, banner, date_added) VALUES(".$customer_id.", '".$image."','".$banner."', NOW())");
            }
            
            if($query){
                $return_array = [
                    'error' => 0,
                    'success' => 1,
                    'message' => $this->language->get('updeted_customer_success')
                ];
            }else{
                $return_array = [
                    'error' => 1,
                    'message' => $this->language->get('updeted_customer_error')
                ];
            }
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        } 
    }

    public function getProductReviews(){
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {
            $this->load->model('wkrestapi/customer');

            $reviews = $this->model_wkrestapi_customer->getProductReviews($this->request->post);

            $this->load->model('tool/image');

            foreach($reviews as $review_index => $review) {
                $reviews[$review_index]['image'] = $this->model_tool_image->resize($review['image'], 200, 200);
            }

            $return_array = [
                'success' => 1,
                'reviews' => $reviews,
                'total'   => $this->model_wkrestapi_customer->getTotalProductReviews($this->request->post)
            ];

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        } 
    }

    // 

    // get all sidebar names
    public function getUserNavigationList(){
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

         //Get wk_token from header
         if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }
        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('error' => 1, 'message' => $this->language->get('text_token_message'))));
        }else{
            $lang = $this->load->language('extension/module/account');              
            $profile_list['my_account'] = $lang['heading_title'];
            $profile_list['edit'] = $lang['text_edit'];
            $profile_list['password'] = $lang['text_password'];
            $profile_list['address'] = $lang['text_address'];
            $profile_list['wishlist'] = $lang['text_wishlist'];
            $profile_list['order'] = $lang['text_order'];
            $profile_list['product_review'] = $lang['text_product_review'];
            $profile_list['download'] = $lang['text_download'];
            if ($this->config->get('total_reward_status')) {
                $profile_list['reward'] = $lang['text_reward'];
            } else {
                $profile_list['reward'] = $lang['text_reward'];
            }		
            $profile_list['return'] = $lang['text_return'];
            $profile_list['transaction'] = $lang['text_transaction'];
            $profile_list['newsletter'] = $lang['text_newsletter'];
            $profile_list['recurring'] = $lang['text_recurring'];

            if(isset($post['customer_id'])){  
                $query = $this->db->query("SELECT * FROM ". DB_PREFIX ."mobikul_customer_image WHERE customer_id='".$post['customer_id']."' order by date_added desc limit 1"  );
                $customer = $this->db->query("SELECT firstname,lastname,email FROM ". DB_PREFIX . "customer WHERE customer_id='".$post['customer_id']."'");

                if($query->num_rows > 0 || $customer->num_rows > 0 ){
                    $c_image = isset($query->row['image']) ? $query->row['image'] : '';
                    $c_banner = isset($query->row['banner']) ? $query->row['banner'] : '';
                    if($c_image != ''){
                        $image = HTTP_SERVER . 'image/user/'.$query->row['image'];
                    }else{
                        $image = '';
                    }

                    if($c_banner != ''){
                        $banner = HTTP_SERVER . 'image/user/'.$query->row['banner'];
                    }else{
                        $banner = '';
                    }
                    $profile_list['banner'] = [
                        'firstname' => $customer->row['firstname'],
                        'lastname' => $customer->row['lastname'],
                        'email' => $customer->row['email'],
                        'image' =>  $image,
                        'banner' => $banner
                    ];
                }
            }
            $profile_list['error'] = 0;
            $profile_list['success'] = 1;
            $profile_list['message'] = "Fetched navigation list successfully";
        
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($profile_list));
        }

    }

    // delete customer image
    public function removeUserImage(){
        $this->load->language('account/api');
        $post = $this->request->post;
        //Accepting data in json format / raw data
        $raw_data = json_decode(file_get_contents("php://input"), true);
        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }
         //Get wk_token from header
         if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }
        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('error' => 1, 'message' => $this->language->get('text_token_message'))));
        }else{
            if(isset($post['customer_id'])){
                $query = $this->db->query("UPDATE " .DB_PREFIX. "mobikul_customer_image SET image='' WHERE customer_id='".$post['customer_id']."'");
                $query = $this->db->countAffected();
                if($query){
                    $return_array = [
                        'success' => 1,
                        'message' => $this->language->get('text_remove_image')
                    ];
                }else{
                    $return_array = [
                        'error' => 1,
                        'message' => $this->language->get('user_not_found')
                    ];
                }
            }else{
                $return_array = [
                    'error' => 1,
                    'message' => $this->language->get('text_profile_error')
                ];
            }
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    // delete customer banner
    public function removeUserBanner(){
        $this->load->language('account/api');
        $post = $this->request->post;
        //Accepting data in json format / raw data
        $raw_data = json_decode(file_get_contents("php://input"), true);
        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }
            //Get wk_token from header
            if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }
        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('error' => 1, 'message' => $this->language->get('text_token_message'))));
        }else{
            if(isset($post['customer_id'])){
                $query = $this->db->query("UPDATE " .DB_PREFIX. "mobikul_customer_image SET banner='' WHERE customer_id='".$post['customer_id']."'");
                $query = $this->db->countAffected();
                if($query){
                    $return_array = [
                        'success' => 1,
                        'message' => $this->language->get('text_remove_banner')
                    ];
                }else{
                    $return_array = [
                        'error' => 1,
                        'message' => $this->language->get('user_not_found')
                    ];
                }
            }else{
                $return_array = [
                    'error' => 1,
                    'message' => $this->language->get('text_profile_error')
                ];
            }
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    // Share wishlist
    public function shareWishlist(){
        $this->load->language('account/api');
        $post = $this->request->post;
        //Accepting data in json format / raw data
        $raw_data = json_decode(file_get_contents("php://input"), true);
        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }
            //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }
        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('error' => 1, 'message' => $this->language->get('text_token_message'))));
        }else{
            if(isset($post['email'])){
                if ($this->customer->isLogged()) {
                    $this->load->model('wkrestapi/catalog');
                    $this->load->model('account/customer');
                    $wishlists = $this->model_wkrestapi_catalog->getDBWishlist();
                    $getCustomer = $this->model_account_customer->getCustomerByEmail(isset($post['email'])?$post['email']:'');
                    $customer_id = isset($getCustomer['customer_id']) ? $getCustomer['customer_id'] : '';
                    if($customer_id){
                        foreach($wishlists as $wishlist){
                            $query = $this->db->query("SELECT * FROM ". DB_PREFIX ."customer_wishlist WHERE customer_id='".$customer_id."' AND product_id='".$wishlist['product_id']."'");
                            if($query->num_rows < 1){
                                $this->db->query("INSERT INTO ". DB_PREFIX ."customer_wishlist SET customer_id='".$customer_id."', product_id='".$wishlist['product_id']."', date_added=NOW()");
                            }
                        }
                        $return_array = [
                            'success' => 1,
                            'message' => $this->language->get('text_shared_wishlist')
                        ];
                    }else{
                        $return_array = [
                            'error' => 1,
                            'message' => $this->language->get('user_not_found')
                        ];
                    }
                }else{
                    $return_array = [
                        'error' => 1,
                        'message' => $this->language->get('text_user_not_login')
                    ];
                }
            }else{
                $return_array = [
                    'error' => 1,
                    'message' => $this->language->get('missing_email_param')
                ];
            }
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    protected function checkSession($session_id)
    {
        if (version_compare(VERSION,'3.0.0.0','>=')) {
			if (isset($this->session->data['session_id']) && $this->session->data['session_id'] == $session_id) {
				return true;
			}
		}else{
			foreach ($_SESSION as $key => $value) {
				if(isset($value['session_id']) && $session_id == $value['session_id']) {
					return true;
				}
			}

			if (isset($_SESSION['session_id']) && $_SESSION['session_id'] == $session_id) {
				return true;
            }
		}
        return false;
    }
}
if (!function_exists('getallheaders')) {
	function getallheaders() {
		$headers = [];
		foreach ($_SERVER as $name => $value) {
			if (substr($name, 0, 5) == 'HTTP_') {
				$headers[str_replace(' ', '-', ucwords(strtolower(str_replace('_', ' ', substr($name, 5)))))] = $value;
			}
		}
		return $headers;
	}
}
if (!function_exists('mime_content_type')) {
	function mime_content_type($file) {
		$image = getimagesize($file);
		return isset($image['mime']) ? $image['mime'] : 'application/octet-stream';
	}
}
