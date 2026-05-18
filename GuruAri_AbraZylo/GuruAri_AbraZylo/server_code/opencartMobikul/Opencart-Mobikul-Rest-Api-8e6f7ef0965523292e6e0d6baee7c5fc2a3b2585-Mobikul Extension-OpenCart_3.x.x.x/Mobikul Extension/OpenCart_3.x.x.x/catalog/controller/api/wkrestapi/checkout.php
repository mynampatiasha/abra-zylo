<?php
class ControllerApiWkrestapiCheckout extends Controller {

	/**
	 * Completes the check process
	 * @param  json $data contains checkout data
	 * @return json       return error if exists
	 */
	public function checkout()	{
		$this->load->language('checkout/checkout');
		$this->load->language('account/api');

		$post = $this->request->post;
		//Accepting data in json format / raw data

		$raw_data = json_decode(file_get_contents("php://input"),true);

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

			$checkoutData = array();

			foreach ($post as $key => $value) {
			    $checkoutData[$key] = $value;
			}

			$redirect = 0;

			// Validate minimum quantity requirements.
			$products = $this->cart->getProducts();

			foreach ($products as $product) {
				$product_total = 0;

				foreach ($products as $product_2) {
					if ($product_2['product_id'] == $product['product_id']) {
						$product_total += $product_2['quantity'];
					}
				}

				if ($product['minimum'] > $product_total) {
					$redirect = 1;
				}
			}

			// Validate cart has products and has stock.
			if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))  || $redirect) {
				$this->response->addHeader('Content-Type: application/json');
				$this->response->setOutput(json_encode(array('redirect'=>'cart','error'=>1)));
			} else {

				// Validate minimum quantity requirements.
				$products = $this->cart->getProducts();

				$temp = 1;

				foreach ($products as $product) {
					$product_total = 0;

					foreach ($products as $product_2) {
						if ($product_2['product_id'] == $product['product_id']) {
							$product_total += $product_2['quantity'];
						}
					}

					if ($product['minimum'] > $product_total) {
						$temp = 0;
						break;
					}
				}

				if ($temp) {

					$this->load->language('checkout/checkout');

					$this->document->setTitle($this->language->get('heading_title'));

					$checkout['heading_title'] = $this->language->get('heading_title');

					$checkout['text_checkout_option'] = sprintf($this->language->get('text_checkout_option'), 1);
					$checkout['text_checkout_account'] = html_entity_decode(sprintf($this->language->get('text_checkout_account'), 2));
					$checkout['text_checkout_payment_address'] = sprintf($this->language->get('text_checkout_payment_address'), 2);
					$checkout['text_checkout_shipping_address'] = sprintf($this->language->get('text_checkout_shipping_address'), 3);
					$checkout['text_checkout_shipping_method'] = sprintf($this->language->get('text_checkout_shipping_method'), 4);
					$checkout['text_checkout_payment_method'] = sprintf($this->language->get('text_checkout_payment_method'), 5);
					$checkout['text_checkout_confirm'] = sprintf($this->language->get('text_checkout_confirm'), 6);

					$logged = $this->customer->isLogged();

					$checkout['shipping_required'] = $shipping_required = $this->cart->hasShipping();

					if (isset($checkoutData['function'])) {
						if ($checkoutData['function'] == 'paymentAddress') { // when payment address is asked and customer is logged in
							if ($logged) {
								$checkout['paymentAddress'] = $this->paymentAddress();
							}
						} elseif ($checkoutData['function'] == 'shippingAddress') { // when shipping address is asked and customer is logged in
							if ($logged) {
								if ($this->cart->hasShipping()) { // checks whether shipping is required on the cart's products
									$checkout['shippingAddress'] = $this->savePaymentAdd($checkoutData);
								} else {
									$checkout['paymentMethods'] = $this->savePaymentAdd($checkoutData);
								}
							}
						}  elseif ($checkoutData['function'] == 'shippingMethod') { // saves shipping address and fetches shipping methods

							if ($logged) {
								$checkout['shippingMethods'] = $this->saveShippingAdd($checkoutData);
							}
						} elseif ($checkoutData['function'] == 'paymentMethod') { // saves shipping method and fetches payment methods
							$checkout['paymentMethods'] = $this->saveShippingMeth($checkoutData);
						} elseif ($checkoutData['function'] == 'confirm') {
							$checkout['continue'] = $this->savePaymentMeth($checkoutData);
						} elseif ($checkoutData['function'] == 'login') { // if not login, logins at checkout page
							if (!$logged) {
								$checkout['paymentAddress'] = $this->saveLogin($checkoutData);
							}
						} elseif ($checkoutData['function'] == 'guest') { // if guest, fetches guest form data
							if (!$logged) {
								$checkout['guest'] = $this->guest();
							}
						} elseif ($checkoutData['function'] == 'saveGuest') { // saves guest and fetches shipping address or payment methods in case of shipping not required
							if (!$logged) {
								if (!empty($checkoutData['shipping_address'])) {
									$checkout['shippingMethods'] = $this->saveGuest($checkoutData);
									$checkout['guestShipping'] = $this->guestShipping();
								} else {
									if ($this->cart->hasShipping()) { // checks whether shipping is required on the cart's products
										if (isset($this->session->data['guest']['shipping_address']) && !isset($checkoutData['shipping_address'])) {
											$checkout['shippingMethods'] = $this->shippingMethods();
										} else {
											$checkout['shippingAddress'] = $this->saveGuest($checkoutData);
										}
									} else {
										$checkout['paymentMethods'] = $this->saveGuest($checkoutData);
									}
								}
							}
						} elseif ($checkoutData['function'] == 'register') { // if registers at checkout page, then provides form data
							if (!$logged) {
								$checkout['register'] = $this->register();
							}
						} elseif ($checkoutData['function'] == 'saveRegister') { // registers a customer and fetches shipping address or payment methods in case of shipping not required
							if (!$logged) {
								if (!empty($checkoutData['shipping_address'])) {
									$checkout['shippingMethods'] = $this->saveRegister($checkoutData, $shipping_required);
									$checkout['shippingAddress'] = $this->shippingAddress();
								} else {
									if ($this->cart->hasShipping()) { // checks whether shipping is required on the cart's products
										$checkout['shippingAddress'] = $this->saveRegister($checkoutData, $shipping_required);
									} else {
										$checkout['paymentMethods'] = $this->saveRegister($checkoutData, $shipping_required);
									}
								}
							}
						} elseif ($checkoutData['function'] == 'saveGuestShipping') { // saves shipping for guest
							if (!$logged) {
								$checkout['shippingMethods'] = $this->saveGuestShipping($checkoutData);
							}
						}
					}

					if (isset($this->session->data['account'])) {
						$checkout['account'] = $this->session->data['account'];
					} else {
						$checkout['account'] = '';
					}

					$checkout['logged'] = $this->customer->isLogged();

					if (version_compare(VERSION,'2.1.0.0','>=')) {
						$cart_count = $this->db->query("SELECT SUM(quantity) as total FROM " . DB_PREFIX . "cart WHERE customer_id = '" . $this->customer->getId() . "' OR (customer_id = '0' AND session_id = '" . $this->session->getId() . "') ")->row;

						if ($checkout['logged']) {
							$checkout['cartCount'] = $cart_count['total'] ? $cart_count['total'] : 0;
						} else {
							$checkout['cartCount'] = $this->cart->countProducts();
						}
					} else {
						$checkout['cartCount'] = $this->cart->countProducts();
					}

					$checkout['currency_code'] = $this->session->data['currency'];
					/**
					 * Returns login form data on checkout page if user not login
					 */
					if (!$logged && empty($checkoutData['function'])) {
						$checkout['login'] = $this->login();
					}

					if ($checkout) {
					$this->response->addHeader('Content-Type: application/json');
					$this->response->setOutput(json_encode($checkout));
					} else {
						$return_array = array(
								'error'		=> 1
							);
						$this->response->addHeader('Content-Type: application/json');
						$this->response->setOutput(json_encode($return_array));
					}

				} else {
					$this->response->addHeader('Content-Type: application/json');
					$this->response->setOutput(json_encode(array('cart'=>0,'error'=>1)));
				}
			}
		}
	}

	/**
	 * Confirms the order
	 * @param  json $data contains order description
	 * @return json       return error if exists
	 */
	public function confirmOrder()	{

		$this->load->language('account/api');

		$post = $this->request->post;

		//Accepting data in json format / raw data

		$raw_data = json_decode(file_get_contents("php://input"),true);

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

			$confirm_data = array();

			foreach ($post as $key => $value) {
			    $confirm_data[$key] = $value;
			}

			$json = array();

			$this->load->model('checkout/order');

			$paymentMethod = isset($this->session->data['payment_method']['code']) ? $this->session->data['payment_method']['code'] : '';

			if ($paymentMethod == 'cod') {

				if (version_compare(VERSION,'3.0.0.0','>=')) {
					$this->model_checkout_order->addOrderHistory($this->session->data['order_id'], $this->config->get('payment_cod_order_status_id'));
				} elseif (version_compare(VERSION,'2.0.0.0','>=')){
					$this->model_checkout_order->addOrderHistory($this->session->data['order_id'], $this->config->get('cod_order_status_id'));
				} else {
					$this->model_checkout_order->confirm($this->session->data['order_id'], $this->config->get('cod_order_status_id'));
				}

			} elseif ($paymentMethod == 'cheque') {

				if (version_compare(VERSION,'2.3.0.0','>=')) {
				  $this->load->language('extension/payment/cheque');
				} else {
				  $this->load->language('payment/cheque');
				}

				$comment  = $this->language->get('text_payable') . "\n";
				$comment .= $this->config->get('cheque_payable') . "\n\n";
				$comment .= $this->language->get('text_address') . "\n";
				$comment .= $this->config->get('config_address') . "\n\n";
				$comment .= $this->language->get('text_payment') . "\n";

				if (version_compare(VERSION,'3.0.0.0','>=')) {
					$this->model_checkout_order->addOrderHistory($this->session->data['order_id'], $this->config->get('payment_cheque_order_status_id'), $comment, true);
				} elseif (version_compare(VERSION,'2.0.0.0','>=')) {
					$this->model_checkout_order->addOrderHistory($this->session->data['order_id'], $this->config->get('cheque_order_status_id'), $comment, true);
				}else{
					$this->model_checkout_order->confirm($this->session->data['order_id'], $this->config->get('cheque_order_status_id'), $comment, true);
				}
			} elseif (substr($paymentMethod,0,5) == 'bank_') {
				if (version_compare(VERSION,'2.3.0.0','>=')) {
				  $this->load->language('extension/payment/'.$this->session->data['payment_method']['code']);
				} else {
				  $this->load->language('payment/'.$this->session->data['payment_method']['code']);
				}

				$comment  = $this->language->get('text_instruction') . "\n\n";
				$comment .= $this->config->get($this->session->data['payment_method']['code'].'_bank' . $this->config->get('config_language_id')) . "\n\n";
				$comment .= $this->language->get('text_payment');

				if (version_compare(VERSION,'3.0.0.0','>=')) {
					$this->model_checkout_order->addOrderHistory($this->session->data['order_id'], $this->config->get('payment_'.$this->session->data['payment_method']['code'].'_order_status_id'), $comment, true);
				}elseif (version_compare(VERSION,'2.0.0.0','>=')){
					$this->model_checkout_order->addOrderHistory($this->session->data['order_id'], $this->config->get($this->session->data['payment_method']['code'].'_order_status_id'), $comment, true);
				}else{
					$this->model_checkout_order->confirm($this->session->data['order_id'], $this->config->get($this->session->data['payment_method']['code'].'_order_status_id'), $comment, true);
				}

			} elseif ($paymentMethod == 'free_checkout') {
				$this->load->model('checkout/order');
				if (version_compare(VERSION,'3.0.0.0','>=')){
					$this->model_checkout_order->addOrderHistory($this->session->data['order_id'], $this->config->get('payment_free_checkout_order_status_id'));
				} elseif (version_compare(VERSION,'2.0.0.0','>=')){
					$this->model_checkout_order->addOrderHistory($this->session->data['order_id'], $this->config->get('free_checkout_order_status_id'));
				}else{
					$this->model_checkout_order->confirm($this->session->data['order_id'], $this->config->get('free_checkout_order_status_id'));
				}
			} elseif ($paymentMethod == 'pp_express') {
               
				if (version_compare(VERSION,'2.3.0.0','>=')) {
					$this->language->load('extension/payment/pp_express');
					$this->load->model('extension/payment/pp_express');
				} else {
					$this->language->load('payment/pp_express');
					$this->load->model('payment/pp_express');
				}


				$this->load->model('checkout/order');

				$order_id = $confirm_data['order_id'];

				if($confirm_data['state']) { 

					if (version_compare(VERSION,'3.0.0.0','>=')) {
						$order_status_id = $this->config->get('payment_pp_express_completed_status_id');
					} else {
						$order_status_id = $this->config->get('pp_express_completed_status_id');
					}

					//add order to paypal table
					$paypal_order_data = array(
						'order_id' => $order_id,
						'capture_status' => ($confirm_data['intent'] == 'sale' ? 'Complete' : 'NotComplete'),
						'currency_code' => $confirm_data['currency_code'],
						'authorization_id' => $confirm_data['id'],
						'total' => $confirm_data['amount'],
					);

					if (version_compare(VERSION,'2.3.0.0','>=')) {
						$paypal_order_id = $this->model_extension_payment_pp_express->addOrder($paypal_order_data);
					} else {
						$paypal_order_id = $this->model_payment_pp_express->addOrder($paypal_order_data);
					}

					//add transaction to paypal transaction table
					$paypal_transaction_data = array(
						'paypal_order_id' => $paypal_order_id,
						'transaction_id' => $confirm_data['id'],
						'parent_transaction_id' => $confirm_data['id'],
						'note' => 'This transaction is made using mobile application',
						'msgsubid' => '',
						'receipt_id' => (isset($confirm_data['PAYMENTINFO_0_RECEIPTID']) ? $confirm_data['PAYMENTINFO_0_RECEIPTID'] : ''),
						'payment_type' => $confirm_data['response_type'],
						'payment_status' => $confirm_data['state'],
						'pending_reason' => '',
						'transaction_entity' => ($this->config->get('pp_express_method') == 'Sale' ? 'payment' : 'auth'),
						'amount' => $confirm_data['amount'],
						'debug_data' => $confirm_data,
					);

					if (version_compare(VERSION,'2.3.0.0','>=')) {
						$this->model_extension_payment_pp_express->addTransaction($paypal_transaction_data);
					} else {
						$this->model_payment_pp_express->addTransaction($paypal_transaction_data);
					}

				} else {
					$json['error'] = 1;
					$json['message'] = 'No approval from the paypal';
				}


					} elseif ($paymentMethod == 'pp_standard') {
						if(!isset($confirm_data['state']) || (int)$confirm_data['state'] != 1) {
							$json['error'] = 1;
							$json['message'] = $this->language->get('text_error_payment');
						}


			} elseif ($paymentMethod == 'pp_pro') {

				$this->load->model('checkout/order');

				$order_id = $confirm_data['order_id'];
				if($confirm_data['state']) {

					if (version_compare(VERSION,'3.0.0.0','>=')) {
						$order_status_id = $this->config->get('pp_pro_order_status_id');
					} else {
						$order_status_id = $this->config->get('payment_pp_pro_order_status_id');
					}

					$this->model_checkout_order->confirm($order_id, $order_status_id);
				} else {
					$json['error'] = 1;
					$json['message'] = 'No approval from the paypal';
				}
			} else {
				$json['error'] = 1;
				$json['message'] = 'Payment method issue';
			}

			if (!$json) {
				
				$language_id = $this->db->query("SELECT `language_id` FROM ".DB_PREFIX."language WHERE `code`='".$this->session->data['language'] . "'")->row['language_id'];
			
				$this->load->controller('api/wkrestapi/customer/sendNotificationForOrderStatus', array("customer_id" => $this->customer->getId(), "order_id" => $this->session->data['order_id'],"language_id" => $language_id));
				$return_array = array('order_id' => $this->session->data['order_id'], 'success' => $this->success(), 'error' => 0);
			} else {
				$return_array = $json;
			}

			$this->response->addHeader('Content-Type: application/json');

			$this->response->setOutput(json_encode($return_array));
		}
	}

	/**
	 * success page after successful payment
	 * @return array returns error if exists
	 */
	protected function success() {
		$this->load->language('checkout/success');

		$order_id = 0;

		if (isset($this->session->data['order_id'])) {
			//Order entry
			$this->load->model('wkrestapi/checkout');
			$this->model_wkrestapi_checkout->addOrder();

			$order_id = $this->session->data['order_id'];

			$this->cart->clear();
			if (version_compare(VERSION,'2.0.0.0','>=')) {
			// Add to activity log
			$this->load->model('account/activity');

				if ($this->customer->isLogged()) {
					$activity_data = array(
						'customer_id' => $this->customer->getId(),
						'name'        => $this->customer->getFirstName() . ' ' . $this->customer->getLastName(),
					);

					$this->model_account_activity->addActivity('order_account', $activity_data);
				} else {
					$activity_data = array(
						'name'     => $this->session->data['guest']['firstname'] . ' ' . $this->session->data['guest']['lastname'],
					);

					$this->model_account_activity->addActivity('order_guest', $activity_data);
				}
			}

			unset($this->session->data['shipping_method']);
			unset($this->session->data['shipping_methods']);
			unset($this->session->data['payment_method']);
			unset($this->session->data['payment_methods']);
			unset($this->session->data['guest']);
			unset($this->session->data['comment']);
			unset($this->session->data['order_id']);
			unset($this->session->data['coupon']);
			unset($this->session->data['reward']);
			unset($this->session->data['voucher']);
			unset($this->session->data['vouchers']);
			unset($this->session->data['totals']);
		}

		$success['heading_title'] = $this->language->get('heading_title');

		if ($this->customer->isLogged()) {
			$success['text_message'] = strip_tags(sprintf($this->language->get('text_customer'), '', '', '', ''));
		} else {
			$success['text_message'] = strip_tags(sprintf($this->language->get('text_guest'), ''));
		}

		$success['button_continue'] = $this->language->get('button_continue');

		return $success;
	}


