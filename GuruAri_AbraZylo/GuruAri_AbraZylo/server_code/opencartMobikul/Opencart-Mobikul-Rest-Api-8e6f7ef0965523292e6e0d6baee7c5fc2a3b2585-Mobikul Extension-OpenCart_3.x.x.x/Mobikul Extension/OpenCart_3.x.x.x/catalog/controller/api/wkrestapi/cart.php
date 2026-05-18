<?php
class ControllerApiWkrestapiCart extends Controller {


	/**
	 * Adds a product to the cart
	 * @param json $data contains product info
	 */
	public function addToCart()	{

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

		// Use when get the option in json format
		if (isset($post['option']) && $post['option'] && !is_array($post['option'])) {
			$post['option'] = stripslashes(html_entity_decode($post['option']));
			$post['option'] = json_decode($post['option'],true);
		}

		if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
			$this->response->addHeader('Content-Type: application/json');
			$this->response->setOutput(json_encode(array('fault'=>1,'message'=>$this->language->get('text_token_message'))));
		} else {

			$productData = array();

			foreach ($post as $key => $value) {
			    $productData[$key] = $value;
			}

			$this->load->language('checkout/cart');

			$json = array();

			if (isset($productData['product_id'])) {
				$product_id = (int)$productData['product_id'];
			} else {
				$product_id = 0;
			}

			$this->load->model('catalog/product');

			$product_info = $this->model_catalog_product->getProduct($product_id);

			if ($this->config->get('marketplace_status') || $this->config->get('module_marketplace_status')) {
				$this->load->model('account/customerpartner');
				$this->load->language('extension/module/marketplace');
				$checkSellerOwnProduct = $this->model_account_customerpartner->checkSellerOwnProduct($product_id);

				if($checkSellerOwnProduct && !$this->config->get('marketplace_sellerbuyproduct')) {
					$return_array['error'] = 1;
					$return_array['message'] = $this->language->get('error_own_product');

					$this->response->addHeader('Content-Type: application/json');
					$this->response->setOutput(json_encode($return_array));return;
				}
			}

			if ($product_info) {
				if (isset($productData['quantity']) && ((int)$productData['quantity'] >= $product_info['minimum'])) {
					$quantity = (int)$productData['quantity'];
				} else {
					$quantity = $product_info['minimum'] ? $product_info['minimum'] : 1;
				}

				if (isset($productData['option'])) {

					$option_data = array();
					$option_value_data = array();

					foreach ($productData['option'] as $option_key => $option_value) {

						if (is_array($option_value)) {

							foreach ($option_value as $value_key => $value_value) {
								$option_value_data[$value_key] = $value_value;
							}
							$option_data[$option_key] = $option_value_data;
						}
					    $option_data[$option_key] = $option_value;
					}

					$option = array_filter($option_data);
				} else {
					$option = array();
				}

				$product_options = $this->model_catalog_product->getProductOptions($productData['product_id']);

				foreach ($product_options as $product_option) {
					if ($product_option['required'] && empty($option[$product_option['product_option_id']])) {
						// remove the index(['error']['option'][$product_option['product_option_id']]) of the option for making it simple array for the app end
						$json[] = sprintf($this->language->get('error_required'), $product_option['name']);
					}
				}

				if (isset($productData['recurring_id'])) {
					$recurring_id = $productData['recurring_id'];
				} else {
					$recurring_id = 0;
				}

				$recurrings = $this->model_catalog_product->getProfiles($product_info['product_id']);

				if ($recurrings) {
					$recurring_ids = array();

					foreach ($recurrings as $recurring) {
						$recurring_ids[] = $recurring['recurring_id'];
					}

					if (!in_array($recurring_id, $recurring_ids)) {
						// remove the index(['error']['recurring']) for making it simple array for the app end
						$json[] = $this->language->get('error_recurring_required');
					}
				}

				if (!$json) {
					$this->cart->add($productData['product_id'], $quantity, $option, $recurring_id);

					$return_array['message'] = strip_tags(sprintf($this->language->get('text_success'), '', html_entity_decode($product_info['name'], ENT_QUOTES, 'UTF-8'), ''));

					unset($this->session->data['shipping_method']);
					unset($this->session->data['shipping_methods']);
					unset($this->session->data['payment_method']);
					unset($this->session->data['payment_methods']);

					// Totals
					if (version_compare(VERSION,'3.0.0.0','>=') || version_compare(VERSION,'2.0.0.0','<')) {
						$this->load->model('setting/extension');
					}else{
						$this->load->model('extension/extension');
					}

					$total_data = array();
					$total = 0;
					$taxes = $this->cart->getTaxes();

					if (version_compare(VERSION,'2.2.0.0','>=')) {
						$total_data = array(
							'totals' => &$totals,
							'taxes'  => &$taxes,
							'total'  => &$total
						);
					}

					// Display prices
					if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
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

						foreach ($total_data as $key => $value) {
							if (isset($value['sort_order'])) {
								$sort_order[$key] = $value['sort_order'];
							} else {
								$sort_order[$key] = 1;
							}
						}

						array_multisort($sort_order, SORT_ASC, $total_data);
					}

					$return_array['total'] = (string) $this->cart->countProducts();
					$return_array['error'] = 0;
				} else {
					$return_array['error'] = 1;
					$return_array['message'] = $json[0];
				}
			} else {
				$return_array['error'] = 1;
				$return_array['message'] = $this->language->get('text_product_message');
			}
			$this->response->addHeader('Content-Type: application/json');

