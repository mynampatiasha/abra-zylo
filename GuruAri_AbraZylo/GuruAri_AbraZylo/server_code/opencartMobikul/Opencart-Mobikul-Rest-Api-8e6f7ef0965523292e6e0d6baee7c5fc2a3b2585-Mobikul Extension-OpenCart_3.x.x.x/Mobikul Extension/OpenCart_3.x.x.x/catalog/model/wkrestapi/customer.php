<?php
class ModelWkrestapiCustomer extends Model {

/**
 * Authenticates a user
 * @return true returns true if user is valid otherwise false
 */
	public function doAuthenticate($username,$password = 0){
		if ($this->config->get('mobikul_status') && $password) {
			$uname = $this->config->get('mobikul_api_key');
			$pwd = md5($this->config->get('mobikul_api_password'));

			if($username == $uname && $password == $pwd)
				return true;
			else
				return false;
		} else {

			if (version_compare(VERSION,'2.1.0.0','>=')) {
				$api_info = $this->db->query("SELECT * FROM `" . DB_PREFIX . "api` WHERE `key` = '" . $this->db->escape($username) . "' AND status = '1'")->row;
			} else {
				$api_info = $this->db->query("SELECT * FROM `" . DB_PREFIX . "api` WHERE `password` = '" . $this->db->escape($username) . "' AND status = '1'")->row;
			}

			if($api_info)
				return true;
			else
				return false;
		}
	}

	/**
	 * [registerDeviceToken] uses for register IOS/Android device token returned by firebase server
	 * @param  string $android_device_id   [POST param for android device ID]
	 * @param  string $ios_device_id       [POST param for ios device ID]
	 * @param  string $customer_id       [param for customer id]
	 * @return null
	 */
	public function registerDeviceToken($android_device_id = '', $ios_device_id = '', $customer_id = '') {
		if(!$customer_id) {
			$customer_id = $this->customer->getId();
		}
		if ($customer_id) {
			$check_exist = $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_customer_to_notification WHERE customer_id = '" . $customer_id . "'")->num_rows;
			if ($check_exist) {
				if ($android_device_id) {
					$this->db->query("UPDATE " . DB_PREFIX . "mobikul_customer_to_notification SET android_device_id = '" . $android_device_id . "' WHERE customer_id = '" . $customer_id . "'");
				}

				if ($ios_device_id) {
					$this->db->query("UPDATE " . DB_PREFIX . "mobikul_customer_to_notification SET ios_device_id = '" . $this->db->escape($ios_device_id) . "' WHERE customer_id = '" . $customer_id . "'");
				}
			} else {
				if ($android_device_id) {
					$this->db->query("INSERT INTO " . DB_PREFIX . "mobikul_customer_to_notification SET android_device_id = '" . $this->db->escape($android_device_id) . "', customer_id = '" . $customer_id . "'");
				}

				if ($ios_device_id) {
					$this->db->query("INSERT INTO " . DB_PREFIX . "mobikul_customer_to_notification SET android_device_id = '" . $this->db->escape($ios_device_id) . "', customer_id = '" . $customer_id . "'");
				}
			}
		}
	}

	/**
	 * fetch ios/android device if by customer id
	 * @param  int $customer_id contain ordered customer id
	 * @return array array contains ios/android device id
	 */
	public function getDeviceIdByCustomerId($customer_id) {
		return $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_customer_to_notification WHERE customer_id = '" . $this->db->escape($customer_id) . "'")->row;
	}

	/**
	 * [removeDeviceToken] remove device token when logout
	 * @param  string $device_type 		check device is ios or android
	 * @return null
	 */
	public function removeDeviceToken($device_type = '') {
		if ($this->customer->getId()) {
			$check_exist = $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_customer_to_notification WHERE customer_id = '" . $this->customer->getId() . "'")->num_rows;
			if ($check_exist) {
				if ($device_type == 'android') {
					$this->db->query("UPDATE " . DB_PREFIX . "mobikul_customer_to_notification SET android_device_id = '' WHERE customer_id = '" . $this->customer->getId() . "'");
				}

				if ($device_type == 'ios') {
					$this->db->query("UPDATE " . DB_PREFIX . "mobikul_customer_to_notification SET ios_device_id = '' WHERE customer_id = '" . $this->customer->getId() . "'");
				}
			}
		}
	}