/**
 * gives a login form to customer on checkout page
 * @return [array] contains the data of login form
 */
	protected function login() {
		$this->load->language('checkout/checkout');

		$checkout['text_checkout_account'] = html_entity_decode(sprintf($this->language->get('text_checkout_account'), 2));
		$checkout['text_checkout_payment_address'] = sprintf($this->language->get('text_checkout_payment_address'), 2);
		$login['text_new_customer'] = $this->language->get('text_new_customer');
		$login['text_returning_customer'] = $this->language->get('text_returning_customer');
		$login['text_checkout'] = $this->language->get('text_checkout');
		$login['text_register'] = $this->language->get('text_register');
		$login['text_guest'] = $this->language->get('text_guest');
		$login['text_i_am_returning_customer'] = $this->language->get('text_i_am_returning_customer');
		$login['text_register_account'] = $this->language->get('text_register_account');
		$login['text_forgotten'] = $this->language->get('text_forgotten');
		$login['text_loading'] = $this->language->get('text_loading');

		$login['entry_email'] = $this->language->get('entry_email');
		$login['entry_password'] = $this->language->get('entry_password');

		$login['button_continue'] = $this->language->get('button_continue');
		$login['button_login'] = $this->language->get('button_login');

		$login['checkout_guest'] = (($this->config->get('config_checkout_guest') || $this->config->get('config_guest_checkout')) && !$this->config->get('config_customer_price') && !$this->cart->hasDownload());

		if (isset($this->session->data['account'])) {
			$login['account'] = $this->session->data['account'];
		} else {
			$login['account'] = 'register';
		}
		return $login;
	}
/**
 * logins a customer on checkout page
 * @param  array $loginData contains login info of a customer
 * @return array            returns payment addresses
 */
	public function saveLogin($loginData) {
		$this->load->language('checkout/checkout');

		$json = array();

		if ($this->customer->isLogged()) {
			$json = array('redirect'=>'checkout','error'=>1);
		}

		if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
			$json = array('redirect'=>'cart','error'=>1);
		}

		if (!$json) {
			$this->load->model('account/customer');

			// Check how many login attempts have been made.
			$login_info = $this->model_account_customer->getLoginAttempts($loginData['email']);

			if ($login_info && ($login_info['total'] >= $this->config->get('config_login_attempts')) && strtotime('-1 hour') < strtotime($login_info['date_modified'])) {
				$json['error'] = $this->language->get('error_attempts');
			}

			// Check if customer has been approved.
			$customer_info = $this->model_account_customer->getCustomerByEmail($loginData['email']);
			if (version_compare(VERSION,'3.0.0.0','<')) {
				if ($customer_info && !$customer_info['approved']) {
					$json['error'] = $this->language->get('error_approved');
				}
			}

			if (!isset($json['error'])) {
				if (!$this->customer->login($loginData['email'], $loginData['password'])) {
					$json['error'] = $this->language->get('error_login');

					$this->model_account_customer->addLoginAttempt($loginData['email']);
				} else {
					$this->model_account_customer->deleteLoginAttempts($loginData['email']);
				}
			}
		}

		if (!$json) {
			unset($this->session->data['guest']);

			$this->load->model('account/address');

			if ($this->config->get('config_tax_customer') == 'payment') {
				$this->session->data['payment_address'] = $this->model_account_address->getAddress($this->customer->getAddressId());
			}

			if ($this->config->get('config_tax_customer') == 'shipping') {
				$this->session->data['shipping_address'] = $this->model_account_address->getAddress($this->customer->getAddressId());
			}
			if (version_compare(VERSION,'2.0.0.0','>=')) {
				// Add to activity log
				$this->load->model('account/activity');

				$activity_data = array(
					'customer_id' => $this->customer->getId(),
					'name'        => $this->customer->getFirstName() . ' ' . $this->customer->getLastName()
				);

				$this->model_account_activity->addActivity('login', $activity_data);
			}
		}

		if ($json) {
			return $json;
		} else {
			return $this->paymentAddress();
		}

	}
/**
 * Provides register form data to customer on checkout page
 * @return array returns the registration form data on checkout page
 */
	protected function register() {
		$this->load->language('checkout/checkout');

		$register['text_checkout_payment_address'] = $this->language->get('text_checkout_payment_address');
		$register['text_your_details'] = $this->language->get('text_your_details');
		$register['text_your_address'] = $this->language->get('text_your_address');
		$register['text_your_password'] = $this->language->get('text_your_password');
		$register['text_select'] = $this->language->get('text_select');
		$register['text_none'] = $this->language->get('text_none');
		$register['text_loading'] = $this->language->get('text_loading');

		$register['entry_customer_group'] = $this->language->get('entry_customer_group');
		$register['entry_firstname'] = $this->language->get('entry_firstname');
		$register['entry_lastname'] = $this->language->get('entry_lastname');
		$register['entry_email'] = $this->language->get('entry_email');
		$register['entry_telephone'] = $this->language->get('entry_telephone');
		$register['entry_fax'] = $this->language->get('entry_fax');
		$register['entry_company'] = $this->language->get('entry_company');
		$register['entry_address_1'] = $this->language->get('entry_address_1');
		$register['entry_address_2'] = $this->language->get('entry_address_2');
		$register['entry_postcode'] = $this->language->get('entry_postcode');
		$register['entry_city'] = $this->language->get('entry_city');
		$register['entry_country'] = $this->language->get('entry_country');
		$register['entry_zone'] = $this->language->get('entry_zone');
		$register['entry_newsletter'] = strip_tags(sprintf($this->language->get('entry_newsletter'), $this->config->get('config_name')));
		$register['entry_password'] = $this->language->get('entry_password');
		$register['entry_confirm'] = $this->language->get('entry_confirm');
		$register['entry_shipping'] = $this->language->get('entry_shipping');

		$register['button_continue'] = $this->language->get('button_continue');
		$register['button_upload'] = $this->language->get('button_upload');

		$register['customer_groups'] = array();

		if (is_array($this->config->get('config_customer_group_display'))) {
			$this->load->model('account/customer_group');

			$customer_groups = $this->model_account_customer_group->getCustomerGroups();

			foreach ($customer_groups  as $customer_group) {
				if (in_array($customer_group['customer_group_id'], $this->config->get('config_customer_group_display'))) {
					$register['customer_groups'][] = $customer_group;
				}
			}
		}

		$register['customer_group_id'] = $this->config->get('config_customer_group_id');

		if (isset($this->session->data['shipping_address']['postcode'])) {
			$register['postcode'] = $this->session->data['shipping_address']['postcode'];
		} else {
			$register['postcode'] = '';
		}

		if (isset($this->session->data['shipping_address']['country_id'])) {
			$register['country_id'] = $this->session->data['shipping_address']['country_id'];
		} else {
			$register['country_id'] = $this->config->get('config_country_id');
		}

		if (isset($this->session->data['shipping_address']['zone_id'])) {
			$register['zone_id'] = $this->session->data['shipping_address']['zone_id'];
		} else {
			$register['zone_id'] = '';
		}

		$this->load->model('wkrestapi/customer');

		$register['countryData'] = $this->model_wkrestapi_customer->getCountryData();

		$register['custom_fields'] = array();

		if (version_compare(VERSION,'2.0.0.0','>=')) {
		// Custom Fields
			$this->load->model('account/custom_field');

			$register['custom_fields'] = $this->model_account_custom_field->getCustomFields();
		}
		if ($this->config->get('config_account_id')) {
			$this->load->model('catalog/information');

			$information_info = $this->model_catalog_information->getInformation($this->config->get('config_account_id'));

			if ($information_info) {
				$register['text_agree'] = strip_tags(sprintf($this->language->get('text_agree'), $this->url->link('information/information/agree', 'information_id=' . $this->config->get('config_account_id'), 'SSL'), $information_info['title'], $information_info['title']));
			} else {
				$register['text_agree'] = '';
			}
		} else {
			$register['text_agree'] = '';
		}

		if ($this->config->get('config_account_id')) {
			$this->load->model('catalog/information');
			$this->load->language('account/register');

			$information_info = $this->model_catalog_information->getInformation($this->config->get('config_account_id'));

			if ($information_info) {
				$agreeInfo = array(
						'text'	=> $this->language->get('text_agree'),
						'data'	=> $information_info
					);
			} else {
				$agreeInfo = '';
			}
		} else {
			$agreeInfo = '';
		}

		$register['agreeInfo'] = $agreeInfo;

		$register['shipping_required'] = $this->cart->hasShipping();
		return $register;
	}
/**
 * registers a customer on checkout page
 * @param  array $registerData contains customer's info used for registration
 * @return array               returns the shipping address or payment methods if shipping is not required
 */
	public function saveRegister($registerData, $shipping_required) {
		$this->load->language('checkout/checkout');

		$json = array();

		// Validate if customer is already logged out.
		if ($this->customer->isLogged()) {
			$json = array('redirect'=>'checkout','error'=>1);
		}

		// Validate cart has products and has stock.
		if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
			$json = array('redirect'=>'cart','error'=>1);
		}

		// Validate minimum quantity requirements.
		$products = $this->cart->getProducts();

		foreach ($products as $product) {
			$product_total = 0;

			foreach ($products as $product_2) {
				if ($product_2['product_id'] == $product['product_id']) {
					$product_total += $product_2['quantity'];
				}
			}

			if ($product['minimum'] > $product_total) {
				$json = array('cart'=>0,'error'=>1);

				break;
			}
		}

		if (!$json) {
			$this->load->model('account/customer');

			if ((utf8_strlen(trim($registerData['firstname'])) < 1) || (utf8_strlen(trim($registerData['firstname'])) > 32)) {
				$json['error']['firstname'] = $this->language->get('error_firstname');
			}

			if ((utf8_strlen(trim($registerData['lastname'])) < 1) || (utf8_strlen(trim($registerData['lastname'])) > 32)) {
				$json['error']['lastname'] = $this->language->get('error_lastname');
			}

			if ((utf8_strlen($registerData['email']) > 96) || !preg_match('/^[^\@]+@.*.[a-z]{2,15}$/i', $registerData['email'])) {
				$json['error']['email'] = $this->language->get('error_email');
			}

			if ($this->model_account_customer->getTotalCustomersByEmail($registerData['email'])) {
				$json['error']['warning'] = $this->language->get('error_exists');
			}

			if ((utf8_strlen($registerData['telephone']) < 3) || (utf8_strlen($registerData['telephone']) > 32)) {
				$json['error']['telephone'] = $this->language->get('error_telephone');
			}

			if ((utf8_strlen(trim($registerData['address_1'])) < 3) || (utf8_strlen(trim($registerData['address_1'])) > 128)) {
				$json['error']['address_1'] = $this->language->get('error_address_1');
			}

			if ((utf8_strlen(trim($registerData['city'])) < 2) || (utf8_strlen(trim($registerData['city'])) > 128)) {
				$json['error']['city'] = $this->language->get('error_city');
			}

			$this->load->model('localisation/country');

			$country_info = $this->model_localisation_country->getCountry($registerData['country_id']);

			if ($country_info && $country_info['postcode_required'] && (utf8_strlen(trim($registerData['postcode'])) < 2 || utf8_strlen(trim($registerData['postcode'])) > 10)) {
				$json['error']['postcode'] = $this->language->get('error_postcode');
			}

			if ($registerData['country_id'] == '') {
				$json['error']['country'] = $this->language->get('error_country');
			}

			if (!isset($registerData['zone_id']) || $registerData['zone_id'] == '') {
				$json['error']['zone'] = $this->language->get('error_zone');
			}

			if ((utf8_strlen($registerData['password']) < 4) || (utf8_strlen($registerData['password']) > 20)) {
				$json['error']['password'] = $this->language->get('error_password');
			}

			if ($registerData['confirm'] != $registerData['password']) {
				$json['error']['confirm'] = $this->language->get('error_confirm');
			}

			if ($this->config->get('config_account_id')) {
				$this->load->model('catalog/information');

				$information_info = $this->model_catalog_information->getInformation($this->config->get('config_account_id'));

				if ($information_info && !isset($registerData['agree'])) {
					$json['error']['warning'] = sprintf($this->language->get('error_agree'), $information_info['title']);
				}
			}

			// Customer Group
			if (isset($registerData['customer_group_id']) && is_array($this->config->get('config_customer_group_display')) && in_array($registerData['customer_group_id'], $this->config->get('config_customer_group_display'))) {
				$customer_group_id = $registerData['customer_group_id'];
			} else {
				$customer_group_id = $this->config->get('config_customer_group_id');
			}
			// if (version_compare(VERSION,'2.0.0.0','>=')) {
			// // Custom field validation
			// 	$this->load->model('account/custom_field');

			// 	$custom_fields = $this->model_account_custom_field->getCustomFields($customer_group_id);

			// 	foreach ($custom_fields as $custom_field) {
			// 		if ($custom_field['required'] && empty($registerData['custom_field'][$custom_field['location']][$custom_field['custom_field_id']])) {
			// 			// $json['error']['custom_field' . $custom_field['custom_field_id']] = sprintf($this->language->get('error_custom_field'), $custom_field['name']);
			// 		}
			// 	}
			// }
		}

		if (!$json) {
			$customer_id = $this->model_account_customer->addCustomer($registerData);

			if (version_compare(VERSION,'3.0.0.0','>=')) {
				$this->load->model('account/address');
				$this->model_account_address->addAddress($customer_id,$registerData);
			}

			// Clear any previous login attempts for unregistered accounts.
			$this->model_account_customer->deleteLoginAttempts($registerData['email']);

			$this->session->data['account'] = 'register';

			$this->load->model('account/customer_group');

			$customer_group_info = $this->model_account_customer_group->getCustomerGroup($customer_group_id);

			if ($customer_group_info && !$customer_group_info['approval']) {
				$this->customer->login($registerData['email'], $registerData['password']);

				// Default Payment Address
				$this->load->model('account/address');

				$this->session->data['payment_address'] = $this->model_account_address->getAddress($this->customer->getAddressId());

				if (!empty($registerData['shipping_address'])) {
					$this->session->data['shipping_address'] = $this->model_account_address->getAddress($this->customer->getAddressId());
				}
			} else {
				$json['redirect'] = $this->url->link('account/success');
			}

			unset($this->session->data['guest']);
			unset($this->session->data['shipping_method']);
			unset($this->session->data['shipping_methods']);
			unset($this->session->data['payment_method']);
			unset($this->session->data['payment_methods']);

			if (version_compare(VERSION,'2.0.0.0','>=')) {
			// Add to activity log
				$this->load->model('account/activity');

				$activity_data = array(
					'customer_id' => $customer_id,
					'name'        => $registerData['firstname'] . ' ' . $registerData['lastname']
				);

				$this->model_account_activity->addActivity('register', $activity_data);
			}
		}

		if ($json) {
			return $json;
		} else {
			/**
			 * if shipping is not required for products in the cart then instead of shipping methods, payment methods will be returned
			 */
			if ($shipping_required) {
				if (!empty($registerData['shipping_address'])) {
					return $this->shippingMethods();
				} else {
					return $this->shippingAddress();
				}
			} else {
				return $this->paymentMethods();
			}
		}
	}
