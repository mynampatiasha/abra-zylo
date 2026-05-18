<?php
class ModelWkrestapiCatalog extends Model
{

	/**
	 * Fetches the notification previous hour
	 * @return array returns notifications
	 */
	public function getNotifications()
	{

		/**
		 * addition in query to fetch previous hour data in case of pull notifications
		 * @var string
		 */
		$hour_before = date('Y-m-d H:i:s', strtotime(date('Y-m-d H:i:s') . ' -1 hour'));
		if ($this->config->get('mobikul_status')) {

			$sql = "SELECT * FROM " . DB_PREFIX . "mobikul_notification mn LEFT JOIN " . DB_PREFIX . "mobikul_notification_description mnd ON (mn.notification_id = mnd.notification_id) WHERE mnd.language_id = '" . $this->config->get('config_language_id') . "' AND date_added > '" . $hour_before . "'";

			$results = $this->db->query($sql)->rows;

			$this->load->model('catalog/product');
			$this->load->model('tool/image');
			$notifications = array();

			foreach ($results as $result) {
				$type = '';

				if ($result['type'] == 1) {
					$type = 'product';
				} elseif ($result['type'] == 2) {
					$type = 'category';
				} elseif ($result['type'] == 3) {
					$type = 'other';
				} elseif ($result['type'] == 4) {
					$type = 'Custom';
				}

				$notifications[] = array(
					'notification_id' => $result['notification_id'],
					'title'		=> html_entity_decode($result['title'], ENT_QUOTES, 'UTF-8'),
					'type'		=> $type ? $type : $result['type'],
					'id'		=> $result['pro_cat_id'],
					'content'	=> $result['content'],
					'bannerImage' => HTTP_SERVER . "image/" . $result['image'],
					'subTitle'	=> strip_tags(html_entity_decode($result['content']))
				);
			}

			$return_array = array(
				'notifications'	=> $notifications,
				'error'			=> 0
			);
		} else {
			$return_array = array(
				'error'			=> 1
			);
		}
		return $return_array;
	}

	public function getProductLanguage()
	{
		$this->load->model('localisation/language');
		$results = $this->model_localisation_language->getLanguages();

		foreach ($results as $result) {
			if ($result['status']) {
				$data['languages'][] = array(
					'language_id'  => $result['language_id'],
					'name'  => $result['name'],
					'code'  => $result['code'],
					'image' => HTTP_SERVER . 'catalog/language/' . $result['code'] . '/' . $result['code'] . '.png'
				);
			}
		}
		return $data;
	}

	public function getOldPartner($start, $limit)
	{
		return $this->db->query("SELECT *,co.name as country,companylocality FROM " . DB_PREFIX . "customerpartner_to_customer c2c LEFT JOIN " . DB_PREFIX . "customer c ON (c2c.customer_id = c.customer_id) LEFT JOIN " . DB_PREFIX . "country co ON (c2c.country = co.iso_code_2) WHERE is_partner = 1 AND c.status = '1' ORDER BY c2c.customer_id ASC LIMIT " . $start . ',' . $limit . "")->rows;
	}

	public function getTotalOldPartner()
	{
		return $this->db->query("SELECT *,co.name as country,companylocality FROM " . DB_PREFIX . "customerpartner_to_customer c2c LEFT JOIN " . DB_PREFIX . "customer c ON (c2c.customer_id = c.customer_id) LEFT JOIN " . DB_PREFIX . "country co ON (c2c.country = co.iso_code_2) WHERE is_partner = 1 AND c.status = '1' ORDER BY c2c.customer_id ASC")->num_rows;
	}

	/*
    Fetches the AR products and return boolean
   */
	public function checkAR($product_id = 0)
	{
		$ar_exist = $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_ar WHERE product_id = '" . $product_id . "'")->row;
		if ((isset($ar_exist['android_file']) && $ar_exist['android_file']) || (isset($ar_exist['ios_file']) && $ar_exist['ios_file'])) {
			return true;
		} else {
			return false;
		}
	}
	/**
	 * Fetches lastest 20 notifications
	 * @return array contains notifications
	 */
	public function viewNotifications($width)
	{

		if ($this->config->get('mobikul_status')) {

			$sql = "SELECT * FROM " . DB_PREFIX . "mobikul_notification mn LEFT JOIN " . DB_PREFIX . "mobikul_notification_description mnd ON (mn.notification_id = mnd.notification_id) WHERE mnd.language_id = '" . $this->config->get('config_language_id') . "' AND mn.status = '1' ORDER BY date_added DESC LIMIT 0,20";

			$results = $this->db->query($sql)->rows;

			$notifications = array();
			$this->load->model('catalog/product');
			$this->load->model('tool/image');
			foreach ($results as $result) {

				$type = '';

				if ($result['type'] == 1) {
					$type = 'product';
				} elseif ($result['type'] == 2) {
					$type = 'category';
				} elseif ($result['type'] == 3) {
					$type = 'other';
				} elseif ($result['type'] == 4) {
					$type = 'Custom';
				}

				if (isset($result['image']) && is_file(DIR_IMAGE . $result['image'])) {
					$dc_image = DIR_IMAGE . $result['image'];
					$this->load->model('tool/image');
					$image = $this->model_tool_image->resize($result['image'], $width, $width / 2);
				} elseif (is_file(DIR_IMAGE . 'placeholder.png')) {
					$dc_image = DIR_IMAGE . 'placeholder.png';
					$this->load->model('tool/image');
					$image = $this->model_tool_image->resize('placeholder.png', $width, $width / 2);
				} else {
					$dc_image = '';
					$image = '';
				}

				$dominant_color = $this->getDominantColor($dc_image);

				$notifications[] = array(
					'notification_id' => $result['notification_id'],
					'title'		=> html_entity_decode($result['title'], ENT_QUOTES, 'UTF-8'),
					'image'   => $image,
					'dominant_color' => $dominant_color,
					'type'		=> $type ? $type : $result['type'],
					'id'		=> $result['pro_cat_id'],
					'content'	=> html_entity_decode(strip_tags(html_entity_decode($result['content'], ENT_QUOTES, 'UTF-8')), ENT_QUOTES, 'UTF-8'),
					'subTitle'	=> html_entity_decode(strip_tags(html_entity_decode($result['content'], ENT_QUOTES, 'UTF-8')), ENT_QUOTES, 'UTF-8'),
				);
			}

			$return_array = array(
				'notifications'	=> $notifications,
				'error'			=> 0
			);
		} else {
			$return_array = array(
				'error'			=> 1
			);
		}
		return $return_array;
	}
	/**
	 * writes the review of a product
	 * @param  array $reviewData contains review data
	 * @return array             returns error if exists
	 */
	public function writeReview($reviewData)
	{
		$this->load->language('product/product');

		$json = array();

		if ($reviewData) {
			if ((utf8_strlen($reviewData['name']) < 3) || (utf8_strlen($reviewData['name']) > 25)) {
				$json['error'] = $this->language->get('error_name');
			}

			if ((utf8_strlen($reviewData['text']) < 25) || (utf8_strlen($reviewData['text']) > 1000)) {
				$json['error'] = $this->language->get('error_text');
			}

			if (empty($reviewData['rating']) || $reviewData['rating'] < 0 || $reviewData['rating'] > 5) {
				$json['error'] = $this->language->get('error_rating');
			}

			if (!isset($json['error'])) {
				$this->load->model('catalog/review');

				$this->model_catalog_review->addReview($reviewData['product_id'], $reviewData);

				$json['message'] = $this->language->get('text_success');
				$json['error'] = 0;
			}
		}
		return $json;
	}

	/**
	 * Return Best Sell Product
	 * @param  array $count contains limit of products
	 * @return array             return count number of latest data
	 */

	public function getBestSellerTotal($data = array())
	{

		$this->load->model('catalog/product');

		$this->load->model('tool/image');

		$sql = "SELECT COUNT(DISTINCT op.product_id) as total 
FROM " . DB_PREFIX . "order_product op 
LEFT JOIN `" . DB_PREFIX . "order` o ON (op.order_id = o.order_id) 
LEFT JOIN " . DB_PREFIX . "product_description as pd on op.product_id = pd.product_id 
LEFT JOIN `" . DB_PREFIX . "product` p ON (op.product_id = p.product_id) 
LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON (p.product_id = p2s.product_id) 
WHERE o.order_status_id > '0' 
AND p.status = '1' 
AND p.date_available <= NOW() 
AND p2s.store_id = '" . (int)$this->config->get('config_store_id') . "'";


		$query = $this->db->query($sql);
		return $query->row['total'];
	}


	public function getBestSeller($data = array())
	{

		$this->load->model('catalog/product');

		$this->load->model('tool/image');

		if (isset($data['sort']) && !empty($data['sort'])) {
			$sort = $data['sort'];
		} else {
			$sort = 'total';
		}

		if (isset($data['order']) && !empty($data['order'])) {
			$order = $data['order'];
		} else {
			$order = 'DESC';
		}

		if (isset($data['page'])) {
			$page = $data['page'];
		} else {
			$page = 1;
		}

		if (isset($data['limit'])) {
			$limit = $data['limit'];
		} elseif (isset($data['count'])) {
			$limit = $data['count'];
		} else {
			$limit = 5;
		}

		$page = ($page - 1) * $limit;

		$sql = "SELECT DISTINCT op.product_id, SUM(op.quantity) AS total, 
    (SELECT price FROM " . DB_PREFIX . "product_discount pd2 
    WHERE pd2.product_id = p.product_id 
    AND pd2.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
    AND pd2.quantity = '1' 
    AND ((pd2.date_start = '0000-00-00' OR pd2.date_start < NOW()) 
    AND (pd2.date_end = '0000-00-00' OR pd2.date_end > NOW())) 
    ORDER BY pd2.priority ASC, pd2.price ASC LIMIT 1) AS discount, 
    (SELECT price FROM " . DB_PREFIX . "product_special ps 
    WHERE ps.product_id = p.product_id 
    AND ps.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
    AND ((ps.date_start = '0000-00-00' OR ps.date_start < NOW()) 
    AND (ps.date_end = '0000-00-00' OR ps.date_end > NOW())) 
    ORDER BY ps.priority ASC, ps.price ASC LIMIT 1) AS special 
FROM " . DB_PREFIX . "order_product op 
LEFT JOIN `" . DB_PREFIX . "order` o ON (op.order_id = o.order_id) 
LEFT JOIN " . DB_PREFIX . "product_description as pd on op.product_id = pd.product_id 
LEFT JOIN `" . DB_PREFIX . "product` p ON (op.product_id = p.product_id) 
LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON (p.product_id = p2s.product_id) 
WHERE o.order_status_id > '0' 
AND p.status = '1' 
AND p.date_available <= NOW() 
AND p2s.store_id = '" . (int)$this->config->get('config_store_id') . "' 
GROUP BY op.product_id";


		$sort_data = array(
			'pd.name',
			'p.model',
			'p.price',
			'p.sort_order',
		);
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			if ($data['sort'] == 'pd.name' || $data['sort'] == 'p.model') {
				$sql .= " ORDER BY LCASE(" . $data['sort'] . ")";
			} elseif ($data['sort'] == 'p.price') {
				$sql .= " ORDER BY (CASE WHEN special IS NOT NULL THEN special WHEN discount IS NOT NULL THEN discount ELSE p.price END)";
			}
			if (isset($data['order']) && ($data['order'] == 'DESC')) {
				$sql .= " DESC";
			} else {
				$sql .= " ASC";
			}
		} else {
			$sql .= " ORDER BY p.sort_order DESC";
		}

		if (!isset($data['total'])) {
			$sql .=  " LIMIT " . $page . "," . $limit;
		} else {
			return $this->db->query($sql)->num_rows;
		}

		$query = $this->db->query($sql)->rows;

		if (!empty($query)) {
			foreach ($query as $result) {
				$results[$result['product_id']] = $this->model_catalog_product->getProduct($result['product_id']);
			}
		} else {
			$results = array();
		}
		$best_seller = array();