	/**
	 * fetch order status name by order status id
	 * @param  int $order_status_id contain order status id
	 * @return string contains order status name
	 */
	public function getOrderStatusById($order_status_id,$language_id) { 	
		$result = $this->db->query("SELECT name FROM " . DB_PREFIX . "order_status WHERE order_status_id = '" . $this->db->escape($order_status_id) . "' AND language_id = '" . $language_id . "'")->row;
		return isset($result['name']) ? $result['name'] : '';
	}

	public function languageName($id){
		$sql = "SELECT * FROM ".DB_PREFIX."language WHERE `language_id`=".$id;		 
		return $this->db->query($sql)->row;
	}

/**
 * Logins a customer
 * @param  array $data contains username and password of customer
 * @return array       contains the details of customer
 */
	public function customerLogin($data) {

		if (version_compare(VERSION,'2.2.0.0','<') && version_compare(VERSION,'2.0.0.0','>=') ) {
			$this->event->trigger('pre.customer.login');
		}
		$this->load->model('tool/image');
		$this->load->model('account/customer');
		$this->load->language('account/login');


		// Checks how many login attempts have been made.
		if(version_compare(VERSION,'2.0.0.0','>=')){
			$login_info = $this->model_account_customer->getLoginAttempts($data['username']);

			if ($login_info && ($login_info['total'] >= $this->config->get('config_login_attempts')) && strtotime('-1 hour') < strtotime($login_info['date_modified'])) {
				$error = $this->language->get('error_attempts');
			}
		}

		// Check if customer has been approved.
		$customer_info = $this->model_account_customer->getCustomerByEmail($data['username']);

		if (!$customer_info) {
			$customer_info = $this->db->query("SELECT * FROM " . DB_PREFIX . "customer WHERE telephone = '" . $data['username'] . "'")->row;
			if (isset($customer_info['email']) && $customer_info['email']) {
				$data['username'] = $customer_info['email'];
			}
		}

		if (version_compare(VERSION,'3.0.0.0','<')) {
			if ($customer_info && !$customer_info['approved']) {
				$error = $this->language->get('error_approved');
			}
		}

		if (!isset($error)) {
			if (!$this->customer->login($data['username'], $data['password'])) {
				$error['warning'] = $this->language->get('error_login');
				if(version_compare(VERSION,'2.0.0.0','>='))
				$this->model_account_customer->addLoginAttempt($data['username']);
			} else {
				if(version_compare(VERSION,'2.0.0.0','>='))
				$this->model_account_customer->deleteLoginAttempts($data['username']);

				if (version_compare(VERSION,'2.2.0.0','<') && version_compare(VERSION,'2.0.0.0','>=')) {
					$this->event->trigger('post.customer.login');
				}
			}
		} else {
			return array('error' => 1, 'message' => $error);
		}

		if (isset($error['warning'])) {
			return array('error' => 1, 'message' => $error['warning']);
		} else {
			// Add to activity log
			if(version_compare(VERSION,'2.0.0.0','>=')){
				$this->load->model('account/activity');

				$activity_data = array(
					'customer_id' => $this->customer->getId(),
					'name'        => $this->customer->getFirstName() . ' ' . $this->customer->getLastName()
				);

				$this->model_account_activity->addActivity('login', $activity_data);
			}
			$customer_data = $this->model_account_customer->getCustomer($this->customer->getId());

			$partner = 0;
			$partner_approve_required = false;

			if ($this->config->get('marketplace_status') || $this->config->get('module_marketplace_status')) {

				$this->load->model('account/customerpartner');

				if ($this->chkIsPartner($this->customer->getId())) {
					$partner = 1;
				}
				if ($partner == 0) {
					$hasApplied = $this->IsApplyForSellership($this->customer->getId());
					if ($hasApplied) {
						$partner_approve_required = true;
					}
				}
			}

			$cart_count = 0;

			if (!isset($data['android_device_id']))
			$data['android_device_id'] = '';

			if (!isset($data['ios_device_id']))
			$data['ios_device_id'] = '';

			$this->registerDeviceToken($data['android_device_id'], $data['ios_device_id']);

			if (version_compare(VERSION,'2.1.0.0','>=')) {
				$cart_count = $this->db->query("SELECT SUM(quantity) as total FROM " . DB_PREFIX . "cart WHERE customer_id = '" . $this->customer->getId() . "' OR (customer_id = '0' AND session_id = '" . $this->session->getId() . "') ")->row['total'];
			} else {
				$cart_count = $this->cart->countProducts();
			}

			$image = '';

			$return_array = array(
					'customer_id'		=> $this->customer->getId(),
					'partner'			=> $partner,
					'partner_approve_required'  => $partner_approve_required,
					'firstname'			=> html_entity_decode($this->customer->getFirstName(),ENT_QUOTES,'UTF-8'),
					'lastname'			=> html_entity_decode($this->customer->getLastName(),ENT_QUOTES,'UTF-8'),
					'email'				=> $this->customer->getEmail(),
					'phone'				=> $this->customer->getTelephone(),
					'store_id'			=> $customer_data['store_id'],
					'status'			=> $customer_data['status'],
					'cart_total'		=> $cart_count,
					'image' 	=> $image
				);
			$this->session->data['details'] = $return_array;

			return $return_array;
		}
	}