/**
 * provides form for gathering guest user information
 * @return array contains form data content
 */
	protected function guest() {
		$this->load->language('checkout/checkout');

		$guest['text_select'] = $this->language->get('text_select');
		$guest['text_none'] = $this->language->get('text_none');
		$guest['text_your_details'] = $this->language->get('text_your_details');
		$guest['text_your_account'] = $this->language->get('text_your_account');
		$guest['text_your_address'] = $this->language->get('text_your_address');
		$guest['text_loading'] = $this->language->get('text_loading');

		$guest['entry_firstname'] = $this->language->get('entry_firstname');
		$guest['entry_lastname'] = $this->language->get('entry_lastname');
		$guest['entry_email'] = $this->language->get('entry_email');
		$guest['entry_telephone'] = $this->language->get('entry_telephone');
		$guest['entry_fax'] = $this->language->get('entry_fax');
		$guest['entry_company'] = $this->language->get('entry_company');
		$guest['entry_customer_group'] = $this->language->get('entry_customer_group');
		$guest['entry_address_1'] = $this->language->get('entry_address_1');
		$guest['entry_address_2'] = $this->language->get('entry_address_2');
		$guest['entry_postcode'] = $this->language->get('entry_postcode');
		$guest['entry_city'] = $this->language->get('entry_city');
		$guest['entry_country'] = $this->language->get('entry_country');
		$guest['entry_zone'] = $this->language->get('entry_zone');
		$guest['entry_shipping'] = $this->language->get('entry_shipping');

		$guest['button_continue'] = $this->language->get('button_continue');
		$guest['button_upload'] = $this->language->get('button_upload');

		$guest['customer_groups'] = array();

		if (is_array($this->config->get('config_customer_group_display'))) {
			$this->load->model('account/customer_group');

			$customer_groups = $this->model_account_customer_group->getCustomerGroups();

			foreach ($customer_groups as $customer_group) {
				if (in_array($customer_group['customer_group_id'], $this->config->get('config_customer_group_display'))) {
					$guest['customer_groups'][] = $customer_group;
				}
			}
		}

		if (isset($this->session->data['guest']['customer_group_id'])) {
			$guest['customer_group_id'] = $this->session->data['guest']['customer_group_id'];
		} else {
			$guest['customer_group_id'] = $this->config->get('config_customer_group_id');
		}

		if (isset($this->session->data['guest']['firstname'])) {
			$guest['firstname'] = $this->session->data['guest']['firstname'];
		} else {
			$guest['firstname'] = '';
		}

		if (isset($this->session->data['guest']['lastname'])) {
			$guest['lastname'] = $this->session->data['guest']['lastname'];
		} else {
			$guest['lastname'] = '';
		}

		if (isset($this->session->data['guest']['email'])) {
			$guest['email'] = $this->session->data['guest']['email'];
		} else {
			$guest['email'] = '';
		}

		if (isset($this->session->data['guest']['telephone'])) {
			$guest['telephone'] = $this->session->data['guest']['telephone'];
		} else {
			$guest['telephone'] = '';
		}

		if (isset($this->session->data['guest']['fax'])) {
			$guest['fax'] = $this->session->data['guest']['fax'];
		} else {
			$guest['fax'] = '';
		}

		if (isset($this->session->data['payment_address']['company'])) {
			$guest['company'] = $this->session->data['payment_address']['company'];
		} else {
			$guest['company'] = '';
		}

		if (isset($this->session->data['payment_address']['address_1'])) {
			$guest['address_1'] = $this->session->data['payment_address']['address_1'];
		} else {
			$guest['address_1'] = '';
		}

		if (isset($this->session->data['payment_address']['address_2'])) {
			$guest['address_2'] = $this->session->data['payment_address']['address_2'];
		} else {
			$guest['address_2'] = '';
		}

		if (isset($this->session->data['payment_address']['postcode'])) {
			$guest['postcode'] = (string)$this->session->data['payment_address']['postcode'];
		} elseif (isset($this->session->data['shipping_address']['postcode'])) {
			$guest['postcode'] = (string)$this->session->data['shipping_address']['postcode'];
		} else {
			$guest['postcode'] = '';
		}

		if (isset($this->session->data['payment_address']['city'])) {
			$guest['city'] = $this->session->data['payment_address']['city'];
		} else {
			$guest['city'] = '';
		}

		if (isset($this->session->data['payment_address']['country_id'])) {
			$guest['country_id'] = (string)$this->session->data['payment_address']['country_id'];
		} elseif (isset($this->session->data['shipping_address']['country_id'])) {
			$guest['country_id'] = (string)$this->session->data['shipping_address']['country_id'];
		} else {
			$guest['country_id'] = $this->config->get('config_country_id');
		}

		if (isset($this->session->data['payment_address']['zone_id'])) {
			$guest['zone_id'] = (string)$this->session->data['payment_address']['zone_id'];
		} elseif (isset($this->session->data['shipping_address']['zone_id'])) {
			$guest['zone_id'] = (string)$this->session->data['shipping_address']['zone_id'];
		} else {
			$guest['zone_id'] = '';
		}

		$this->load->model('wkrestapi/customer');

		$guest['countryData'] = $this->model_wkrestapi_customer->getCountryData();

		// Custom Fields
		$guest['custom_fields'] = array();
		if (version_compare(VERSION,'2.0.0.0','>=')) {
			$this->load->model('account/custom_field');

			$guest['custom_fields'] = $this->model_account_custom_field->getCustomFields();
		}
		if (isset($this->session->data['guest']['custom_field'])) {
			if (isset($this->session->data['guest']['custom_field'])) {
				$guest_custom_field = $this->session->data['guest']['custom_field'];
			} else {
				$guest_custom_field = array();
			}

			if (isset($this->session->data['payment_address']['custom_field']) && $this->session->data['payment_address']['custom_field']) {
				$address_custom_field = $this->session->data['payment_address']['custom_field'];
			} else {
				$address_custom_field = array();
			}

			$guest['guest_custom_field'] = $guest_custom_field + $address_custom_field;
		} else {
			$guest['guest_custom_field'] = array();
		}

		$guest['shipping_required'] = $this->cart->hasShipping();

		if (isset($this->session->data['guest']['shipping_address'])) {
			$guest['shipping_address'] = $this->session->data['guest']['shipping_address'];
		} else {
			$guest['shipping_address'] = true;
		}

		return $guest;
	}
/**
 * saves guest information
 * @param  array $guestData contains guest data
 * @return array            returns shipping address or payment methods if shipping not required
 */
	public function saveGuest($guestData) {
		$this->load->language('checkout/checkout');

		$json = array();

		// Validate if customer is logged in.
		if ($this->customer->isLogged()) {
			$json = array('redirect'=>'checkout','error'=>1);
		}

		// Validate cart has products and has stock.
		if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
			$json = array('redirect'=>'cart','error'=>1);
		}

		// Check if guest checkout is available.
		if (!($this->config->get('config_checkout_guest') || $this->config->get('config_guest_checkout')) || $this->config->get('config_customer_price') || $this->cart->hasDownload()) {
			$json = array('redirect'=>'checkout','error'=>1);
		}

		if (!$json) {
			if ((utf8_strlen(trim($guestData['firstname'])) < 1) || (utf8_strlen(trim($guestData['firstname'])) > 32)) {
				$json['error']['firstname'] = $this->language->get('error_firstname');
			}

			if ((utf8_strlen(trim($guestData['lastname'])) < 1) || (utf8_strlen(trim($guestData['lastname'])) > 32)) {
				$json['error']['lastname'] = $this->language->get('error_lastname');
			}

			if ((utf8_strlen($guestData['email']) > 96) || !preg_match('/^[^\@]+@.*.[a-z]{2,15}$/i', $guestData['email'])) {
				$json['error']['email'] = $this->language->get('error_email');
			}

			if ((utf8_strlen($guestData['telephone']) < 3) || (utf8_strlen($guestData['telephone']) > 32)) {
				$json['error']['telephone'] = $this->language->get('error_telephone');
			}

			if ((utf8_strlen(trim($guestData['address_1'])) < 3) || (utf8_strlen(trim($guestData['address_1'])) > 128)) {
				$json['error']['address_1'] = $this->language->get('error_address_1');
			}

			if ((utf8_strlen(trim($guestData['city'])) < 2) || (utf8_strlen(trim($guestData['city'])) > 128)) {
				$json['error']['city'] = $this->language->get('error_city');
			}

			if (isset($guestData['custom_field']) && $guestData['custom_field'] && !is_array($guestData['custom_field'])) {
				$guestData['custom_field'] = stripslashes(html_entity_decode($guestData['custom_field']));
				$guestData['custom_field'] = json_decode($guestData['custom_field'],true);
			}

			$this->load->model('localisation/country');

			$country_info = $this->model_localisation_country->getCountry($guestData['country_id']);

			if ($country_info && $country_info['postcode_required'] && (utf8_strlen(trim($guestData['postcode'])) < 2 || utf8_strlen(trim($guestData['postcode'])) > 10)) {
				$json['error']['postcode'] = $this->language->get('error_postcode');
			}

			if ($guestData['country_id'] == '') {
				$json['error']['country'] = $this->language->get('error_country');
			}

			if (!isset($guestData['zone_id']) || $guestData['zone_id'] == '') {
				$json['error']['zone'] = $this->language->get('error_zone');
			}

			// Customer Group
			if (isset($guestData['customer_group_id']) && is_array($this->config->get('config_customer_group_display')) && in_array($guestData['customer_group_id'], $this->config->get('config_customer_group_display'))) {
				$customer_group_id = $guestData['customer_group_id'];
			} else {
				$customer_group_id = $this->config->get('config_customer_group_id');
			}
			// if (version_compare(VERSION,'2.0.0.0','>=')) {
			// // Custom field validation
			// 	$this->load->model('account/custom_field');

			// 	$custom_fields = $this->model_account_custom_field->getCustomFields($customer_group_id);

			// 	foreach ($custom_fields as $custom_field) {
			// 		if ($custom_field['required'] && empty($guestData['custom_field'][$custom_field['location']][$custom_field['custom_field_id']])) {
			// 			// $json['error']['custom_field' . $custom_field['custom_field_id']] = sprintf($this->language->get('error_custom_field'), $custom_field['name']);
			// 		}
			// 	}
			// }
		}

		if (!$json) {
			$this->session->data['account'] = 'guest';

			$this->session->data['guest']['customer_group_id'] = $customer_group_id;
			$this->session->data['guest']['firstname'] = $guestData['firstname'];
			$this->session->data['guest']['lastname'] = $guestData['lastname'];
			$this->session->data['guest']['email'] = $guestData['email'];
			$this->session->data['guest']['telephone'] = $guestData['telephone'];
			$this->session->data['guest']['fax'] = $guestData['fax'];

			if (isset($guestData['custom_field']['account'])) {
				$this->session->data['guest']['custom_field'] = $guestData['custom_field']['account'];
			} else {
				$this->session->data['guest']['custom_field'] = array();
			}

			$this->session->data['payment_address']['firstname'] = $guestData['firstname'];
			$this->session->data['payment_address']['lastname'] = $guestData['lastname'];
			$this->session->data['payment_address']['company'] = $guestData['company'];
			$this->session->data['payment_address']['address_1'] = $guestData['address_1'];
			$this->session->data['payment_address']['address_2'] = $guestData['address_2'];
			$this->session->data['payment_address']['postcode'] = $guestData['postcode'];
			$this->session->data['payment_address']['city'] = $guestData['city'];
			$this->session->data['payment_address']['country_id'] = $guestData['country_id'];
			$this->session->data['payment_address']['zone_id'] = $guestData['zone_id'];

			$this->load->model('localisation/country');

			$country_info = $this->model_localisation_country->getCountry($guestData['country_id']);

			if ($country_info) {
				$this->session->data['payment_address']['country'] = $country_info['name'];
				$this->session->data['payment_address']['iso_code_2'] = $country_info['iso_code_2'];
				$this->session->data['payment_address']['iso_code_3'] = $country_info['iso_code_3'];
				$this->session->data['payment_address']['address_format'] = $country_info['address_format'];
			} else {
				$this->session->data['payment_address']['country'] = '';
				$this->session->data['payment_address']['iso_code_2'] = '';
				$this->session->data['payment_address']['iso_code_3'] = '';
				$this->session->data['payment_address']['address_format'] = '';
			}

			if (isset($guestData['custom_field']['address'])) {
				$this->session->data['payment_address']['custom_field'] = $guestData['custom_field']['address'];
			} else {
				$this->session->data['payment_address']['custom_field'] = array();
			}

			$this->load->model('localisation/zone');

			$zone_info = $this->model_localisation_zone->getZone($guestData['zone_id']);

			if ($zone_info) {
				$this->session->data['payment_address']['zone'] = $zone_info['name'];
				$this->session->data['payment_address']['zone_code'] = $zone_info['code'];
			} else {
				$this->session->data['payment_address']['zone'] = '';
				$this->session->data['payment_address']['zone_code'] = '';
			}

			if (!empty($guestData['shipping_address'])) {
				$this->session->data['guest']['shipping_address'] = $guestData['shipping_address'];
			} else {
				$this->session->data['guest']['shipping_address'] = false;
			}

			// Default Payment Address
			if ($this->session->data['guest']['shipping_address']) {
				$this->session->data['shipping_address']['firstname'] = $guestData['firstname'];
				$this->session->data['shipping_address']['lastname'] = $guestData['lastname'];
				$this->session->data['shipping_address']['company'] = $guestData['company'];
				$this->session->data['shipping_address']['address_1'] = $guestData['address_1'];
				$this->session->data['shipping_address']['address_2'] = $guestData['address_2'];
				$this->session->data['shipping_address']['postcode'] = $guestData['postcode'];
				$this->session->data['shipping_address']['city'] = $guestData['city'];
				$this->session->data['shipping_address']['country_id'] = $guestData['country_id'];
				$this->session->data['shipping_address']['zone_id'] = $guestData['zone_id'];

				if ($country_info) {
					$this->session->data['shipping_address']['country'] = $country_info['name'];
					$this->session->data['shipping_address']['iso_code_2'] = $country_info['iso_code_2'];
					$this->session->data['shipping_address']['iso_code_3'] = $country_info['iso_code_3'];
					$this->session->data['shipping_address']['address_format'] = $country_info['address_format'];
				} else {
					$this->session->data['shipping_address']['country'] = '';
					$this->session->data['shipping_address']['iso_code_2'] = '';
					$this->session->data['shipping_address']['iso_code_3'] = '';
					$this->session->data['shipping_address']['address_format'] = '';
				}

				if ($zone_info) {
					$this->session->data['shipping_address']['zone'] = $zone_info['name'];
					$this->session->data['shipping_address']['zone_code'] = $zone_info['code'];
				} else {
					$this->session->data['shipping_address']['zone'] = '';
					$this->session->data['shipping_address']['zone_code'] = '';
				}

				if (isset($guestData['custom_field']['address'])) {
					$this->session->data['shipping_address']['custom_field'] = $guestData['custom_field']['address'];
				} else {
					$this->session->data['shipping_address']['custom_field'] = array();
				}
			}

			unset($this->session->data['shipping_method']);
			unset($this->session->data['shipping_methods']);
			unset($this->session->data['payment_method']);
			unset($this->session->data['payment_methods']);
		}

		if ($json) {
			return $json;
		} else {
			/**
			 * if shipping is not required for products in the cart then instead of shipping methods, payment methods will be returned
			 */
			if ($this->cart->hasShipping()) {
				if ($this->session->data['guest']['shipping_address']) {
					return $this->shippingMethods();
				} else {
					return $this->guestShipping();
				}
			} else {
				return $this->paymentMethods();
			}
		}
	}