		if (!empty($results)) {
			foreach ($results as $result) {

				if (isset($result['product_id']) && $result['product_id']) {

					$already_status = false;
					if (version_compare(VERSION, '2.1.0.1	', '>=')) {
						foreach ($this->getDBWishlist() as $wishlist) {
							if ($wishlist['product_id'] == $result['product_id']) {
								$already_status = true;
							}
						}
					}

					if ($result['image']) {
						$image = str_replace(' ', '%20', $this->model_tool_image->resize($result['image'], $data['width'], $data['width']));
					} else {
						$image = $this->model_tool_image->resize('placeholder.png',  $data['width'], $data['width']);
					}

					if ($this->customer->isLogged() || !$this->config->get('config_customer_price')) {
						$price = $this->currency->format($this->tax->calculate($result['price'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
					} else {
						$price = false;
					}

					if ((float)$result['special']) {
						$formatedSpecial = $this->currency->format($this->tax->calculate($result['special'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
						$special = $result['special'];
					} else {
						$formatedSpecial = '';
						$special = 0.00;
					}

					if ($this->config->get('config_tax')) {
						$tax = $this->currency->format((float)$result['special'] ? $result['special'] : $result['price'], $this->session->data['currency']);
					} else {
						$tax = false;
					}

					if ($this->config->get('config_review_status')) {
						$rating = $result['rating'];
					} else {
						$rating = 0;
					}

					if (isset($result['image']) && is_file(DIR_IMAGE . $result['image']))
						$dc_image = DIR_IMAGE . $result['image'];
					elseif (is_file(DIR_IMAGE . 'placeholder.png'))
						$dc_image = DIR_IMAGE . 'placeholder.png';
					else
						$dc_image = '';

					$dominant_color = $this->getDominantColor($dc_image);

					$set_date = $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_product_set_date WHERE product_id = " . $result['product_id'])->row;

					$best_seller[] = array(
						'product_id' => $result['product_id'],
						'thumb'   	 => $image,
						'dominant_color' => $dominant_color,
						'name'    	 => html_entity_decode($result['name'], ENT_QUOTES, "UTF-8"),
						'price'   	 => $price,
						'quantity' 	 => $result['quantity'],
						'special' 	 => (float) $special,
						'formatted_special' => $formatedSpecial,
						'tax'        => $tax == false ? '' : $tax,
						'rating'     => $rating,
						'reviews'    => sprintf($this->language->get('text_reviews'), (int)$result['reviews']),
						'hasOption'  => $this->productOption($result['product_id']),
						'wishlist_status' => $already_status,
						'start_date' => isset($set_date['start_date']) ? $set_date['start_date'] : '',
						'close_date' => isset($set_date['close_date']) ? $set_date['close_date'] : ''
					);
				}
			}
		}
		return $best_seller;
	}

	/**
	 * Return Best Sell Product
	 * @param  array $count contains limit of products
	 * @return array             return count number of latest data
	 */
	public function getPopularProductTotal($data = array())
	{
		$this->load->model('catalog/product');

		$this->load->model('tool/image');

		$language_id = $this->getLanguageIdByCode($this->session->data['language']);

		if (!isset($language_id['id']))
			$language_id['id'] = '1';

		$sql = "SELECT COUNT(DISTINCT p.product_id) as total 
			FROM " . DB_PREFIX . "product p 
			LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON (p.product_id = p2s.product_id) 
			LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) 
			WHERE p.status = '1' 
			AND p.date_available <= NOW() 
			AND p2s.store_id = '" . (int)$this->config->get('config_store_id') . "' 
			AND pd.language_id= '" . $language_id['id'] . "'";



		$query = $this->db->query($sql);
		return $query->row['total'];
	}




	public function getPopularProduct($data = array())
	{

		$this->load->model('catalog/product');

		$this->load->model('tool/image');

		if (isset($data['sort']) && $data['sort']) {
			$sort = $data['sort'];
		} else {
			$sort = 'p.viewed DESC, p.date_added';
		}

		if (isset($data['order']) && !empty($data['order'])) {
			$order = $data['order'];
		} else {
			$order = 'DESC';
		}

		if (isset($data['page']) && !empty($data['page'])) {
			$page = $data['page'];
		} else {
			$page = 1;
		}

		if (isset($data['limit']) && !empty($data['limit'])) {
			$limit = $data['limit'];
		} elseif (isset($data['count']) && !empty($data['count'])) {
			$limit = $data['count'];
		} else {
			$limit = 5;
		}

		$page = ($page - 1) * $limit;

		$language_id = $this->getLanguageIdByCode($this->session->data['language']);

		if (!isset($language_id['id']))
			$language_id['id'] = '1';

		

		$sql = "SELECT DISTINCT p.product_id, 
    (SELECT price FROM " . DB_PREFIX . "product_discount pd2 
    WHERE pd2.product_id = p.product_id 
    AND pd2.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
    AND pd2.quantity = '1' 
    AND ((pd2.date_start = '0000-00-00' OR pd2.date_start < NOW()) 
    AND (pd2.date_end = '0000-00-00' OR pd2.date_end > NOW())) 
    ORDER BY pd2.priority ASC, pd2.price ASC LIMIT 1) AS discount, 
    (SELECT price FROM " . DB_PREFIX . "product_special ps 
    WHERE ps.product_id = p.product_id 
    AND ps.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
    AND ((ps.date_start = '0000-00-00' OR ps.date_start < NOW()) 
    AND (ps.date_end = '0000-00-00' OR ps.date_end > NOW())) 
    ORDER BY ps.priority ASC, ps.price ASC LIMIT 1) AS special 
FROM " . DB_PREFIX . "product p 
LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON (p.product_id = p2s.product_id) 
LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) 
WHERE p.status = '1' 
AND p.date_available <= NOW() 
AND p2s.store_id = '" . (int)$this->config->get('config_store_id') . "' 
AND pd.language_id= '" . $language_id['id'] . "'";


		$sort_data = array(
			'pd.name',
			'p.model',
			'p.price',
			'p.sort_order',
		);
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			if ($data['sort'] == 'pd.name' || $data['sort'] == 'p.model') {
				$sql .= " ORDER BY LCASE(" . $data['sort'] . ")";
			} elseif ($data['sort'] == 'p.price') {
				$sql .= " ORDER BY (CASE WHEN special IS NOT NULL THEN special WHEN discount IS NOT NULL THEN discount ELSE p.price END)";
			}
			if (isset($data['order']) && ($data['order'] == 'DESC')) {
				$sql .= " DESC";
			} else {
				$sql .= " ASC";
			}
		} else {
			$sql .= " ORDER BY p.viewed DESC";
		}


		if (!isset($data['total'])) {
			$sql .=  " LIMIT " . $page . "," . $limit;
		} else {
			return $this->db->query($sql)->num_rows;
		}

		$query = $this->db->query($sql)->rows;

		if (!empty($query)) {
			foreach ($query as $result) {
				$results[$result['product_id']] = $this->model_catalog_product->getProduct($result['product_id']);
			}
		} else {
			$results = array();
		}
		$best_seller = array();

		if (!empty($results)) {
			foreach ($results as $result) {

				if (isset($result['product_id']) && $result['product_id']) {

					$already_status = false;
					if (version_compare(VERSION, '2.1.0.1	', '>=')) {
						foreach ($this->getDBWishlist() as $wishlist) {
							if ($wishlist['product_id'] == $result['product_id']) {
								$already_status = true;
							}
						}
					}

					if ($result['image']) {
						$image = str_replace(' ', '%20', $this->model_tool_image->resize($result['image'], $data['width'], $data['width']));
					} else {
						$image = $this->model_tool_image->resize('placeholder.png',  $data['width'], $data['width']);
					}

					if ($this->customer->isLogged() || !$this->config->get('config_customer_price')) {
						$price = $this->currency->format($this->tax->calculate($result['price'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
					} else {
						$price = false;
					}

					if ((float)$result['special']) {
						$formatedSpecial = $this->currency->format($this->tax->calculate($result['special'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
						$special = $result['special'];
					} else {
						$formatedSpecial = '';
						$special = 0.00;
					}

					if ($this->config->get('config_tax')) {
						$tax = $this->currency->format((float)$result['special'] ? $result['special'] : $result['price'], $this->session->data['currency']);
					} else {
						$tax = false;
					}

					if ($this->config->get('config_review_status')) {
						$rating = $result['rating'];
					} else {
						$rating = 0;
					}

					if (isset($result['image']) && is_file(DIR_IMAGE . $result['image']))
						$dc_image = DIR_IMAGE . $result['image'];
					elseif (is_file(DIR_IMAGE . 'placeholder.png'))
						$dc_image = DIR_IMAGE . 'placeholder.png';
					else
						$dc_image = '';

					$dominant_color = $this->getDominantColor($dc_image);

					$set_date = $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_product_set_date WHERE product_id = " . $result['product_id'])->row;

					$best_seller[] = array(
						'product_id' => $result['product_id'],
						'thumb'   	 => $image,
						'dominant_color' => $dominant_color,
						'name'    	 => html_entity_decode($result['name'], ENT_QUOTES, "UTF-8"),
						'price'   	 => $price,
						'quantity' 	 => $result['quantity'],
						'special' 	 => (float) $special,
						'formatted_special' => $formatedSpecial,
						'tax'        => $tax == false ? '' : $tax,
						'rating'     => $rating,
						'reviews'    => sprintf($this->language->get('text_reviews'), (int)$result['reviews']),
						'hasOption'  => $this->productOption($result['product_id']),
						'wishlist_status' => $already_status,
						'start_date' => isset($set_date['start_date']) ? $set_date['start_date'] : '',
						'close_date' => isset($set_date['close_date']) ? $set_date['close_date'] : ''
					);
				}
			}
		}
		return $best_seller;
	}

	public function getLanguageIdByCode($code = '')
	{
		return $this->db->query("SELECT language_id as id FROM " . DB_PREFIX . "language WHERE code = '" . $code . "'")->row;
	}

	/**
	 * Fetch image average hexdecimal
	 */

	public function getDominantColor($filePath)
	{

		$hash = md5($filePath);
		$json_file = DIR_APPLICATION . 'controller/api/wkrestapi/color.json';
		$json_data = json_decode(file_get_contents($json_file), true);

		if (is_array($json_data) && key_exists($hash, $json_data))
			return $json_data[$hash];

		$total = $blueTotal = $greenTotal = $redTotal = 0;
		if (pathinfo($filePath, PATHINFO_EXTENSION) == 'jpg') {
			$image = @imagecreatefromjpeg($filePath);
		} elseif (pathinfo($filePath, PATHINFO_EXTENSION) == 'png') {
			$image = @imagecreatefrompng($filePath);
		} elseif (pathinfo($filePath, PATHINFO_EXTENSION) == 'gd') {
			$image = @imagecreatefromgd($filePath);
		} elseif (pathinfo($filePath, PATHINFO_EXTENSION) == 'xbm') {
			$image = @imagecreatefromxbm($filePath);
		} elseif (pathinfo($filePath, PATHINFO_EXTENSION) == 'xpm') {
			$image = @imagecreatefromxpm($filePath);
		} else {
			$image = '';
		}

		if (!$image) {
			$json_data[$hash] = '#000000';
			file_put_contents($json_file, json_encode($json_data));
			return '#000000';
		}

		for ($x = 0; $x < @imagesx($image); $x++) {
			for ($y = 0; $y < @imagesy($image); $y++) {
				$rgb = @imagecolorat($image, $x, $y);
				$red = ($rgb >> 16) & 0xFF;
				$green = ($rgb >> 8) & 0xFF;
				$blue = $rgb & 0xFF;
				$redTotal += $red;
				$greenTotal += $green;
				$blueTotal += $blue;
				$total++;
			}
		}
		$redAverage = $total ? round($redTotal / $total) : 0;
		$greenAverage = $total ? round($greenTotal / $total) : 0;
		$blueAverage = $total ? round($blueTotal / $total) : 0;

		$json_data[$hash] = sprintf("#%02x%02x%02x", $redAverage, $greenAverage, $blueAverage);
		file_put_contents($json_file, json_encode($json_data));
		return sprintf("#%02x%02x%02x", $redAverage, $greenAverage, $blueAverage);
	}


	/**
	 * fetches the language content
	 * @return array returns the language content
	 */
	public function languages()
	{

		if (version_compare(VERSION, '2.0.0.0', '<')) {
			$this->load->language('module/language');
		} else {
			$this->load->language('common/language');
		}
		$data['text_language'] = $this->language->get('text_language');

		$data['code'] = $this->session->data['language'];
		$data['image'] = '';

		$this->load->model('localisation/language');

		$data['languages'] = array();

		$results = $this->model_localisation_language->getLanguages();

		foreach ($results as $result) {
			if ($result['status']) {
				$data['languages'][] = array(
					'name'  => $result['name'],
					'code'  => $result['code'],
					'image' => HTTP_SERVER . 'catalog/language/' . $result['code'] . '/' . $result['code'] . '.png'
				);
			}
			if ($result['code'] == $data['code']) {
				$data['image'] = HTTP_SERVER . 'catalog/language/' . $result['code'] . '/' . $result['code'] . '.png';
			}
		}
		return $data;
	}
	/**
	 * Fetches the currency data
	 * @return array return the currency content
	 */
	public function currencies()
	{

		if (version_compare(VERSION, '2.0.0.0', '<')) {
			$this->load->language('module/currency');
		} else {
			$this->load->language('common/currency');
		}

		$data['text_currency'] = $this->language->get('text_currency');

		if (version_compare(VERSION, '2.1.0.0', '>=')) {
			$data['code'] = $this->session->data['currency'];
		} else {
			$data['code'] = $this->currency->getCode();
		}

		$this->load->model('localisation/currency');

		$data['currencies'] = array();

		$results = $this->model_localisation_currency->getCurrencies();

		foreach ($results as $result) {
			if ($result['status']) {
				$data['currencies'][] = array(
					'title'        => (($result['symbol_left']) ? $result['symbol_left'] : $result['symbol_right']) . ' ' . $result['title'],
					'code'         => $result['code']
				);
			}
			if ($result['code'] == $data['code']) {
				$data['text_currency'] = '<b>' . (($result['symbol_left']) ? $result['symbol_left'] : $result['symbol_right']) . '</b> ' . $this->language->get('text_currency');
			}
		}
		return $data;
	}
	/**
	 * Fetches the banners for home page
	 * @param  integer $width contains the width of device
	 * @return array        contains banner data
	 */
	public function banners($banner_id, $width)
	{
		$this->load->model('tool/image');
		$banners = array();
		$id = explode("_", $banner_id)[1];
		if ($this->config->get('mobikul_status')) {

			$results = $this->db->query("SELECT * FROM `" . DB_PREFIX . "mobikul_banner` mb LEFT JOIN `" . DB_PREFIX . "mobikul_banner_description` mbd ON (mb.id = mbd.id) WHERE mb.id= " . $id . " AND mbd.language_id = '" . (int)$this->config->get('config_language_id') . "' ORDER BY mb.sort_order")->row;

			if ($results) {
				$type = '';

				if ($results['type'] == 1) {
					$type = 'product';
					$link = $results['pro_cat_id'];
				} elseif ($results['type'] == 2) {
					$type = 'category';
					$link = $results['pro_cat_id'];
				} elseif ($results['type'] == 3) {
					$type = 'external_link';
					$link = $results['name'];
				} elseif ($results['type'] == 4) {
					$type = 'no_link';
					$link = '';
				}

				if ($results['image']) {
					$image = str_replace(' ', '%20', $this->model_tool_image->resize($results['image'], $width, $width / 2));
				} else {
					$image = $this->model_tool_image->resize('placeholder.png',  $width, $width / 2);
				}

				if (isset($results['image']) && is_file(DIR_IMAGE . $results['image']))
					$dc_image = DIR_IMAGE . $results['image'];
				elseif (is_file(DIR_IMAGE . 'placeholder.png'))
					$dc_image = DIR_IMAGE . 'placeholder.png';
				else
					$dc_image = '';

				$dominant_color = $this->getDominantColor($dc_image);

				$banners = array(
					'home_sequence_id' => $banner_id,
					'title' => html_entity_decode($results['title'], ENT_QUOTES, "UTF-8"),
					'type'	=> $type ? $type : $results['type'],
					'link'  => $link,
					'image' => $image,
					'dominant_color' => $dominant_color
				);
			}
		}

		return $banners;
	}
	/**
	 * Fetches the carousel content
	 * @param  integer $width   contains the width of the device
	 * @return array          returns the carousel data
	 */
	public function carousel($type, $data)
	{

		$this->load->model('design/banner');
		$this->load->model('tool/image');
		$return_carousel = array();
		$products = array();
		$id = explode("_", $type)[1];
		if ($this->config->get('mobikul_status')) {
			$sql = "SELECT c.id,cd.title,c.type,c.product_type,c.image_sub_type, c.status,c.sort_order FROM " . DB_PREFIX . "mobikul_carousel c left join " .  DB_PREFIX . "mobikul_carousel_description cd on (c.id=cd.id) where cd.id=" . $id . " AND cd.language_id =" . $this->config->get('config_language_id');

			$results = $this->db->query($sql)->row;


			if ($results) {

				if (isset($results['type']) && $results['type'] && $results['type'] == 'Product' && isset($results['product_type']) && $results['product_type']) {

					if ($results['product_type'] == 'best') {
						$products = $this->getBestSeller($data);
						$total_products = $this->getBestSellerTotal($data);
					} else if ($results['product_type'] == 'popular') {
						$products = $this->getPopularProduct($data);
						$total_products = $this->getPopularProductTotal($data);
					} else if ($results['product_type'] == 'latest') {
						$products = $this->latestProduct($data);
						$total_products = $this->latestProductTotal($data);
					} else if ($results['product_type'] == 'special_products') {
						$products = $this->getSpecialProduct($data);
						$total_products = $this->getSpecialProductTotal($data);
					} else if ($results['product_type'] == 'discounted_products') {
						$products = $this->getAllDiscountedProduct($id, $data);
						$total_products = $this->getAllDiscountedProductTotal($id, $data);
					} else if ($results['product_type'] == 'random_product') {
						$products = $this->getProductById($id, $data);
						$total_products = $this->getProductByIdTotal($id, $data);
					} else if ($results['product_type'] == 'manufacturer') {
						$products = $this->getAllManufacturerProduct($id, $data);
						$total_products = $this->getAllManufacturerProductTotal($id, $data);
					} else if ($results['product_type'] == 'manufacturer_products') {
						$products = $this->getProductById($id, $data);
						$total_products = $this->getProductByIdTotal($id, $data);
					} else if ($results['product_type'] == 'catagories') {
						$products = $this->getAllCategoriesProduct($id, $data);
						$total_products = $this->getAllCategoriesProductTotal($id, $data);
					} else if ($results['product_type'] == 'catagory_products') {
						$products = $this->getProductById($id, $data);
						$total_products = $this->getProductByIdTotal($id, $data);
					}
				}

				if (isset($results['type']) && $results['type'] && $results['type'] == 'Image' && isset($results['image_sub_type']) && $results['image_sub_type']) {

					if ($results['image_sub_type'] == 'image_manufacturer') {
						$image_manufacturer = $this->getManufacturerCarousel($id, $data);
					} else if ($results['image_sub_type'] == 'image_catagory') {
						$image_catagory = $this->getCategoryCarousel($id, $data);
					} else if ($results['image_sub_type'] == 'image_carousel') {
						$image_carousel = $this->getBannerCarousel($id, $data);
					} else if ($results['image_sub_type'] == 'image_all_parrent_category') {
						$image_all_parrent_category = $this->getParentCatagoryCarousel($id, $data);
					}
				}
			}

			$arr_products = array();
			$i = 0;
			foreach ($products as $product) {
				$set_date = $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_product_set_date WHERE product_id = " . $product['product_id'])->row;
				$arr_products[$i] = [
					'product_id' => $product['product_id'],
					'thumb' => $product['thumb'],
					'dominant_color' => $product['dominant_color'],
					'name' => $product['name'],
					'price' => $product['price'],
					'quantity' => $product['quantity'],
					'special' => $product['special'],
					'formatted_special' => $product['formatted_special'],
					'tax' => $product['tax'],
					'rating' => $product['rating'],
					'hasOption' => $product['hasOption'],
					'wishlist_status' => $product['wishlist_status'],
					'start_date' => isset($set_date['start_date']) ? $set_date['start_date'] : '',
					'close_date' => isset($set_date['close_date']) ? $set_date['close_date'] : ''
				];
				$i++;
			}

			$return_carousel = array(
				"home_sequence_id" => $type,
				"id" => isset($results['id']) ? $results['id'] : '',
				"title" => isset($results['title']) ? html_entity_decode($results['title'], ENT_QUOTES, "UTF-8") : '',
				"type" => isset($results['type']) ? $results['type'] : '',
				"product_type" => isset($results['product_type']) ? $results['product_type'] : '',
				"image_sub_type" => isset($results['image_sub_type']) ? $results['image_sub_type'] : '',
				"sort_order" => isset($results['sort_order']) ? $results['sort_order'] : '',
				"products" => $arr_products,
				"image_all_parrent_category" => (isset($image_all_parrent_category) && $image_all_parrent_category) ? $image_all_parrent_category : [],
				"image_manufacturer" => (isset($image_manufacturer) && $image_manufacturer) ? $image_manufacturer : [],
				"image_catagory" => (isset($image_catagory) && $image_catagory) ? $image_catagory : [],
				"image_carousel" => (isset($image_carousel) && $image_carousel) ? $image_carousel : [],
				"product_total" => isset($total_products) ? $total_products : 0

			);

			$return_carousel['sorts'] = array();

			$return_carousel['sorts'][] = array(
				'text'  => $this->language->get('text_default'),
				'value' => 'p.sort_order',
				'order'	=> 'ASC',
			);

			$return_carousel['sorts'][] = array(
				'text'  => $this->language->get('text_name_asc'),
				'value' => 'pd.name',
				'order'	=> 'ASC',
			);

			$return_carousel['sorts'][] = array(
				'text'  => $this->language->get('text_name_desc'),
				'value' => 'pd.name',
				'order'	=> 'DESC',
			);

			$return_carousel['sorts'][] = array(
				'text'  => $this->language->get('text_price_asc'),
				'value' => 'p.price',
				'order'	=> 'ASC',
			);

			$return_carousel['sorts'][] = array(
				'text'  => $this->language->get('text_price_desc'),
				'value' => 'p.price',
				'order'	=> 'DESC'
			);

			if ($this->config->get('config_review_status')) {
				$return_carousel['sorts'][] = array(
					'text'  => $this->language->get('text_rating_desc'),
					'value' => 'rating',
					'order'	=> 'DESC',
				);

				$return_carousel['sorts'][] = array(
					'text'  => $this->language->get('text_rating_asc'),
					'value' => 'rating',
					'order'	=> 'ASC',
				);
			}

			$return_carousel['sorts'][] = array(
				'text'  => $this->language->get('text_model_asc'),
				'value' => 'p.model',
				'order'	=> 'ASC',
			);

			$return_carousel['sorts'][] = array(
				'text'  => $this->language->get('text_model_desc'),
				'value' => 'p.model',
				'order'	=> 'DESC',
			);
		}

		return $return_carousel;
	}


	public function getParentCatagoryCarousel($carousel_id, $data)
	{

		$return_carousel_data = [];
		if (!isset($data['width']) || $data['width']) {
			$width = $data['width'];
		} else {
			$width = 100;
		}

		$this->load->model('catalog/category');
		$this->load->model('catalog/product');

		$sql = "SELECT c.category_id, cd.name, c.image,mc.category_image ,mc.category_icon FROM " . DB_PREFIX . "category c LEFT JOIN " . DB_PREFIX . "category_description cd on cd.category_id=c.category_id LEFT JOIN " . DB_PREFIX . "mobikul_category mc ON mc.category_id =c.category_id LEFT JOIN " . DB_PREFIX . "category_to_store c2s ON c2s.category_id =c.category_id WHERE cd.language_id=" . (int)$this->config->get('config_language_id') . " AND c.parent_id=" . (int)$this->config->get('config_store_id') . " AND c.status = '1' ORDER BY c.sort_order ASC";

		$category_carousel = $this->db->query($sql)->rows;

		if ($category_carousel) {
			foreach ($category_carousel as $category) {

				$filter_data = array(
					'filter_category_id'  => $category['category_id'],
					'filter_sub_category' => true
				);

				$children = $this->model_catalog_category->getCategories($category['category_id']);

				if ($children) {
					$child_exist = true;
				} else {
					$child_exist = false;
				}


				if (is_file(DIR_IMAGE . $category['category_image']) && $category['category_image'] != 'no_image.png'  && isset($category['category_icon'])) {
					$image = DIR_IMAGE . $category['category_image'];
					$imagelink = $category['category_image'];
				} elseif (is_file(DIR_IMAGE . $category['image'])) {
					$image = DIR_IMAGE . $category['image'];
					$imagelink = $category['image'];
				} else {
					$image = DIR_IMAGE . 'no_image.png';
					$imagelink = 'no_image.png';
				}

				if (is_file(DIR_IMAGE . $category['category_icon']) && isset($category['category_icon'])) {
					$category_icon = DIR_IMAGE . $category['category_icon'];
					$category_icon_link = $category['category_icon'];
				} else {
					$category_icon = DIR_IMAGE . 'no_image.png';
					$category_icon_link = 'no_image.png';
				}

				// Level 1
				$return_carousel_data[] = array(
					'name'  => html_entity_decode($category['name'], ENT_QUOTES, 'UTF-8'),
					'child_status' => $child_exist,
					'path'     => $category['category_id'],
					'image'		=> str_replace(' ', '%20', $this->model_tool_image->resize($imagelink, $width, $width / 2)),
					'dominant_color' => $this->model_wkrestapi_catalog->getDominantColor($image),
					"icon"  =>  str_replace(' ', '%20', $this->model_tool_image->resize($category_icon_link, $width, $width)),
					'dominant_color_icon' => $this->model_wkrestapi_catalog->getDominantColor($category_icon),


				);
			}
		}

		return $return_carousel_data;
	}

	public function getCategoryCarousel($carousel_id, $data)
	{
		$return_carousel_data = [];
		if (!isset($data['width']) || $data['width']) {
			$width = $data['width'];
		} else {
			$width = 100;
		}

		$this->load->model('catalog/category');
		$this->load->model('catalog/product');

		$sql = "SELECT cat.category_id, cd.name, cat.image,mc.category_image ,mc.category_icon FROM " . DB_PREFIX . "mobikul_carousel c LEFT JOIN " . DB_PREFIX . "mobikul_carousel_to_categories c2c ON c.id=c2c.id LEFT JOIN " . DB_PREFIX . "category cat on cat.category_id=c2c.catagories_id LEFT JOIN " . DB_PREFIX . "category_description cd ON cd.category_id =c2c.catagories_id LEFT JOIN " . DB_PREFIX . "mobikul_category mc ON mc.category_id =cat.category_id WHERE c.id=" . $carousel_id . " AND c.type='Image' AND c.image_sub_type='image_catagory' AND cd.language_id=" . $this->config->get('config_language_id');

		$category_carousel = $this->db->query($sql)->rows;

		if ($category_carousel) {
			foreach ($category_carousel as $category) {

				$filter_data = array(
					'filter_category_id'  => $category['category_id'],
					'filter_sub_category' => true
				);

				$children = $this->model_catalog_category->getCategories($category['category_id']);

				if ($children) {
					$child_exist = true;
				} else {
					$child_exist = false;
				}


				if (is_file(DIR_IMAGE . $category['category_image']) && $category['category_image'] != 'no_image.png'  && isset($category['category_icon'])) {
					$image = DIR_IMAGE . $category['category_image'];
					$imagelink = $category['category_image'];
				} elseif (is_file(DIR_IMAGE . $category['image'])) {
					$image = DIR_IMAGE . $category['image'];
					$imagelink = $category['image'];
				} else {
					$image = DIR_IMAGE . 'no_image.png';
					$imagelink = 'no_image.png';
				}

				if (is_file(DIR_IMAGE . $category['category_icon']) && isset($category['category_icon'])) {
					$category_icon = DIR_IMAGE . $category['category_icon'];
					$category_icon_link = $category['category_icon'];
				} else {
					$category_icon = DIR_IMAGE . 'no_image.png';
					$category_icon_link = 'no_image.png';
				}

				// Level 1
				$return_carousel_data[] = array(
					'name'  => html_entity_decode($category['name'], ENT_QUOTES, 'UTF-8') . ($this->config->get('config_product_count') ? ' (' . $this->model_catalog_product->getTotalProducts($filter_data) . ')' : ''),
					'child_status' => $child_exist,
					'path'     => $category['category_id'],
					'image'		=> str_replace(' ', '%20', $this->model_tool_image->resize($imagelink, $width, $width / 2)),
					'dominant_color' => $this->model_wkrestapi_catalog->getDominantColor($image),
					"icon"  =>  str_replace(' ', '%20', $this->model_tool_image->resize($category_icon_link, $width, $width)),
					'dominant_color_icon' => $this->model_wkrestapi_catalog->getDominantColor($category_icon),


				);
			}
		}

		return $return_carousel_data;
	}
	public function getManufacturerCarousel($carousel_id, $data)
	{


		$sql = "SELECT m.manufacturer_id,m.name,m.image FROM " . DB_PREFIX . "mobikul_carousel c LEFT JOIN " . DB_PREFIX . "mobikul_carousel_to_manufacturer cm ON c.id=cm.id LEFT JOIN " . DB_PREFIX . "manufacturer m on m.manufacturer_id= cm.manufacturer_id LEFT JOIN " . DB_PREFIX . "manufacturer_to_store m2s on m2s.manufacturer_id=cm.manufacturer_id WHERE c.type='Image' AND c.image_sub_type='image_manufacturer'";
		$carousel_manufacture = $this->db->query($sql)->rows;

		$manufacturer_array = [];
		$this->load->model('tool/image');
		if (isset($data['width']))
			$width = $data['width'];
		else
			$width = 100;

		if ($carousel_manufacture) {
			foreach ($carousel_manufacture as $manufacturer) {


				if (isset($manufacturer['image']) && $manufacturer['image']) {
					$image = str_replace(' ', '%20', $this->model_tool_image->resize($manufacturer['image'], ($width / 2), ($width / 2)));
				} else {
					$image = $this->model_tool_image->resize('placeholder.png', ($width / 2), ($width / 2));
				}

				$manufacturer_array[] = array(
					"manufacturer_id" => $manufacturer['manufacturer_id'],
					"name" =>  $manufacturer['name'],
					"image" => $image ? $image : $this->model_tool_image->resize('placeholder.png', ($width / 2), ($width / 2)),
				);
			}
		}

		return  $manufacturer_array;
	}

	public function getBannerCarousel($carousel_id, $data)
	{


		$sql = "SELECT b.name,b.type,b.pro_cat_id,b.image,bd.title  FROM " . DB_PREFIX . "mobikul_carousel c LEFT JOIN " . DB_PREFIX . "mobikul_carousel_to_image_id c2img ON c2img.id = c.id LEFT JOIN " . DB_PREFIX . "mobikul_banner b ON b.id =c2img.image_id LEFT JOIN " . DB_PREFIX . "mobikul_banner_description bd ON bd.id =b.id  WHERE c.type='Image' AND c.image_sub_type='image_carousel' AND bd.language_id=" . $this->config->get('config_language_id') . " AND c.id=" . $carousel_id ." ORDER BY b.sort_order ASC";

		$carousel_images = $this->db->query($sql)->rows;

		$image_carousel_array = [];
		$this->load->model('tool/image');
		if (isset($data['width']))
			$width = $data['width'];
		else
			$width = 100;

		if ($carousel_images) {
			foreach ($carousel_images as $carousel_image) {

				$type = '';
				$link = $carousel_image['pro_cat_id'];
				if ($carousel_image['type'] == 1) {
					$type = 'product';
				} elseif ($carousel_image['type'] == 2) {
					$type = 'category';
				} elseif($carousel_image['type'] == 3) {
					$type = 'extenal_link';
					$link = html_entity_decode($carousel_image['name'], ENT_QUOTES, "UTF-8");
				} else {
					$type = 'no_link';
				}

				if (is_file(DIR_IMAGE . $carousel_image['image'])) {

					if (isset($carousel_image['image']) && is_file(DIR_IMAGE . $carousel_image['image']))
						$dc_image = DIR_IMAGE . $carousel_image['image'];
					elseif (is_file(DIR_IMAGE . 'placeholder.png'))
						$dc_image = DIR_IMAGE . 'placeholder.png';
					else
						$dc_image = '';

					$dominant_color = $this->getDominantColor($dc_image);

					$image_carousel_array[] = array(
						'banner_title' => html_entity_decode($carousel_image['title'], ENT_QUOTES, "UTF-8"),
						'title' => html_entity_decode($carousel_image['name'], ENT_QUOTES, "UTF-8"),
						'type'	=> $type,
						'link'  => $link,
						'image' => str_replace(' ', '%20', $this->model_tool_image->resize($carousel_image['image'], ($width), ($width / 2))),
						'dominant_color' => $dominant_color
					);
				}
			}
		}

		return  $image_carousel_array;
	}

	public function getAllCategoriesProductTotal($carousel_id, $data)
	{
		
		$product_idss = array();
		
		
		$sql = "SELECT c2c.catagories_id FROM " . DB_PREFIX . "mobikul_carousel_to_categories c2c 
        LEFT JOIN " . DB_PREFIX . "mobikul_carousel c ON c2c.id = c.id 
        WHERE c2c.id = '" . (int)$carousel_id . "'";

		

		$category = $this->db->query($sql)->rows;

		$this->load->model('catalog/product');


		foreach ($category as $category_id) {			
		
			$filter_data = array(
				'filter_category_id' => (int)$category_id['catagories_id'],
				'filter_sub_category' => true,
			);
			
			$results = $this->model_catalog_product->getProducts($filter_data);
			
		
			// $results = $this->model_catalog_product->getProducts($filter_data);
		  if(!empty($results)){	
			foreach ($results as $result) {
				$product_idss[] = $result['product_id'];
			}
	      	}
		}
		// Convert array to comma-separated string for IN clause
	   if(!empty($product_idss)){	
		$product_ids_string = implode(',', $product_idss);
		$sql1 = "SELECT COUNT(DISTINCT p.product_id) as total 
		FROM " . DB_PREFIX . "product p
		LEFT JOIN " . DB_PREFIX . "product_description pd ON p.product_id=pd.product_id
		LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON p2s.product_id=p.product_id
		WHERE p.product_id IN (" . $product_ids_string . ")";

		$query = $this->db->query($sql1);
		return $query->row['total'];
	   } else {
		return 0;
	   }
	}


		public function getAllCategoriesProduct($carousel_id, $data)
	{


		$product_idss = array();
		
		
		$sql = "SELECT c2c.catagories_id FROM " . DB_PREFIX . "mobikul_carousel_to_categories c2c 
        LEFT JOIN " . DB_PREFIX . "mobikul_carousel c ON c2c.id = c.id 
        WHERE c2c.id = '" . (int)$carousel_id . "'";

		if (isset($data['page'])) {
			$page = $data['page'];
		} else {
			$page = 1;
		}

		if (isset($data['limit'])) {
			$limit = $data['limit'];
		} elseif (isset($data['count'])) {
			$limit = $data['count'];
		} else {
			$limit = 5;
		}

		$start    = ($page - 1) * $limit;

		$category = $this->db->query($sql)->rows;

		$this->load->model('catalog/product');

		foreach ($category as $category_id) {			
		
			$filter_data = array(
				'filter_category_id' => (int)$category_id['catagories_id'],
				'filter_sub_category' => true,
				'start' => $start,
				'limit' => $limit,
			);

			if(isset($data['sort']) && $data['sort']) {
				$filter_data['sort'] = $data['sort'];
			}

			if(isset($data['order']) && $data['order']) {
				$filter_data['order'] = $data['order'];
			}	
			
			$results = $this->model_catalog_product->getProducts($filter_data);
			
		
		   if(!empty($results))	{
			foreach ($results as $result) {
				$product_idss[] = $result['product_id'];
			}
		   }
		}
		// Convert array to comma-separated string for IN clause

  if(!empty($product_idss)){

	$product_ids_string = implode(',', $product_idss);

		$sql1 = "SELECT DISTINCT p.*, 
    (SELECT price FROM " . DB_PREFIX . "product_discount pd2 
     WHERE pd2.product_id = p.product_id 
     AND pd2.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
     AND pd2.quantity = '1' 
     AND ((pd2.date_start = '0000-00-00' OR pd2.date_start < NOW()) 
     AND (pd2.date_end = '0000-00-00' OR pd2.date_end > NOW())) 
     ORDER BY pd2.priority ASC, pd2.price ASC LIMIT 1) AS discount, 
    (SELECT price FROM " . DB_PREFIX . "product_special ps 
     WHERE ps.product_id = p.product_id 
     AND ps.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
     AND ((ps.date_start = '0000-00-00' OR ps.date_start < NOW()) 
     AND (ps.date_end = '0000-00-00' OR ps.date_end > NOW())) 
     ORDER BY ps.priority ASC, ps.price ASC LIMIT 1) AS special 
     FROM " . DB_PREFIX . "product p 
     LEFT JOIN " . DB_PREFIX . "product_description pd ON p.product_id=pd.product_id 
     LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON p2s.product_id=p.product_id 
      WHERE p.product_id IN (" . $product_ids_string . ")";



		if (isset($data['filter_name'])) {
			$sql1 .=  " AND pd.name LIKE '%" . $data['filter_name'] . "%'";
		}
		if (isset($data['filter_model'])) {
			$sql1 .=  " AND p.model LIKE '%" . $data['filter_model'] . "%'";
		}
		if (isset($data['filter_price'])) {
			$sql1 .=  " AND p.price LIKE '%" . $data['filter_price'] . "%'";
		}
		if (isset($data['filter_quantity'])) {
			$sql1 .=  " AND p.quantity LIKE '%" . $data['filter_quantity'] . "%'";
		}
		if (isset($data['filter_status'])) {
			$sql1 .=  " AND p.status LIKE '%" . $data['filter_status'] . "%'";
		}

		$sql1 .= "  GROUP BY p.product_id";



		// $products = $this->db->query($sql)->rows;



		$sort_data = array(
			'pd.name',
			'p.model',
			'p.price',
			'p.sort_order',
		);
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			if ($data['sort'] == 'pd.name' || $data['sort'] == 'p.model') {
				$sql1 .= " ORDER BY LCASE(" . $data['sort'] . ")";
			} elseif ($data['sort'] == 'p.price') {
				$sql1 .= " ORDER BY (CASE WHEN special IS NOT NULL THEN special WHEN discount IS NOT NULL THEN discount ELSE p.price END)";
			}
			if (isset($data['order']) && ($data['order'] == 'DESC')) {
				$sql1 .= " DESC";
			} else {
				$sql1 .= " ASC";
			}
		} else {
			$sql1 .= " ORDER BY p.sort_order DESC";
		}


		// if (isset($data['page'])) {
		// 	$page = $data['page'];
		// } else {
		// 	$page = 1;
		// }

		// if (isset($data['limit'])) {
		// 	$limit = $data['limit'];
		// } elseif (isset($data['count'])) {
		// 	$limit = $data['count'];
		// } else {
		// 	$limit = 5;
		// }

		// $start    = ($page - 1) * $limit;
		// $sql1 .= " LIMIT " . $start . ", " . $limit;

		$products = $this->db->query($sql1)->rows;


		return $this->getProductFormat($products, $data['width']);
	  }
	}

	public function getAllDiscountedProductTotal($carousel_id, $data)
	{
		$sql = "SELECT COUNT(DISTINCT p.product_id) as total 
		FROM " . DB_PREFIX . "product_discount pd2 
		LEFT JOIN " . DB_PREFIX . "product p ON p.product_id=pd2.product_id 
		LEFT JOIN " . DB_PREFIX . "product_description pd ON pd.product_id=p.product_id 
		LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON p2s.product_id=p.product_id 
		WHERE pd2.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
		AND ((pd2.date_start = '0000-00-00' OR pd2.date_start < NOW()) 
		AND (pd2.date_end = '0000-00-00' OR pd2.date_end > NOW())) 
		AND pd.language_id=" . (int)$this->config->get('config_language_id') . " 
		AND p2s.store_id=" . (int)$this->config->get('config_store_id');

		$query = $this->db->query($sql);
		return $query->row['total'];
	}

	public function getAllDiscountedProduct($carousel_id, $data)
	{

		$sql = "SELECT DISTINCT p.product_id,
    (SELECT price FROM " . DB_PREFIX . "product_discount pd2 
    WHERE pd2.product_id = p.product_id 
    AND pd2.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
    AND ((pd2.date_start = '0000-00-00' OR pd2.date_start < NOW()) 
    AND (pd2.date_end = '0000-00-00' OR pd2.date_end > NOW())) 
    ORDER BY pd2.priority ASC, pd2.price ASC LIMIT 1) AS discount, 
    (SELECT price FROM " . DB_PREFIX . "product_special ps 
    WHERE ps.product_id = p.product_id 
    AND ps.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
    AND ((ps.date_start = '0000-00-00' OR ps.date_start < NOW()) 
    AND (ps.date_end = '0000-00-00' OR ps.date_end > NOW())) 
    ORDER BY ps.priority ASC, ps.price ASC LIMIT 1) AS special 
FROM " . DB_PREFIX . "product_discount pd2 
LEFT JOIN " . DB_PREFIX . "product p ON p.product_id=pd2.product_id 
LEFT JOIN " . DB_PREFIX . "product_description pd ON pd.product_id=p.product_id 
LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON p2s.product_id=p.product_id 
WHERE pd2.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
AND ((pd2.date_start = '0000-00-00' OR pd2.date_start < NOW()) 
AND (pd2.date_end = '0000-00-00' OR pd2.date_end > NOW())) 
AND pd.language_id=" . (int) $this->config->get('config_language_id') . " 
AND p2s.store_id=" . (int)$this->config->get('config_store_id');


		if (isset($data['filter_name'])) {
			$sql .=  " AND pd.name LIKE '%" . $data['filter_name'] . "%'";
		}
		if (isset($data['filter_model'])) {
			$sql .=  " AND p.model LIKE '%" . $data['filter_model'] . "%'";
		}
		if (isset($data['filter_price'])) {
			$sql .=  " AND p.price LIKE '%" . $data['filter_price'] . "%'";
		}
		if (isset($data['filter_quantity'])) {
			$sql .=  " AND p.quantity LIKE '%" . $data['filter_quantity'] . "%'";
		}
		if (isset($data['filter_status'])) {
			$sql .=  " AND p.status LIKE '%" . $data['filter_status'] . "%'";
		}

		$sql .= "  GROUP BY p.product_id";

		$sort_data = array(
			'pd.name',
			'p.model',
			'p.price',
			'p.sort_order',
		);
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			if ($data['sort'] == 'pd.name' || $data['sort'] == 'p.model') {
				$sql .= " ORDER BY LCASE(" . $data['sort'] . ")";
			} elseif ($data['sort'] == 'p.price') {
				$sql .= " ORDER BY (CASE WHEN special IS NOT NULL THEN special WHEN discount IS NOT NULL THEN discount ELSE p.price END)";
			}
			if (isset($data['order']) && ($data['order'] == 'DESC')) {
				$sql .= " DESC";
			} else {
				$sql .= " ASC";
			}
		} else {
			$sql .= " ORDER BY p.sort_order DESC";
		}

		if (isset($data['page'])) {
			$page = $data['page'];
		} else {
			$page = 1;
		}

		if (isset($data['limit'])) {
			$limit = $data['limit'];
		} elseif (isset($data['count'])) {
			$limit = $data['count'];
		} else {
			$limit = 5;
		}

		$start    = ($page - 1) * $limit;

		$sql .= " LIMIT " . $start . ", " . $limit;

		$products = $this->db->query($sql)->rows;

		return $this->getProductFormat($products, $data['width']);
	}

	public function getAllDiscountedProductTotal($carousel_id, $data)
	{
		$sql = "SELECT COUNT(DISTINCT p.product_id) as total 
		FROM " . DB_PREFIX . "product_discount pd2 
		LEFT JOIN " . DB_PREFIX . "product p ON p.product_id=pd2.product_id 
		LEFT JOIN " . DB_PREFIX . "product_description pd ON pd.product_id=p.product_id 
		LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON p2s.product_id=p.product_id 
		WHERE pd2.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
		AND ((pd2.date_start = '0000-00-00' OR pd2.date_start < NOW()) 
		AND (pd2.date_end = '0000-00-00' OR pd2.date_end > NOW())) 
		AND pd.language_id=" . (int)$this->config->get('config_language_id') . " 
		AND p2s.store_id=" . (int)$this->config->get('config_store_id');

		$query = $this->db->query($sql);
		return $query->row['total'];
	}

	public function getAllDiscountedProduct($carousel_id, $data)
	{

		$sql = "SELECT DISTINCT p.product_id,
    (SELECT price FROM " . DB_PREFIX . "product_discount pd2 
    WHERE pd2.product_id = p.product_id 
    AND pd2.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
    AND ((pd2.date_start = '0000-00-00' OR pd2.date_start < NOW()) 
    AND (pd2.date_end = '0000-00-00' OR pd2.date_end > NOW())) 
    ORDER BY pd2.priority ASC, pd2.price ASC LIMIT 1) AS discount, 
    (SELECT price FROM " . DB_PREFIX . "product_special ps 
    WHERE ps.product_id = p.product_id 
    AND ps.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
    AND ((ps.date_start = '0000-00-00' OR ps.date_start < NOW()) 
    AND (ps.date_end = '0000-00-00' OR ps.date_end > NOW())) 
    ORDER BY ps.priority ASC, ps.price ASC LIMIT 1) AS special 
FROM " . DB_PREFIX . "product_discount pd2 
LEFT JOIN " . DB_PREFIX . "product p ON p.product_id=pd2.product_id 
LEFT JOIN " . DB_PREFIX . "product_description pd ON pd.product_id=p.product_id 
LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON p2s.product_id=p.product_id 
WHERE pd2.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
AND ((pd2.date_start = '0000-00-00' OR pd2.date_start < NOW()) 
AND (pd2.date_end = '0000-00-00' OR pd2.date_end > NOW())) 
AND pd.language_id=" . (int) $this->config->get('config_language_id') . " 
AND p2s.store_id=" . (int)$this->config->get('config_store_id');


		if (isset($data['filter_name'])) {
			$sql .=  " AND pd.name LIKE '%" . $data['filter_name'] . "%'";
		}
		if (isset($data['filter_model'])) {
			$sql .=  " AND p.model LIKE '%" . $data['filter_model'] . "%'";
		}
		if (isset($data['filter_price'])) {
			$sql .=  " AND p.price LIKE '%" . $data['filter_price'] . "%'";
		}
		if (isset($data['filter_quantity'])) {
			$sql .=  " AND p.quantity LIKE '%" . $data['filter_quantity'] . "%'";
		}
		if (isset($data['filter_status'])) {
			$sql .=  " AND p.status LIKE '%" . $data['filter_status'] . "%'";
		}

		$sql .= "  GROUP BY p.product_id";

		$sort_data = array(
			'pd.name',
			'p.model',
			'p.price',
			'p.sort_order',
		);
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			if ($data['sort'] == 'pd.name' || $data['sort'] == 'p.model') {
				$sql .= " ORDER BY LCASE(" . $data['sort'] . ")";
			} elseif ($data['sort'] == 'p.price') {
				$sql .= " ORDER BY (CASE WHEN special IS NOT NULL THEN special WHEN discount IS NOT NULL THEN discount ELSE p.price END)";
			}
			if (isset($data['order']) && ($data['order'] == 'DESC')) {
				$sql .= " DESC";
			} else {
				$sql .= " ASC";
			}
		} else {
			$sql .= " ORDER BY p.sort_order DESC";
		}

		if (isset($data['page'])) {
			$page = $data['page'];
		} else {
			$page = 1;
		}

		if (isset($data['limit'])) {
			$limit = $data['limit'];
		} elseif (isset($data['count'])) {
			$limit = $data['count'];
		} else {
			$limit = 5;
		}

		$start    = ($page - 1) * $limit;

		$sql .= " LIMIT " . $start . ", " . $limit;

		$products = $this->db->query($sql)->rows;

		return $this->getProductFormat($products, $data['width']);
	}

	public function getAllManufacturerProductTotal($carousel_id, $data)
	{
		$sql = "SELECT COUNT(DISTINCT p.product_id) as total 
		FROM " . DB_PREFIX . "mobikul_carousel c 
		LEFT JOIN " . DB_PREFIX . "mobikul_carousel_to_manufacturer cm ON cm.id=c.id 
		LEFT JOIN " . DB_PREFIX . "manufacturer m ON m.manufacturer_id=cm.manufacturer_id 
		LEFT JOIN " . DB_PREFIX . "manufacturer_to_store m2s ON m2s.manufacturer_id=m.manufacturer_id 
		LEFT JOIN " . DB_PREFIX . "product p ON p.manufacturer_id=m.manufacturer_id 
		LEFT JOIN " . DB_PREFIX . "product_description pd ON pd.product_id=p.product_id 
		WHERE c.type='Product' 
		AND c.product_type='manufacturer' 
		AND m2s.store_id=" . (int)$this->config->get('config_store_id') . " 
		AND pd.language_id=" . (int)$this->config->get('config_language_id') . " 
		AND c.id=" . (int)$carousel_id;

		$query = $this->db->query($sql);
		return $query->row['total'];
	}




	public function getAllManufacturerProduct($carousel_id, $data)
	{


		$sql = "SELECT DISTINCT p.*, pd.*, 
    (SELECT price FROM " . DB_PREFIX . "product_discount pd2 
    WHERE pd2.product_id = p.product_id 
    AND pd2.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
    AND pd2.quantity = '1' 
    AND ((pd2.date_start = '0000-00-00' OR pd2.date_start < NOW()) 
    AND (pd2.date_end = '0000-00-00' OR pd2.date_end > NOW())) 
    ORDER BY pd2.priority ASC, pd2.price ASC LIMIT 1) AS discount, 
    (SELECT price FROM " . DB_PREFIX . "product_special ps 
    WHERE ps.product_id = p.product_id 
    AND ps.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
    AND ((ps.date_start = '0000-00-00' OR ps.date_start < NOW()) 
    AND (ps.date_end = '0000-00-00' OR ps.date_end > NOW())) 
    ORDER BY ps.priority ASC, ps.price ASC LIMIT 1) AS special 
FROM " . DB_PREFIX . "mobikul_carousel c 
LEFT JOIN " . DB_PREFIX . "mobikul_carousel_to_manufacturer cm ON cm.id=c.id 
LEFT JOIN " . DB_PREFIX . "manufacturer m ON m.manufacturer_id =cm.manufacturer_id 
LEFT JOIN " . DB_PREFIX . "manufacturer_to_store m2s ON m2s.manufacturer_id=m.manufacturer_id 
LEFT JOIN " . DB_PREFIX . "product p ON p.manufacturer_id=m.manufacturer_id 
LEFT JOIN " . DB_PREFIX . "product_description pd ON pd.product_id =p.product_id 
WHERE c.type='Product' 
AND c.product_type='manufacturer' 
AND m2s.store_id =" . (int)$this->config->get('config_store_id') . " 
AND pd.language_id=" . (int) $this->config->get('config_language_id') . " 
AND c.id=" . (int) $carousel_id;





		if (isset($data['filter_name'])) {
			$sql .=  " AND pd.name LIKE '%" . $data['filter_name'] . "%'";
		}
		if (isset($data['filter_model'])) {
			$sql .=  " AND p.model LIKE '%" . $data['filter_model'] . "%'";
		}
		if (isset($data['filter_price'])) {
			$sql .=  " AND p.price LIKE '%" . $data['filter_price'] . "%'";
		}
		if (isset($data['filter_quantity'])) {
			$sql .=  " AND p.quantity LIKE '%" . $data['filter_quantity'] . "%'";
		}
		if (isset($data['filter_status'])) {
			$sql .=  " AND p.status LIKE '%" . $data['filter_status'] . "%'";
		}

		$sql .= "  GROUP BY p.product_id";

		$sort_data = array(
			'pd.name',
			'p.model',
			'p.price',
			'p.sort_order',
		);
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			if ($data['sort'] == 'pd.name' || $data['sort'] == 'p.model') {
				$sql .= " ORDER BY LCASE(" . $data['sort'] . ")";
			} elseif ($data['sort'] == 'p.price') {
				$sql .= " ORDER BY (CASE WHEN special IS NOT NULL THEN special WHEN discount IS NOT NULL THEN discount ELSE p.price END)";
			}
			if (isset($data['order']) && ($data['order'] == 'DESC')) {
				$sql .= " DESC";
			} else {
				$sql .= " ASC";
			}
		} else {
			$sql .= " ORDER BY p.sort_order DESC";
		}
		if (isset($data['page'])) {
			$page = $data['page'];
		} else {
			$page = 1;
		}

		if (isset($data['limit'])) {
			$limit = $data['limit'];
		} elseif (isset($data['count'])) {
			$limit = $data['count'];
		} else {
			$limit = 5;
		}

		$start    = ($page - 1) * $limit;

		$sql .= " LIMIT " . $start . ", " . $limit;

		$products = $this->db->query($sql)->rows;

		return $this->getProductFormat($products, $data['width']);
	}



	protected function getProductFormat($products, $width)
	{
		if ($products) {
			foreach ($products as $product_id) {

				$product_info = $this->model_catalog_product->getProduct($product_id['product_id']);

				$this->load->model('tool/image');

				if ($product_info) {

					$already_status = false;

					if (version_compare(VERSION, '2.1.0.1	', '>=')) {
						foreach ($this->getDBWishlist() as $wishlist) {
							if ($wishlist['product_id'] == $product_id['product_id']) {
								$already_status = true;
							}
						}
					}



					if ($product_info['image']) {
						$image = str_replace(' ', '%20', $this->model_tool_image->resize($product_info['image'], ($width / 2), ($width / 2)));
					} else {
						$image = $this->model_tool_image->resize('placeholder.png', ($width / 2), ($width / 2));
					}

					if ($this->customer->isLogged() || !$this->config->get('config_customer_price')) {
						$price = $this->currency->format($this->tax->calculate($product_info['price'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
					} else {
						$price = false;
					}
					if ((float) $product_info['special']) {
						$formatedSpecial = $this->currency->format($this->tax->calculate($product_info['special'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
						$special = $product_info['special'];
					} else {
						$formatedSpecial = '';
						$special = 0.00;
					}

					if ($this->config->get('config_tax')) {
						$tax = $this->currency->format((float)$product_info['special'] ? $product_info['special'] : $product_info['price'], $this->session->data['currency']);
					} else {
						$tax = false;
					}

					if ($this->config->get('config_review_status')) {
						$rating = $product_info['rating'];
					} else {
						$rating = 0;
					}


					if (isset($product_info['image']) && is_file(DIR_IMAGE . $product_info['image']))
						$dc_image = DIR_IMAGE . $product_info['image'];
					elseif (is_file(DIR_IMAGE . 'placeholder.png'))
						$dc_image = DIR_IMAGE . 'placeholder.png';
					else
						$dc_image = '';

					$dominant_color = $this->getDominantColor($dc_image);

					$products_data[] = array(
						'product_id'  => $product_info['product_id'],
						'thumb'       => $image,
						'dominant_color' => $dominant_color,
						'name'        => html_entity_decode($product_info['name'], ENT_QUOTES, "UTF-8"),
						'price'       => $price,
						'quantity' 	 	=> $product_info['quantity'],
						'special' 	 => (float) $special,
						'formatted_special' => $formatedSpecial,
						'tax'         => $tax == false ? '' : $tax,
						'rating'      => $rating,
						'hasOption'	  => $this->productOption($product_info['product_id']),
						'wishlist_status' => $already_status
					);
				}
			}

			return $products_data;
		} else {
			return [];
		}
	}


	public function getProductByIdTotal($id, $data)
	{


	$sql=	"SELECT COUNT(DISTINCT mcp.product_id) as total 
	FROM " . DB_PREFIX . "mobikul_carousel_to_product mcp 
	LEFT JOIN " . DB_PREFIX . "product p ON (mcp.product_id = p.product_id) 
	LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) 
	WHERE mcp.id = " . (int)$id;
	


		$query = $this->db->query($sql);
		return $query->row['total'];
	}



	public function getProductById($id, $data)
	{


		$products_data = array();
		// $sql = "SELECT product_id FROM " . DB_PREFIX . "mobikul_carousel_to_product WHERE id=" . $id;
		// $sql = "SELECT mcp.product_id, pd.name, p.model, p.price, p.quantity, p.status 
		// FROM " . DB_PREFIX . "mobikul_carousel_to_product mcp
		// LEFT JOIN " . DB_PREFIX . "product p ON (mcp.product_id = p.product_id)
		// LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id)
		// WHERE mcp.id = " . (int)$id;


		$sql = "SELECT DISTINCT mcp.product_id, pd.name, p.model, p.price, p.quantity, p.status 
        FROM " . DB_PREFIX . "mobikul_carousel_to_product mcp 
         LEFT JOIN " . DB_PREFIX . "product p ON (mcp.product_id = p.product_id) 
          LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) 
         WHERE mcp.id = " . (int)$id;


		if (!empty($data['filter_name'])) {
			$sql .= " AND pd.name LIKE '" . $this->db->escape($data['filter_name']) . "%'";
		}

		if (!empty($data['filter_model'])) {
			$sql .= " AND p.model LIKE '" . $this->db->escape($data['filter_model']) . "%'";
		}

		if (!empty($data['filter_price'])) {
			$sql .= " AND p.price LIKE '" . $this->db->escape($data['filter_price']) . "%'";
		}

		if (isset($data['filter_quantity']) && $data['filter_quantity'] !== '') {
			$sql .= " AND p.quantity = '" . (int)$data['filter_quantity'] . "'";
		}

		if (isset($data['filter_status']) && $data['filter_status'] !== '') {
			$sql .= " AND p.status = '" . (int)$data['filter_status'] . "'";
		}

		$sort_data = array(
			'pd.name',
			'p.model',
			'p.price',
			'p.quantity',
			'p.status'
		);

		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY pd.name";
		}

		if (isset($data['order']) && ($data['order'] == 'DESC')) {
			$sql .= " DESC";
		} else {
			$sql .= " ASC";
		}

		if (isset($data['start']) || isset($data['limit'])) {
			if (!isset($data['start'])) {
				$data['start'] = 0;
			}

			if (!isset($data['limit']) || $data['limit'] < 1) {
				$data['limit'] = 20;
			}

			// $sql .= " LIMIT " . (int)$data['start'] . "," . (int)$data['limit'];
		}

		if (isset($data['page'])) {
			$page = $data['page'];
		} else {
			$page = 1;
		}

		if (isset($data['limit'])) {
			$limit = $data['limit'];
		} elseif (isset($data['count'])) {
			$limit = $data['count'];
		} else {
			$limit = 5;
		}

		$start    = ($page - 1) * $limit;
		$sql .= " LIMIT " . $start . ", " . $limit;

		$products = $this->db->query($sql)->rows;

		if ($products) {
			foreach ($products as $product_id) {
				$product_info = $this->model_catalog_product->getProduct($product_id['product_id']);

				$this->load->model('tool/image');

				if ($product_info) {

					$already_status = false;

					if (version_compare(VERSION, '2.1.0.1	', '>=')) {
						foreach ($this->getDBWishlist() as $wishlist) {
							if ($wishlist['product_id'] == $product_id['product_id']) {
								$already_status = true;
							}
						}
					}


					if (isset($data['width']))
						$width = $data['width'];
					else
						$width = 100;

					if ($product_info['image']) {
						$image = str_replace(' ', '%20', $this->model_tool_image->resize($product_info['image'], ($width / 2), ($width / 2)));
					} else {
						$image = $this->model_tool_image->resize('placeholder.png', ($width / 2), ($width / 2));
					}

					if ($this->customer->isLogged() || !$this->config->get('config_customer_price')) {
						$price = $this->currency->format($this->tax->calculate($product_info['price'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
					} else {
						$price = false;
					}
					if ((float) $product_info['special']) {
						$formatedSpecial = $this->currency->format($this->tax->calculate($product_info['special'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
						$special = $product_info['special'];
					} else {
						$formatedSpecial = '';
						$special = 0.00;
					}

					if ($this->config->get('config_tax')) {
						$tax = $this->currency->format((float)$product_info['special'] ? $product_info['special'] : $product_info['price'], $this->session->data['currency']);
					} else {
						$tax = false;
					}

					if ($this->config->get('config_review_status')) {
						$rating = $product_info['rating'];
					} else {
						$rating = 0;
					}


					if (isset($product_info['image']) && is_file(DIR_IMAGE . $product_info['image']))
						$dc_image = DIR_IMAGE . $product_info['image'];
					elseif (is_file(DIR_IMAGE . 'placeholder.png'))
						$dc_image = DIR_IMAGE . 'placeholder.png';
					else
						$dc_image = '';

					$dominant_color = $this->getDominantColor($dc_image);

					$products_data[] = array(
						'product_id'  => $product_info['product_id'],
						'thumb'       => $image,
						'dominant_color' => $dominant_color,
						'name'        => html_entity_decode($product_info['name'], ENT_QUOTES, "UTF-8"),
						'price'       => $price,
						'quantity' 	 	=> $product_info['quantity'],
						'special' 	 => (float) $special,
						'formatted_special' => $formatedSpecial,
						'tax'         => $tax == false ? '' : $tax,
						'rating'      => $rating,
						'hasOption'	  => $this->productOption($product_info['product_id']),
						'wishlist_status' => $already_status
					);
				}
			}
		}

		return $products_data;
	}
	/**
	 * Fetches the featured product content
	 * @param  integer $width   contains the width of the device
	 * @return array          returns the featured product data
	 */
	public function featured($data = array())
	{
		$this->load->model('catalog/product');

		if (isset($data['sort'])) {
			$sort = $data['sort'];
		} else {
			$sort = 'p.sort_order';
		}

		if (isset($data['order'])) {
			$order = $data['order'];
		} else {
			$order = 'ASC';
		}

		if (isset($data['page'])) {
			$page = $data['page'];
		} else {
			$page = 1;
		}

		if (isset($data['limit'])) {
			$limit = $data['limit'];
		} elseif (isset($data['count'])) {
			$limit = $data['count'];
		} else {
			$limit = 5;
		}

		if (isset($data['filter_name'])) {
			$filter_name = $data['filter_name'];
		} else {
			$filter_name = '';
		}


		$filter_data = array(
			'filter_name'     => $filter_name,
			'sort'               => $sort,
			'order'              => $order,
			'start'              => ($page - 1) * $limit,
			'limit'              => $limit
		);

		$products = $this->getFeaturedProduct($filter_data);
		$products_data = array();
		if ($products) {
			foreach ($products as $product_id) {
				$product_info = $this->model_catalog_product->getProduct($product_id['product_id']);

				$this->load->model('tool/image');

				if ($product_info) {

					$already_status = false;

					if (version_compare(VERSION, '2.1.0.1	', '>=')) {
						foreach ($this->getDBWishlist() as $wishlist) {
							if ($wishlist['product_id'] == $product_id['product_id']) {
								$already_status = true;
							}
						}
					}


					if (isset($data['width']))
						$width = $data['width'];
					else
						$width = 100;

					if ($product_info['image']) {
						$image = str_replace(' ', '%20', $this->model_tool_image->resize($product_info['image'], ($width / 2), ($width / 2)));
					} else {
						$image = $this->model_tool_image->resize('placeholder.png', ($width / 2), ($width / 2));
					}

					if ($this->customer->isLogged() || !$this->config->get('config_customer_price')) {
						$price = $this->currency->format($this->tax->calculate($product_info['price'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
					} else {
						$price = false;
					}
					if ((float) $product_info['special']) {
						$formatedSpecial = $this->currency->format($this->tax->calculate($product_info['special'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
						$special = $product_info['special'];
					} else {
						$formatedSpecial = '';
						$special = 0.00;
					}

					if ($this->config->get('config_tax')) {
						$tax = $this->currency->format((float)$product_info['special'] ? $product_info['special'] : $product_info['price'], $this->session->data['currency']);
					} else {
						$tax = false;
					}

					if ($this->config->get('config_review_status')) {
						$rating = $product_info['rating'];
					} else {
						$rating = 0;
					}


					if (isset($product_info['image']) && is_file(DIR_IMAGE . $product_info['image']))
						$dc_image = DIR_IMAGE . $product_info['image'];
					elseif (is_file(DIR_IMAGE . 'placeholder.png'))
						$dc_image = DIR_IMAGE . 'placeholder.png';
					else
						$dc_image = '';

					$dominant_color = $this->getDominantColor($dc_image);

					$products_data[] = array(
						'product_id'  => $product_info['product_id'],
						'thumb'       => $image,
						'dominant_color' => $dominant_color,
						'name'        => html_entity_decode($product_info['name'], ENT_QUOTES, "UTF-8"),
						'description' => utf8_substr(strip_tags(html_entity_decode($product_info['description'], ENT_QUOTES, 'UTF-8')), 0, $this->config->get('config_product_description_length')) . '..',
						'price'       => $price,
						'quantity' 	 	=> $product_info['quantity'],
						'special' 	 => (float) $special,
						'formatted_special' => $formatedSpecial,
						'tax'         => $tax == false ? '' : $tax,
						'rating'      => $rating,
						'hasOption'	  => $this->productOption($product_info['product_id']),
						'wishlist_status' => $already_status
					);
				}
			}
		}
		return $products_data;
	}

	/**
	 * Fetch Featured Data
	 */
	public function getFeaturedProduct($data = array())
	{
		$sql = "SELECT mf.product_id FROM " . DB_PREFIX . "mobikul_featured_product mf LEFT JOIN " . DB_PREFIX . "product p ON(mf.product_id = p.product_id) LEFT JOIN " . DB_PREFIX . "product_description pd ON(p.product_id = pd.product_id) WHERE p.status = '1' AND  pd.language_id = " . $this->config->get('config_language_id');

		if (isset($data['filter_name']) && $data['filter_name']) {
			$sql .= " AND pd.name LIKE '%" . $data['filter_name'] . "%'";
		}

		if (isset($data['sort']) && $data['sort'] && isset($data['order'])) {
			$sql .= " ORDER BY " . $data['sort'] . " " . $data['order'];
		} else {
			$sql .= " ORDER BY p.sort_order DESC";
		}


		if (isset($data['start']) && isset($data['limit'])) {
			$sql .= " LIMIT " . $data['start'] . "," . $data['limit'];
		}

		return $this->db->query($sql)->rows;
	}


	public function getTotalFeatured($data = array())
	{
		return $this->db->query("SELECT mf.product_id FROM " . DB_PREFIX . "mobikul_featured_product mf LEFT JOIN " . DB_PREFIX . "product p ON(mf.product_id = p.product_id) LEFT JOIN " . DB_PREFIX . "product_description pd ON(p.product_id = pd.product_id) WHERE p.status = '1' AND  pd.language_id = " . $this->config->get('config_language_id'))->num_rows;
	}
	/**
	 * Filter product module data
	 * @param  string $filterData  contains filter data
	 * @param  integer $category_id contains category ID
	 * @return array              returns filtered data
	 */
	public function filterModInfo($filterData = '', $category_id)
	{
		$this->load->model('catalog/category');
		$category_info = $this->model_catalog_category->getCategory($category_id);

		if ($category_info) {
			$this->load->language('module/filter');

			$filterMod['path'] = (string)$category_id;

			if (isset($filterData)) {
				$filterMod['filter_category'] = explode(',', $filterData);
			} else {
				$filterMod['filter_category'] = array();
			}

			$this->load->model('catalog/product');

			$filterMod['filter_groups'] = array();

			$filter_groups = $this->model_catalog_category->getCategoryFilters($category_id);

			if ($filter_groups) {
				foreach ($filter_groups as $filter_group) {
					$childen_data = array();

					foreach ($filter_group['filter'] as $filter) {
						$filter_data = array(
							'filter_category_id' => $category_id,
							'filter_filter'      => $filter['filter_id']
						);

						$childen_data[] = array(
							'filter_id' => $filter['filter_id'],
							'name'      => $filter['name'] . ($this->config->get('config_product_count') ? ' (' . $this->model_catalog_product->getTotalProducts($filter_data) . ')' : '')
						);
					}

					$filterMod['filter_groups'][] = array(
						'filter_group_id' => $filter_group['filter_group_id'],
						'name'            => $filter_group['name'],
						'filter'          => $childen_data
					);
				}
			}
			return $filterMod;
		}
	}
	/**
	 * Fetches the information of a category
	 * @param  array $categoryData contains category data
	 * @return array               contains category data description
	 */
	public function productCategory($categoryData)
	{
		$this->load->model('catalog/category');
		$this->load->language('product/category');
		$this->load->model('catalog/product');

		if (isset($categoryData['filter'])) {
			$filter = $categoryData['filter'];
		} else {
			$filter = '';
		}

		if (!isset($categoryData['width']) || !$categoryData['width']) {
			$categoryData['width'] = 100;
		}

		if (isset($categoryData['sort'])) {
			$sort = $categoryData['sort'];
		} else {
			$sort = 'p.sort_order';
		}

		if (isset($categoryData['order'])) {
			$order = $categoryData['order'];
		} else {
			$order = 'ASC';
		}

		if (isset($categoryData['page'])) {
			$page = $categoryData['page'];
		} else {
			$page = 1;
		}

		if (isset($categoryData['limit'])) {
			$limit = $categoryData['limit'];
		} else {
			$limit = $this->config->get('config_product_limit');
		}

		if (version_compare(VERSION, '2.0.0.0', '>=')) {
			$module_data = $this->filterModInfo($filter, $categoryData['path']);
		}

		if (isset($categoryData['path'])) {

			$path = '';

			$parts = explode('_', (string)$categoryData['path']);

			$category_id = (int)array_pop($parts);

			foreach ($parts as $path_id) {
				if (!$path) {
					$path = (int)$path_id;
				} else {
					$path .= '_' . (int)$path_id;
				}

				$category_info = $this->model_catalog_category->getCategory($path_id);
			}
		} else {
			$category_id = 0;
		}

		$category_info = $this->model_catalog_category->getCategory($category_id);

		if ($category_info) {

			$this->load->model('tool/image');

			if ($category_info['image']) {
				$category['thumb'] = str_replace(' ', '%20', $this->model_tool_image->resize($category_info['image'], ($categoryData['width'] / 2), ($categoryData['width'] / 2)));
			} else {
				$category['thumb'] = '';
			}
			if (isset($category['image']) && is_file(DIR_IMAGE . $category['image']))
				$dc_image = DIR_IMAGE . $category['image'];
			elseif (is_file(DIR_IMAGE . 'placeholder.png'))
				$dc_image = DIR_IMAGE . 'placeholder.png';
			else
				$dc_image = '';

			$category['dominant_color'] = $this->getDominantColor($dc_image);

			$category['description'] = html_entity_decode($category_info['description'], ENT_QUOTES, 'UTF-8');
			// $category['compare'] = $this->url->link('product/compare');

			$category['categories'] = array();

			$results = $this->model_catalog_category->getCategories($category_id);

			foreach ($results as $result) {
				$filter_data = array(
					'filter_category_id'  => $result['category_id'],
					'filter_sub_category' => true
				);

				$category['categories'][] = array(
					'name'  => html_entity_decode($result['name'], ENT_QUOTES, "UTF-8") . ($this->config->get('config_product_count') ? ' (' . $this->model_catalog_product->getTotalProducts($filter_data) . ')' : ''),
					'path'  => $categoryData['path'] . '_' . $result['category_id']
				);
			}

			$category['products'] = array();

			$filter_data = array(
				'filter_category_id' => $category_id,
				'filter_filter'      => $filter,
				'sort'               => $sort,
				'order'              => $order,
				'start'              => ($page - 1) * $limit,
				'limit'              => $limit
			);


			$category['product_total'] = $this->model_catalog_product->getTotalProducts($filter_data);

		


			$results = $this->model_catalog_product->getProducts($filter_data);


			foreach ($results as $result) {

				$already_status = false;
				if (version_compare(VERSION, '2.1.0.1	', '>=')) {
					foreach ($this->getDBWishlist() as $wishlist) {
						if ($wishlist['product_id'] == $result['product_id']) {
							$already_status = true;
						}
					}
				}

				if ($result['image']) {
					$image = $result['image'];
				} else {
					$image = 'placeholder.png';
				}

				if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
					$price = $this->currency->format($this->tax->calculate($result['price'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
				} else {
					$price = false;
				}

				if ((float) $result['special']) {
					$formatedSpecial = $this->currency->format($this->tax->calculate($result['special'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
					$special = $result['special'];
				} else {
					$formatedSpecial = '';
					$special = 0.00;
				}

				if ($this->config->get('config_tax')) {
					$tax = $this->currency->format((float)$result['special'] ? $result['special'] : $result['price'], $this->session->data['currency']);
				} else {
					$tax = false;
				}

				if ($this->config->get('config_review_status')) {
					$rating = (int)$result['rating'];
				} else {
					$rating = 0;
				}

				if (isset($result['image']) && is_file(DIR_IMAGE . $result['image']))
					$dc_image = DIR_IMAGE . $result['image'];
				elseif (is_file(DIR_IMAGE . 'placeholder.png'))
					$dc_image = DIR_IMAGE . 'placeholder.png';
				else
					$dc_image = '';

				$dominant_color = $this->getDominantColor($dc_image);

				$category['products'][] = array(
					'product_id'  => $result['product_id'],
					'thumb'       => str_replace(' ', '%20', $this->model_tool_image->resize($image, ($categoryData['width'] / 2.5), ($categoryData['width'] / 2.5))),
					'dominant_color' => $dominant_color,
					'name'        => html_entity_decode($result['name'], ENT_QUOTES, 'UTF-8'),
					'description' => utf8_substr(strip_tags(html_entity_decode($result['description'], ENT_QUOTES, 'UTF-8')), 0, $this->config->get('config_product_description_length')) . '..',
					'price'       => $price,
					'special' 	 => (float) $special,
					'formatted_special' => $formatedSpecial,
					'quantity' 	 => $result['quantity'],
					'tax'         => $tax == false ? '' : $tax,
					'minimum'     => $result['minimum'] > 0 ? $result['minimum'] : 1,
					'rating'      => $result['rating'],
					'path'        => (string)$categoryData['path'],
					'product_id'  => $result['product_id'],
					'hasOption'	  => $this->productOption($result['product_id']),
					'wishlist_status' => $already_status
				);
			}

			$category['sorts'] = array();

			$category['sorts'][] = array(
				'text'  => $this->language->get('text_default'),
				'value' => 'p.sort_order',
				'order'	=> 'ASC',
				'path'  => (string)$categoryData['path']
			);

			$category['sorts'][] = array(
				'text'  => $this->language->get('text_name_asc'),
				'value' => 'pd.name',
				'order'	=> 'ASC',
				'path'  => (string)$categoryData['path']
			);

			$category['sorts'][] = array(
				'text'  => $this->language->get('text_name_desc'),
				'value' => 'pd.name',
				'order'	=> 'DESC',
				'path'  => (string)$categoryData['path']
			);

			$category['sorts'][] = array(
				'text'  => $this->language->get('text_price_asc'),
				'value' => 'p.price',
				'order'	=> 'ASC',
				'path'  => (string)$categoryData['path']
			);

			$category['sorts'][] = array(
				'text'  => $this->language->get('text_price_desc'),
				'value' => 'p.price',
				'order'	=> 'DESC',
				'path'  => (string)$categoryData['path']
			);

			if ($this->config->get('config_review_status')) {
				$category['sorts'][] = array(
					'text'  => $this->language->get('text_rating_desc'),
					'value' => 'rating',
					'order'	=> 'DESC',
					'path'  => (string)$categoryData['path']
				);

				$category['sorts'][] = array(
					'text'  => $this->language->get('text_rating_asc'),
					'value' => 'rating',
					'order'	=> 'ASC',
					'path'  => (string)$categoryData['path']
				);
			}

			$category['sorts'][] = array(
				'text'  => $this->language->get('text_model_asc'),
				'value' => 'p.model',
				'order'	=> 'ASC',
				'path'  => (string)$categoryData['path']
			);

			$category['sorts'][] = array(
				'text'  => $this->language->get('text_model_desc'),
				'value' => 'p.model',
				'order'	=> 'DESC',
				'path'  => (string)$categoryData['path']
			);
		}

		if (version_compare(VERSION, '2.0.0.0', '>=')) {
			$return_array = array(
				'categoryData'	=> $category ?? [],
				'moduleData'	=> $module_data
			);
		} else {
			$return_array = array(
				'categoryData'	=> $category
			);
		}

		return $return_array;
	}
	/**
	 * tells whether the product contain options
	 * @param  integer $product_id  Contains product ID
	 * @return boolean             [returns true or false]
	 */
	public function productOption($product_id)
	{
		$sql = "SELECT product_option_id FROM " . DB_PREFIX . "product_option WHERE product_id = '" . $product_id . "'";
		$query = $this->db->query($sql);
		if ($query->row) {
			return true;
		} else {
			return false;
		}
	}
	/**
	 * fetches a product's data
	 * @param  integer  $product_id contains product's ID
	 * @param  integer $width      contains width of device
	 * @return array              return product information
	 */
	public function getProduct($product_id, $width = 100)
	{
		if (isset($product_id)) {
			$product_id = (int)$product_id;
		} else {
			$product_id = 0;
		}

		$productData = array();

		$productData['langArray'] = $this->load->language('product/product');
		$this->load->model('catalog/product');

		$product_info = $this->model_catalog_product->getProduct($product_id);

		if ($product_info) {

			$already_status = false;
			if (version_compare(VERSION, '2.1.0.1	', '>=')) {
				foreach ($this->getDBWishlist() as $wishlist) {
					if ($wishlist['product_id'] == $product_id) {
						$already_status = true;
					}
				}
			}

			$productData['tab_review'] = sprintf($this->language->get('tab_review'), $product_info['reviews']);

			if ($product_id) {
				$ar_exist = $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_ar WHERE product_id = '" . $product_id . "'")->row;
				if (!empty($ar_exist) && $ar_exist['status']) {
					$productData['is_ar'] = true;
					$productData['ar_url'] = html_entity_decode($this->url->link('api/wkrestapi/catalog/arProduct', 'product_id=' . $product_id, true), ENT_QUOTES, 'UTF-8');
				} else {
					$productData['is_ar'] = false;
				}
			} else {
				$productData['is_ar'] = false;
			}

			$productData['product_id'] = (int)$product_id;
			$productData['name'] = html_entity_decode($product_info['name'], ENT_QUOTES, "UTF-8");
			$productData['manufacturer'] = html_entity_decode($product_info['manufacturer'], ENT_QUOTES, 'UTF-8');
			$productData['manufacturer_id'] = $product_info['manufacturer_id'];
			$productData['model'] = html_entity_decode($product_info['model'], ENT_QUOTES, 'UTF-8');

			if ($this->config->get('module_marketplace_status') || $this->config->get('marketplace_status')) {
				$check_seller = $this->db->query("SELECT c2p.customer_id,oc.firstname,oc.lastname FROM " . DB_PREFIX . "customerpartner_to_product c2p LEFT JOIN " . DB_PREFIX . "customer oc ON (c2p.customer_id = oc.customer_id) WHERE c2p.product_id = '" . (int)$product_id . "' AND c2p.customer_id > 0")->row;

				if ($check_seller) {
					$productData['seller_id'] = $check_seller['customer_id'];
					$productData['seller_name'] = html_entity_decode($check_seller['firstname'] . " " . $check_seller['lastname'], ENT_QUOTES, 'UTF-8');
				} else {
					$productData['seller_id'] = '';
					$productData['seller_name'] = '';
				}
			}

			$productData['reward'] = $product_info['reward'];
			$productData['points'] = $product_info['points'];

			if ($product_info['quantity'] <= 0) {
				$productData['stock'] = $product_info['stock_status'];
			} elseif ($this->config->get('config_stock_display')) {
				$productData['stock'] = $product_info['quantity'];
			} else {
				$productData['stock'] = strip_tags($this->language->get('text_instock'));
			}

			$this->load->model('tool/image');

			if ($product_info['image']) {
				$productData['popup'] = str_replace(' ', '%20', $this->model_tool_image->resize($product_info['image'], $width * 2, $width * 2));
			} else {
				$productData['popup'] = '';
			}

			if ($product_info['image']) {
				$productData['thumb'] = str_replace(' ', '%20', $this->model_tool_image->resize($product_info['image'], $width, $width));
			} else {
				$productData['thumb'] = '';
			}

			if (isset($product_info['image']) && is_file(DIR_IMAGE . $product_info['image']))
				$dc_image = DIR_IMAGE . $product_info['image'];
			elseif (is_file(DIR_IMAGE . 'placeholder.png'))
				$dc_image = DIR_IMAGE . 'placeholder.png';
			else
				$dc_image = '';

			$productData['dominant_color'] = $this->getDominantColor($dc_image);

			$productData['wishlist_status'] = $already_status;

			$productData['images'] = array();

			$results = $this->model_catalog_product->getProductImages($product_id);

			$productData['images'][] = array(
				'popup'	=> $productData['popup'],
				'thumb'	=> $product_info['image'] ? str_replace(' ', '%20', $this->model_tool_image->resize($product_info['image'], ($width / 4), ($width / 4))) : '',
				'dominant_color' => $productData['dominant_color']
			);

			foreach ($results as $result) {

				if (isset($result['image']) && is_file(DIR_IMAGE . $result['image']))
					$dc_image = DIR_IMAGE . $result['image'];
				elseif (is_file(DIR_IMAGE . 'placeholder.png'))
					$dc_image = DIR_IMAGE . 'placeholder.png';
				else
					$dc_image = '';

				$dominant_color = $this->getDominantColor($dc_image);

				$productData['images'][] = array(
					'popup' => str_replace(' ', '%20', $this->model_tool_image->resize($result['image'], $width * 2, $width * 2)),
					'thumb' => str_replace(' ', '%20', $this->model_tool_image->resize($result['image'], ($width / 4), ($width / 4))),
					'dominant_color' => $dominant_color
				);
			}

			if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
				$productData['price'] = $this->currency->format($this->tax->calculate($product_info['price'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
			} else {
				$productData['price'] = false;
			}

			if ((float) $product_info['special']) {
				$formatedSpecial = $this->currency->format($this->tax->calculate($product_info['special'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
				$special = $product_info['special'];
			} else {
				$formatedSpecial = '';
				$special = 0.00;
			}

			$productData['special'] = (float) $special;
			$productData['formatted_special'] = $formatedSpecial;

			if ($this->config->get('config_tax')) {
				$productData['tax'] = $this->currency->format((float)$product_info['special'] ? $product_info['special'] : $product_info['price'], $this->session->data['currency']);
			} else {
				$productData['tax'] = false;
			}

			$discounts = $this->model_catalog_product->getProductDiscounts($product_id);

			$productData['discounts'] = array();

			foreach ($discounts as $discount) {
				$productData['discounts'][] = array(
					'quantity' => $discount['quantity'],
					'price'    => $this->currency->format($this->tax->calculate($discount['price'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency'])
				);
			}

			$productData['options'] = array();

			foreach ($this->model_catalog_product->getProductOptions($product_id) as $option) {
				$product_option_value_data = array();
				if (version_compare(VERSION, '2.0.0.0', '<')) {
					$option['product_option_value'] = $option['option_value'];
				}
				foreach ($option['product_option_value'] as $option_value) {
					if (!$option_value['subtract'] || ($option_value['quantity'] > 0)) {
						if ((($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) && (float)$option_value['price']) {
							$price = $this->currency->format($this->tax->calculate($option_value['price'], $product_info['tax_class_id'], $this->config->get('config_tax') ? 'P' : false), $this->session->data['currency']);
						} else {
							$price = '';
						}

						$product_option_value_data[] = array(
							'product_option_value_id' => $option_value['product_option_value_id'],
							'option_value_id'         => $option_value['option_value_id'],
							'name'                    => htmlspecialchars_decode($option_value['name']),
							'image'                   => $option_value['image'] ? str_replace(' ', '%20', $this->model_tool_image->resize($option_value['image'], $width, $width)) : '',
							'price'                   => $price,
							'price_prefix'            => $option_value['price_prefix']
						);
					}
				}

				if (version_compare(VERSION, '2.0.0.0', '>='))
					$option_value_option = $option['value'];
				else
					$option_value_option = '';

				$productData['options'][] = array(
					'product_option_id'    => $option['product_option_id'],
					'product_option_value' => $product_option_value_data,
					'option_id'            => $option['option_id'],
					'name'                 => htmlspecialchars_decode($option['name']),
					'type'                 => $option['type'],
					'value'                => $option_value_option,
					'required'             => $option['required']
				);
			}

			if ($product_info['quantity']) {
				$productData['quantity'] = $product_info['quantity'];
			} else {
				$productData['quantity'] = 0;
			}

			if ($product_info['minimum']) {
				$productData['minimum'] = $product_info['minimum'];
			} else {
				$productData['minimum'] = 1;
			}

			$productData['review_status'] = $this->config->get('config_review_status');

			if ($this->config->get('config_review_guest') || $this->customer->isLogged()) {
				$productData['review_guest'] = true;
			} else {
				$productData['review_guest'] = false;
			}

			if ($this->customer->isLogged()) {
				$productData['customer_name'] = $this->customer->getFirstName() . '&nbsp;' . $this->customer->getLastName();
			} else {
				$productData['customer_name'] = '';
			}

			$productData['reviews'] = sprintf($this->language->get('text_reviews'), (int)$product_info['reviews']);
			$productData['rating'] = (int)$product_info['rating'];
			$productData['description'] = html_entity_decode($product_info['description'], ENT_QUOTES, 'UTF-8');
			if ($this->session->data['language'] == 'ar') {
				$productData['description'] = "<html dir='rtl'>" . $productData['description'] . "</html>";
			}
			$productData['attribute_groups'] = $this->model_catalog_product->getProductAttributes($product_id);

			$productData['relatedProducts'] = array();

			$results = $this->model_catalog_product->getProductRelated($product_id);

			foreach ($results as $result) {

				$already_status = false;

				if (version_compare(VERSION, '2.1.0.1	', '>=')) {
					foreach ($this->getDBWishlist() as $wishlist) {
						if ($wishlist['product_id'] == $result['product_id']) {
							$already_status = true;
						}
					}
				}

				if ($result['image']) {
					$image = $result['image'];
				} else {
					$image = 'placeholder.png';
				}

				if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
					$price = $this->currency->format($this->tax->calculate($result['price'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
				} else {
					$price = false;
				}

				if ((float) $result['special']) {
					$formatedSpecial = $this->currency->format($this->tax->calculate($result['special'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
					$special = $result['special'];
				} else {
					$formatedSpecial = '';
					$special = 0.00;
				}

				if ($this->config->get('config_tax')) {
					$tax = $this->currency->format((float)$result['special'] ? $result['special'] : $result['price'], $this->session->data['currency']);
				} else {
					$tax = false;
				}

				if ($this->config->get('config_review_status')) {
					$rating = (int)$result['rating'];
				} else {
					$rating = 0;
				}

				$related_product_info = $this->model_catalog_product->getProduct($result['product_id']);

				if ($related_product_info['quantity'] <= 0) {
					$stock = $related_product_info['stock_status'];
				} elseif ($this->config->get('config_stock_display')) {
					$stock = $related_product_info['quantity'];
				} else {
					$stock = $this->language->get('text_instock');
				}

				if (isset($result['image']) && is_file(DIR_IMAGE . $result['image']))
					$dc_image = DIR_IMAGE . $result['image'];
				elseif (is_file(DIR_IMAGE . 'placeholder.png'))
					$dc_image = DIR_IMAGE . 'placeholder.png';
				else
					$dc_image = '';

				$dominant_color = $this->getDominantColor($dc_image);

				$productData['relatedProducts'][] = array(
					'product_id'  => $result['product_id'],
					'thumb'       => str_replace(' ', '%20', $this->model_tool_image->resize($image, $width, $width)),
					'dominant_color' => $dominant_color,
					'name'        => html_entity_decode($result['name'], ENT_QUOTES, 'UTF-8'),
					'description' => utf8_substr(strip_tags(html_entity_decode($result['description'], ENT_QUOTES, 'UTF-8')), 0, $this->config->get('config_product_description_length')) . '..',
					'price'       => $price,
					'special' 	 => (float) $special,
					'formatted_special' => $formatedSpecial,
					'tax'         => $tax == false ? '' : $tax,
					'hasOption'	  => $this->productOption($result['product_id']),
					'stock'		  => $stock,
					'minimum'     => $result['minimum'] > 0 ? $result['minimum'] : 1,
					'rating'      => $rating,
					'href'        => htmlspecialchars_decode($this->url->link('product/product', 'product_id=' . $result['product_id'] . '&name=' . $result['name'], 'SSL')),
					'wishlist_status' => $already_status
				);
			}

			$productData['tags'] = array();

			if ($product_info['tag']) {
				$tags = explode(',', $product_info['tag']);

				foreach ($tags as $tag) {
					$productData['tags'][] = array(
						'tag'  => trim($tag)
					);
				}
			}

			$productData['href'] = htmlspecialchars_decode($this->url->link('product/product', 'product_id=' . $product_id . '&name=' . $productData['name'], 'SSL'));
			$productData['text_payment_recurring'] = $this->language->get('text_payment_recurring');
			$productData['recurrings'] = $this->model_catalog_product->getProfiles($product_id);
			$productData['reviewData'] = $this->review($product_id);
			if (isset($productData['reviewData']['reviews']) && !empty($productData['reviewData']['reviews'])) {
				foreach ($productData['reviewData']['reviews'] as $key => $value) {
					$productData['reviewData']['reviews'][$key]['author'] = html_entity_decode($value['author'], ENT_QUOTES, 'UTF-8');
					$productData['reviewData']['reviews'][$key]['text'] = strip_tags($value['text']);
				}
			}
			$productData['productPrev'] = $this->productPrev($product_id);
			$productData['productNext'] = $this->productNext($product_id);
			/**
			 * For MP Mobikul
			 */
			// if ($this->config->get('marketplace_status')) {
			// 	$productData['mp_info']=$this->getSellerAtProduct($product_id);
			// }

			$this->model_catalog_product->updateViewed($product_id);

			if (!$productData['tax']) {
				$productData['tax'] = '';
			}
			return $productData;
		} else
			return false;
	}

	/**
	 * fetches a sepcial products
	 * @param  array  $filter_data data for filtering
	 * @param  integer $width      contains width of device
	 * @return array              return product information
	 */
	public function getSpecialProductTotal($filter_data, $width = 100)
	{
		$this->load->language('product/special');

		$this->load->model('catalog/product');

		$this->load->model('tool/image');


		$product_total = $this->model_catalog_product->getTotalProductSpecials();

		return $product_total;
	}


	public function getSpecialProduct($filter_data, $width = 100)
	{
		$this->load->language('product/special');

		$this->load->model('catalog/product');

		$this->load->model('tool/image');

		if (isset($filter_data['sort'])) {
			$sort = $filter_data['sort'];
		} else {
			$sort = 'p.sort_order';
		}

		if (isset($filter_data['order'])) {
			$order = $filter_data['order'];
		} else {
			$order = 'ASC';
		}

		if (isset($filter_data['page'])) {
			$page = $filter_data['page'];
		} else {
			$page = 1;
		}

		if (isset($filter_data['limit'])) {
			$limit = $filter_data['limit'];
		} else {
			$limit = $this->config->get('config_product_limit');
		}

		$data['products'] = array();

		$filter_data = array(
			'sort'  => $sort,
			'order' => $order,
			'start' => ($page - 1) * $limit,
			'limit' => $limit
		);

		$product_total = $this->model_catalog_product->getTotalProductSpecials();

		$results = $this->model_catalog_product->getProductSpecials($filter_data);

		foreach ($results as $result) {


			if ($result['image']) {
				$image = $this->model_tool_image->resize($result['image'], $width, $width);
			} else {
				$image = $this->model_tool_image->resize('placeholder.png', $width, $width);
			}

			if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
				$price = $this->currency->format($this->tax->calculate($result['price'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
			} else {
				$price = false;
			}

			if ((float) $result['special']) {
				$formatedSpecial = $this->currency->format($this->tax->calculate($result['special'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
				$special = $result['special'];
			} else {
				$formatedSpecial = '';
				$special = 0.00;
			}

			if ($this->config->get('config_tax')) {
				$tax = $this->currency->format((float)$result['special'] ? $result['special'] : $result['price'], $this->session->data['currency']);
			} else {
				$tax = false;
			}

			if ($this->config->get('config_review_status')) {
				$rating = (int)$result['rating'];
			} else {
				$rating = 0;
			}
			$already_status = false;

			if (version_compare(VERSION, '2.1.0.1	', '>=')) {
				foreach ($this->getDBWishlist() as $wishlist) {
					if ($wishlist['product_id'] == $result['product_id']) {
						$already_status = true;
					}
				}
			}
			$data['products'][] = array(
				'product_id'  => $result['product_id'],
				'thumb'       => $image,
				'dominant_color' => $this->getDominantColor($image),
				'name'        => html_entity_decode($result['name'], ENT_QUOTES, 'UTF-8'),
				'price'       => $price,
				'quantity' 	 => $result['quantity'],
				'special' 	 => (float) $special,
				'formatted_special' => $formatedSpecial,
				'tax'         => $tax == false ? '' : $tax,
				'rating'      => $result['rating'],
				'reviews'    => sprintf($this->language->get('text_reviews'), (int)$result['reviews']),
				'hasOption'  => $this->productOption($result['product_id']),
				'wishlist_status' => $already_status


			);
		}
		$sorts = array();
		$categoryData['path'] = '';

		$sorts[] = array(
			'text'  => $this->language->get('text_default'),
			'value' => 'p.sort_order',
			'order'	=> 'ASC',
			'path'  => (string)$categoryData['path']
		);

		$sorts[] = array(
			'text'  => $this->language->get('text_name_asc'),
			'value' => 'pd.name',
			'order'	=> 'ASC',
			'path'  => (string)$categoryData['path']
		);

		$sorts[] = array(
			'text'  => $this->language->get('text_name_desc'),
			'value' => 'pd.name',
			'order'	=> 'DESC',
			'path'  => (string)$categoryData['path']
		);

		$sorts[] = array(
			'text'  => $this->language->get('text_price_asc'),
			'value' => 'ps.price',
			'order'	=> 'ASC',
			'path'  => (string)$categoryData['path']
		);

		$sorts[] = array(
			'text'  => $this->language->get('text_price_desc'),
			'value' => 'ps.price',
			'order'	=> 'DESC',
			'path'  => (string)$categoryData['path']
		);

		if ($this->config->get('config_review_status')) {
			$sorts[] = array(
				'text'  => $this->language->get('text_rating_desc'),
				'value' => 'rating',
				'order'	=> 'DESC',
				'path'  => (string)$categoryData['path']
			);

			$sorts[] = array(
				'text'  => $this->language->get('text_rating_asc'),
				'value' => 'rating',
				'order'	=> 'ASC',
				'path'  => (string)$categoryData['path']
			);
		}

		$sorts[] = array(
			'text'  => $this->language->get('text_model_asc'),
			'value' => 'p.model',
			'order'	=> 'ASC',
			'path'  => (string)$categoryData['path']
		);

		$sorts[] = array(
			'text'  => $this->language->get('text_model_desc'),
			'value' => 'p.model',
			'order'	=> 'DESC',
			'path'  => (string)$categoryData['path']
		);

		

		return $data['products'];
	}

	/**
	 * [getSellerAtProduct description]
	 * @param  $product_id for show seller and his other product on product page
	 * @return array of sellers info and his products
	 */

	public function getSellerAtProduct($id)
	{

		$sql = "SELECT customer_id FROM " . DB_PREFIX . "customerpartner_to_product WHERE product_id = '" . (int)$id . "'";
		$query  = $this->db->query($sql)->row;
		if (!$query)
			return array('error' => 0);

		$result = $this->getSellerProfile($query);
		$fields = array(
			'avatar',
			'gender',
			'country',
			'firstname',
			'lastname',
			'country'
		);
		foreach ($fields as $field) {
			$data[$field] = $result[$field];
		}
		$this->load->model('customerpartner/master');
		$this->language->load('module/marketplace');
		$data['text_ask_question'] = $this->language->get('text_ask_seller');
		$data['text_from']	=	$this->language->get('text_from');
		$data['text_seller']	=	$this->language->get('text_seller');
		$data['text_total_products']	=	$this->language->get('text_total_products');
		$data['text_tax']	=	$this->language->get('text_tax');
		$data['text_latest_product']	=	$this->language->get('text_latest_product');

		$data['logged'] = $this->customer->isLogged();
		$data['contact_mail'] = true;
		$data['launchModal'] = false;
		$data['total_products'] = $this->model_customerpartner_master->getPartnerCollectionCount($query['customer_id']);
		$this->load->model('account/customerpartner');
		$latest = $this->model_account_customerpartner->getProductsSeller(array('customer_id' => $query['customer_id']));
		$data['latest'] = array();

		if ($latest) {
			foreach ($latest as $key => $result) {

				if ($result['product_id'] == $id)
					continue;

				if ($result['image']) {
					$image = $this->model_tool_image->resize($result['image'], $this->config->get('config_image_product_width'), $this->config->get('config_image_product_height'));
				} else {
					$image = $this->model_tool_image->resize('no_image.png', $this->config->get('config_image_product_width'), $this->config->get('config_image_product_height'));
				}

				if (isset($result['image']) && is_file(DIR_IMAGE . $result['image']))
					$dc_image = DIR_IMAGE . $result['image'];
				elseif (is_file(DIR_IMAGE . 'placeholder.png'))
					$dc_image = DIR_IMAGE . 'placeholder.png';
				else
					$dc_image = '';

				$dominant_color = $this->getDominantColor($dc_image);

				if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
					$price = $this->currency->format($this->tax->calculate($result['price'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
				} else {
					$price = false;
				}

				if ((float) $result['special']) {
					$formatedSpecial = $this->currency->format($this->tax->calculate($result['special'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
					$special = $result['special'];
				} else {
					$formatedSpecial = '';
					$special = 0.00;
				}

				if ($this->config->get('config_tax')) {
					$tax = $this->currency->format(((float)$result['special'] ? $result['special'] : $result['price']), $this->session->data['currency']);
				} else {
					$tax = false;
				}

				if ($this->config->get('config_review_status')) {
					$rating = (int)$result['rating'];
				} else {
					$rating = 0;
				}

				$this->load->model('catalog/product');

				$product_info = $this->model_catalog_product->getProduct($result['product_id']);

				if ($product_info['quantity'] <= 0) {
					$stock = $product_info['stock_status'];
				} elseif ($this->config->get('config_stock_display')) {
					$stock = $product_info['quantity'];
				} else {
					$stock = 'In Stock';
				}

				$already_status = false;

				if (version_compare(VERSION, '2.1.0.1	', '>=')) {
					foreach ($this->getDBWishlist() as $wishlist) {
						if ($wishlist['product_id'] == $result['product_id']) {
							$already_status = true;
						}
					}
				}

				$data['latest'][] = array(
					'product_id'  => $result['product_id'],
					'thumb'       => $image,
					'dominant_color' => $dominant_color,
					'name'        => html_entity_decode($result['name'], ENT_QUOTES, 'UTF-8'),
					'description' => utf8_substr(strip_tags(html_entity_decode($result['description'], ENT_QUOTES, 'UTF-8')), 0, $this->config->get('config_product_description_length')) . '..',
					'price'       => $price,
					'special' 	 => (float) $special,
					'formatted_special' => $formatedSpecial,
					'tax'         => $tax == false ? '' : $tax,
					'hasOption'	  => $this->productOption($result['product_id']),
					'stock'		  => $stock,
					'rating'      => $result['rating'],
					'wishlist_status' => $already_status
				);
			}
		}
		return array('error' => 1, 'data' => $data);
	}

	/**
	 * Fetches product reviews
	 * @param  integer $product_id Product ID
	 * @return array             Contains reviews of product
	 */
	public function review($product_id)
	{
		$this->load->language('product/product');

		$this->load->model('catalog/review');

		$data['text_no_reviews'] = $this->language->get('text_no_reviews');

		if (isset($page)) {
			$page = $page;
		} else {
			$page = 1;
		}

		$data['reviews'] = array();

		$review_total = $this->model_catalog_review->getTotalReviewsByProductId($product_id);

		$results = $this->model_catalog_review->getReviewsByProductId($product_id, ($page - 1) * 5, 5);

		foreach ($results as $result) {
			$data['reviews'][] = array(
				'author'     => $result['author'],
				'text'       => htmlspecialchars_decode($result['text']),
				'rating'     => (int)$result['rating'],
				'date_added' => date($this->language->get('date_format_short'), strtotime($result['date_added']))
			);
		}
		return $data;
	}
	/**
	 * Writes product's review
	 * @param  array $reviewData contains review data
	 * @return array             returns product review data
	 */
	public function writeProductReview($reviewData)
	{
		$this->load->language('product/product');

		$json = array();

		if (isset($reviewData['name']) && $reviewData['name']) {
			$reviewData['name'] = html_entity_decode($reviewData['name'], ENT_QUOTES, 'UTF-8');
		}

		if ($reviewData) {
			if (empty($reviewData['name']) || (utf8_strlen($reviewData['name']) < 3) || (utf8_strlen($reviewData['name']) > 25)) {
				$json['error'] = 1;
				$json['message'] = $this->language->get('error_name');
			}

			if (empty($reviewData['text']) || (utf8_strlen($reviewData['text']) < 25) || (utf8_strlen($reviewData['text']) > 1000)) {
				$json['error'] = 1;
				$json['message'] = $this->language->get('error_text');
			}

			if (empty($reviewData['rating']) || $reviewData['rating'] < 0 || $reviewData['rating'] > 5) {
				$json['error'] = 1;
				$json['message'] = $this->language->get('error_rating');
			}

			if (!isset($json['error'])) {
				$this->load->model('catalog/review');

				$this->model_catalog_review->addReview($reviewData['product_id'], $reviewData);
				$json['error'] = 0;

				$json['message'] = $this->language->get('text_success');
			}
		}
		return $json;
	}
	/**
	 * add a product to wishlist
	 * @param integer $product_id contains product ID
	 */
	public function addToWishlist($product_id = 0)
	{

		$this->load->language('account/wishlist');

		$json = array();

		$this->load->model('catalog/product');

		$product_info = $this->model_catalog_product->getProduct($product_id);

		if (version_compare(VERSION, '2.1.0.0', '>=')) {

			if ($product_info) {
				if ($this->customer->isLogged()) {
					// Edit customers cart
					$this->load->model('account/wishlist');

					$already_status = true;

					foreach ($this->getDBWishlist() as $wishlist) {
						if ($wishlist['product_id'] == $product_id) {
							$this->model_account_wishlist->deleteWishlist($product_id);
							$already_status = false;
							$json['message'] = $this->language->get('text_remove');
						}
					}

					if ($already_status) {
						$this->model_account_wishlist->addWishlist($product_id);
						$json['message'] = strip_tags(sprintf($this->language->get('text_success'), '', html_entity_decode($product_info['name'], ENT_QUOTES, 'UTF-8'), ''));
					}

					$json['total'] = sprintf($this->language->get('text_wishlist'), $this->model_account_wishlist->getTotalWishlist());
					$json['wishlist_status'] = $already_status;
				} else {
					if (!isset($this->session->data['wishlist'])) {
						$this->session->data['wishlist'] = array();
					}

					$this->session->data['wishlist'][] = $product_id;

					$this->session->data['wishlist'] = array_unique($this->session->data['wishlist']);

					$json['info'] = strip_tags(sprintf($this->language->get('text_login'), '', '', '', html_entity_decode($product_info['name'], ENT_QUOTES, 'UTF-8'), ''));

					$json['total'] = sprintf($this->language->get('text_wishlist'), (isset($this->session->data['wishlist']) ? count($this->session->data['wishlist']) : 0));
				}

				$json['error'] = 0;
				return $json;
			}

			$json['error'] = 1;
			return $json;
		} else {

			if (!isset($this->session->data['wishlist'])) {
				$this->session->data['wishlist'] = array();
			}

			if ($product_info) {
				if (!in_array($product_id, $this->session->data['wishlist'])) {
					if ($this->customer->isLogged()) {
						$this->addDBWishlist((int)$product_id);
					}
					$this->session->data['wishlist'][] = (int)$product_id;

					if ($this->customer->isLogged()) {
						$json['message'] = strip_tags(sprintf($this->language->get('text_success'), '', html_entity_decode($product_info['name'], ENT_QUOTES, 'UTF-8'), ''));
					} else {
						$json['info'] = strip_tags(sprintf($this->language->get('text_login'), '', '', '', html_entity_decode($product_info['name'], ENT_QUOTES, 'UTF-8'), ''));
					}
				} else {
					$json['info'] = strip_tags(sprintf($this->language->get('text_exists'), '', html_entity_decode($product_info['name'], ENT_QUOTES, 'UTF-8'), ''));
				}

				$json['total'] = strip_tags(sprintf($this->language->get('text_wishlist'), (isset($this->session->data['wishlist']) ? count($this->session->data['wishlist']) : 0)));
				$json['error'] = 0;
				return $json;
			} else
				return false;
		}
	}
	/**
	 * Searches a product
	 * @param  array $searchData contains search data
	 * @return array             return searched data
	 */
	public function productSearch($searchData)
	{
		$this->load->model('catalog/product');
		$this->load->language('product/search');

		if (isset($searchData['search'])) {
			$search = $searchData['search'];
		} else {
			$search = '';
		}

		if (isset($searchData['tag'])) {
			$tag = $searchData['tag'];
		} elseif (isset($searchData['search'])) {
			$tag = $searchData['search'];
		} else {
			$tag = '';
		}

		if (isset($searchData['description'])) {
			$description = $searchData['description'];
		} else {
			$description = '';
		}

		if (isset($searchData['category_id'])) {
			$category_id = $searchData['category_id'];
		} else {
			$category_id = 0;
		}

		if (isset($searchData['sub_category'])) {
			$sub_category = $searchData['sub_category'];
		} else {
			$sub_category = '';
		}

		if (isset($searchData['sort'])) {
			$sort = $searchData['sort'];
		} else {
			$sort = 'p.sort_order';
		}

		if (isset($searchData['order'])) {
			$order = $searchData['order'];
		} else {
			$order = 'ASC';
		}

		if (isset($searchData['page'])) {
			$page = $searchData['page'];
		} else {
			$page = 1;
		}

		if (isset($searchData['limit'])) {
			$limit = $searchData['limit'];
		} else {
			$limit = $this->config->get('config_product_limit');
		}

		if (isset($searchData['search'])) {
			$searched['heading_title'] = $this->language->get('heading_title') .  ' - ' . $searchData['search'];
		} else {
			$searched['heading_title'] = $this->language->get('heading_title');
		}

		$searched['text_empty'] = $this->language->get('text_empty');
		$searched['text_search'] = $this->language->get('text_search');
		$searched['text_keyword'] = $this->language->get('text_keyword');
		$searched['text_category'] = $this->language->get('text_category');
		$searched['text_sub_category'] = $this->language->get('text_sub_category');
		$searched['text_quantity'] = $this->language->get('text_quantity');
		$searched['text_manufacturer'] = $this->language->get('text_manufacturer');
		$searched['text_model'] = $this->language->get('text_model');
		$searched['text_price'] = $this->language->get('text_price');
		$searched['text_tax'] = $this->language->get('text_tax');
		$searched['text_points'] = $this->language->get('text_points');
		$searched['text_compare'] = sprintf($this->language->get('text_compare'), (isset($this->session->data['compare']) ? count($this->session->data['compare']) : 0));
		$searched['text_sort'] = $this->language->get('text_sort');
		$searched['text_limit'] = $this->language->get('text_limit');
		$searched['entry_search'] = $this->language->get('entry_search');
		$searched['entry_description'] = $this->language->get('entry_description');
		$searched['button_search'] = $this->language->get('button_search');
		$searched['button_cart'] = $this->language->get('button_cart');
		$searched['button_wishlist'] = $this->language->get('button_wishlist');
		$searched['button_compare'] = $this->language->get('button_compare');
		$searched['button_list'] = $this->language->get('button_list');
		$searched['button_grid'] = $this->language->get('button_grid');

		$this->load->model('catalog/category');

		// 3 Level Category Search
		$searched['categories'] = array();

		$categories_1 = $this->model_catalog_category->getCategories(0);

		foreach ($categories_1 as $category_1) {
			$level_2_data = array();

			$categories_2 = $this->model_catalog_category->getCategories($category_1['category_id']);

			foreach ($categories_2 as $category_2) {
				$level_3_data = array();

				$categories_3 = $this->model_catalog_category->getCategories($category_2['category_id']);

				foreach ($categories_3 as $category_3) {
					$level_3_data[] = array(
						'category_id' => $category_3['category_id'],
						'name'        => html_entity_decode($category_3['name'], ENT_QUOTES, "UTF-8"),
					);
				}

				$level_2_data[] = array(
					'category_id' => $category_2['category_id'],
					'name'        => html_entity_decode($category_2['name'], ENT_QUOTES, "UTF-8"),
					'children'    => $level_3_data
				);
			}

			$searched['categories'][] = array(
				'category_id' => $category_1['category_id'],
				'name'        => html_entity_decode($category_1['name'], ENT_QUOTES, "UTF-8"),
				'children'    => $level_2_data
			);
		}

		$searched['products'] = array();

		if (isset($searchData['search']) || isset($searchData['tag'])) {
			$filter_data = array(
				'filter_name'         => $search,
				'filter_tag'          => $tag,
				'filter_description'  => $description,
				'filter_category_id'  => $category_id,
				'filter_sub_category' => $sub_category,
				'sort'                => $sort,
				'order'               => $order,
				'start'               => ($page - 1) * $limit,
				'limit'               => $limit
			);

			$searched['product_total'] = $this->model_catalog_product->getTotalProducts($filter_data);

			$results = $this->model_catalog_product->getProducts($filter_data);

			$this->load->model('tool/image');

			foreach ($results as $result) {

				$already_status = false;
				if (version_compare(VERSION, '2.1.0.1	', '>=')) {
					foreach ($this->getDBWishlist() as $wishlist) {
						if ($wishlist['product_id'] == $result['product_id']) {
							$already_status = true;
						}
					}
				}

				if ($result['image']) {
					$image = str_replace(' ', '%20', $this->model_tool_image->resize($result['image'], $searchData['width'] / 2, $searchData['width'] / 2));
				} else {
					$image = $this->model_tool_image->resize('placeholder.png', $searchData['width'] / 2, $searchData['width'] / 2);
				}

				if (isset($result['image']) && is_file(DIR_IMAGE . $result['image']))
					$dc_image = DIR_IMAGE . $result['image'];
				elseif (is_file(DIR_IMAGE . 'placeholder.png'))
					$dc_image = DIR_IMAGE . 'placeholder.png';
				else
					$dc_image = '';

				$dominant_color = $this->getDominantColor($dc_image);

				if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
					$price = $this->currency->format($this->tax->calculate($result['price'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
				} else {
					$price = false;
				}

				if ((float) $result['special']) {
					$formatedSpecial = $this->currency->format($this->tax->calculate($result['special'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
					$special = $result['special'];
				} else {
					$formatedSpecial = '';
					$special = 0.00;
				}

				if ($this->config->get('config_tax')) {
					$tax = $this->currency->format((float)$result['special'] ? $result['special'] : $result['price'], $this->session->data['currency']);
				} else {
					$tax = false;
				}

				if ($this->config->get('config_review_status')) {
					$rating = (int)$result['rating'];
				} else {
					$rating = 0;
				}

				$searched['products'][] = array(
					'product_id'  => $result['product_id'],
					'thumb'       => $image,
					'dominant_color' => $dominant_color,
					'name'        => html_entity_decode($result['name'], ENT_QUOTES, 'UTF-8'),
					'description' => utf8_substr(strip_tags(html_entity_decode($result['description'], ENT_QUOTES, 'UTF-8')), 0, $this->config->get('config_product_description_length')) . '..',
					'price'       => $price,
					'special' 	 => (float) $special,
					'formatted_special' => $formatedSpecial,
					'quantity' 	 => $result['quantity'],
					'tax'         => $tax == false ? '' : $tax,
					'minimum'     => $result['minimum'] > 0 ? $result['minimum'] : 1,
					'rating'      => $result['rating'],
					'hasOption'	  => $this->productOption($result['product_id']),
					'wishlist_status' => $already_status
				);
			}

			$searched['sorts'] = array();

			$searched['sorts'][] = array(
				'text'  => $this->language->get('text_default'),
				'value'	=> 'p.sort_order',
				'order'	=> 'ASC'
			);

			$searched['sorts'][] = array(
				'text'  => $this->language->get('text_name_asc'),
				'value' => 'pd.name',
				'order'	=> 'ASC'
			);

			$searched['sorts'][] = array(
				'text'  => $this->language->get('text_name_desc'),
				'value' => 'pd.name',
				'order'	=> 'DESC'
			);

			$searched['sorts'][] = array(
				'text'  => $this->language->get('text_price_asc'),
				'value' => 'p.price',
				'order'	=> 'ASC'
			);

			$searched['sorts'][] = array(
				'text'  => $this->language->get('text_price_desc'),
				'value' => 'p.price',
				'order'	=> 'DESC'
			);

			if ($this->config->get('config_review_status')) {
				$searched['sorts'][] = array(
					'text'  => $this->language->get('text_rating_desc'),
					'value' => 'rating',
					'order'	=> 'DESC'
				);

				$searched['sorts'][] = array(
					'text'  => $this->language->get('text_rating_asc'),
					'value' => 'rating',
					'order'	=> 'ASC'
				);
			}

			$searched['sorts'][] = array(
				'text'  => $this->language->get('text_model_asc'),
				'value' => 'p.model',
				'order'	=> 'ASC'
			);

			$searched['sorts'][] = array(
				'text'  => $this->language->get('text_model_desc'),
				'value' => 'p.model',
				'order'	=> 'DESC'
			);

			$searched['limits'] = array();

			$limits = array_unique(array($this->config->get('config_product_limit'), 25, 50, 75, 100));

			sort($limits);

			foreach ($limits as $value) {
				$searched['limits'][] = array(
					'text'  => $value,
					'value' => $value,
					'limit' => $value
				);
			}
			return $searched;
		} else
			return false;
	}

	public function productPrev($product_id)
	{
		$categorys = $this->db->query("SELECT category_id FROM " . DB_PREFIX . "product_to_category WHERE product_id = '" . (int)$product_id . "'")->rows;

		$category_info = 0;

		if ($categorys) {
			foreach ($categorys as $category) {
				$category_info .= ',' . $category['category_id'];
			}
		}
		$sql = '';

		if ($category_info) {
			$sql = "AND p2c.category_id IN(" . $category_info . ")";
		}

		$query = $this->db->query("SELECT DISTINCT pd.product_id , pd.name FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) LEFT JOIN " . DB_PREFIX . "product_to_category p2c ON (p.product_id = p2c.product_id) WHERE p.status = '1' AND pd.language_id = '" . $this->config->get('config_language_id') . "' AND p.product_id < '" . (int)$product_id . "' " . $sql . "  ORDER BY p.product_id DESC LIMIT 1");

		return ($query->rows);
	}

	public function productNext($product_id)
	{
		$categorys = $this->db->query("SELECT category_id FROM " . DB_PREFIX . "product_to_category WHERE product_id = '" . (int)$product_id . "'")->rows;

		$category_info = 0;

		if ($categorys) {
			foreach ($categorys as $category) {
				$category_info .= ',' . $category['category_id'];
			}
		}
		$sql = '';

		if ($category_info) {
			$sql = "AND p2c.category_id IN(" . $category_info . ")";
		}

		$query = $this->db->query("SELECT DISTINCT pd.product_id , pd.name FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) LEFT JOIN " . DB_PREFIX . "product_to_category p2c ON (p.product_id = p2c.product_id) WHERE p.status = '1' AND pd.language_id = '" . $this->config->get('config_language_id') . "' AND p.product_id > '" . (int)$product_id . "' " . $sql . "  ORDER BY p.product_id ASC LIMIT 1");

		return ($query->rows);
	}
	/**
	 * Fetches the wishlist from the database
	 * @return array contains wishlist
	 */
	public function getDBWishlist()
	{

		if (version_compare(VERSION, '2.1.0.0', '>=')) {
			$this->load->model('account/wishlist');
			$result = $this->model_account_wishlist->getWishlist();
			return $result;
		} else {
			if ($this->customer->getId()) {
				$customer_id = $this->customer->getId();
			} else {
				$customer_id = '0';
			}
			$query = $this->db->query("SELECT wishlist FROM " . DB_PREFIX . "customer WHERE customer_id = " . $customer_id)->row;
			if (isset($query['wishlist'])) return unserialize($query['wishlist']);
			else return 0;
		}
	}

	/**
	 * Adds a product to wishlist in database
	 * @param integer $product_id contains product's ID
	 */
	public function addDBWishlist($product_id)
	{
		$customer_info = $this->db->query("SELECT wishlist FROM " . DB_PREFIX . "customer WHERE customer_id = " . $this->customer->getId())->row;

		if (isset($customer_info['wishlist']) && $customer_info['wishlist']) {
			$wishlist = unserialize($customer_info['wishlist']);
		} else {
			$wishlist = array();
		}

		if (!in_array($product_id, $wishlist)) {
			$wishlist[] = $product_id;
			$this->db->query("UPDATE " . DB_PREFIX . "customer SET wishlist = '" . $this->db->escape(serialize($wishlist)) . "' WHERE customer_id = '" . (int)$this->customer->getId() . "'");
		}
	}
	/**
	 * Fetches the list of manufacturers
	 * @return array returns the list of manufacturers
	 */
	public function productManufacturer()
	{
		$this->load->language('product/manufacturer');

		$this->load->model('catalog/manufacturer');

		$manufacturers['heading_title'] = $this->language->get('heading_title');

		$manufacturers['text_index'] = $this->language->get('text_index');
		$manufacturers['text_empty'] = $this->language->get('text_empty');

		$manufacturers['button_continue'] = $this->language->get('button_continue');

		$manufacturers['categories'] = array();

		$results = $this->model_catalog_manufacturer->getManufacturers();

		$index = 0;

		foreach ($results as $result) {
			if (is_numeric(utf8_substr($result['name'], 0, 1))) {
				$key = '0 - 9';
			} else {
				$key = utf8_substr(utf8_strtoupper($result['name']), 0, 1);
			}

			if (isset($prev) && $key == $prev) {
				$index--;
			}

			if (!isset($manufacturers['categories'][$key])) {
				$manufacturers['categories'][$index]['name'] = $key;
			}

			$manufacturers['categories'][$index]['manufacturer'][] = array(
				'name' => $result['name'],
				'manufacturer_id' => $result['manufacturer_id']
			);

			$prev = $key;
			$index++;
		}

		$return_array = array(
			'manufacturers'	=> $manufacturers,
			'error'			=> 0
		);
		return $return_array;
	}
	/**
	 * Fetches the information of a manufacturer
	 * @param  array $manufacturerData contains the manufacturer data
	 * @return array                   returns the manufacturer info
	 */
	public function manufacturerInfo($manufacturerData)
	{
		$this->load->language('product/manufacturer');

		$this->load->model('catalog/manufacturer');
		$this->load->model('catalog/product');
		$this->load->model('tool/image');

		if (isset($manufacturerData['manufacturer_id'])) {
			$manufacturer_id = (int)$manufacturerData['manufacturer_id'];
		} else {
			$manufacturer_id = 0;
		}

		if (isset($manufacturerData['sort'])) {
			$sort = $manufacturerData['sort'];
		} else {
			$sort = 'p.sort_order';
		}

		if (isset($manufacturerData['order'])) {
			$order = $manufacturerData['order'];
		} else {
			$order = 'ASC';
		}

		if (isset($manufacturerData['page'])) {
			$page = $manufacturerData['page'];
		} else {
			$page = 1;
		}

		if (isset($manufacturerData['limit'])) {
			$limit = $manufacturerData['limit'];
		} else {
			$limit = 10;
		}

		$manufacturer_info = $this->model_catalog_manufacturer->getManufacturer($manufacturer_id);

		if ($manufacturer_info) {
			$manufacturer['heading_title'] = html_entity_decode($manufacturer_info['name'], ENT_QUOTES, 'UTF-8');

			$manufacturer['text_empty'] = $this->language->get('text_empty');
			$manufacturer['text_quantity'] = $this->language->get('text_quantity');
			$manufacturer['text_manufacturer'] = $this->language->get('text_manufacturer');
			$manufacturer['text_model'] = $this->language->get('text_model');
			$manufacturer['text_price'] = $this->language->get('text_price');
			$manufacturer['text_tax'] = $this->language->get('text_tax');
			$manufacturer['text_points'] = $this->language->get('text_points');
			$manufacturer['text_compare'] = sprintf($this->language->get('text_compare'), (isset($this->session->data['compare']) ? count($this->session->data['compare']) : 0));
			$manufacturer['text_sort'] = $this->language->get('text_sort');
			$manufacturer['text_limit'] = $this->language->get('text_limit');

			$manufacturer['button_cart'] = $this->language->get('button_cart');
			$manufacturer['button_wishlist'] = $this->language->get('button_wishlist');
			$manufacturer['button_compare'] = $this->language->get('button_compare');
			$manufacturer['button_continue'] = $this->language->get('button_continue');
			$manufacturer['button_list'] = $this->language->get('button_list');
			$manufacturer['button_grid'] = $this->language->get('button_grid');

			$manufacturer['products'] = array();

			$filter_data = array(
				'filter_manufacturer_id' => $manufacturer_id,
				'sort'                   => $sort,
				'order'                  => $order,
				'start'                  => ($page - 1) * $limit,
				'limit'                  => $limit
			);

			$product_total = $this->model_catalog_product->getTotalProducts($filter_data);

			$results = $this->model_catalog_product->getProducts($filter_data);

			foreach ($results as $result) {

				$already_status = false;
				if (version_compare(VERSION, '2.1.0.1	', '>=')) {
					foreach ($this->getDBWishlist() as $wishlist) {
						if ($wishlist['product_id'] == $result['product_id']) {
							$already_status = true;
						}
					}
				}

				if ($result['image']) {
					$image = str_replace(' ', '%20', $this->model_tool_image->resize($result['image'], $manufacturerData['width'] / 2, $manufacturerData['width'] / 2));
				} else {
					$image = $this->model_tool_image->resize('placeholder.png', $manufacturerData['width'] / 2, $manufacturerData['width'] / 2);
				}

				if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
					$price = $this->currency->format($this->tax->calculate($result['price'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
				} else {
					$price = false;
				}

				if ((float) $result['special']) {
					$formatedSpecial = $this->currency->format($this->tax->calculate($result['special'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
					$special = $result['special'];
				} else {
					$formatedSpecial = '';
					$special = 0.00;
				}

				if ($this->config->get('config_tax')) {
					$tax = $this->currency->format((float)$result['special'] ? $result['special'] : $result['price'], $this->session->data['currency']);
				} else {
					$tax = false;
				}

				if ($this->config->get('config_review_status')) {
					$rating = (int)$result['rating'];
				} else {
					$rating = 0;
				}

				if (isset($result['image']) && is_file(DIR_IMAGE . $result['image']))
					$dc_image = DIR_IMAGE . $result['image'];
				elseif (is_file(DIR_IMAGE . 'placeholder.png'))
					$dc_image = DIR_IMAGE . 'placeholder.png';
				else
					$dc_image = '';

				$dominant_color = $this->getDominantColor($dc_image);

				$manufacturer['products'][] = array(
					'product_id'  => $result['product_id'],
					'thumb'       => $image,
					'dominant_color' => $dominant_color,
					'name'        => html_entity_decode($result['name'], ENT_QUOTES, 'UTF-8'),
					'description' => utf8_substr(strip_tags(html_entity_decode($result['description'], ENT_QUOTES, 'UTF-8')), 0, $this->config->get('config_product_description_length')) . '..',
					'price'       => $price,
					'special' 	 => (float) $special,
					'formatted_special' => $formatedSpecial,
					'quantity' 	 => $result['quantity'],
					'tax'         => $tax == false ? '' : $tax,
					'minimum'     => $result['minimum'] > 0 ? $result['minimum'] : 1,
					'rating'      => $result['rating'],
					'manufacturer_id' => $result['manufacturer_id'],
					'hasOption'  => $this->productOption($result['product_id']),
					'wishlist_status' => $already_status
				);
			}

			$manufacturer['sorts'] = array();
			$manufacturer['product_total'] = $product_total;
			$manufacturer['sorts'][] = array(
				'text'  => $this->language->get('text_default'),
				'value' => 'p.sort_order',
				'order'	=> 'ASC',
			);

			$manufacturer['sorts'][] = array(
				'text'  => $this->language->get('text_name_asc'),
				'value' => 'pd.name',
				'order'	=> 'ASC',
			);

			$manufacturer['sorts'][] = array(
				'text'  => $this->language->get('text_name_desc'),
				'value' => 'pd.name',
				'order'	=> 'DESC',
			);

			$manufacturer['sorts'][] = array(
				'text'  => $this->language->get('text_price_asc'),
				'value' => 'p.price',
				'order'	=> 'ASC',
			);

			$manufacturer['sorts'][] = array(
				'text'  => $this->language->get('text_price_desc'),
				'value' => 'p.price',
				'order'	=> 'DESC',
			);

			if ($this->config->get('config_review_status')) {
				$manufacturer['sorts'][] = array(
					'text'  => $this->language->get('text_rating_desc'),
					'value' => 'rating',
					'order'	=> 'DESC',
				);

				$manufacturer['sorts'][] = array(
					'text'  => $this->language->get('text_rating_asc'),
					'value' => 'rating',
					'order'	=> 'ASC',
				);
			}

			$manufacturer['sorts'][] = array(
				'text'  => $this->language->get('text_model_asc'),
				'value' => 'p.model',
				'order'	=> 'ASC',
			);

			$manufacturer['sorts'][] = array(
				'text'  => $this->language->get('text_model_desc'),
				'value' => 'p.model',
				'order'	=> 'DESC',
			);

			$manufacturer['limits'] = array();

			$limits = array_unique(array($this->config->get('config_product_limit'), 25, 50, 75, 100));

			sort($limits);

			foreach ($limits as $value) {
				$manufacturer['limits'][] = array(
					'text'  => $value,
					'value' => $value,
				);
			}

			$manufacturer['results'] = sprintf($this->language->get('text_pagination'), ($product_total) ? (($page - 1) * $limit) + 1 : 0, ((($page - 1) * $limit) > ($product_total - $limit)) ? $product_total : ((($page - 1) * $limit) + $limit), $product_total, ceil($product_total / $limit));

			$manufacturer['sort'] = $sort;
			$manufacturer['order'] = $order;
			$manufacturer['limit'] = $limit;
		}

		$return_array = array(
			'manufacturers'	=> $manufacturer,
			'error'			=> 0
		);
		return $return_array;
	}
	/**
	 * Return Latest Product
	 * @param  array $count contains limit of products
	 * @return array             return count number of latest data
	 */

	public function latestProductTotal($data = array())
	{

		$this->load->model('catalog/product');
		$this->load->model('tool/image');

		$sql = "SELECT COUNT(DISTINCT p.product_id) as total FROM " . DB_PREFIX . "product p 
	LEFT JOIN " . DB_PREFIX . "product_description pd ON(p.product_id = pd.product_id) 
	LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON (p.product_id = p2s.product_id) 
	WHERE p.status = '1' 
	AND p.date_available <= NOW() 
	AND p2s.store_id = '" . (int)$this->config->get('config_store_id') . "' 
	AND pd.language_id = '" . $this->config->get('config_language_id') . "'";





		$query = $this->db->query($sql);

		return $query->row['total'];
	}





	public function latestProduct($data = array())
	{

		$this->load->model('catalog/product');

		$this->load->model('tool/image');

		if (isset($data['sort']) && $data['sort']) {
			$sort = $data['sort'];
		} else {
			$sort = 'p.date_added';
		}

		if (isset($data['order']) && $data['order']) {
			$order = $data['order'];
		} else {
			$order = 'DESC';
		}


		if (isset($data['page']) && $data['page']) {
			$page = $data['page'];
		} else {
			$page = 1;
		}

		if (isset($data['limit']) && $data['limit']) {
			$limit = $data['limit'];
		} elseif (isset($data['count']) && $data['count']) {
			$limit = $data['count'];
		} else {
			$limit = 5;
		}

		$page = ($page - 1) * $limit;

		$sql = "SELECT DISTINCT p.product_id, 
    (SELECT price FROM " . DB_PREFIX . "product_discount pd2 
    WHERE pd2.product_id = p.product_id 
    AND pd2.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
    AND pd2.quantity = '1' 
    AND ((pd2.date_start = '0000-00-00' OR pd2.date_start < NOW()) 
    AND (pd2.date_end = '0000-00-00' OR pd2.date_end > NOW())) 
    ORDER BY pd2.priority ASC, pd2.price ASC LIMIT 1) AS discount, 
    (SELECT price FROM " . DB_PREFIX . "product_special ps 
    WHERE ps.product_id = p.product_id 
    AND ps.customer_group_id = '" . (int)$this->config->get('config_customer_group_id') . "' 
    AND ((ps.date_start = '0000-00-00' OR ps.date_start < NOW()) 
    AND (ps.date_end = '0000-00-00' OR ps.date_end > NOW())) 
    ORDER BY ps.priority ASC, ps.price ASC LIMIT 1) AS special 
FROM " . DB_PREFIX . "product p 
LEFT JOIN " . DB_PREFIX . "product_description pd ON(p.product_id = pd.product_id) 
LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON (p.product_id = p2s.product_id) 
WHERE p.status = '1' 
AND p.date_available <= NOW() 
AND p2s.store_id = '" . (int)$this->config->get('config_store_id') . "' 
AND pd.language_id = '" . $this->config->get('config_language_id') . "'";


		$sort_data = array(
			'pd.name',
			'p.model',
			'p.price',
			'p.sort_order',
		);
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			if ($data['sort'] == 'pd.name' || $data['sort'] == 'p.model') {
				$sql .= " ORDER BY LCASE(" . $data['sort'] . ")";
			} elseif ($data['sort'] == 'p.price') {
				$sql .= " ORDER BY (CASE WHEN special IS NOT NULL THEN special WHEN discount IS NOT NULL THEN discount ELSE p.price END)";
			}
			if (isset($data['order']) && ($data['order'] == 'DESC')) {
				$sql .= " DESC";
			} else {
				$sql .= " ASC";
			}
		} else {
			$sql .= " ORDER BY p.date_added DESC";
		}

		if (!isset($data['total'])) {
			$sql .=  " LIMIT " . $page . "," . $limit;
		} else {
			return $this->db->query($sql)->num_rows;
		}

		$query = $this->db->query($sql)->rows;

		if (!empty($query)) {
			foreach ($query as $result) {
				$results[$result['product_id']] = $this->model_catalog_product->getProduct($result['product_id']);
			}
		} else {
			$results = array();
		}
		$latest = array();

		if (!empty($results)) {
			foreach ($results as $result) {
				if (isset($result['product_id'])) {
					$already_status = false;
					if (version_compare(VERSION, '2.1.0.1	', '>=')) {
						foreach ($this->getDBWishlist() as $wishlist) {
							if ($wishlist['product_id'] == $result['product_id']) {
								$already_status = true;
							}
						}
					}

					if ($result['image']) {
						$image = str_replace(' ', '%20', $this->model_tool_image->resize($result['image'], $data['width'], $data['width']));
					} else {
						$image = $this->model_tool_image->resize('placeholder.png',  $data['width'], $data['width']);
					}

					if ($this->customer->isLogged() || !$this->config->get('config_customer_price')) {
						$price = $this->currency->format($this->tax->calculate($result['price'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
					} else {
						$price = false;
					}

					if ((float)$result['special']) {
						$formatedSpecial = $this->currency->format($this->tax->calculate($result['special'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
						$special = $result['special'];
					} else {
						$formatedSpecial = '';
						$special = 0.00;
					}

					if ($this->config->get('config_tax')) {
						$tax = $this->currency->format((float)$result['special'] ? $result['special'] : $result['price'], $this->session->data['currency']);
					} else {
						$tax = false;
					}

					if ($this->config->get('config_review_status')) {
						$rating = $result['rating'];
					} else {
						$rating = 0;
					}

					if (isset($result['image']) && is_file(DIR_IMAGE . $result['image']))
						$dc_image = DIR_IMAGE . $result['image'];
					elseif (is_file(DIR_IMAGE . 'placeholder.png'))
						$dc_image = DIR_IMAGE . 'placeholder.png';
					else
						$dc_image = '';

					$dominant_color = $this->getDominantColor($dc_image);

					$set_date = $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_product_set_date WHERE product_id = " . $result['product_id'])->row;

					$latest[] = array(
						'product_id' => $result['product_id'],
						'thumb'   	 => $image,
						'dominant_color' => $dominant_color,
						'name'    	 => html_entity_decode($result['name'], ENT_QUOTES, "UTF-8"),
						'price'   	 => $price,
						'quantity' 	 => $result['quantity'],
						'special' 	 => (float) $special,
						'formatted_special' => $formatedSpecial,
						'tax'        => $tax == false ? '' : $tax,
						'rating'     => $rating,
						'reviews'    => sprintf($this->language->get('text_reviews'), (int)$result['reviews']),
						'hasOption'  => $this->productOption($result['product_id']),
						'wishlist_status' => $already_status,
						'start_date' => isset($set_date['start_date']) ? $set_date['start_date'] : '',
						'close_date' => isset($set_date['close_date']) ? $set_date['close_date'] : ''
					);
				}
			}
		}
		return $latest;
	}

	public function getsearchSuggest($search)
	{


		$this->load->model('catalog/product');

		if (isset($search['search']) && $search['search']) {

			$products = $this->db->query("
                 SELECT DISTINCT pd.product_id, pd.name 
                  FROM " . DB_PREFIX . "product p 
                  LEFT JOIN " . DB_PREFIX . "product_description pd 
                  ON (p.product_id = pd.product_id) 
                   WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "' 
                   AND p.status = '1' 
                   AND (pd.name LIKE '%" . $this->db->escape($search['search']) . "%' 
                 OR pd.tag LIKE '%" . $this->db->escape($search['search']) . "%')")->rows;

			if ($products) {
				foreach ($products as $key => $value) {
					if (isset($products[$key]['name']))
						$products[$key]['name'] = html_entity_decode($products[$key]['name'], ENT_QUOTES, 'UTF-8');
				}
				return array('search_data' => $products);
			} else {
				$this->load->language('account/api');
				return array(
					'message' => $this->language->get('text_no_product'),
					'error'	=> 0
				);
			}
		} else {
			$this->load->language('account/api');
			return array(
				'message' => $this->language->get('text_no_product'),
				'error'	=> 0
			);
		}
	}

	public function customCollection($data)
	{
		if (isset($data['width']) && $data['width']) {
			$width = $data['width'];
		} else {
			$width = 100;
		}

		if (isset($data['id']) && $data['id']) {
			$id = $data['id'];
		} else {
			$id = 0;
		}

		$this->load->model('catalog/product');

		$this->load->model('tool/image');

		$products = array();

		if ($this->config->get('mobikul_status')) {
			$product_ids = $this->db->query("SELECT product_id FROM " . DB_PREFIX . "mobikul_custom_collection_to_product WHERE id=" . (int)$id)->rows;
		} else {
			$product_ids = array();
		}

		$total_product = 0;
		if ($product_ids) {
			foreach ($product_ids as $product_id) {
				$total_product++;
				$product_info = $this->model_catalog_product->getProduct($product_id['product_id']);

				if ($product_info['image']) {
					$image = $product_info['image'];
				} else {
					$image = 'placeholder.png';
				}

				if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
					$price = $this->currency->format($this->tax->calculate($product_info['price'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
				} else {
					$price = false;
				}

				if ((float) $product_info['special']) {
					$formatedSpecial = $this->currency->format($this->tax->calculate($product_info['special'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
					$special = $product_info['special'];
				} else {
					$formatedSpecial = '';
					$special = 0.00;
				}

				if ($this->config->get('config_tax')) {
					$tax = $this->currency->format((float)$product_info['special'] ? $product_info['special'] : $product_info['price'], $this->session->data['currency']);
				} else {
					$tax = false;
				}

				if ($this->config->get('config_review_status')) {
					$rating = (int)$product_info['rating'];
				} else {
					$rating = 0;
				}

				if ($product_info['quantity'] <= 0) {
					$stock = $product_info['stock_status'];
				} elseif ($this->config->get('config_stock_display')) {
					$stock = $product_info['quantity'];
				} else {
					$stock = 'In Stock';
				}

				$already_status = false;
				if (version_compare(VERSION, '2.1.0.1	', '>=')) {
					foreach ($this->getDBWishlist() as $wishlist) {
						if ($wishlist['product_id'] == $product_info['product_id']) {
							$already_status = true;
						}
					}
				}

				if (isset($product_info['image']) && is_file(DIR_IMAGE . $product_info['image']))
					$dc_image = DIR_IMAGE . $product_info['image'];
				elseif (is_file(DIR_IMAGE . 'placeholder.png'))
					$dc_image = DIR_IMAGE . 'placeholder.png';
				else
					$dc_image = '';

				$dominant_color = $this->getDominantColor($dc_image);

				$set_date = $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_product_set_date WHERE product_id = " . $product_info['product_id'])->row;

				$products[] = array(
					'product_id'  => $product_info['product_id'],
					'thumb'       => str_replace(' ', '%20', $this->model_tool_image->resize($image, $width, $width)),
					'dominant_color' => $dominant_color,
					'name'        => html_entity_decode($product_info['name'], ENT_QUOTES, "UTF-8"),
					'description' => utf8_substr(strip_tags(html_entity_decode($product_info['description'], ENT_QUOTES, 'UTF-8')), 0, $this->config->get('config_product_description_length')) . '..',
					'price'       => ltrim($price, '$'),
					'special' 	 => (float) $special,
					'formatted_special' => $formatedSpecial,
					'tax'         => $tax == false ? '' : $tax,
					'minimum'     => $product_info['minimum'] > 0 ? $product_info['minimum'] : 1,
					'rating'      => $product_info['rating'],
					'hasOption'	  => $this->productOption($product_info['product_id']),
					'stock'		  => $stock,
					'wishlist_status'	=> $already_status,
					'start_date' => isset($set_date['start_date']) ? $set_date['start_date'] : '',
					'close_date' => isset($set_date['close_date']) ? $set_date['close_date'] : ''
				);
			}
		}

		$return_array = array(
			'product_total'	=> $total_product,
			'products'	=> $products,
			'error'			=> 0
		);
		return $return_array;
	}


	public function productCompare($product_ids)
	{

		$this->load->model('catalog/product');

		$this->load->model('tool/image');
		foreach ($product_ids as $key => $product_id) {
			$product_info = $this->model_catalog_product->getProduct($product_id);

			if ($product_info) {

				$already_status = false;
				if (version_compare(VERSION, '2.1.0.1	', '>=')) {
					foreach ($this->getDBWishlist() as $wishlist) {
						if ($wishlist['product_id'] == $product_info['product_id']) {
							$already_status = true;
						}
					}
				}

				if ($product_info['image']) {
					$image = $this->model_tool_image->resize($product_info['image'], $this->config->get($this->config->get('config_theme') . '_image_compare_width'), $this->config->get($this->config->get('config_theme') . '_image_compare_height'));
				} else {
					$image = false;
				}

				if ($this->customer->isLogged() || !$this->config->get('config_customer_price')) {
					$price = $this->currency->format($this->tax->calculate($product_info['price'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
				} else {
					$price = false;
				}

				if ((float) $product_info['special']) {
					$formatedSpecial = $this->currency->format($this->tax->calculate($product_info['special'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
					$special = $product_info['special'];
				} else {
					$formatedSpecial = '';
					$special = 0.00;
				}

				if ($product_info['quantity'] <= 0) {
					$availability = $product_info['stock_status'];
				} elseif ($this->config->get('config_stock_display')) {
					$availability = $product_info['quantity'];
				} else {
					$availability = $this->language->get('text_instock');
				}

				$attribute_data = array();

				$attribute_groups = $this->model_catalog_product->getProductAttributes($product_id);

				foreach ($attribute_groups as $attribute_group) {
					foreach ($attribute_group['attribute'] as $attribute) {
						$attribute_data[] = array(
							'id' => $attribute['attribute_id'],
							'value' => $attribute['text']
						);
					}
				}

				$data['products'][] = array(
					'product_id'   => $product_info['product_id'],
					'name'         => html_entity_decode($product_info['name'], ENT_QUOTES, "UTF-8"),
					'thumb'        => $image,
					'dominant_color' => $this->getDominantColor($image),
					'price'        => $price,
					'special' 	 => (float) $special,
					'formatted_special' => $formatedSpecial,
					'description'  => utf8_substr(strip_tags(html_entity_decode($product_info['description'], ENT_QUOTES, 'UTF-8')), 0, 200) . '..',
					'model'        => $product_info['model'],
					'manufacturer' => $product_info['manufacturer'],
					'availability' => $availability,
					'minimum'      => $product_info['minimum'] > 0 ? $product_info['minimum'] : 1,
					'rating'       => (int)$product_info['rating'],
					'reviews'      => sprintf($this->language->get('text_reviews'), (int)$product_info['reviews']),
					'weight'       => $this->weight->format($product_info['weight'], $product_info['weight_class_id']),
					'length'       => $this->length->format($product_info['length'], $product_info['length_class_id']),
					'width'        => $this->length->format($product_info['width'], $product_info['length_class_id']),
					'height'       => $this->length->format($product_info['height'], $product_info['length_class_id']),
					'attribute'    => $attribute_data,
					'wishlist_status'	=> $already_status
				);

				foreach ($attribute_groups as $attribute_group) {
					foreach ($attribute_group['attribute'] as $attribute) {
						$data['attribute_groups'][] = array(
							'id' => $attribute['attribute_id'],
							'attribute_group_id' => $attribute_group['attribute_group_id'],
							'group_name' => $attribute_group['name'],
							'name' => $attribute['name']
						);
					}
				}
			}
		}
		return $data;
	}

	public function getWalkthrough($data = array(), $total = false)
	{

		$sql = "SELECT * FROM `" . DB_PREFIX . "mobikul_walkthrough` w where id != '' AND status != '0'";


		if (isset($data['filter_status'])) {
			$sql .= " AND w.status='" . $data['filter_status'] . "'";
		}

		$sql .= " ORDER BY w.sort_order ASC, w.id ASC";


		if ($total) {

			$result = $this->db->query($sql)->num_rows;
			return $result;
		}

		$result = $this->db->query($sql)->rows;

		return $result;
	}

	public function footerMenu()
	{
		$this->load->model('catalog/information');

		$data['informations'] = array();

		foreach ($this->model_catalog_information->getInformations() as $result) {
			if ($result['bottom']) {
				$data['informations'][] = array(
					'information_id' => $result['information_id'],
					'title' => html_entity_decode($result['title'], ENT_QUOTES, "UTF-8"),
					'status' => $result['status'],
					'sort_order' => $result['sort_order']
				);
			}
		}
		if ($data['informations']) {
			return $data['informations'];
		} else {
			return array();
		}
	}

	public function getSellercategories($category_id)
	{
		$seller_category = $this->db->query("SELECT category_id FROM " . DB_PREFIX . "customerpartner_to_category WHERE seller_id = " . (int)$this->customer->getId())->row;

		if (!$seller_category) {
			$seller_category['categories'] = $this->db->query("SELECT c.category_id FROM " . DB_PREFIX . "category c LEFT JOIN " . DB_PREFIX . "category_description cd ON (c.category_id = cd.category_id) WHERE cd.language_id = '" . (int)$this->config->get('config_language_id') . "' AND c.parent_id = " . $category_id)->rows;
		}

		return $seller_category;
	}

	public function getCategories($parent_id = 0)
	{
		$sql = "SELECT cp.category_id AS category_id, c1.sort_order, mc.category_image, c1.image, mc.category_icon, cd2.name AS name, c1.parent_id FROM " . DB_PREFIX . "category_path cp LEFT JOIN " . DB_PREFIX . "category c1 ON (cp.category_id = c1.category_id) LEFT JOIN " . DB_PREFIX . "category c2 ON (cp.path_id = c2.category_id) LEFT JOIN " . DB_PREFIX . "category_description cd1 ON (cp.path_id = cd1.category_id) LEFT JOIN " . DB_PREFIX . "category_description cd2 ON (cp.category_id = cd2.category_id) LEFT JOIN " . DB_PREFIX . "mobikul_category mc ON (cp.category_id = mc.category_id) LEFT JOIN " . DB_PREFIX . "category_to_store c2s ON (c1.category_id = c2s.category_id) WHERE c1.parent_id='" . (int)$parent_id . "' AND cd1.language_id = '" . (int)$this->config->get('config_language_id') . "' AND cd2.language_id = '" . (int)$this->config->get('config_language_id') . "' AND c1.status = '1'";

		$sql .= " GROUP BY cp.category_id";

		$sort_data = array(
			'name',
			'mc.category_image',
			'mc.category_icon'
		);

		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY c1.sort_order";
		}

		if (isset($data['order']) && ($data['order'] == 'DESC')) {
			$sql .= " DESC";
		} else {
			$sql .= " ASC";
		}


		$query = $this->db->query($sql);

		return $query->rows;
	}
}