	/**
	 * [IsApplyForSellership to check customer has applied for sellership or not]
	 * @return [boolean] [true or false]
	 */

	public function IsApplyForSellership($customer_id = 0){
		$query = $this->db->query("SELECT customer_id FROM ".DB_PREFIX ."customerpartner_to_customer WHERE customer_id = '".(int)$customer_id."'")->row;

		if($query){
			return true;
		}else{
			return false;
		}
	}

	/**
	 * [chkIsPartner to check customer is partner or not]
	 * @return [boolean] [true or false]
	 */
	public function chkIsPartner($customer_id = 0) {
		if($customer_id == 0)
		$customer_id = $this->customer->getId();

		$sql = $this->db->query("SELECT * FROM ".DB_PREFIX ."customerpartner_to_customer WHERE customer_id = '" . (int)$customer_id . "'");

		if(count($sql->row) && $sql->row['is_partner']==1){
			return true;
		}else{
			return false;
		}
	}

/**
 * Logouts a customer
 * @return array contains the text shown on logout
 */
	public function customerLogout() {
		if ($this->customer->isLogged()) {
			$this->load->model('wkrestapi/customer'); 
			$this->model_wkrestapi_customer->removeDeviceToken('android');
			$this->model_wkrestapi_customer->removeDeviceToken('ios');
			if (version_compare(VERSION,'2.2.0.0','<') && version_compare(VERSION,'2.0.0.0','>=')) {
				$this->event->trigger('pre.customer.logout');
			}

			$this->customer->logout();
			$this->cart->clear();

			unset($this->session->data['wishlist']);
			unset($this->session->data['shipping_address']);
			unset($this->session->data['shipping_method']);
			unset($this->session->data['shipping_methods']);
			unset($this->session->data['payment_address']);
			unset($this->session->data['payment_method']);
			unset($this->session->data['payment_methods']);
			unset($this->session->data['comment']);
			unset($this->session->data['order_id']);
			unset($this->session->data['coupon']);
			unset($this->session->data['reward']);
			unset($this->session->data['voucher']);
			unset($this->session->data['vouchers']);

			if (version_compare(VERSION,'2.2.0.0','<') && version_compare(VERSION,'2.0.0.0','>=')) {
				$this->event->trigger('post.customer.logout');
			}
		}

		$this->load->language('account/logout');

		$logout['heading_title'] = $this->language->get('heading_title');

		$logout['text_message'] = $this->language->get('text_message');

		$logout['button_continue'] = $this->language->get('button_continue');

		return $logout;
	}

/**
 * Delete a customer information
 * @return array contains the status account deleted or not
 */
public function deleteAccount($customer_id) { 
	if ( $this->customer->isLogged()  && isset($customer_id) && $customer_id ) {
		$this->removeDeviceToken('android');
		$this->removeDeviceToken('ios');
		$this->customer->logout();
		$this->cart->clear();

		unset($this->session->data['wishlist']);
		unset($this->session->data['shipping_address']);
		unset($this->session->data['shipping_method']);
		unset($this->session->data['shipping_methods']);
		unset($this->session->data['payment_address']);
		unset($this->session->data['payment_method']);
		unset($this->session->data['payment_methods']);
		unset($this->session->data['comment']);
		unset($this->session->data['order_id']);
		unset($this->session->data['coupon']);
		unset($this->session->data['reward']);
		unset($this->session->data['voucher']);
		unset($this->session->data['vouchers']);

		$this->db->query("DELETE FROM " . DB_PREFIX . "customer WHERE customer_id = '" . (int)$customer_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "customer_activity WHERE customer_id = '" . (int)$customer_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "customer_affiliate WHERE customer_id = '" . (int)$customer_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "customer_approval WHERE customer_id = '" . (int)$customer_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "customer_reward WHERE customer_id = '" . (int)$customer_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "customer_transaction WHERE customer_id = '" . (int)$customer_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "customer_ip WHERE customer_id = '" . (int)$customer_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "address WHERE customer_id = '" . (int)$customer_id . "'");
		
		if ($this->config->get('marketplace_status') || $this->config->get('module_marketplace_status')) {
			if ($this->chkIsPartner($customer_id)) {
				$customer = $this->db->query("SELECT customer_id,companyname,screenname FROM " . DB_PREFIX . "customerpartner_to_customer where customer_id=" .  (int)$customer_id)->row;
				if (isset($customer) && $customer) {
					$this->db->query("UPDATE " . DB_PREFIX . "customerpartner_to_customer SET screenname = '(deleted) " . $customer['screenname'] . "',companyname = '(deleted) " .  $customer['companyname']  . "' WHERE screenname = '" . $customer['screenname'] . "'");
				}
			}
		}
		
		return true;

	}

	return false;
}
/**
 * Removes an item from the wishlist
 * @param  integer $product_id contains the product's ID
 * @return array             returns error and message if exists
 */
	public function removeFromWishlist($product_id) {

		$this->load->language('account/wishlist');

		if (version_compare(VERSION,'2.1.0.0','>=')) {

			$this->load->model('account/wishlist');

			if ($product_id) {
				// Remove Wishlist
				$this->model_account_wishlist->deleteWishlist($product_id);

				return $this->language->get('text_remove');
			} else {
				return false;
			}

		} else {
			$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "customer WHERE customer_id = '" . (int)$this->customer->getId() . "'")->row;

			$wishListItems = unserialize($query['wishlist']);

			if(($key = array_search($product_id, $wishListItems)) !== false) {
			    unset($wishListItems[$key]);
			}

			$update = $this->db->query("UPDATE " . DB_PREFIX . "customer SET wishlist = '" . serialize($wishListItems) . "' WHERE customer_id = '" . (int)$this->customer->getId() . "'");

			if (is_array($this->session->data['wishlist'])) {

				$keys = array_keys($this->session->data['wishlist'], $product_id);

				if ($keys) {
					foreach ($keys as $value) {
						unset($this->session->data['wishlist'][$value]);
					}
				}
			}

			if ($update) {
				return $this->language->get('text_remove');
			} else {
				return false;
			}
		}
	}