/**
 * Fetches guest shipping form data
 * @return array returns shipping form data
 */
	protected function guestShipping() {

		$this->load->language('checkout/checkout');

		$guestShipping['text_select'] = $this->language->get('text_select');
		$guestShipping['text_none'] = $this->language->get('text_none');
		$guestShipping['text_loading'] = $this->language->get('text_loading');

		$guestShipping['entry_firstname'] = $this->language->get('entry_firstname');
		$guestShipping['entry_lastname'] = $this->language->get('entry_lastname');
		$guestShipping['entry_company'] = $this->language->get('entry_company');
		$guestShipping['entry_address_1'] = $this->language->get('entry_address_1');
		$guestShipping['entry_address_2'] = $this->language->get('entry_address_2');
		$guestShipping['entry_postcode'] = $this->language->get('entry_postcode');
		$guestShipping['entry_city'] = $this->language->get('entry_city');
		$guestShipping['entry_country'] = $this->language->get('entry_country');
		$guestShipping['entry_zone'] = $this->language->get('entry_zone');

		$guestShipping['button_continue'] = $this->language->get('button_continue');
		$guestShipping['button_upload'] = $this->language->get('button_upload');

		if (isset($this->session->data['shipping_address']['firstname'])) {
			$guestShipping['firstname'] = $this->session->data['shipping_address']['firstname'];
		} else {
			$guestShipping['firstname'] = '';
		}

		if (isset($this->session->data['shipping_address']['lastname'])) {
			$guestShipping['lastname'] = $this->session->data['shipping_address']['lastname'];
		} else {
			$guestShipping['lastname'] = '';
		}

		if (isset($this->session->data['shipping_address']['company'])) {
			$guestShipping['company'] = $this->session->data['shipping_address']['company'];
		} else {
			$guestShipping['company'] = '';
		}

		if (isset($this->session->data['shipping_address']['address_1'])) {
			$guestShipping['address_1'] = $this->session->data['shipping_address']['address_1'];
		} else {
			$guestShipping['address_1'] = '';
		}

		if (isset($this->session->data['shipping_address']['address_2'])) {
			$guestShipping['address_2'] = $this->session->data['shipping_address']['address_2'];
		} else {
			$guestShipping['address_2'] = '';
		}

		if (isset($this->session->data['shipping_address']['postcode'])) {
			$guestShipping['postcode'] = $this->session->data['shipping_address']['postcode'];
		} else {
			$guestShipping['postcode'] = '';
		}

		if (isset($this->session->data['shipping_address']['city'])) {
			$guestShipping['city'] = $this->session->data['shipping_address']['city'];
		} else {
			$guestShipping['city'] = '';
		}

		if (isset($this->session->data['shipping_address']['country_id'])) {
			$guestShipping['country_id'] = $this->session->data['shipping_address']['country_id'];
		} else {
			$guestShipping['country_id'] = $this->config->get('config_country_id');
		}

		if (isset($this->session->data['shipping_address']['zone_id'])) {
			$guestShipping['zone_id'] = $this->session->data['shipping_address']['zone_id'];
		} else {
			$guestShipping['zone_id'] = '';
		}

		$this->load->model('wkrestapi/customer');

		$guestShipping['countryData'] = $this->model_wkrestapi_customer->getCountryData();

		$guestShipping['custom_fields'] = array();

		if (version_compare(VERSION,'2.0.0.0','>=')) {
		// Custom Fields
			$this->load->model('account/custom_field');

			$guestShipping['custom_fields'] = $this->model_account_custom_field->getCustomFields($this->session->data['guest']['customer_group_id']);
		}
		if (isset($this->session->data['shipping_address']['custom_field']) && $this->session->data['shipping_address']['custom_field']) {
			$guestShipping['address_custom_field'] = $this->session->data['shipping_address']['custom_field'];
		} else {
			$guestShipping['address_custom_field'] = array();
		}
		return $guestShipping;
	}
/**
 * saves guest shipping details
 * @param  array $guestShippingData contains guest shipping data
 * @return array                    returns shipping methods
 */
	protected function saveGuestShipping($guestShippingData) {
		$this->load->language('checkout/checkout');

		$json = array();

		// Validate if customer is logged in.
		if ($this->customer->isLogged()) {
			$json = array('redirect'=>'checkout','error'=>1);
		}

		// Validate cart has products and has stock.
		if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
			$json = array('redirect'=>'cart','error'=>1);
		}

		// Check if guest checkout is available.
		if (!($this->config->get('config_checkout_guest') || $this->config->get('config_guest_checkout')) || $this->config->get('config_customer_price') || $this->cart->hasDownload()) {
			$json = array('redirect'=>'checkout','error'=>1);
		}

		if (!$json) {
			if ((utf8_strlen(trim($guestShippingData['firstname'])) < 1) || (utf8_strlen(trim($guestShippingData['firstname'])) > 32)) {
				$json['error']['firstname'] = $this->language->get('error_firstname');
			}

			if ((utf8_strlen(trim($guestShippingData['lastname'])) < 1) || (utf8_strlen(trim($guestShippingData['lastname'])) > 32)) {
				$json['error']['lastname'] = $this->language->get('error_lastname');
			}

			if ((utf8_strlen(trim($guestShippingData['address_1'])) < 3) || (utf8_strlen(trim($guestShippingData['address_1'])) > 128)) {
				$json['error']['address_1'] = $this->language->get('error_address_1');
			}

			if ((utf8_strlen(trim($guestShippingData['city'])) < 2) || (utf8_strlen(trim($guestShippingData['city'])) > 128)) {
				$json['error']['city'] = $this->language->get('error_city');
			}

			$this->load->model('localisation/country');

			$country_info = $this->model_localisation_country->getCountry($guestShippingData['country_id']);

			if ($country_info && $country_info['postcode_required'] && (utf8_strlen(trim($guestShippingData['postcode'])) < 2 || utf8_strlen(trim($guestShippingData['postcode'])) > 10)) {
				$json['error']['postcode'] = $this->language->get('error_postcode');
			}

			if ($guestShippingData['country_id'] == '') {
				$json['error']['country'] = $this->language->get('error_country');
			}

			if (!isset($guestShippingData['zone_id']) || $guestShippingData['zone_id'] == '') {
				$json['error']['zone'] = $this->language->get('error_zone');
			}

			// if (version_compare(VERSION,'2.0.0.0','>=')) {
			// // Custom field validation
			// 	$this->load->model('account/custom_field');

			// 	$custom_fields = $this->model_account_custom_field->getCustomFields($this->session->data['guest']['customer_group_id']);

			// 	foreach ($custom_fields as $custom_field) {
			// 		if (($custom_field['location'] == 'address') && $custom_field['required'] && empty($guestShippingData['custom_field'][$custom_field['custom_field_id']])) {
			// 			// $json['error']['custom_field' . $custom_field['custom_field_id']] = sprintf($this->language->get('error_custom_field'), $custom_field['name']);
			// 		}
			// 	}
			// }
		}

		if (!$json) {
			$this->session->data['shipping_address']['firstname'] = $guestShippingData['firstname'];
			$this->session->data['shipping_address']['lastname'] = $guestShippingData['lastname'];
			$this->session->data['shipping_address']['company'] = $guestShippingData['company'];
			$this->session->data['shipping_address']['address_1'] = $guestShippingData['address_1'];
			$this->session->data['shipping_address']['address_2'] = $guestShippingData['address_2'];
			$this->session->data['shipping_address']['postcode'] = $guestShippingData['postcode'];
			$this->session->data['shipping_address']['city'] = $guestShippingData['city'];
			$this->session->data['shipping_address']['country_id'] = $guestShippingData['country_id'];
			$this->session->data['shipping_address']['zone_id'] = $guestShippingData['zone_id'];

			$this->load->model('localisation/country');

			$country_info = $this->model_localisation_country->getCountry($guestShippingData['country_id']);

			if ($country_info) {
				$this->session->data['shipping_address']['country'] = $country_info['name'];
				$this->session->data['shipping_address']['iso_code_2'] = $country_info['iso_code_2'];
				$this->session->data['shipping_address']['iso_code_3'] = $country_info['iso_code_3'];
				$this->session->data['shipping_address']['address_format'] = $country_info['address_format'];
			} else {
				$this->session->data['shipping_address']['country'] = '';
				$this->session->data['shipping_address']['iso_code_2'] = '';
				$this->session->data['shipping_address']['iso_code_3'] = '';
				$this->session->data['shipping_address']['address_format'] = '';
			}

			$this->load->model('localisation/zone');

			$zone_info = $this->model_localisation_zone->getZone($guestShippingData['zone_id']);

			if ($zone_info) {
				$this->session->data['shipping_address']['zone'] = $zone_info['name'];
				$this->session->data['shipping_address']['zone_code'] = $zone_info['code'];
			} else {
				$this->session->data['shipping_address']['zone'] = '';
				$this->session->data['shipping_address']['zone_code'] = '';
			}

			if (isset($guestShippingData['custom_field'])) {
				$this->session->data['shipping_address']['custom_field'] = $guestShippingData['custom_field'];
			} else {
				$this->session->data['shipping_address']['custom_field'] = array();
			}

			unset($this->session->data['shipping_method']);
			unset($this->session->data['shipping_methods']);
		}

		if ($json) {
			return $json;
		} else {
			return $this->shippingMethods();
		}
	}
/**
 * Formats the address
 * @return array contains formatted addresses
 */
	protected function addresses() {

		$this->load->model('account/address');

		$addresses = $this->model_account_address->getAddresses();

		$addressData = array();

		foreach ($addresses as $address) {

			foreach($address as $fkey => $fvalue) {
				if(isset($address[$fkey]) && !is_array($address[$fkey]))
			  $address[$fkey] = html_entity_decode($address[$fkey],ENT_QUOTES,'UTF-8');
			}

			if (empty($address['custom_field'])) {
				$address['custom_field'] = array();
			} else {
				$custom = $address['custom_field'];
				$address['custom_field'] = array();
				foreach($custom as $key => $value ) {
					$address['custom_field'][] = array(
						'id' => $key,
						'value' => $value
					);
				}
			}

			$addressData[] = array(
					'address_id'	=> $address['address_id'],
					'formatted'		=> html_entity_decode($address['firstname']. ' ' .$address['lastname']. ', ' .$address['address_1']. ', ' .$address['city']. ', ' .$address['zone']. ', ' .$address['country']),
					'address'		=> $address
				);
		}
		return $addressData;
	}
/**
 * Fetches all the payment addresses
 * @return array returns all the payment addresses
 */
	protected function paymentAddress()	{

		$this->load->language('checkout/checkout');

		$paymentAddress['text_address_existing'] = $this->language->get('text_address_existing');
		$paymentAddress['text_address_new'] = $this->language->get('text_address_new');
		$paymentAddress['text_select'] = $this->language->get('text_select');
		$paymentAddress['text_none'] = $this->language->get('text_none');
		$paymentAddress['text_loading'] = $this->language->get('text_loading');

		$paymentAddress['entry_firstname'] = $this->language->get('entry_firstname');
		$paymentAddress['entry_lastname'] = $this->language->get('entry_lastname');
		$paymentAddress['entry_company'] = $this->language->get('entry_company');
		$paymentAddress['entry_address_1'] = $this->language->get('entry_address_1');
		$paymentAddress['entry_address_2'] = $this->language->get('entry_address_2');
		$paymentAddress['entry_postcode'] = $this->language->get('entry_postcode');
		$paymentAddress['entry_city'] = $this->language->get('entry_city');
		$paymentAddress['entry_country'] = $this->language->get('entry_country');
		$paymentAddress['entry_zone'] = $this->language->get('entry_zone');

		$paymentAddress['button_continue'] = $this->language->get('button_continue');
		$paymentAddress['button_upload'] = $this->language->get('button_upload');

		if (isset($this->session->data['payment_address']['address_id'])) {
			$paymentAddress['address_id'] = $this->session->data['payment_address']['address_id'];
		} else {
			$paymentAddress['address_id'] = $this->customer->getAddressId();
		}

		$paymentAddress['addresses'] = $this->addresses();

		if (isset($this->session->data['payment_address']['country_id'])) {
			$paymentAddress['country_id'] = $this->session->data['payment_address']['country_id'];
		} else {
			$paymentAddress['country_id'] = $this->config->get('config_country_id');
		}

		if (isset($this->session->data['payment_address']['zone_id'])) {
			$paymentAddress['zone_id'] = $this->session->data['payment_address']['zone_id'];
		} else {
			$paymentAddress['zone_id'] = '';
		}

		$this->load->model('wkrestapi/customer');

		$paymentAddress['countryData'] = $this->model_wkrestapi_customer->getCountryData();
		if ($this->customer->getId()) {
			$paymentAddress['login_data'] = array(
						'customer_id'		=> $this->customer->getId(),
						'firstname'			=> html_entity_decode($this->customer->getFirstName(),ENT_QUOTES,'UTF-8'),
						'lastname'			=> html_entity_decode($this->customer->getLastName(),ENT_QUOTES,'UTF-8'),
						'email'				=> $this->customer->getEmail(),
						'phone'				=> $this->customer->getTelephone(),
						'cart_total'		=> ($this->cart->countProducts())
					);
		} else {
			$paymentAddress['login_data'] = array();
		}
		$paymentAddress['payment_address_custom_field'] = array();
		$paymentAddress['custom_fields']= array();
		if (version_compare(VERSION,'2.0.0.0','>=')) {
		// Custom Fields
			$this->load->model('account/custom_field');

			$paymentAddress['custom_fields'] = $this->model_account_custom_field->getCustomFields($this->config->get('config_customer_group_id'));
		}

		if (isset($this->session->data['payment_address']['custom_field']) && $this->session->data['payment_address']['custom_field']) {
			$custom = $this->session->data['payment_address']['custom_field'];
			foreach($custom as $key => $value ) {
				$paymentAddress['payment_address_custom_field'][] = array(
					'id' => $key,
					'value' => $value
				);
			}
		}

		if (isset($this->session->data['customer_id']) && $this->session->data['customer_id']) {
			$paymentAddress['login_data'] = array(
					'customer_id'		=> $this->customer->getId(),
					'firstname'			=> html_entity_decode($this->customer->getFirstName(),ENT_QUOTES,'UTF-8'),
					'lastname'			=> html_entity_decode($this->customer->getLastName(),ENT_QUOTES,'UTF-8'),
					'email'				=> $this->customer->getEmail(),
					'phone'				=> $this->customer->getTelephone()
				);
		}

		return $paymentAddress;
	}
