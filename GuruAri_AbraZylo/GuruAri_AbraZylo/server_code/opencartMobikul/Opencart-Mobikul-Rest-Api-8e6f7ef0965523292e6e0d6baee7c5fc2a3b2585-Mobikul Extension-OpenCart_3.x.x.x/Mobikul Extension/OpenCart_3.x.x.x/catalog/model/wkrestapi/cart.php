<?php
class ModelWkrestapiCart extends Model {

	/**
	 * Fetches coupon
	 * @return array returns coupon details
	 */
	public function coupon()	{

		$this->load->language('account/api');

		if ($this->config->get('coupon_status')) {

			if (version_compare(VERSION,'2.1.0.0','>=') || version_compare(VERSION,'2.0.0.0','<')) {
				$this->load->language('total/coupon');
			} else {
				$this->load->language('checkout/coupon');
			}

			$coupon['heading_title'] = $this->language->get('heading_title');

			$coupon['text_loading'] = $this->language->get('text_loading');

			$coupon['entry_coupon'] = $this->language->get('entry_coupon');

			$coupon['button_coupon'] = $this->language->get('button_coupon');

			if (isset($this->session->data['coupon'])) {
				$coupon['coupon'] = $this->session->data['coupon'];
			} else {
				$coupon['coupon'] = '';
			}
			return $coupon;
		}
		return array('message' => $this->language->get('text_coupon_message') );
	}
	/**
	 * Fetches voucher info
	 * @return array returns voucher info
	 */
	public function voucher()	{

		$this->load->language('account/api');

		if ($this->config->get('voucher_status')) {

			if (version_compare(VERSION,'2.1.0.0','>=') || version_compare(VERSION,'2.0.0.0','<')) {
				$this->load->language('total/voucher');
			} else {
				$this->load->language('checkout/voucher');
			}

			$voucher['heading_title'] = $this->language->get('heading_title');

			$voucher['text_loading'] = $this->language->get('text_loading');

			$voucher['entry_voucher'] = $this->language->get('entry_voucher');

			$voucher['button_voucher'] = $this->language->get('button_voucher');

			if (isset($this->session->data['voucher'])) {
				$voucher['voucher'] = $this->session->data['voucher'];
			} else {
				$voucher['voucher'] = '';
			}
			return $voucher;
		}
		return array('message' => $this->language->get('text_voucher_message'));
	}
	/**
	 * fetches reward points info
	 * @return array returns reward points info
	 */
	public function reward()	{

		$this->load->language('account/api');

		$points = $this->customer->getRewardPoints();

		$points_total = 0;

		foreach ($this->cart->getProducts() as $product) {
			if ($product['points']) {
				$points_total += $product['points'];
			}
		}

		if ($points && $points_total && ($this->config->get('reward_status') || $this->config->get('total_reward_status'))) {

			if (version_compare(VERSION,'2.3.0.0','>=')) {
	      $this->load->language('extension/total/reward');
	    } elseif (version_compare(VERSION,'2.1.0.0','>=')) {
	      $this->load->language('total/reward');
	    } else {
	      $this->load->language('checkout/reward');
	    }

			$reward['heading_title'] = sprintf($this->language->get('heading_title'), $points);

			$reward['text_loading'] = $this->language->get('text_loading');

			$reward['entry_reward'] = sprintf($this->language->get('entry_reward'), $points_total);

			$reward['button_reward'] = $this->language->get('button_reward');

			if (isset($this->session->data['reward'])) {
				$reward['reward'] = $this->session->data['reward'];
			} else {
				$reward['reward'] = $points;
			}
			return $reward;
		}
		return array('message' => $this->language->get('text_reward_message'));
	}
	/**
	 * Fetches shipping quote
	 * @return array returns shipping quote
	 */
	public function shipping()	{
		if ($this->config->get('shipping_status') && $this->config->get('shipping_estimator') && $this->cart->hasShipping()) {

			if (version_compare(VERSION,'2.1.0.0','>=')) {
				$this->load->language('total/shipping');
			} else {
				$this->load->language('checkout/shipping');
			}

			$shipping['heading_title'] = $this->language->get('heading_title');

			$shipping['text_shipping'] = $this->language->get('text_shipping');
			$shipping['text_shipping_method'] = $this->language->get('text_shipping_method');
			$shipping['text_select'] = $this->language->get('text_select');
			$shipping['text_none'] = $this->language->get('text_none');
			$shipping['text_loading'] = $this->language->get('text_loading');

			$shipping['entry_country'] = $this->language->get('entry_country');
			$shipping['entry_zone'] = $this->language->get('entry_zone');
			$shipping['entry_postcode'] = $this->language->get('entry_postcode');

			$shipping['button_quote'] = $this->language->get('button_quote');
			$shipping['button_shipping'] = $this->language->get('button_shipping');
			$shipping['button_cancel'] = $this->language->get('button_cancel');

			if (isset($this->session->data['shipping_address']['country_id'])) {
				$shipping['country_id'] = $this->session->data['shipping_address']['country_id'];
			} else {
				$shipping['country_id'] = $this->config->get('config_country_id');
			}

			$this->load->model('wkrestapi/customer');

			$shipping['countries'] = $this->model_wkrestapi_customer->getCountryData();

			if (isset($this->session->data['shipping_address']['zone_id'])) {
				$shipping['zone_id'] = $this->session->data['shipping_address']['zone_id'];
			} else {
				$shipping['zone_id'] = '';
			}

			if (isset($this->session->data['shipping_address']['postcode'])) {
				$shipping['postcode'] = $this->session->data['shipping_address']['postcode'];
			} else {
				$shipping['postcode'] = '';
			}

			if (isset($this->session->data['shipping_method'])) {
				$shipping['shipping_method'] = $this->session->data['shipping_method']['code'];
			} else {
				$shipping['shipping_method'] = '';
			}
			return $shipping;
		}
		return false;
	}
}