/**
 * forgot password process
 * @param  array $data contains customer data
 * @return array       return error if exists
 */
	public function forgotPassword($data) {
		$this->load->model('account/customer');
		$this->load->language('account/forgotten');

		$error = array();

		if (!isset($data['email'])) {
			$error['warning'] = $this->language->get('error_email');
		} elseif (!$this->model_account_customer->getTotalCustomersByEmail($data['email'])) {
			$error['warning'] = $this->language->get('error_email');
		}

		if (!$error) {

			$email = $data['email'];

			$this->load->language('mail/forgotten');

			$password = substr(sha1(uniqid(mt_rand(), true)), 0, 10);

			$this->model_account_customer->editPassword($email, $password);

			$subject = sprintf($this->language->get('text_subject'), html_entity_decode($this->config->get('config_name'), ENT_QUOTES, 'UTF-8'));

			$message  = sprintf($this->language->get('text_greeting'), html_entity_decode($this->config->get('config_name'), ENT_QUOTES, 'UTF-8')) . "\n\n";
			$message .= $this->language->get('text_password') . "\n\n";
			$message .= $password;

			if (version_compare(VERSION,'2.0.0.0','>=')) {
				$mail = new Mail();
				$mail->protocol = $this->config->get('config_mail_protocol');
				$mail->parameter = $this->config->get('config_mail_parameter');
				$mail->smtp_hostname = $this->config->get('config_mail_smtp_hostname');
				$mail->smtp_username = $this->config->get('config_mail_smtp_username');
				$mail->smtp_password = html_entity_decode($this->config->get('config_mail_smtp_password'), ENT_QUOTES, 'UTF-8');
				$mail->smtp_port = $this->config->get('config_mail_smtp_port');
				$mail->smtp_timeout = $this->config->get('config_mail_smtp_timeout');
			} else {
				$mail = new Mail();
				$mail->protocol = $this->config->get('config_mail_protocol');
				$mail->parameter = $this->config->get('config_mail_parameter');
				$mail->hostname = $this->config->get('config_smtp_host');
				$mail->username = $this->config->get('config_smtp_username');
				$mail->password = $this->config->get('config_smtp_password');
				$mail->port = $this->config->get('config_smtp_port');
				$mail->timeout = $this->config->get('config_smtp_timeout');
			}
			$mail->setTo($email);
			$mail->setFrom($this->config->get('config_email'));
			$mail->setSender(html_entity_decode($this->config->get('config_name'), ENT_QUOTES, 'UTF-8'));
			$mail->setSubject($subject);
			$mail->setText($message);
			$mail->send();

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
			return $return_array;

		} else {
			$return_array = array(
					'error'		=> 1,
					'message'	=> $error['warning']
				);
			return $return_array;
		}
	}