/**
 * saves the payment method
 * @param  array $postData contains payment address ID
 * @return array           returns the shipping addresses data
 */
	protected function savePaymentAdd($postData) {

		$this->load->language('checkout/checkout');

		$json = array();

		// Validate cart has products and has stock.
		if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
			$json = array('redirect'=>'cart','error'=>1);
		}

		// Validate minimum quantity requirements.
		$products = $this->cart->getProducts();


		foreach ($products as $product) {
			$product_total = 0;

			foreach ($products as $product_2) {
				if ($product_2['product_id'] == $product['product_id']) {
					$product_total += $product_2['quantity'];
				}
			}

			if ($product['minimum'] > $product_total) {
				$json = array('cart'=>0,'error'=>1);

				break;
			}
		}

		if (!$json) {
			if (isset($postData['payment_address']) && $postData['payment_address'] == 'existing') {
				$this->load->model('account/address');

				if (empty($postData['address_id'])) {
					$json['error']['warning'] = $this->language->get('error_address');
				} elseif (!in_array($postData['address_id'], array_keys($this->model_account_address->getAddresses()))) {
					$json['error']['warning'] = $this->language->get('error_address');
				}

				if (!$json) {
					// Default Payment Address
					$this->load->model('account/address');

					$this->session->data['payment_address'] = $this->model_account_address->getAddress($postData['address_id']);

					unset($this->session->data['payment_method']);
					unset($this->session->data['payment_methods']);
				}
			} else {
				if ((utf8_strlen(trim($postData['firstname'])) < 1) || (utf8_strlen(trim($postData['firstname'])) > 32)) {
					$json['error']['firstname'] = $this->language->get('error_firstname');
				}

				if ((utf8_strlen(trim($postData['lastname'])) < 1) || (utf8_strlen(trim($postData['lastname'])) > 32)) {
					$json['error']['lastname'] = $this->language->get('error_lastname');
				}

				if ((utf8_strlen(trim($postData['address_1'])) < 3) || (utf8_strlen(trim($postData['address_1'])) > 128)) {
					$json['error']['address_1'] = $this->language->get('error_address_1');
				}

				if ((utf8_strlen($postData['city']) < 2) || (utf8_strlen($postData['city']) > 32)) {
					$json['error']['city'] = $this->language->get('error_city');
				}

				$this->load->model('localisation/country');

				$country_info = $this->model_localisation_country->getCountry($postData['country_id']);

				if ($country_info && $country_info['postcode_required'] && (utf8_strlen(trim($postData['postcode'])) < 2 || utf8_strlen(trim($postData['postcode'])) > 10)) {
					$json['error']['postcode'] = $this->language->get('error_postcode');
				}

				if ($postData['country_id'] == '') {
					$json['error']['country'] = $this->language->get('error_country');
				}

				if (!isset($postData['zone_id']) || $postData['zone_id'] == '') {
					$json['error']['zone'] = $this->language->get('error_zone');
				}

				// Custom field validation
				// $this->load->model('account/custom_field');

				// $custom_fields = $this->model_account_custom_field->getCustomFields($this->config->get('config_customer_group_id'));

				// foreach ($custom_fields as $custom_field) {
				// 	if (($custom_field['location'] == 'address') && $custom_field['required'] && empty($postData['custom_field'][$custom_field['custom_field_id']])) {
				// 		$json['error']['custom_field' . $custom_field['custom_field_id']] = sprintf($this->language->get('error_custom_field'), $custom_field['name']);
				// 	}
				// }

				if (!$json) {
					// Default Payment Address
					$this->load->model('account/address');

					if (version_compare(VERSION,'3.0.0.0','>=')) {
						$address_id = $this->model_account_address->addAddress($this->customer->getId(),$postData);
					}else{
						$address_id = $this->model_account_address->addAddress($postData);
					}

					$this->session->data['payment_address'] = $this->model_account_address->getAddress($address_id);

					unset($this->session->data['payment_method']);
					unset($this->session->data['payment_methods']);

					if (version_compare(VERSION,'2.0.0.0','>=')) {
						$this->load->model('account/activity');

						$activity_data = array(
							'customer_id' => $this->customer->getId(),
							'name'        => $this->customer->getFirstName() . ' ' . $this->customer->getLastName()
						);

						$this->model_account_activity->addActivity('address_add', $activity_data);
					}
				}
			}
		}
		if($json)
			return $json;
		else {
			if ($this->cart->hasShipping()) {
				return $this->shippingAddress();
			} else {
				return $this->paymentMethods();
			}
		}
	}
/**
 * Fetches all the shipping addresses
 * @return array returns the shipping addresses
 */
	protected function shippingAddress() {
		$this->load->language('checkout/checkout');

		$shippingAddress['text_address_existing'] = $this->language->get('text_address_existing');
		$shippingAddress['text_address_new'] = $this->language->get('text_address_new');
		$shippingAddress['text_select'] = $this->language->get('text_select');
		$shippingAddress['text_none'] = $this->language->get('text_none');
		$shippingAddress['text_loading'] = $this->language->get('text_loading');

		$shippingAddress['entry_firstname'] = $this->language->get('entry_firstname');
		$shippingAddress['entry_lastname'] = $this->language->get('entry_lastname');
		$shippingAddress['entry_company'] = $this->language->get('entry_company');
		$shippingAddress['entry_address_1'] = $this->language->get('entry_address_1');
		$shippingAddress['entry_address_2'] = $this->language->get('entry_address_2');
		$shippingAddress['entry_postcode'] = $this->language->get('entry_postcode');
		$shippingAddress['entry_city'] = $this->language->get('entry_city');
		$shippingAddress['entry_country'] = $this->language->get('entry_country');
		$shippingAddress['entry_zone'] = $this->language->get('entry_zone');

		$shippingAddress['button_continue'] = $this->language->get('button_continue');
		$shippingAddress['button_upload'] = $this->language->get('button_upload');

		if (isset($this->session->data['shipping_address']['address_id'])) {
			$shippingAddress['address_id'] = $this->session->data['shipping_address']['address_id'];
		} else {
			$shippingAddress['address_id'] = $this->customer->getAddressId();
		}

		$shippingAddress['addresses'] = $this->addresses();

		if (isset($this->session->data['shipping_address']['postcode'])) {
			$shippingAddress['postcode'] = $this->session->data['shipping_address']['postcode'];
		} else {
			$shippingAddress['postcode'] = '';
		}

		if (isset($this->session->data['shipping_address']['country_id'])) {
			$shippingAddress['country_id'] = $this->session->data['shipping_address']['country_id'];
		} else {
			$shippingAddress['country_id'] = $this->config->get('config_country_id');
		}

		if (isset($this->session->data['shipping_address']['zone_id'])) {
			$shippingAddress['zone_id'] = $this->session->data['shipping_address']['zone_id'];
		} else {
			$shippingAddress['zone_id'] = '';
		}

		$this->load->model('wkrestapi/customer');

		$shippingAddress['countryData'] = $this->model_wkrestapi_customer->getCountryData();
		$shippingAddress['shipping_address_custom_field'] = array();
		$shippingAddress['custom_fields']  = array();
		if (version_compare(VERSION,'2.0.0.0','>=')) {
		// Custom Fields
			$this->load->model('account/custom_field');

			$shippingAddress['custom_fields'] = $this->model_account_custom_field->getCustomFields($this->config->get('config_customer_group_id'));
		}
		if (isset($this->session->data['shipping_address']['custom_field']) && $this->session->data['shipping_address']['custom_field']) {
			$custom = $this->session->data['shipping_address']['custom_field'];
			foreach($custom as $key => $value ) {
				$shippingAddress['shipping_address_custom_field'][] = array(
					'id' => $key,
					'value' => $value
				);
			}
		} else {
			$shippingAddress['shipping_address_custom_field'] = array();
		}
		return $shippingAddress;
	}
/**
 * saves the shipping address on checkout page
 * @param  array $shippingData contains shipping data
 * @return array               returns shipping methods
 */
	protected function saveShippingAdd($shippingData) {

		$this->load->language('checkout/checkout');

		$json = array();

		// Validate if shipping is required. If not the customer should not have reached this page.
		if (!$this->cart->hasShipping()) {
			$json = array('cart'=>0,'error'=>1);
		}

		// Validate cart has products and has stock.
		if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
			$json = array('redirect'=>'cart','error'=>1);
		}

		// Validate minimum quantity requirements.
		$products = $this->cart->getProducts();

		foreach ($products as $product) {
			$product_total = 0;

			foreach ($products as $product_2) {
				if ($product_2['product_id'] == $product['product_id']) {
					$product_total += $product_2['quantity'];
				}
			}

			if ($product['minimum'] > $product_total) {
				$json = array('cart'=>0,'error'=>1);

				break;
			}
		}

		if (!$json) {
			if (isset($shippingData['shipping_address']) && $shippingData['shipping_address'] == 'existing') {
				$this->load->model('account/address');

				if (empty($shippingData['address_id'])) {
					$json['error']['warning'] = $this->language->get('error_address');
				} elseif (!in_array($shippingData['address_id'], array_keys($this->model_account_address->getAddresses()))) {
					$json['error']['warning'] = $this->language->get('error_address');
				}

				if (!$json) {
					// Default Shipping Address
					$this->load->model('account/address');

					$this->session->data['shipping_address'] = $this->model_account_address->getAddress($shippingData['address_id']);

					unset($this->session->data['shipping_method']);
					unset($this->session->data['shipping_methods']);
				}

			} else {
				if ((utf8_strlen(trim($shippingData['firstname'])) < 1) || (utf8_strlen(trim($shippingData['firstname'])) > 32)) {
					$json['error']['firstname'] = $this->language->get('error_firstname');
				}

				if ((utf8_strlen(trim($shippingData['lastname'])) < 1) || (utf8_strlen(trim($shippingData['lastname'])) > 32)) {
					$json['error']['lastname'] = $this->language->get('error_lastname');
				}

				if ((utf8_strlen(trim($shippingData['address_1'])) < 3) || (utf8_strlen(trim($shippingData['address_1'])) > 128)) {
					$json['error']['address_1'] = $this->language->get('error_address_1');
				}

				if ((utf8_strlen(trim($shippingData['city'])) < 2) || (utf8_strlen(trim($shippingData['city'])) > 128)) {
					$json['error']['city'] = $this->language->get('error_city');
				}

				$this->load->model('localisation/country');

				$country_info = $this->model_localisation_country->getCountry($shippingData['country_id']);

				if ($country_info && $country_info['postcode_required'] && (utf8_strlen(trim($shippingData['postcode'])) < 2 || utf8_strlen(trim($shippingData['postcode'])) > 10)) {
					$json['error']['postcode'] = $this->language->get('error_postcode');
				}

				if ($shippingData['country_id'] == '') {
					$json['error']['country'] = $this->language->get('error_country');
				}

				if (!isset($shippingData['zone_id']) || $shippingData['zone_id'] == '') {
					$json['error']['zone'] = $this->language->get('error_zone');
				}

				// Custom field validation
				// $this->load->model('account/custom_field');

				// $custom_fields = $this->model_account_custom_field->getCustomFields($this->config->get('config_customer_group_id'));

				// foreach ($custom_fields as $custom_field) {
				// 	if (($custom_field['location'] == 'address') && $custom_field['required'] && empty($shippingData['custom_field'][$custom_field['custom_field_id']])) {
				// 		$json['error']['custom_field' . $custom_field['custom_field_id']] = sprintf($this->language->get('error_custom_field'), $custom_field['name']);
				// 	}
				// }

				if (!$json) {
					// Default Shipping Address
					$this->load->model('account/address');

					if (version_compare(VERSION,'3.0.0.0','>=')) {
						$address_id = $this->model_account_address->addAddress($this->customer->getId(),$shippingData);
					}else{
						$address_id = $this->model_account_address->addAddress($shippingData);
					}

					$this->session->data['shipping_address'] = $this->model_account_address->getAddress($address_id);

					unset($this->session->data['shipping_method']);
					unset($this->session->data['shipping_methods']);
					if (version_compare(VERSION,'2.0.0.0','>=')) {
						$this->load->model('account/activity');

						$activity_data = array(
							'customer_id' => $this->customer->getId(),
							'name'        => $this->customer->getFirstName() . ' ' . $this->customer->getLastName()
						);

						$this->model_account_activity->addActivity('address_add', $activity_data);
					}
				}
			}

		}
		if($json)
			return $json;
		else {
			return $this->shippingMethods();
		}
	}
/**
 * Fetches the shipping methods
 * @return array returns the shipping methods
 */
	public function shippingMethods() {

		$shipping_data = array();

		$this->load->language('checkout/checkout');

		if (isset($this->session->data['shipping_address'])) {
			// Shipping Methods
			$method_data = array();

			if (version_compare(VERSION,'3.0.0.0','>=') || version_compare(VERSION,'2.0.0.0','<')) {
				$this->load->model('setting/extension');
			}else{
				$this->load->model('extension/extension');
			}


			if (version_compare(VERSION,'3.0.0.0','>=') || version_compare(VERSION,'2.0.0.0','<')) {
				$results = $this->model_setting_extension->getExtensions('shipping');
			}else{
			$results = $this->model_extension_extension->getExtensions('shipping');

			}

			foreach ($results as $result) {

				if (version_compare(VERSION,'3.0.0.0','>=')) {
					$total_name = 'shipping_' .$result['code'] . '_status';
				}
				else{
					$total_name = $result['code'] . '_status';
				}

				if ($this->config->get('module_mobikul_shipping') && !in_array($result['code'],$this->config->get('module_mobikul_shipping'))) {
				  $display_status = false;
				} else {
				  $display_status = true;
				}

				if ($this->config->get($total_name) && $display_status) {
					if (version_compare(VERSION,'2.3.0.0','>=')) {
						$this->load->model('extension/shipping/' . $result['code']);

						$quote = $this->{'model_extension_shipping_' . $result['code']}->getQuote($this->session->data['shipping_address']);
					} else {
						$this->load->model('shipping/' . $result['code']);

						$quote = $this->{'model_shipping_' . $result['code']}->getQuote($this->session->data['shipping_address']);
					}


					if ($quote) {
						$quote_array = array();

						if (isset($quote['quote']) && $quote['quote']) {
							foreach ($quote['quote'] as $key => $value) {
								$quote_array[] = $value;
							}
						}

						$method_data[] = array(
							'title'      => $quote['title'],
							'quote'      => $quote_array,
							'sort_order' => $quote['sort_order'],
							'error'      => $quote['error']
						);
					}

					if ($quote) {
						$shipping_data[$result['code']] = array(
							'title'      => $quote['title'],
							'quote'      => $quote['quote'],
							'sort_order' => $quote['sort_order'],
							'error'      => $quote['error']
						);
					}
				}
			}


			$sort_order = array();

			foreach ($method_data as $key => $value) {
				if (isset($value['sort_order'])) {
					$sort_order[$key] = $value['sort_order'];
				} else {
					$sort_order[$key] = 1;
				}
			}
			if ($shipping_data) {
				foreach ($shipping_data as $key => $value) {
					if (isset($value['sort_order'])) {
						$sort_order[$key] = $value['sort_order'];
					} else {
						$sort_order[$key] = 1;
					}
				}
			}

			// array_multisort($sort_order, SORT_ASC, $method_data);

			// array_multisort($sort_order, SORT_ASC, $shipping_data);

			$this->session->data['shipping_methods'] = $shipping_data;
		}

		$shippingData['text_shipping_method'] = $this->language->get('text_shipping_method');
		$shippingData['text_comments'] = $this->language->get('text_comments');
		$shippingData['text_loading'] = $this->language->get('text_loading');

		$shippingData['button_continue'] = $this->language->get('button_continue');

		if (empty($this->session->data['shipping_methods'])) {
			$shippingData['error_warning'] = strip_tags(sprintf($this->language->get('error_no_shipping'), ''));
		} else {
			$shippingData['error_warning'] = '';
		}

		$shippingData['is_required'] =  $this->config->get('pincodedays_isitoptional') ? false : true;
		$shippingData['dateformat'] =  $this->config->get('pincodedays_dateformat') ? "MM/DD/YYYY" : "DD-MM-YYYY";
		$shippingData['deliverytoday'] =  $this->config->get('pincodedays_samedaydelivery') ? true : false;

		$this->language->load('mail/deliverydate');
		$shippingData['text_delivery_date'] =  $this->language->get('text_sdelivery_date');
		$shippingData['text_date_placeholder'] =  $this->language->get('text_enterdate');
		$shippingData['error_dmy_format'] =  $this->language->get('error_dmy_format');
		$shippingData['error_mdy_format'] =  $this->language->get('error_mdy_format');

		

		if (isset($method_data)) {
			$shippingData['shipping_methods'] = $method_data;
		} else {
			$shippingData['shipping_methods'] = array();
		}

		if (isset($this->session->data['shipping_method']['code'])) {
			$shippingData['code'] = $this->session->data['shipping_method']['code'];
		} else {
			$shippingData['code'] = '';
		}

		if (isset($this->session->data['comment'])) {
			$shippingData['comment'] = $this->session->data['comment'];
		} else {
			$shippingData['comment'] = '';
		}
		return $shippingData;
	}