			$this->response->setOutput(json_encode($return_array));
		}
	}

	public function getShipping()	{

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

			if (version_compare(VERSION,'2.3.0.0','>=')) {
				$this->load->language('extension/total/shipping');
			} else {
				$this->load->language('total/shipping');
			}

			$json['error'] = 1;
			if (!$this->cart->hasProducts()) {
				$json['message'] = $this->language->get('error_product');
			}

			if (!$this->cart->hasShipping()) {
				$json['message'] = strip_tags(sprintf($this->language->get('error_no_shipping'),''));
			}

			if (!isset($post['country_id']) || $post['country_id'] == '') {
				$json['message'] = $this->language->get('error_country');
				$post['country_id'] = 0;
			}

			if (!isset($post['zone_id']) || $post['zone_id'] == '') {
				$json['message'] = $this->language->get('error_zone');
			}


			$this->load->model('localisation/country');

			$country_info = $this->model_localisation_country->getCountry($post['country_id']);

			if ($country_info && $country_info['postcode_required'] && (utf8_strlen(trim($post['postcode'])) < 2 || utf8_strlen(trim($post['postcode'])) > 10)) {
				$json['message'] = $this->language->get('error_postcode');
			}

			if (!isset($json['message'])) {
				$this->tax->setShippingAddress($post['country_id'], $post['zone_id']);

				if ($country_info) {
					$country = $country_info['name'];
					$iso_code_2 = $country_info['iso_code_2'];
					$iso_code_3 = $country_info['iso_code_3'];
					$address_format = $country_info['address_format'];
				} else {
					$country = '';
					$iso_code_2 = '';
					$iso_code_3 = '';
					$address_format = '';
				}

				$this->load->model('localisation/zone');

				$zone_info = $this->model_localisation_zone->getZone($post['zone_id']);

				if ($zone_info) {
					$zone = $zone_info['name'];
					$zone_code = $zone_info['code'];
				} else {
					$zone = '';
					$zone_code = '';
				}

				$this->session->data['shipping_address'] = array(
					'firstname'      => '',
					'lastname'       => '',
					'company'        => '',
					'address_1'      => '',
					'address_2'      => '',
					'postcode'       => $post['postcode'],
					'city'           => '',
					'zone_id'        => $post['zone_id'],
					'zone'           => $zone,
					'zone_code'      => $zone_code,
					'country_id'     => $post['country_id'],
					'country'        => $country,
					'iso_code_2'     => $iso_code_2,
					'iso_code_3'     => $iso_code_3,
					'address_format' => $address_format
				);

				$quote_data = array();

				if (version_compare(VERSION,'3.0.0.0','>=') || version_compare(VERSION,'2.0.0.0','<')) {
					$this->load->model('setting/extension');
					$results = $this->model_setting_extension->getExtensions('shipping');
				} else {
					$this->load->model('extension/extension');
					$results = $this->model_extension_extension->getExtensions('shipping');
				}

				foreach ($results as $result) {
					if (version_compare(VERSION,'3.0.0.0','>=')) {
						$shipping = 'shipping_' .$result['code'] . '_status';
					} else {
						$shipping = $result['code'] . '_status';
					}
					if ($this->config->get($shipping)) {
						if (version_compare(VERSION,'2.3.0.0','>=')) {
							$this->load->model('extension/shipping/' . $result['code']);
							$quote = $this->{'model_extension_shipping_' . $result['code']}->getQuote($this->session->data['shipping_address']);
						} else {
							$this->load->model('shipping/' . $result['code']);
							$quote = $this->{'model_shipping_' . $result['code']}->getQuote($this->session->data['shipping_address']);
						}

						if ($quote) {
							$quote_data[$result['code']] = array(
								'title'      => $quote['title'],
								'quote'      => $quote['quote'],
								'sort_order' => $quote['sort_order'],
							);

							$quotes = array();
							if (!empty($quote['quote'])) {
								foreach($quote['quote'] as $key => $value) {
								$quotes[] = $value;
								}
							}

							$quote_data_display[] = array(
								'title'      => $quote['title'],
								'quote'      => $quotes,
								'sort_order' => $quote['sort_order'],
							);
						}
					}
				}

				$sort_order = array();

				foreach ($quote_data as $key => $value) {
					$sort_order[$key] = $value['sort_order'];
				}

				array_multisort($sort_order, SORT_ASC, $quote_data);

				$this->session->data['shipping_methods'] = $quote_data;

				if (isset($quote_data_display) && $quote_data_display) {
					$json['shipping_method'] = $quote_data_display;
					$json['error'] = 0;
				} else {
					$json['message'] = strip_tags(sprintf($this->language->get('error_no_shipping'),''));
				}
			}

			$this->response->addHeader('Content-Type: application/json');

			$this->response->setOutput(json_encode($json));
		}
	}

	public function applyShipping()	{

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

			if (version_compare(VERSION,'2.3.0.0','>=')) {
				$this->load->language('extension/total/shipping');
			} else {
				$this->load->language('total/shipping');
			}

			$json['error'] = 1;

			if (!empty($post['shipping_method'])) {
				$shipping = explode('.', $post['shipping_method']);

				if (!isset($shipping[0]) || !isset($shipping[1]) || !isset($this->session->data['shipping_methods'][$shipping[0]]['quote'][$shipping[1]])) {
					$json['message'] = $this->language->get('error_shipping');
				}
			} else {
				$json['message'] = $this->language->get('error_shipping');
			}

			if (!isset($json['message'])) {
				$shipping = explode('.', $post['shipping_method']);
				$this->session->data['shipping_method'] = $this->session->data['shipping_methods'][$shipping[0]]['quote'][$shipping[1]];
				$json['error'] = 0;
				$json['message'] = $this->language->get('text_success');
			}

			$this->response->addHeader('Content-Type: application/json');
			$this->response->setOutput(json_encode($json));
		}
	}

	public function getCountry() {
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
			$json_file = DIR_APPLICATION . 'controller/api/wkrestapi/country.json';
			if (is_file($json_file)) {
				$json_countries = json_decode(file_get_contents($json_file), true);
				if(!$json_countries) {
					$this->load->model('wkrestapi/customer');
					$countryData = $this->model_wkrestapi_customer->getCountryData();
					file_put_contents($json_file, json_encode($countryData));

					$return_array['error'] = 0;
					$return_array['country_data'] = $countryData;
				} else {
					$return_array['error'] = 0;
					$return_array['country_data'] = $json_countries;
				}
			} else {
				$this->load->model('wkrestapi/customer');
				$return_array['error'] = 0;
				$return_array['country_data'] = $this->model_wkrestapi_customer->getCountryData();
			}

			$this->response->addHeader('Content-Type: application/json');
			$this->response->setOutput(json_encode($return_array));
		}
	}

	/**
	 * Views the cart
	 * @param  json $data contains width of device
	 * @return json       returns whole cart item
	 */
	public function viewCart()	{

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

			if (isset($post['width'])) {
				$width = (int) $post['width'];
			} else {
				$width = 100;
			}

			$this->load->model('wkrestapi/cart');

			$this->load->model('wkrestapi/catalog');

			$this->load->language('checkout/cart');

			$cart = array();

			$wishlist_count = (int) $this->model_wkrestapi_catalog->getDBWishlist();

			if ($this->cart->hasProducts() || !empty($this->session->data['vouchers'])) {

				if (!$this->cart->hasStock() && (!$this->config->get('config_stock_checkout') || $this->config->get('config_stock_warning'))) {
					foreach($this->cart->getProducts() as $product) {
						if (!$product['stock']) {
							$cart['error_warning'] = html_entity_decode($product['name'],ENT_QUOTES,'UTF-8')." ".$this->language->get('text_stock_error');
						}
					}
				} elseif (isset($this->session->data['error'])) {
					$cart['error_warning'] = $this->session->data['error'];

					unset($this->session->data['error']);
				} else {
					$cart['error_warning'] = '';
				}

				if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
					$cart['checkout_eligible'] = 0;
				} else {
					$cart['checkout_eligible'] = 1;
				}

				if (version_compare(VERSION,'3.0.0.0','>=')) {
					$cart['voucher_status'] = $this->config->get('total_voucher_status') ? 1 : 0;
					$cart['coupon_status'] = $this->config->get('total_coupon_status') ? 1 : 0;
				} else {
					$cart['voucher_status'] = $this->config->get('voucher_status') ? 1 : 0;
					$cart['coupon_status'] = $this->config->get('coupon_status') ? 1 : 0;
				}

				$cart['guest_status'] = $this->config->get('config_checkout_guest') ? true : false;

				if ($this->cart->hasDownload()) {
					$cart['download_status'] = 1;
				} else {
					$cart['download_status'] = 0;
				}

				if ($this->config->get('config_stock_checkout')) {
					$cart['checkout'] = $this->config->get('config_stock_checkout');
				} else {
					$cart['checkout'] = 0;
				}

				if ($this->config->get('config_customer_price') && !$this->customer->isLogged()) {
					$cart['attention'] = strip_tags(sprintf($this->language->get('text_login'), '', ''));
				} else {
					$cart['attention'] = '';
				}

				if (isset($this->session->data['success'])) {
					$cart['success'] = $this->session->data['success'];

					unset($this->session->data['success']);
				} else {
					$cart['success'] = '';
				}

				$cart['action'] = $this->url->link('checkout/cart/edit', '', true);

				if ($this->config->get('config_cart_weight')) {
					$cart['weight'] = $this->weight->format($this->cart->getWeight(), $this->config->get('config_weight_class_id'), $this->language->get('decimal_point'), $this->language->get('thousand_point'));
				} else {
					$cart['weight'] = '';
				}

				$this->load->model('tool/image');
				if (version_compare(VERSION,'2.0.0.0','>='))
					$this->load->model('tool/upload');

				$cart['products'] = array();

				$products = $this->cart->getProducts();

				foreach ($products as $product) {
					$product_total = 0;

					foreach ($products as $product_2) {
						if ($product_2['product_id'] == $product['product_id']) {
							$product_total += $product_2['quantity'];
						}
					}

					$already_status = false;

					if (version_compare(VERSION,'2.1.0.1	','>=')) {
						foreach($this->model_wkrestapi_catalog->getDBWishlist() as $wishlist) {
							if($wishlist['product_id'] == $product['product_id']){
								$already_status = true;
							}
						}
					}

					if ($product['minimum'] > $product_total) {
						$cart['checkout_eligible'] = 0;
						$cart['error_warning'] = sprintf($this->language->get('error_minimum'), $product['name'], $product['minimum']);
					}

					if ($product['image']) {
						$image = $this->model_tool_image->resize($product['image'], $width ? $width/2.5 : $this->config->get('config_image_cart_width'), $width ? $width/2.5 : $this->config->get('config_image_cart_height'));
					} else {
						$image = '';
					}

					if (isset($product['image']) && is_file(DIR_IMAGE.$product['image']))
					$dc_image = DIR_IMAGE.$product['image'];
					elseif (is_file(DIR_IMAGE.'placeholder.png'))
					$dc_image = DIR_IMAGE.'placeholder.png';
					else
					$dc_image = '';

					$this->load->model('wkrestapi/catalog');
					$dominant_color = $this->model_wkrestapi_catalog->getDominantColor($dc_image);

					$option_data = array();

					foreach ($product['option'] as $option) {
						if ($option['type'] != 'file') {

							if (version_compare(VERSION,'2.0.0.0','<'))
								$value = $option['price'];
							else
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

						$value = html_entity_decode($value,ENT_QUOTES,"UTF-8");

						$option_data[] = array(
							'name'  => html_entity_decode($option['name'],ENT_QUOTES,'UTF-8'),
							'value' => (utf8_strlen($value) > 20 ? utf8_substr($value, 0, 20) . '..' : $value)
						);
					}

					// Display prices
					if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
						$price = $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax')),$this->session->data['currency']);
					} else {
						$price = false;
					}

					// Display prices
					if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
						$total = $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax')) * $product['quantity'],$this->session->data['currency']);
					} else {
						$total = false;
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

					if (version_compare(VERSION,'2.1.0.0','>=')) {
						$cart['products'][] = array(
							'key'       => $product['cart_id'],
							'thumb'     => $image,
							'dominant_color' => $dominant_color,
							'name'      => html_entity_decode($product['name'],ENT_QUOTES,"UTF-8"),
							'model'     => html_entity_decode($product['model'],ENT_QUOTES,"UTF-8"),
							'option'    => $option_data,
							'recurring' => $recurring,
							'quantity'  => $product['quantity'],
							'stock'     => $product['stock'] ? true : !(!$this->config->get('config_stock_checkout') || $this->config->get('config_stock_warning')),
							'reward'    => ($product['reward'] ? sprintf($this->language->get('text_points'), $product['reward']) : ''),
							'points'    => ($product['points'] ? $product['points'] : ''),
							'price'     => $price,
							'total'     => $total,
							'product_id'=> $product['product_id'],
							'wishlist_status' => $already_status
						);
					} else {
						$cart['products'][] = array(
							'key'       => $product['key'],
							'thumb'     => $image,
							'dominant_color' => $dominant_color,
							'name'      => html_entity_decode($product['name'],ENT_QUOTES,"UTF-8"),
							'model'     => html_entity_decode($product['model'],ENT_QUOTES,"UTF-8"),
							'option'    => $option_data,
							'recurring' => $recurring,
							'quantity'  => $product['quantity'],
							'stock'     => $product['stock'] ? true : !(!$this->config->get('config_stock_checkout') || $this->config->get('config_stock_warning')),
							'reward'    => ($product['reward'] ? sprintf($this->language->get('text_points'), $product['reward']) : ''),
							'points'    => ($product['points'] ? $product['points'] : ''),
							'price'     => $price,
							'total'     => $total,
							'product_id'=> $product['product_id'],
							'wishlist_status' => $already_status
						);
					}
				}

				// Gift Voucher
				$cart['vouchers'] = array();

				if (!empty($this->session->data['vouchers'])) {
					foreach ($this->session->data['vouchers'] as $key => $voucher) {
						$cart['vouchers'][] = array(
							'key'         => $key,
							'description' => $voucher['description'],
							'amount'      => $this->currency->format($voucher['amount'],$this->session->data['currency']),
							'remove'      => $this->url->link('checkout/cart', 'remove=' . $key)
						);
					}
				}

				// Totals
				if (version_compare(VERSION,'3.0.0.0','>=') || version_compare(VERSION,'2.0.0.0','<')) {
					$this->load->model('setting/extension');
				}else{
					$this->load->model('extension/extension');
				}

				$total_data = array();
				$total = 0;
				$taxes = $this->cart->getTaxes();

				if (version_compare(VERSION,'2.2.0.0','>=')) {
					$total_data = array(
						'totals' => &$totals,
						'taxes'  => &$taxes,
						'total'  => &$total
					);
				}

				// Display prices
				if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
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

					foreach ($total_data as $key => $value) {
						if (isset($value['sort_order'])) {
							$sort_order[$key] = $value['sort_order'];
						} else {
							$sort_order[$key] = 1;
						}
					}

					array_multisort($sort_order, SORT_ASC, $total_data);
				}

				$cart['totals'] = array();

				if (version_compare(VERSION,'2.2.0.0','>=')) {
					if (isset($total_data['totals']) && $total_data['totals']) {
						foreach ($total_data['totals'] as $total) {
							$cart['totals'][] = array(
								'title' => isset($total['title']) ? $total['title'] : '',
								'text'  => isset($total['value']) ? $this->currency->format($total['value'],$this->session->data['currency']) : ''
							);
						}
					}
				} else {
					if (isset($total_data) && $total_data) {
						foreach ($total_data as $total) {
							$cart['totals'][] = array(
								'title' => isset($total['title']) ? $total['title'] : '',
								'text'  => isset($total['value']) ? $this->currency->format($total['value'],$this->session->data['currency']) : ''
							);
						}
					}
				}

				$cart['total_products'] = $this->cart->countProducts();

				$return_array = array(
					'cart'		=> $cart,
					'wishlist' => (int) $wishlist_count,
					'coupon'	=> $this->model_wkrestapi_cart->coupon(),
					'voucher'	=> $this->model_wkrestapi_cart->voucher(),
					'reward'	=> $this->model_wkrestapi_cart->reward(),
					'shipping'	=> ''//$this->model_wkrestapi_cart->shipping()
				);
			} else {
				$return_array = array('cart'=>array('cart'=>0, 'weight' => '0.00kg'),'error'=>0,'wishlist'=>(int) $wishlist_count);
			}

			$this->response->addHeader('Content-Type: application/json');

			$this->response->setOutput(json_encode($return_array));
		}
	}

	/**
	 * Removes items from the cart
	 * @param  json $data contains product's data
	 * @return json       return error if exists
	 */
	public function removeFromCart()	{

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

			if (isset($post['key']) && $post['key']) {

				$this->load->language('checkout/cart');

				$this->cart->remove($post['key']);

				unset($this->session->data['vouchers'][$post['key']]);

				$return_array['message'] = $this->language->get('text_remove');

				unset($this->session->data['shipping_method']);
				unset($this->session->data['shipping_methods']);
				unset($this->session->data['payment_method']);
				unset($this->session->data['payment_methods']);
				unset($this->session->data['reward']);

				// Totals
				if (version_compare(VERSION,'3.0.0.0','>=') || version_compare(VERSION,'2.0.0.0','<')) {
					$this->load->model('setting/extension');
				}else{
					$this->load->model('extension/extension');
				}

				$total_data = array();
				$total = 0;
				$taxes = $this->cart->getTaxes();

				if (version_compare(VERSION,'2.2.0.0','>=')) {
					$total_data = array(
						'totals' => &$totals,
						'taxes'  => &$taxes,
						'total'  => &$total
					);
				}

				// Display prices
				if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
					$sort_order = array();

					if (version_compare(VERSION,'3.0.0.0','>=') || version_compare(VERSION,'2.0.0.0','<')) {
						$results = $this->model_setting_extension->getExtensions('total');
					}else{
					$results = $this->model_extension_extension->getExtensions('total');

					}

					foreach ($results as $key => $value) {
						$sort_order[$key] = $this->config->get($value['code'] . '_sort_order');
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

					foreach ($total_data as $key => $value) {
						if (isset($value['sort_order'])) {
							$sort_order[$key] = $value['sort_order'];
						} else {
							$sort_order[$key] = 1;
						}
					}

					array_multisort($sort_order, SORT_ASC, $total_data);
				}

				$return_array['total'] = sprintf($this->language->get('text_items'), $this->cart->countProducts() + (isset($this->session->data['vouchers']) ? count($this->session->data['vouchers']) : 0), $this->currency->format($total,$this->session->data['currency']));
				$return_array['error'] = 0;

			} else {
				$return_array = array(
					'error'		=> 1 ,
					'message'	=> $this->language->get('text_key_message')
				);
			}

			$this->response->addHeader('Content-Type: application/json');

			$this->response->setOutput(json_encode($return_array));
		}
	}

	/**
	 * Updates the cart
	 * @param  json $data contains cart data
	 * @return json       return error if exists
	 */
	public function updateCart()	{

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

			if (!empty($post['quantity'])) {
				$quantity = $post['quantity'];
				if(!is_array($post['quantity'])){
					$quantity = stripslashes(html_entity_decode($post['quantity']));
					$quantity = json_decode($quantity,true);
				}

				foreach ($quantity as $key => $value) {
					$this->cart->update($key, $value);
				}
			}

			unset($this->session->data['shipping_method']);
			unset($this->session->data['shipping_methods']);
			unset($this->session->data['payment_method']);
			unset($this->session->data['payment_methods']);
			unset($this->session->data['reward']);

			$return_array = array(
					'error'		=> 0,
					'message'   => $this->language->get('text_update_cart_message')
			);

			$this->response->addHeader('Content-Type: application/json');

			$this->response->setOutput(json_encode($return_array));
		}
	}

	/**
	 * Applies coupon at the cart
	 * @param  json $data contains coupon data
	 * @return json       returns error if exists
	 */
	public function applyCoupon()	{

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

			if (isset($post['coupon'])) {
				$coupon = $post['coupon'];
			} else {
				$coupon = '';
			}

			if (version_compare(VERSION,'2.3.0.0','>=')) {

				$this->load->language('extension/total/coupon');

				$this->load->model('extension/total/coupon');

				$coupon_info = $this->model_extension_total_coupon->getCoupon($coupon);

			} else {

				if (version_compare(VERSION,'2.1.0.0','>=')) {
					$this->load->language('total/coupon');

					$this->load->model('total/coupon');

					$coupon_info = $this->model_total_coupon->getCoupon($coupon);
				} else {
					$this->load->language('checkout/coupon');

					$this->load->model('checkout/coupon');

					$coupon_info = $this->model_checkout_coupon->getCoupon($coupon);
				}
			}

			if (empty($coupon)) {
				$return_array['error'] = 1;
				$return_array['message'] = $this->language->get('error_empty');

				unset($this->session->data['coupon']);
			} elseif ($coupon_info) {
				$this->session->data['coupon'] = $coupon;
				$return_array['error'] = 0;
				$return_array['message'] = $this->language->get('text_success');
			} else {
				$return_array['error'] = 1;
				$return_array['message'] = $this->language->get('error_coupon');
			}

			$this->response->addHeader('Content-Type: application/json');

			$this->response->setOutput(json_encode($return_array));
		}
	}

	/**
	 * Applies voucher on the cart page
	 * @param  json $data contains the voucher infomation
	 * @return json       return error if exists
	 */
	public function applyVoucher()	{

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

			if (isset($post['voucher'])) {
				$voucher = $post['voucher'];
			} else {
				$voucher = '';
			}

			if (version_compare(VERSION,'2.3.0.0','>=')) {

				$this->load->language('extension/total/voucher');

				$this->load->model('extension/total/voucher');

				$voucher_info = $this->model_extension_total_voucher->getVoucher($voucher);

			} else {
				if (version_compare(VERSION,'2.1.0.0','>=')) {
					$this->load->language('total/voucher');

					$this->load->model('total/voucher');

					$voucher_info = $this->model_total_voucher->getVoucher($voucher);


				} else {
					$this->load->language('checkout/voucher');

					$this->load->model('checkout/voucher');

					$voucher_info = $this->model_checkout_voucher->getVoucher($voucher);
				}
			}

			if (empty($voucher)) {
				$return_array = array(
					'error' => 1,
					'message' => $this->language->get('error_empty')
				);
			} elseif ($voucher_info) {
				$this->session->data['voucher'] = $voucher;
				$return_array = array(
					'error' => 0,
					'message' => $this->language->get('text_success')
				);
			} else {
				$return_array = array(
					'error' => 1,
					'message' => $this->language->get('error_voucher')
				);
			}

			$this->response->addHeader('Content-Type: application/json');

			$this->response->setOutput(json_encode($return_array));
		}
	}

	/**
	 * Applies reward points on the cart page
	 * @param  json $data contains reward point data
	 * @return json       returns error if exists
	 */
	 public function applyPoints()	{

 		$this->load->language('account/api');

 		$post = $this->request->post;

 		//Accepting post data in json format / raw data

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

 			if (isset($post['reward'])) {
 				$reward_data = $post['reward'];
 			} else {
 				$reward_data = '';
 			}


			if (version_compare(VERSION,'2.3.0.0','>=')) {
				$this->load->language('extension/total/reward');
			} elseif (version_compare(VERSION,'2.1.0.0','>=')) {
				$this->load->language('total/reward');
			} else {
				$this->load->language('checkout/reward');
			}

 			$points = $this->customer->getRewardPoints();

 			$points_total = 0;

 			foreach ($this->cart->getProducts() as $product) {
 				if ($product['points']) {
 					$points_total += $product['points'];
 				}
 			}

 			if (empty($reward_data)) {
 				$return_array['message'] = $this->language->get('error_reward');
 			}

 			if ($reward_data > $points) {
 				$return_array['message'] = sprintf($this->language->get('error_points'), $reward_data);
 			}

 			if ($reward_data > $points_total) {
 				$return_array['message'] = sprintf($this->language->get('error_maximum'), $points_total);
 			}

 			if (!isset($return_array)) {
 				$this->session->data['reward'] = abs($reward_data);

 				$return_array['message'] = $this->language->get('text_success');
 				$return_array['error'] = 0;
 			} else {
 				$return_array['error'] = 1;
 			}

 			$this->response->addHeader('Content-Type: application/json');

 			$this->response->setOutput(json_encode($return_array));
 		}
 	}

	public function clearCart()	{

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
	    $this->cart->clear();

	    $return_array = array(
	      'error'		=> 0 ,
	      'message'	=> $this->language->get('text_cart_clear')
	    );

	    $this->response->addHeader('Content-Type: application/json');

	    $this->response->setOutput(json_encode($return_array));
	  }
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