/**
 * fetches download data of a file
 * @param  integer $download_id contains download ID of a product
 * @param  integer $customer_id contains customer ID
 * @return array              contains download file name and mask
 */
	public function getDownload($download_id,$customer_id) {
		$implode = array();

		$order_statuses = $this->config->get('config_complete_status');

		foreach ($order_statuses as $order_status_id) {
			$implode[] = "o.order_status_id = '" . (int)$order_status_id . "'";
		}

		if ($implode) {
			$query = $this->db->query("SELECT d.filename, d.mask FROM `" . DB_PREFIX . "order` o LEFT JOIN " . DB_PREFIX . "order_product op ON (o.order_id = op.order_id) LEFT JOIN " . DB_PREFIX . "product_to_download p2d ON (op.product_id = p2d.product_id) LEFT JOIN " . DB_PREFIX . "download d ON (p2d.download_id = d.download_id) WHERE o.customer_id = '" . (int)$customer_id . "' AND (" . implode(" OR ", $implode) . ") AND d.download_id = '" . (int)$download_id . "'");

			return $query->row;
		} else {
			return;
		}
	}
/**
 * fetches country and zone data
 * @return array returns country and zone data
 */
	public function getCountryData() {
		$country = $this->db->query("SELECT * FROM `" . DB_PREFIX . "country` WHERE status = '1'")->rows;

		$country_info = array();

		foreach ($country as $country) {
			$zone = $this->db->query("SELECT zone_id, name FROM `" . DB_PREFIX . "zone` WHERE country_id = '". $country['country_id'] ."' AND status = '1' ORDER BY name")->rows;

			foreach($zone as $key => $value) {
				if (isset($zone[$key]['name'])) {
					$zone[$key]['name'] = html_entity_decode($zone[$key]['name'],ENT_QUOTES,'UTF-8');
				}
			}

			$country_info[] = array(
					'country_id'	=> $country['country_id'],
					'name'			=> html_entity_decode($country['name'],ENT_QUOTES,'UTF-8'),
					'zone'			=> $zone,
				);
		}
		if ($country_info) {
			return $country_info;
		} else {
			return false;
		}
	}

	public function getCategories($data = array()) {
		$sql = "SELECT cp.category_id AS category_id, mc.category_image, c1.image, mc.category_icon, GROUP_CONCAT(cd1.name ORDER BY cp.level SEPARATOR '&nbsp;&nbsp;&gt;&nbsp;&nbsp;') AS name, c1.parent_id FROM " . DB_PREFIX . "category_path cp LEFT JOIN " . DB_PREFIX . "category c1 ON (cp.category_id = c1.category_id) LEFT JOIN " . DB_PREFIX . "category c2 ON (cp.path_id = c2.category_id) LEFT JOIN " . DB_PREFIX . "category_description cd1 ON (cp.path_id = cd1.category_id) LEFT JOIN " . DB_PREFIX . "category_description cd2 ON (cp.category_id = cd2.category_id) LEFT JOIN " . DB_PREFIX . "mobikul_category mc ON (cp.category_id = mc.category_id) WHERE cd1.language_id = '" . (int)$this->config->get('config_language_id') . "' AND cd2.language_id = '" . (int)$this->config->get('config_language_id') . "'";

		if (!empty($data['filter_name'])) {
			$sql .= " AND cd2.name LIKE '%" . $this->db->escape($data['filter_name']) . "%'";
		}

		$sql .= " GROUP BY cp.category_id";

		$sort_data = array(
			'name',
			'mc.category_image',
			'mc.category_icon'
		);

		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY name";
		}

		if (isset($data['order']) && ($data['order'] == 'DESC')) {
			$sql .= " DESC";
		} else {
			$sql .= " ASC";
		}	

		if (isset($data['filter_count'])) {
			
			if ($data['filter_count'] < 1) {
				$data['filter_count'] = 10;
			}

			$sql .= " LIMIT " . 0 . "," . (int)$data['filter_count'];
		}
		$query = $this->db->query($sql);

		return $query->rows;
	}

	public function getProductReviews($data = array()) {
		$sql = "SELECT r.review_id, r.text, r.status, r.rating, p.product_id, pd.name as product_name, p.image  FROM " . DB_PREFIX . "review r LEFT JOIN " . DB_PREFIX . "product p ON(r.product_id = p.product_id) LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON(p.product_id = p2s.product_id) LEFT JOIN " . DB_PREFIX . "product_description pd ON(p.product_id = pd.product_id) WHERE r.customer_id = '" . $this->customer->getId() . "' AND p.status='1' AND pd.language_id = '" . $this->config->get('config_language_id') . "' AND p2s.store_id = '" . $this->config->get('config_store_id') . "'";

		if(isset($data['filter_product_name']) && $data['filter_product_name']) {
			$sql .= " AND pd.name LIKE '%" . $this->db->escape($data['filter_product_name']) . "%'";
		}

		if(isset($data['filter_rating']) && $data['filter_rating']) {
			$sql .= " AND r.rating = '" . $this->db->escape($data['filter_rating']) . "'";
		}

		$sql .= " ORDER BY r.date_added";

		if(!isset($data['limit'])) {
			$data['limit'] = 10;
		}

		if(!isset($data['page'])) {
			$data['page'] = 1;
		}

		$start = ((int) $data['page'] - 1) * (int) $data['limit'];

		$sql .= " LIMIT " . $start . "," . (int) $data['limit'];

		$query = $this->db->query($sql);

		return $query->rows;
	}

	public function getTotalProductReviews($data = array()) {
		$sql = "SELECT COUNT(*) as total  FROM " . DB_PREFIX . "review r LEFT JOIN " . DB_PREFIX . "product p ON(r.product_id = p.product_id) LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON(p.product_id = p2s.product_id) LEFT JOIN " . DB_PREFIX . "product_description pd ON(p.product_id = pd.product_id) WHERE r.customer_id = '" . $this->customer->getId() . "' AND p.status='1' AND pd.language_id = '" . $this->config->get('config_language_id') . "' AND p2s.store_id = '" . $this->config->get('config_store_id') . "'";

		if(isset($data['filter_product_name']) && $data['filter_product_name']) {
			$sql .= " AND pd.name LIKE '%" . $this->db->escape($data['filter_product_name']) . "%'";
		}

		if(isset($data['filter_rating']) && $data['filter_rating']) {
			$sql .= " AND r.rating = '" . $this->db->escape($data['filter_rating']) . "'";
		}

		$query = $this->db->query($sql);

		return (int) $query->row['total'];
	}
}