/**
 * saves the shipping method
 * @param  array $shippingMeth contains shipping method data
 * @return array               returns payment methods
 */
	protected function saveShippingMeth($shippingMeth) {
		$this->load->language('checkout/checkout');

		$json = array();

		// Validate if shipping is required. If not the customer should not have reached this page.
		if (!$this->cart->hasShipping()) {
			$json = array('cart'=>0,'error'=>1);
		}

		// Validate if shipping address has been set.
		if (!isset($this->session->data['shipping_address'])) {
			$json = array('cart'=>0,'error'=>1);
		}

		// Validate cart has products and has stock.
		if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
			$json = array('redirect'=>'cart','error'=>1);
		}

		// Validate minimum quantity requirements.
		$products = $this->cart->getProducts();

		foreach ($products as $product) {
			$product_total = 0;

			foreach ($products as $product_2) {
				if ($product_2['product_id'] == $product['product_id']) {
					$product_total += $product_2['quantity'];
				}
			}

			if ($product['minimum'] > $product_total) {
				$json = array('cart'=>0,'error'=>1);

				break;
			}
		}

		if(!isset($shippingMeth['deliverydate']))
		$shippingMeth['deliverydate'] = '';
		unset($this->session->data['pincodedays_deliverydate']);
		unset($this->session->data['pincodedays_timeslot']);
		unset($this->session->data['pincodedays_daynumber']);
		$this->language->load('mail/deliverydate');
		if($this->config->get('pincodedays_status')) {
			if (isset($shippingMeth['deliverydate'])) {
				if($shippingMeth['deliverydate'] == "") {
					if(!$this->config->get('pincodedays_isitoptional')) {
						$json['error'] = 1;
						$json['message'] = $this->language->get('error_deliverydate_empty');
					}
				} else {
					$date = date_parse($shippingMeth['deliverydate']);
					$result = checkdate($date['month'],$date['day'],$date['year']);
					if($result && !$json)  {
						$daynumber =  date('N', strtotime($shippingMeth['deliverydate']));
						if($daynumber == 7) {$daynumber = 0;}
						if(isset($this->session->data['blockdays'])) {
							if(in_array($daynumber,$this->session->data['blockdays'])) {
								$json['error'] = 1;
								$json['message'] = $this->language->get('error_deliverydate_blocked');
							}
						}
						if(isset($this->session->data['holiday_block']) && !empty($this->session->data['holiday_block'])) {
							if(in_array($shippingMeth['deliverydate'],$this->session->data['holiday_block'])) {
								$json['error'] = 1;
								$json['message'] = $this->language->get('error_deliverydate_blocked');
							}
						}
						$postdatetime = strtotime(date($shippingMeth['deliverydate']));
						$currentdatetime = strtotime(date('d-m-Y'));

						if($postdatetime < $currentdatetime) {
							$json['error'] = 1;
							 $json['message'] = $this->language->get('error_deliverydate_old');
						}
						if($postdatetime == $currentdatetime) {
							if(isset($this->session->data['deliverytoday']) && !$this->session->data['deliverytoday']) {
								$json['error'] = 1;
								$json['message'] =  $this->language->get('error_deliveryslots_over');
							} else {
								if(isset($this->session->data['todaytimeslot']) && $this->session->data['todaytimeslot']) {
									$this->load->model("extension/module/pincodedays");
									if(isset($this->session->data['timezonename'])) {
										$timezone = $this->session->data['timezonename'];
									} else {
										$timezone = "Asia/Kolkata";
									}
									$data['timeslots_today']  = $this->model_extension_module_pincodedays->getTimeSlotsForToday($daynumber,$timezone);
									if(empty($data['timeslots_today'])) {
										$json['message'] =  $this->language->get('error_deliveryslots_over');
									}
								}
							}
						}
						$this->load->model("extension/module/pincodedays");
						$blockedslots = $this->model_extension_module_pincodedays->getBlockedTimeSlotId($shippingMeth['deliverydate'],$daynumber);
						if(isset($this->session->data['timeslots'][$daynumber])) {
							$totaltimeslots = count($this->session->data['timeslots'][$daynumber]);
							$totalblocks = count($blockedslots);
							if($totalblocks == $totaltimeslots) {
								$json['message'] = $this->language->get('error_alltimeslot_full');
							}
						}
						if(!$json ) {
							$this->session->data['pincodedays_deliverydate'] = $shippingMeth['deliverydate'];
							if(isset($this->session->data['timeslots']) && isset($this->session->data['timeslots'][$daynumber]) && isset($this->request->post['time_slots'])) {
								if(array_key_exists($shippingMeth['time_slots'], $this->session->data['timeslots'][$daynumber])) {
									if(empty($blockedslots) || (!empty($blockedslots) && !in_array($shippingMeth['time_slots'],$blockedslots))) {
										$this->session->data['pincodedays_timeslot'] = $shippingMeth['time_slots'];
									}
								}
							}
							$this->session->data['pincodedays_daynumber'] = $daynumber;
						}
					} else {
						$json['error'] = 1;
						$json['message'] = $this->language->get('error_deliverydate_invalid');
					}
				}
			} else {
				$json['error'] = 1;
				$json['message'] = $this->language->get('error_deliverydate_empty');
			}
		}

		if (!isset($shippingMeth['shipping_method'])) {
			$json['error'] = $this->language->get('error_shipping');
		} else {
			$shipping = explode('.', $shippingMeth['shipping_method']);

			if (!isset($shipping[0]) || !isset($shipping[1]) || !isset($this->session->data['shipping_methods'][$shipping[0]]['quote'][$shipping[1]])) {
				$json['error'] = $this->language->get('error_shipping');
			}
		}

		if (!$json) {
			$this->session->data['shipping_method'] = $this->session->data['shipping_methods'][$shipping[0]]['quote'][$shipping[1]];
			if (isset($shippingMeth['comment'])) {
				$this->session->data['comment'] = strip_tags($shippingMeth['comment']);
			} else {
				$this->session->data['comment'] = '';
			}
		}
		if($json)
			return $json;
		else {
			return $this->paymentMethods();
		}
	}
/**
 * Fetches payment methods
 * @return array returns the payment Methods
 */

 public function getTimeSlots() {
	 $this->load->language('account/api');

	 $post = $this->request->post;

	 //Accepting data in json format / raw data

	 $raw_data = json_decode(file_get_contents("php://input"),true);

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
		 unset($this->session->data['pincodedays_deliverydate']);
		 unset($this->session->data['pincodedays_timeslot']);
		 unset($this->session->data['pincodedays_daynumber']);

		 $json = array();
		 $this->language->load('mail/deliverydate');
		 if($this->config->get('module_pincodedays_status')) {
			 if (isset($post['deliverydate'])) {
				 if($post['deliverydate'] == "") {
					 $json['error'] = 1;
					 $json['message'] = $this->language->get('error_deliverydate_empty');
				 } else {
					 $date = date_parse($post['deliverydate']);
					 $result = checkdate($date['month'],$date['day'],$date['year']);
					 if($date['year'] < (date("Y") - 1)) {
						 $json['error'] = 1;
						 $json['message'] = $this->language->get('error_deliverydate_blocked');
					 }
					 if($result && !$json)  {
						 $this->load->model("extension/module/pincodedays");
						 $daynumber =  date('N', strtotime($post['deliverydate']));
						 if($daynumber == 7) {$daynumber = 0;}
						 if(isset($this->session->data['blockdays'])) {
							 if(in_array($daynumber,$this->session->data['blockdays'])) {
								 $json['error'] = 1;
								 $json['message'] = $this->language->get('error_deliverydate_blocked');
							 }
						 }

						 if(isset($this->session->data['holiday_block']) && !empty($this->session->data['holiday_block'])) {
							 if(in_array($post['deliverydate'],$this->session->data['holiday_block'])) {
								 $json['error'] = 1;
								 $json['message'] = $this->language->get('error_deliverydate_blocked');
							 }
						 }

						 $postdatetime = strtotime(date($post['deliverydate']));
						 $currentdatetime = strtotime(date('d-m-Y'));

						 if($postdatetime < $currentdatetime) {
							 $json['error'] = 1;
								$json['message'] = $this->language->get('error_deliverydate_old');
						 }
						 if($postdatetime == $currentdatetime) {
							 if(isset($this->session->data['deliverytoday']) && !$this->session->data['deliverytoday']) {
								 $json['error'] = 1;
								 $json['message'] = $this->language->get('error_deliveryslots_over');
							 } else {
								 if(isset($this->session->data['todaytimeslot']) && $this->session->data['todaytimeslot']) {
									 if(isset($this->session->data['timezonename'])) {
										 $timezone = $this->session->data['timezonename'];
									 } else {
										 $timezone = "Asia/Kolkata";
									 }
									 echo "<pre>";
									 print_r($daynumber);
									 echo "</pre>";
									 die();
									 $data['timeslots_today']  = $this->model_extension_module_pincodedays->getTimeSlotsForToday($daynumber, $timezone);
									 if(empty($data['timeslots_today'])) {
										 $json['error'] = 1;
										 $json['message'] = $this->language->get('error_deliveryslots_over');
										 $todayslots = 0;
									 } else {
										 $todayslots = 1;
									 }
								 }
							 }
						 }
						 if(isset($this->session->data['timeslots']) && !empty($this->session->data['timeslots'])) {
							 if(isset($this->session->data['timeslots'][$daynumber]) && is_array($this->session->data['timeslots'][$daynumber])) {
								 $areslotsavailable = 1;
							 }
						 }
						 $this->load->model("extension/module/pincodedays");
						 $blockeddays = $this->model_extension_module_pincodedays->getBlockedTimeSlotId($post['deliverydate'],$daynumber);
						 if(isset($this->session->data['timeslots'][$daynumber])) {
							 $totaltimeslots = count($this->session->data['timeslots'][$daynumber]);
							 $totalblocks = count($blockeddays);
							 if($totalblocks == $totaltimeslots) {
								 $json['error'] = 1;
								 $json['message'] = $this->language->get('error_alltimeslot_full');
							 }
						 }
					 } else {
						 $json['error'] = 1;
						 $json['message'] = $this->language->get('error_deliverydate_invalid');
					 }
				 }
			 } else {
				 $json['error'] = 1;
				 $json['message'] = $this->language->get('error_deliverydate_empty');
			 }
		 }

		 if(!$json) {
			 $data['error'] = 0;

			 if(isset($post['deliverydate'])) {
				 $this->session->data['pincodedays_deliverydate'] = $post['deliverydate'];
			 }
			 if(isset($this->session->data['timeslots']) && isset($daynumber) && isset($this->session->data['timeslots'][$daynumber]) && isset($post['time_slots'])) {
				 if(array_key_exists($post['time_slots'], $this->session->data['timeslots'][$daynumber])) {
					 $this->session->data['pincodedays_timeslot'] = $post['time_slots'];
				 }
			 }

			 if(isset($daynumber)) {
				 $this->session->data['pincodedays_daynumber'] = $daynumber;
			 }
			 $timezoneid = $this->config->get('pincodedays_timezone');
			 if(!$timezoneid) {$timezoneid = "247";}
			 $this->load->model("extension/module/pincodedays");
			 $timezonename = $this->model_extension_module_pincodedays->getTimeZoneName($timezoneid);
			 $this->session->data['timezonename'] = $timezonename;
			 date_default_timezone_set($timezonename);
			 $daynum = date("N", strtotime(date("d-m-Y")));
			 if($daynum == 7) {$daynum = 0;}
			 $holidays_array_session = $data['timeslots_today'] = $holidays_array = array();
			 if($this->config->get('pincodedays_status')) {
			 $timeslots = $this->model_extension_module_pincodedays->getTimeSlots();
			 $timeslots_today  = $this->model_extension_module_pincodedays->getTimeSlotsForToday($daynum,$timezonename);
			 if(isset($timeslots_today) && isset($timeslots_today[$daynumber])) {
				 foreach($timeslots_today[$daynumber] as $key => $value) {
					 $data['timeslots'][] = array('id' => $key,'deliverydate' => $value);
				 }
			 } elseif(isset($timeslots) && isset($timeslots[$daynumber])) {
				 foreach($timeslots[$daynumber] as $key => $value) {
					 $data['timeslots'][] = array('id' => $key,'deliverydate' => $value);
				 }
			 } else {
				 $data['timeslots'] = array();
			 }
				 $this->session->data['timeslots'] = $timeslots;
				 if(isset($timeslots[$daynum]) && !empty($timeslots[$daynum])) {
					 $this->session->data['todaytimeslot'] = 1;
					 $data['timeslots_today']  = $this->model_extension_module_pincodedays->getTimeSlotsForToday($daynum,$timezonename);
					 if(empty($data['timeslots_today'])) {
						 $data['deliverytoday']= 0;
					 }
				 } else {
					 $this->session->data['todaytimeslot'] = 0;
				 }

				 $this->session->data['deliverytoday'] = $data['deliverytoday'];

				 $this->session->data['holiday_block'] = $holidays_array_session;
			 }

			 $this->response->addHeader('Content-Type: application/json');
			 $this->response->setOutput(json_encode($data));
		 } else {
			 $this->response->addHeader('Content-Type: application/json');
			 $this->response->setOutput(json_encode($json));
		 }
	 }

 }
	protected function paymentMethods()	{
		$this->load->language('checkout/checkout');

		if (isset($this->session->data['payment_address'])) {
			// Totals
			$total_data = array();
			$totals = array();
			$taxes = $this->cart->getTaxes();
			$total = 0;

			if (version_compare(VERSION,'2.2.0.0','>=')) {
				$total_data = array(
					'totals' => &$totals,
					'taxes'  => &$taxes,
					'total'  => &$total
				);
			}

			if (version_compare(VERSION,'3.0.0.0','>=') || version_compare(VERSION,'2.0.0.0','<')) {
				$this->load->model('setting/extension');
			}else{
				$this->load->model('extension/extension');
			}

			$sort_order = array();

			if (version_compare(VERSION,'3.0.0.0','>=') || version_compare(VERSION,'2.0.0.0','<')) {
				$results = $this->model_setting_extension->getExtensions('total');
			}else{
			$results = $this->model_extension_extension->getExtensions('total');

			}

			foreach ($results as $key => $value) {
				if (version_compare(VERSION,'3.0.0.0','>=')) {
					$sort_order[$key] = $this->config->get('total_' . $value['code'] . '_sort_order');
				} else {
					$sort_order[$key] = $this->config->get($value['code'] . '_sort_order');
				}
			}

			array_multisort($sort_order, SORT_ASC, $results);

			foreach ($results as $result) {

				if (version_compare(VERSION,'3.0.0.0','>=')) {
					$total_name = 'total_' .$result['code'] . '_status';
				}
				else{
					$total_name = $result['code'] . '_status';
				}

				if ($this->config->get($total_name)) {

					if (version_compare(VERSION,'2.3.0.0','>=')) {
						$this->load->model('extension/total/' . $result['code']);

						$this->{'model_extension_total_' . $result['code']}->getTotal($total_data);
					} else {
						$this->load->model('total/' . $result['code']);

						if (version_compare(VERSION,'2.2.0.0','>=')) {
							$this->{'model_total_' . $result['code']}->getTotal($total_data);
						} else {
							$this->{'model_total_' . $result['code']}->getTotal($total_data, $total, $taxes);
						}
					}
				}
			}

			// Payment Methods
			$method_data = array();

			if (version_compare(VERSION,'3.0.0.0','>=') || version_compare(VERSION,'2.0.0.0','<')) {
				$this->load->model('setting/extension');
			}else{
				$this->load->model('extension/extension');
			}

			if (version_compare(VERSION,'3.0.0.0','>=') || version_compare(VERSION,'2.0.0.0','<')) {
				$results = $this->model_setting_extension->getExtensions('payment');
			}else{
			$results = $this->model_extension_extension->getExtensions('payment');

			}

			$recurring = $this->cart->hasRecurringProducts();

			foreach ($results as $result) {

				if (version_compare(VERSION,'3.0.0.0','>=')) {
					$total_name = 'payment_' .$result['code'] . '_status';
				}
				else{
					$total_name = $result['code'] . '_status';
				}

				if ($this->config->get('module_mobikul_payment') && !in_array($result['code'],$this->config->get('module_mobikul_payment'))) {
				  $display_status = false;
				} else {
				  $display_status = true;
				}

				if ($this->config->get($total_name) && $display_status) {

					if (version_compare(VERSION,'2.3.0.0','>=')) {
						$this->load->model('extension/payment/' . $result['code']);

						$method = $this->{'model_extension_payment_' . $result['code']}->getMethod($this->session->data['payment_address'], $total);

						if ($method) {
							if ($recurring) {
								if (property_exists($this->{'model_extension_payment_' . $result['code']}, 'recurringPayments') && $this->{'model_extension_payment_' . $result['code']}->recurringPayments()) {
									$method_data[$result['code']] = $method;
								}
							} else {
								$method_data[$result['code']] = $method;
							}
						}
					} else {
						$this->load->model('payment/' . $result['code']);

						$method = $this->{'model_payment_' . $result['code']}->getMethod($this->session->data['payment_address'], $total);

						if ($method) {
							if ($recurring) {
								if (property_exists($this->{'model_payment_' . $result['code']}, 'recurringPayments') && $this->{'model_payment_' . $result['code']}->recurringPayments()) {
									$method_data[$result['code']] = $method;
								}
							} else {
								$method_data[$result['code']] = $method;
							}
						}
					}
				}
			}

			$sort_order = array();

			foreach ($method_data as $key => $value) {
				if (isset($value['sort_order'])) {
					$sort_order[$key] = $value['sort_order'];
				} else {
					$sort_order[$key] = 1;
				}
			}

			array_multisort($sort_order, SORT_ASC, $method_data);

			$payment_data = array();

			if ($method_data) {
			  foreach ($method_data as $key => $value) {
					if(isset($value['title'])) {
						$value['title'] = html_entity_decode(strip_tags($value['title']),ENT_QUOTES,"UTF-8");
						if (!$value['title'])
		       	$value['title'] = ucwords(str_replace('_',' ',$value['code']));
					}
			    $payment_data[] = $value;
			  }
			}

			$this->session->data['payment_methods'] = $method_data;
		}

		$paymentMethodsData['text_payment_method'] = $this->language->get('text_payment_method');
		$paymentMethodsData['text_comments'] = $this->language->get('text_comments');
		$paymentMethodsData['text_loading'] = $this->language->get('text_loading');

		$paymentMethodsData['button_continue'] = $this->language->get('button_continue');

		if (empty($this->session->data['payment_methods'])) {
			$paymentMethodsData['error_warning'] = strip_tags(sprintf($this->language->get('error_no_payment'), $this->url->link('information/contact')));
		} else {
			$paymentMethodsData['error_warning'] = '';
		}

		if (isset($this->session->data['payment_methods'])) {
			$paymentMethodsData['payment_methods'] = $payment_data;
		} else {
			$paymentMethodsData['payment_methods'] = array();
		}

		if (isset($this->session->data['payment_method']['code'])) {
			$paymentMethodsData['code'] = $this->session->data['payment_method']['code'];
		} else {
			$paymentMethodsData['code'] = '';
		}

		if (isset($this->session->data['comment'])) {
			$paymentMethodsData['comment'] = $this->session->data['comment'];
		} else {
			$paymentMethodsData['comment'] = '';
		}

		$paymentMethodsData['scripts'] = $this->document->getScripts();

		if ($this->config->get('config_checkout_id')) {
			$this->load->model('catalog/information');

			$information_info = $this->model_catalog_information->getInformation($this->config->get('config_checkout_id'));

			if ($information_info) {
				$paymentMethodsData['text_agree'] = strip_tags(sprintf($this->language->get('text_agree'), $this->url->link('information/information/agree', 'information_id=' . $this->config->get('config_checkout_id'), 'SSL'), $information_info['title'], $information_info['title']));

				if (isset($information_info['description']) && $information_info['description']) {
					$paymentMethodsData['text_agree_info'] = html_entity_decode($information_info['description']);
				}
			} else {
				$paymentMethodsData['text_agree'] = '';
				$paymentMethodsData['text_agree_info'] = '';
			}
		} else {
			$paymentMethodsData['text_agree'] = '';
			$paymentMethodsData['text_agree_info'] = '';
		}

		if (isset($this->session->data['agree'])) {
			$paymentMethodsData['agree'] = $this->session->data['agree'];
		} else {
			$paymentMethodsData['agree'] = '';
		}

		return $paymentMethodsData;
	}
/**
 * saves the payment method
 * @param  array $paymentMeth contains payment method data
 * @return array              returns error if exists
 */
	protected function savePaymentMeth($paymentMeth) {

		$this->load->language('checkout/checkout');

		$json = array();

		// Validate if payment address has been set.
		if (!isset($this->session->data['payment_address'])) {
			$json = array('redirect'=>'cart','error'=>1);
		}

		// Validate cart has products and has stock.
		if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
			$json = array('redirect'=>'cart','error'=>1);
		}

		// Validate minimum quantity requirements.
		$products = $this->cart->getProducts();

		foreach ($products as $product) {
			$product_total = 0;

			foreach ($products as $product_2) {
				if ($product_2['product_id'] == $product['product_id']) {
					$product_total += $product_2['quantity'];
				}
			}

			if ($product['minimum'] > $product_total) {
				$json = array('cart'=>0,'error'=>1);

				break;
			}
		}

		if (!isset($paymentMeth['payment_method'])) {
			$json['error'] = $this->language->get('error_payment');
		} elseif (!isset($this->session->data['payment_methods'][$paymentMeth['payment_method']])) {
			$json['error'] = $this->language->get('error_payment');
		}

		if ($this->config->get('config_checkout_id')) {
			$this->load->model('catalog/information');

			$information_info = $this->model_catalog_information->getInformation($this->config->get('config_checkout_id'));

			if ($information_info && !isset($paymentMeth['agree'])) {
				$json['error'] = sprintf($this->language->get('error_agree'), $information_info['title']);
			}
		}

		if (!$json) {
			$this->session->data['payment_method'] = $this->session->data['payment_methods'][$paymentMeth['payment_method']];

     if(isset($paymentMeth['comment']))
			$this->session->data['comment'] = strip_tags($paymentMeth['comment']);
		}
		if($json)
			return $json;
		else {
			return $this->confirm();
		}
	}
/**
 * confirm an order
 * @return array return error if exists
 */
	protected function confirm() {

		$redirect = '';

		if ($this->cart->hasShipping()) {
			// Validate if shipping address has been set.
			if (!isset($this->session->data['shipping_address'])) {
				$redirect = array('redirect'=>'checkout','error'=>1);
			}

			// Validate if shipping method has been set.
			if (!isset($this->session->data['shipping_method'])) {
				$redirect = array('redirect'=>'checkout','error'=>1);
			}
		} else {
			unset($this->session->data['shipping_address']);
			unset($this->session->data['shipping_method']);
			unset($this->session->data['shipping_methods']);
		}

		// Validate if payment address has been set.
		if (!isset($this->session->data['payment_address'])) {
			$redirect = array('redirect'=>'checkout','error'=>1);
		}

		// Validate if payment method has been set.
		if (!isset($this->session->data['payment_method'])) {
			$redirect = array('redirect'=>'checkout','error'=>1);
		}

		// Validate cart has products and has stock.
		if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
			$json = array('redirect'=>'cart','error'=>1);
		}

		// Validate minimum quantity requirements.
		$products = $this->cart->getProducts();

		foreach ($products as $product) {
			$product_total = 0;

			foreach ($products as $product_2) {
				if ($product_2['product_id'] == $product['product_id']) {
					$product_total += $product_2['quantity'];
				}
			}

			if ($product['minimum'] > $product_total) {
				$redirect = array('redirect'=>'cart','error'=>1);

				break;
			}
		}

		if (!$redirect) {
			$order_data = array();

			$total_data = array();
			$totals = array();
			$total = 0;
			$taxes = $this->cart->getTaxes();

			if (version_compare(VERSION,'2.2.0.0','>=')) {
				$total_data = array(
					'totals' => &$totals,
					'taxes'  => &$taxes,
					'total'  => &$total
				);
			}

			if (version_compare(VERSION,'3.0.0.0','>=') || version_compare(VERSION,'2.0.0.0','<')) {
				$this->load->model('setting/extension');
			}else{
				$this->load->model('extension/extension');
			}

			$sort_order = array();

			if (version_compare(VERSION,'3.0.0.0','>=') || version_compare(VERSION,'2.0.0.0','<')) {
				$results = $this->model_setting_extension->getExtensions('total');
			}else{
			$results = $this->model_extension_extension->getExtensions('total');

			}

			foreach ($results as $key => $value) {
				if (version_compare(VERSION,'3.0.0.0','>=')) {
					$sort_order[$key] = $this->config->get('total_' . $value['code'] . '_sort_order');
				} else {
					$sort_order[$key] = $this->config->get($value['code'] . '_sort_order');
				}
			}

			array_multisort($sort_order, SORT_ASC, $results);

			foreach ($results as $result) {

				if (version_compare(VERSION,'3.0.0.0','>=')) {
					$total_name = 'total_' .$result['code'] . '_status';
				}
				else{
					$total_name = $result['code'] . '_status';
				}

				if ($this->config->get($total_name)) {
					if (version_compare(VERSION,'2.3.0.0','>=')) {
						$this->load->model('extension/total/' . $result['code']);

						$this->{'model_extension_total_' . $result['code']}->getTotal($total_data);
					} else {
						$this->load->model('total/' . $result['code']);

						if (version_compare(VERSION,'2.2.0.0','>=')) {
							$this->{'model_total_' . $result['code']}->getTotal($total_data);
						} else {
							$this->{'model_total_' . $result['code']}->getTotal($total_data,$total, $taxes);
						}
					}
				}
			}

			$sort_order = array();

			foreach ($totals as $key => $value) {
				if (isset($value['sort_order'])) {
					$sort_order[$key] = $value['sort_order'];
				} else {
					$sort_order[$key] = 1;
				}
			}

			array_multisort($sort_order, SORT_ASC, $totals);

			if (version_compare(VERSION,'2.2.0.0','>=')) {
				$order_data['totals'] = $totals;
			} else {
				$order_data['totals'] = $total_data;
			}

			$this->load->language('checkout/checkout');

			$order_data['invoice_prefix'] = $this->config->get('config_invoice_prefix');
			$order_data['store_id'] = $this->config->get('config_store_id');
			$order_data['store_name'] = $this->config->get('config_name');

			if ($this->config->get('config_checkout_id')) {
				$this->load->model('catalog/information');

				$information_info = $this->model_catalog_information->getInformation($this->config->get('config_checkout_id'));

				if ($information_info) {
					$order_data['text_agree'] = strip_tags(sprintf($this->language->get('text_agree'), $this->url->link('information/information/agree', 'information_id=' . $this->config->get('config_checkout_id'), 'SSL'), $information_info['title'], $information_info['title']));

					if (isset($information_info['description']) && $information_info['description']) {
						$order_data['text_agree_info'] = html_entity_decode($information_info['description']);
					}
				} else {
					$order_data['text_agree'] = '';
					$order_data['text_agree_info'] = '';
				}
			} else {
				$order_data['text_agree'] = '';
				$order_data['text_agree_info'] = '';
			}

			if ($order_data['store_id']) {
				$order_data['store_url'] = $this->config->get('config_url');
			} else {
				$order_data['store_url'] = HTTP_SERVER;
			}

			if ($this->customer->isLogged()) {
				$this->load->model('account/customer');

				$customer_info = $this->model_account_customer->getCustomer($this->customer->getId());

				$order_data['customer_id'] = $this->customer->getId();
				$order_data['customer_group_id'] = $customer_info['customer_group_id'];
				$order_data['firstname'] = html_entity_decode($customer_info['firstname'],ENT_QUOTES,'UTF-8');
				$order_data['lastname'] = html_entity_decode($customer_info['lastname'],ENT_QUOTES,'UTF-8');
				$order_data['email'] = $customer_info['email'];
				$order_data['telephone'] = $customer_info['telephone'];

				$order_data['fax'] = $customer_info['fax'];

				if(isset($customer_info['custom_field'])){
					if (version_compare(VERSION,'2.1.0.0','>=')) {
						$order_data['custom_field'] = json_decode($customer_info['custom_field']);
					} else {
						$order_data['custom_field'] = unserialize($customer_info['custom_field']);
					}
				}else{
					$order_data['custom_field'] = (object) array();
				}

			} elseif (isset($this->session->data['guest'])) {
				$order_data['customer_id'] = 0;
				$order_data['customer_group_id'] = $this->session->data['guest']['customer_group_id'];
				$order_data['firstname'] = html_entity_decode($this->session->data['guest']['firstname'],ENT_QUOTES,"UTF-8");
				$order_data['lastname'] = html_entity_decode($this->session->data['guest']['lastname'],ENT_QUOTES,"UTF-8");
				$order_data['email'] = html_entity_decode($this->session->data['guest']['email'],ENT_QUOTES,"UTF-8");
				$order_data['telephone'] = $this->session->data['guest']['telephone'];
				$order_data['fax'] = html_entity_decode($this->session->data['guest']['fax'],ENT_QUOTES,"UTF-8");
				$order_data['custom_field'] = $this->session->data['guest']['custom_field'];
			}

			$order_data['payment_firstname'] = html_entity_decode($this->session->data['payment_address']['firstname'],ENT_QUOTES,"UTF-8");
			$order_data['payment_lastname'] = html_entity_decode($this->session->data['payment_address']['lastname'],ENT_QUOTES,"UTF-8");
			$order_data['payment_company'] = html_entity_decode($this->session->data['payment_address']['company'],ENT_QUOTES,"UTF-8");
			$order_data['payment_address_1'] = html_entity_decode($this->session->data['payment_address']['address_1'],ENT_QUOTES,"UTF-8");
			$order_data['payment_address_2'] = html_entity_decode($this->session->data['payment_address']['address_2'],ENT_QUOTES,"UTF-8");
			$order_data['payment_city'] = html_entity_decode($this->session->data['payment_address']['city'],ENT_QUOTES,"UTF-8");
			$order_data['payment_postcode'] = $this->session->data['payment_address']['postcode'];
			$order_data['payment_zone'] = html_entity_decode($this->session->data['payment_address']['zone'],ENT_QUOTES,"UTF-8");
			$order_data['payment_zone_id'] = $this->session->data['payment_address']['zone_id'];
			$order_data['payment_country'] = html_entity_decode($this->session->data['payment_address']['country'],ENT_QUOTES,"UTF-8");

			if (version_compare(VERSION,'2.0.0.0','<')){

				$order_data['payment_company_id'] = $this->session->data['payment_address']['company_id'];
				$order_data['payment_tax_id'] = $this->session->data['payment_address']['tax_id'];
			}

			$order_data['payment_country_id'] = $this->session->data['payment_address']['country_id'];
			$order_data['payment_address_format'] = $this->session->data['payment_address']['address_format'];

			$order_data['payment_custom_field'] = array();
			if(isset($this->session->data['payment_address']['custom_field']) && $this->session->data['payment_address']['custom_field']) {
				$custom = $this->session->data['payment_address']['custom_field'];
				foreach($custom as $key => $value ) {
					$order_data['payment_custom_field'][] = array(
						'id' => $key,
						'value' => $value
					);
				}
			}

			
			if ( isset($this->session->data['payment_method']['title']) && strpos($this->session->data['payment_method']['title'],'<img src') !== false ) {
				$order_data['payment_method'] = $this->session->data['payment_method']['code'];
			} else {
				$order_data['payment_method'] = strip_tags($this->session->data['payment_method']['title']);
			}


			if (isset($this->session->data['payment_method']['code'])) {
				$order_data['payment_code'] = $this->session->data['payment_method']['code'];
			} else {
				$order_data['payment_code'] = '';
			}


			if ($this->cart->hasShipping()) {
				$order_data['shipping_firstname'] = html_entity_decode($this->session->data['shipping_address']['firstname'],ENT_QUOTES,'UTF-8');
				$order_data['shipping_lastname'] = html_entity_decode($this->session->data['shipping_address']['lastname'],ENT_QUOTES,'UTF-8');
				$order_data['shipping_company'] = html_entity_decode($this->session->data['shipping_address']['company'],ENT_QUOTES,'UTF-8');
				$order_data['shipping_address_1'] = html_entity_decode($this->session->data['shipping_address']['address_1'],ENT_QUOTES,'UTF-8');
				$order_data['shipping_address_2'] = html_entity_decode($this->session->data['shipping_address']['address_2'],ENT_QUOTES,'UTF-8');
				$order_data['shipping_city'] = html_entity_decode($this->session->data['shipping_address']['city'],ENT_QUOTES,'UTF-8');
				$order_data['shipping_postcode'] = $this->session->data['shipping_address']['postcode'];
				$order_data['shipping_zone'] = html_entity_decode($this->session->data['shipping_address']['zone'],ENT_QUOTES,'UTF-8');
				$order_data['shipping_zone_id'] = $this->session->data['shipping_address']['zone_id'];
				$order_data['shipping_country'] = html_entity_decode($this->session->data['shipping_address']['country'],ENT_QUOTES,'UTF-8');
				$order_data['shipping_country_id'] = $this->session->data['shipping_address']['country_id'];
				$order_data['shipping_address_format'] = html_entity_decode($this->session->data['shipping_address']['address_format'],ENT_QUOTES,'UTF-8');

				$order_data['shipping_custom_field'] = array();
				if(isset($this->session->data['shipping_address']['custom_field']) && $this->session->data['shipping_address']['custom_field']) {
					$custom = $this->session->data['shipping_address']['custom_field'];
					foreach($custom as $key => $value ) {
						$order_data['shipping_custom_field'][] = array(
							'id' => $key,
							'value' => $value
						);
					}
				}

				if (isset($this->session->data['shipping_method']['title'])) {
					$order_data['shipping_method'] = $this->session->data['shipping_method']['title'];
				} else {
					$order_data['shipping_method'] = '';
				}

				if (isset($this->session->data['shipping_method']['code'])) {
					$order_data['shipping_code'] = $this->session->data['shipping_method']['code'];
				} else {
					$order_data['shipping_code'] = '';
				}
			} else {
				$order_data['shipping_firstname'] = '';
				$order_data['shipping_lastname'] = '';
				$order_data['shipping_company'] = '';
				$order_data['shipping_address_1'] = '';
				$order_data['shipping_address_2'] = '';
				$order_data['shipping_city'] = '';
				$order_data['shipping_postcode'] = '';
				$order_data['shipping_zone'] = '';
				$order_data['shipping_zone_id'] = '';
				$order_data['shipping_country'] = '';
				$order_data['shipping_country_id'] = '';
				$order_data['shipping_address_format'] = '';
				$order_data['shipping_custom_field'] = array();
				$order_data['shipping_method'] = '';
				$order_data['shipping_code'] = '';
			}

			$this->load->model('tool/image');

			$order_data['products'] = array();

			foreach ($this->cart->getProducts() as $product) {
				$option_data = array();

				foreach ($product['option'] as $option) {
					$option_data[] = array(
						'product_option_id'       => $option['product_option_id'],
						'product_option_value_id' => $option['product_option_value_id'],
						'option_id'               => $option['option_id'],
						'option_value_id'         => $option['option_value_id'],
						'name'                    => $option['name'],
						'value'                   => $option['value'],
						'type'                    => $option['type']
					);
				}

				if (isset($product['image']) && is_file(DIR_IMAGE.$product['image']))
				$dc_image = DIR_IMAGE.$product['image'];
				elseif (is_file(DIR_IMAGE.'placeholder.png'))
				$dc_image = DIR_IMAGE.'placeholder.png';
				else
				$dc_image = '';

				$this->load->model('wkrestapi/catalog');
				$dominant_color = $this->model_wkrestapi_catalog->getDominantColor($dc_image);

				$order_data['products'][] = array(
					'product_id' => $product['product_id'],
					'name'       => html_entity_decode($product['name'],ENT_QUOTES,'UTF-8'),
					'model'      => html_entity_decode($product['model'],ENT_QUOTES,'UTF-8'),
					'option'     => $option_data,
					'download'   => $product['download'],
					'quantity'   => $product['quantity'],
					'subtract'   => $product['subtract'],
					'price'      => $product['price'],
					'total'      => $product['total'],
					'price_text' =>	$this->currency->format($product['price'],$this->session->data['currency']),
					'total_text' =>	$this->currency->format($product['total'],$this->session->data['currency']),
					'tax'        => $this->tax->getTax($product['price'], $product['tax_class_id']),
					'reward'     => $product['reward'],
					'dominant_color' => $dominant_color,
					'image'			 => $this->model_tool_image->resize($product['image'], 100, 100),
				);
			}

			// Gift Voucher
			$order_data['vouchers'] = array();

			if (!empty($this->session->data['vouchers'])) {
				foreach ($this->session->data['vouchers'] as $voucher) {
					$order_data['vouchers'][] = array(
						'description'      => $voucher['description'],
						'code'             => substr(md5(mt_rand()), 0, 10),
						'to_name'          => $voucher['to_name'],
						'to_email'         => $voucher['to_email'],
						'from_name'        => $voucher['from_name'],
						'from_email'       => $voucher['from_email'],
						'voucher_theme_id' => $voucher['voucher_theme_id'],
						'message'          => $voucher['message'],
						'amount'           => $voucher['amount']
					);
				}
			}

			if(isset($this->session->data['comment']))
			$order_data['comment'] = $this->session->data['comment'];
			$order_data['total'] = $total;

			if (isset($this->request->cookie['tracking'])) {
				$order_data['tracking'] = $this->request->cookie['tracking'];

				$subtotal = $this->cart->getSubTotal();

				// Affiliate
				$this->load->model('affiliate/affiliate');

				$affiliate_info = $this->model_affiliate_affiliate->getAffiliateByCode($this->request->cookie['tracking']);

				if ($affiliate_info) {
					$order_data['affiliate_id'] = $affiliate_info['affiliate_id'];
					$order_data['commission'] = ($subtotal / 100) * $affiliate_info['commission'];
				} else {
					$order_data['affiliate_id'] = 0;
					$order_data['commission'] = 0;
				}

				// Marketing
				$this->load->model('checkout/marketing');

				$marketing_info = $this->model_checkout_marketing->getMarketingByCode($this->request->cookie['tracking']);

				if ($marketing_info) {
					$order_data['marketing_id'] = $marketing_info['marketing_id'];
				} else {
					$order_data['marketing_id'] = 0;
				}
			} else {
				$order_data['affiliate_id'] = 0;
				$order_data['commission'] = 0;
				$order_data['marketing_id'] = 0;
				$order_data['tracking'] = '';
			}

			$order_data['language_id'] = $this->config->get('config_language_id');

			if (version_compare(VERSION,'2.2.x.x','>=')) {
				$order_data['currency_id'] = $this->currency->getId($this->session->data['currency']);
				$order_data['currency_code'] = $this->session->data['currency'];
				$order_data['currency_value'] = $this->currency->getValue($this->session->data['currency']);
			} else {
				$order_data['currency_id'] = $this->currency->getId();
				$order_data['currency_code'] = $this->currency->getCode();
				$order_data['currency_value'] = $this->currency->getValue($this->currency->getCode());
			}

			$order_data['ip'] = $this->request->server['REMOTE_ADDR'];

			if (!empty($this->request->server['HTTP_X_FORWARDED_FOR'])) {
				$order_data['forwarded_ip'] = $this->request->server['HTTP_X_FORWARDED_FOR'];
			} elseif (!empty($this->request->server['HTTP_CLIENT_IP'])) {
				$order_data['forwarded_ip'] = $this->request->server['HTTP_CLIENT_IP'];
			} else {
				$order_data['forwarded_ip'] = '';
			}

			if (isset($this->request->server['HTTP_USER_AGENT'])) {
				$order_data['user_agent'] = $this->request->server['HTTP_USER_AGENT'];
			} else {
				$order_data['user_agent'] = '';
			}

			if (isset($this->request->server['HTTP_ACCEPT_LANGUAGE'])) {
				$order_data['accept_language'] = $this->request->server['HTTP_ACCEPT_LANGUAGE'];
			} else {
				$order_data['accept_language'] = '';
			}

			$this->load->model('checkout/order');

			$this->session->data['order_id'] = $this->model_checkout_order->addOrder($order_data);
			
			if(strip_tags($this->session->data['payment_method']['title']) == ''){
                $order_data['payment_method'] = $this->session->data['payment_method']['code'];
			}
			
			$confirm_data['text_recurring_item'] = $this->language->get('text_recurring_item');
			$confirm_data['text_payment_recurring'] = $this->language->get('text_payment_recurring');

			$confirm_data['column_name'] = $this->language->get('column_name');
			$confirm_data['column_model'] = $this->language->get('column_model');
			$confirm_data['column_quantity'] = $this->language->get('column_quantity');
			$confirm_data['column_price'] = $this->language->get('column_price');
			$confirm_data['column_total'] = $this->language->get('column_total');

			if ($this->config->get('config_checkout_id')) {
				$this->load->model('catalog/information');

				$information_info = $this->model_catalog_information->getInformation($this->config->get('config_checkout_id'));

				if ($information_info) {
					$confirm_data['text_agree'] = strip_tags(sprintf($this->language->get('text_agree'), $this->url->link('information/information/agree', 'information_id=' . $this->config->get('config_checkout_id'), 'SSL'), $information_info['title'], $information_info['title']));

					if (isset($information_info['description']) && $information_info['description']) {
						$confirm_data['text_agree_info'] = html_entity_decode($information_info['description']);
					}
				} else {
					$confirm_data['text_agree'] = '';
					$confirm_data['text_agree_info'] = '';
				}
			} else {
				$confirm_data['text_agree'] = '';
				$confirm_data['text_agree_info'] = '';
			}

			if (version_compare(VERSION,'2.0.0.0','>='))
				$this->load->model('tool/upload');

			$confirm_data['products'] = array();

			foreach ($this->cart->getProducts() as $product) {
				$option_data = array();

				foreach ($product['option'] as $option) {
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

				$recurring = '';

				if ($product['recurring']) {
					$frequencies = array(
						'day'        => $this->language->get('text_day'),
						'week'       => $this->language->get('text_week'),
						'semi_month' => $this->language->get('text_semi_month'),
						'month'      => $this->language->get('text_month'),
						'year'       => $this->language->get('text_year'),
					);

					if ($product['recurring']['trial']) {
						$recurring = sprintf($this->language->get('text_trial_description'), $this->currency->format($this->tax->calculate($product['recurring']['trial_price'] * $product['quantity'], $product['tax_class_id'], $this->config->get('config_tax')),$this->session->data['currency']), $product['recurring']['trial_cycle'], $frequencies[$product['recurring']['trial_frequency']], $product['recurring']['trial_duration']) . ' ';
					}

					if ($product['recurring']['duration']) {
						$recurring .= sprintf($this->language->get('text_payment_description'), $this->currency->format($this->tax->calculate($product['recurring']['price'] * $product['quantity'], $product['tax_class_id'], $this->config->get('config_tax')),$this->session->data['currency']), $product['recurring']['cycle'], $frequencies[$product['recurring']['frequency']], $product['recurring']['duration']);
					} else {
						$recurring .= sprintf($this->language->get('text_payment_cancel'), $this->currency->format($this->tax->calculate($product['recurring']['price'] * $product['quantity'], $product['tax_class_id'], $this->config->get('config_tax')),$this->session->data['currency']), $product['recurring']['cycle'], $frequencies[$product['recurring']['frequency']], $product['recurring']['duration']);
					}
				}
				// if (version_compare(VERSION,'2.1.0.0','>=')) {
				// 	$confirm_data['products'][] = array(
				// 		'cart_id'    => $product['cart_id'],
				// 		'product_id' => $product['product_id'],
				// 		'name'       => $product['name'],
				// 		'model'      => $product['model'],
				// 		'option'     => $option_data,
				// 		'recurring'  => $recurring,
				// 		'quantity'   => $product['quantity'],
				// 		'subtract'   => $product['subtract'],
				// 		'price'      => $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax')),$this->session->data['currency']),
				// 		'total'      => $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax')) * $product['quantity'],$this->session->data['currency']),
				// 		'href'       => $this->url->link('product/product', 'product_id=' . $product['product_id'], 'SSL'),
				// 	);
				// } else {
				// 	$confirm_data['products'][] = array(
				// 		'key'        => $product['key'],
				// 		'product_id' => $product['product_id'],
				// 		'name'       => $product['name'],
				// 		'model'      => $product['model'],
				// 		'option'     => $option_data,
				// 		'recurring'  => $recurring,
				// 		'quantity'   => $product['quantity'],
				// 		'subtract'   => $product['subtract'],
				// 		'price'      => $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax'))),
				// 		'total'      => $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax')) * $product['quantity']),
				// 		'href'       => $this->url->link('product/product', 'product_id=' . $product['product_id']),
				// 	);
				// }

			}

			// Gift Voucher
			$confirm_data['vouchers'] = array();

			if (!empty($this->session->data['vouchers'])) {
				foreach ($this->session->data['vouchers'] as $voucher) {
					$confirm_data['vouchers'][] = array(
						'description' => $voucher['description'],
						'amount'      => $this->currency->format($voucher['amount'],$this->session->data['currency'])
					);
				}
			}

			$confirm_data['totals'] = array();

			if (isset($order_data['totals']) && $order_data['totals']) {
				foreach($order_data['totals'] as $key => $find) {
					if (isset($find['title']))
					$order_data['totals'][$key]['title'] = strip_tags($find['title']);
				}
			}

			if (version_compare(VERSION,'2.2.0.0','>=')) {
				foreach ($order_data['totals'] as $key => $total) {
					if(isset($order_data['totals'][$key]['value']) && !is_float($order_data['totals'][$key]['value'])) {
					$order_data['totals'][$key]['value'] = (float) $order_data['totals'][$key]['value'];
					}
			    $confirm_data['totals'][] = array(
			      'title' => $total['title'],
			      'text'  => $this->currency->format($total['value'],$this->session->data['currency']),
			      'value'	=> (float) $total['value']
			    );
			  }
			} else {
			  foreach ($total_data as $total) {
			    $confirm_data['totals'][] = array(
			      'title' => $total['title'],
			      'text'  => $this->currency->format($total['value'],$this->session->data['currency']),
			      'value'	=> (float) $total['value']
			    );
			  }
			}

			$confirm_data['order_details'] = $order_data;

			//if ($order_data['payment_code'] == 'pp_express' || $order_data['payment_code'] == 'pp_pro'|| substr($this->session->data['payment_method']['code'],0,5) == 'bank_') {
 if ($order_data['payment_code'] == 'pp_express' || $order_data['payment_code'] == 'pp_pro' || substr($this->session->data['payment_method']['code'],0,5) == 'bank_' || $order_data['payment_code'] == 'pp_standard') {
				if ($order_data['payment_code'] == 'pp_express') {

					$confirm_data['pp_express'] = array(
						'DEBUG'		=> $this->config->get('pp_express_debug'),
						'USER' 		=> $this->config->get('pp_express_username'),
						'PWD' 		=> $this->config->get('pp_express_password'),
						'SIGNATURE' => $this->config->get('pp_express_signature'),
						'SandBox'	=> $this->config->get('pp_express_test')
					);
				}

				if ($order_data['payment_code'] == 'pp_pro') {

					$confirm_data['pp_pro'] = array(
						'TRANSACTION'		=> $this->config->get('pp_pro_transaction'),
						'USER' 		=> $this->config->get('pp_pro_username'),
						'PWD' 		=> $this->config->get('pp_pro_password'),
						'SIGNATURE' => $this->config->get('pp_pro_signature'),
						'SandBox'	=> $this->config->get('pp_pro_test')
					);
				}

				if (substr($this->session->data['payment_method']['code'],0,5) == 'bank_') {					
					if (version_compare(VERSION,'3.0.0.0','>=')) {
					  $instruction = $this->config->get('payment_'.$this->session->data['payment_method']['code'].'_bank'. $this->config->get('config_language_id'));
					  $confirm_data['bank_instruction'] = "";
					  if ($instruction) {
						$confirm_data['bank_instruction'] = $instruction;
					  }
					} else {
					  $instruction = $this->config->get($this->session->data['payment_method']['code'].'_bank'. $this->config->get('config_language_id'));
					  $confirm_data['bank_instruction'] = "";
					  if ($instruction) {
						$confirm_data['bank_instruction'] = $instruction;
					  }
					}
				  } else {
					$confirm_data['bank_instruction'] = "";
				  }

				if ($order_data['payment_code'] == 'pp_standard') {
				          $this->session->data['application'] = true;
				          $confirm_data['pp_standard'] = array(
				            'url'				=> $this->url->link('extension/payment/pp_standard', 'wk_token=' . $this->request->post['wk_token'], 'SSL'),
				            'success'		=> 'checkout/success',
				            'cancel'			=> 'checkout/checkout'
				          );
				        }

				$paypal_array['tax'] = 0;

				foreach ($order_data['totals'] as $total) {
					if ($total['code'] == 'tax') {
						$paypal_array['tax'] += $this->currency->convert($total['value'], $this->config->get('config_currency'), $this->session->data['currency']);
					} else {
						$paypal_array[$total['code']] = $this->currency->convert($total['value'], $this->config->get('config_currency'), $this->session->data['currency']);
					}
				}

				$paypal_array['discount'] = $this->currency->convert(($paypal_array['total'] - ((isset($paypal_array['sub_total']) ? $paypal_array['sub_total'] : 0) + (isset($paypal_array['tax']) ? $paypal_array['tax'] : 0) + (isset($paypal_array['shipping']) ? $paypal_array['shipping'] : 0))), $this->config->get('config_currency'), $this->session->data['currency']);
				$confirm_data['paypal_data'] = $paypal_array;
			}
			$confirm_data['order_id'] = $this->session->data['order_id'];
		} else {
			return $redirect;
		}
		return $confirm_data;
	}

	protected function checkSession($session_id) {

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
