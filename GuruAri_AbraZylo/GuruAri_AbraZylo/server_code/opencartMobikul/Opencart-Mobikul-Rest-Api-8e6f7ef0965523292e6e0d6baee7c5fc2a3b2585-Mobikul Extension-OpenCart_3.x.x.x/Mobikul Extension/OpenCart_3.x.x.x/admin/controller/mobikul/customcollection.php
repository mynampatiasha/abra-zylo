<?php
class ControllerMobikulCustomcollection extends Controller {
	private $error = array();

	public function index() {

		$data = array();

		$data = array_merge($data,$this->language->load('mobikul/customcollection'));

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('setting/setting');

		$this->load->model('mobikul/customcollection');

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}

		if (isset($this->error['image'])) {
			$data['error_image'] = $this->error['image'];
		} else {
			$data['error_image'] = array();
		}

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], 'SSL'),
		);

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('mobikul/customcollection', 'user_token=' . $this->session->data['user_token'], 'SSL'),
		);

		$data['action'] = $this->url->link('mobikul/customcollection', 'user_token=' . $this->session->data['user_token'], 'SSL');

		$data['cancel'] = $this->url->link('mobikul/customcollection', 'user_token=' . $this->session->data['user_token'], 'SSL');

		$data['user_token'] = $this->session->data['user_token'];

		if (isset($this->session->data['success'])) {
			$data['success'] = $this->session->data['success'];

			unset($this->session->data['success']);
		} else {
			$data['success'] = '';
		}

		if (isset($this->request->get['page'])) {
			$page = $this->request->get['page'];
		} else {
			$page = 1;
		}
	
		if (isset($this->request->get['sort'])) {
			$sort = $this->request->get['sort'];
			
		} else {
			$sort = 'mc.id';
		}

		if (isset($this->request->get['order'])) {
			$order = $this->request->get['order'];
		} else {
			$order = 'ASC';
		}

		$url = '';	

		if ($order == 'ASC') {
			$url .= '&order=DESC';
		} else {
			$url .= '&order=ASC';
		}

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}
		

		$filter = array(		
			'sort'      => $sort,
			'order'      => $order,
			'start'           => ($page - 1) * $this->config->get('config_limit_admin'),
			'limit'           => $this->config->get('config_limit_admin')
		);

		$collections = $this->model_mobikul_customcollection->getCustomCollection($filter);
	
		if($collections){
			foreach( $collections as $collections ){
				$data['collections'][] = array(
					'id' =>  $collections['id'],
					'name' => $collections['name'][(int)$this->config->get('config_language_id') ]['name'],
					'product_ids' => $collections['product_ids'],
					'product_name' => $collections['product_name'],
					'edit' => $this->url->link('mobikul/customcollection/edit&collection_id='.$collections['id'], 'user_token=' . $this->session->data['user_token'], 'SSL')

				);
			}
		}	
		$data['sort_id'] = $this->url->link('mobikul/customcollection', 'user_token=' . $this->session->data['user_token'] . '&sort=mc.id' . $url, true);
		$data['sort_name'] = $this->url->link('mobikul/customcollection', 'user_token=' . $this->session->data['user_token'] . '&sort=mcd.name' . $url, true);
		$collection_total = $this->model_mobikul_customcollection->getTotalCollection();
	
		$data['add'] = $this->url->link('mobikul/customcollection/add', 'user_token=' . $this->session->data['user_token'].$url, 'SSL');
		
		$url = '';	
		
		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}
		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}
		
		
		$pagination = new Pagination();
		$pagination->total = $collection_total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_limit_admin');
		$pagination->url = $this->url->link('mobikul/customcollection', 'user_token=' . $this->session->data['user_token'] .$url.'&page={page}', 'SSL');

		$data['pagination'] = $pagination->render();

		$data['results'] = sprintf($this->language->get('text_pagination'), ($collection_total) ? (($page - 1) * $this->config->get('config_limit_admin')) + 1 : 0, ((($page - 1) * $this->config->get('config_limit_admin')) > ($collection_total - $this->config->get('config_limit_admin'))) ? $collection_total : ((($page - 1) * $this->config->get('config_limit_admin')) + $this->config->get('config_limit_admin')), $collection_total, ceil($collection_total / $this->config->get('config_limit_admin')));

		
		$data['sort'] = $sort;
		$data['order'] = $order;
		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/customcollection_list', $data));
	}

	public function add(){
		$data = array();

		$data = array_merge($data,$this->language->load('mobikul/customcollection'));

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('setting/setting');

		$this->load->model('mobikul/customcollection');

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
		
			if ($this->request->post['collection_type'] == 'latest_count') {
				$this->request->post['mobikul_customcollection_customcollection_product'] = $this->model_mobikul_customcollection->getLatestProducts($this->request->post['latest_count']);
			}

			if ($this->request->post['collection_type'] == 'product_attribute') {
				if ($this->request->post['product_attribute'] == 'price') {
					$this->request->post['mobikul_customcollection_customcollection_product'] = $this->model_mobikul_customcollection->getProductsByAttribute($this->request->post['product_attribute'],$this->request->post['price_from'],$this->request->post['price_to']);
				} else if($this->request->post['product_attribute'] == 'manufacturer'){ 
					$this->request->post['mobikul_customcollection_customcollection_product'] = $this->model_mobikul_customcollection->getProductsByAttribute($this->request->post['product_attribute'],$this->request->post['manufacturer_id']);
				} else {
					$this->request->post['mobikul_customcollection_customcollection_product'] = $this->model_mobikul_customcollection->getProductsByAttribute($this->request->post['product_attribute'],$this->request->post['product_model']);
				}

			}

			$this->request->post['mobikul_customcollection_customcollection_product_names'] = array();

			if ($this->request->post['mobikul_customcollection_customcollection_product']) {
				foreach ($this->request->post['mobikul_customcollection_customcollection_product'] as $key =>  $value) {
					$this->request->post['mobikul_customcollection_customcollection_product_names'][$key] = $this->model_mobikul_customcollection->getProductName($value);
				}
			}
			
			$this->model_mobikul_customcollection->addCollection($this->request->post);		
			$this->session->data['success'] = $this->language->get('text_success');

			$this->response->redirect($this->url->link('mobikul/customcollection', 'user_token=' . $this->session->data['user_token'], 'SSL'));
			$this->session->data['success'] = $this->language->get('text_success');
		}
		
		if (isset($this->request->get['collection_id'])) {
			$data['collection_heading'] = $this->language->get('heading_title_edit');
		} else {
			$data['collection_heading'] = $this->language->get('heading_title_add');
		}


		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}

		if (isset($this->error['image'])) {
			$data['error_image'] = $this->error['image'];
		} else {
			$data['error_image'] = array();
		}

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = array();
		}
		if (isset($this->error['error_collection_name'])) {
			$data['error_collection_name'] = $this->error['error_collection_name'];
		} else {
			$data['error_collection_name'] = array();
		}

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], 'SSL'),
		);

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('mobikul/customcollection', 'user_token=' . $this->session->data['user_token'], 'SSL'),
		);

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('heading_title_add'),
			'href'      => $this->url->link('mobikul/customcollection/add', 'user_token=' . $this->session->data['user_token'], 'SSL'),
		);

		$data['action'] = $this->url->link('mobikul/customcollection/add', 'user_token=' . $this->session->data['user_token'], 'SSL');

		$data['cancel'] = $this->url->link('mobikul/customcollection', 'user_token=' . $this->session->data['user_token'], 'SSL');

		$data['user_token'] = $this->session->data['user_token'];

		if (isset($this->request->post['mobikul_customcollection_customcollection_product'])) {
			$data['customcollection_product'] = $this->request->post['mobikul_customcollection_customcollection_product'];
		} else {
			$data['customcollection_product'] = '';
		}

		if (isset($this->request->post['name'])) {
			$data['customcollection_name'] = $this->request->post['name'];
		} else {
			$data['customcollection_name'] = '';
		}

		if (isset($this->session->data['success'])) {
			$data['success'] = $this->session->data['success'];

			unset($this->session->data['success']);
		} else {
			$data['success'] = '';
		}


		$this->load->model('catalog/product');

		if (isset($this->request->post['mobikul_customcollection_customcollection_product'])) {
			$products =  $this->request->post['mobikul_customcollection_customcollection_product'];
		} else {
			$products = '';
		}
		$data['products'] = array();
		if(!empty($products)) {
			foreach ($products as $product_id) {
				$product_info = $this->model_catalog_product->getProduct($product_id);

				if ($product_info) {
					$data['products'][] = array(
						'product_id' => $product_info['product_id'],
						'name'       => $product_info['name'],
						'edit'       => $this->url->link('mobikul/customcollection/edit&collection_id=', 'user_token=' . $this->session->data['user_token'], 'SSL'),
					);
				}
			}
		}
		if (isset($this->request->post['name'])) {
			$collections['collection_name'] = $this->request->post['name'];
		}else {
			$collections['collection_name'] = array();
		}

		if (isset($this->request->post['collection_type'])) {
			$collections['collection_type'] = $this->request->post['collection_type'];
		}  else {
			$collections['collection_type'] = '';
		}
		
		if (isset($this->request->post['product'])) {
			$products = $this->request->post['product'];
		}  else {
			$products = array();
		}
		if (isset($this->request->post['latest_count'])) {
			$collections['latest_count'] = $this->request->post['latest_count'];
		}else {
			$collections['latest_count'] = '';
		}
		
		if (isset($this->request->post['product_attribute'])) {
			$collections['product_attribute'] = $this->request->post['product_attribute'];
		} else {
			$collections['product_attribute'] = '';
		}
		if (isset($this->request->post['price_from'])) {
			$collections['price_from'] = $this->request->post['price_from'];
		} else {
			$collections['price_from'] = '';
		}
		if (isset($this->request->post['price_to'])) {
			$collections['price_to'] = $this->request->post['price_to'];
		} else {
			$collections['price_to'] = '';
		}
		if (isset($this->request->post['manufacturer_name'])) {
			$manufacturer = $this->request->post['manufacturer_name'];
		} else {
			$manufacturer = '';
		}
		if (isset($this->request->post['product_model'])) {
			$collections['product_model'] = $this->request->post['product_model'];
		}else {
			$collections['product_model'] = '';
		}

		$data['custom_collection'] = array(	
						
			"collection_type"   =>   $collections['collection_type'],
			"collection_name"   =>  $collections['collection_name'],
			"products"   =>    $products,
			"latest_count"   =>  !is_null($collections['latest_count']) ? $collections['latest_count'] : '',
			"product_attribute"   => !is_null($collections['product_attribute']) ? $collections['product_attribute'] : '',
			"price_from"   =>   !is_null($collections['price_from']) ? $collections['price_from'] : '',
			"price_to"   =>    !is_null($collections['price_to']) ? $collections['price_to'] : '',
			"manufacturer_name"   =>  !is_null($manufacturer) ? $manufacturer : '',
			"product_model"   =>  !is_null($collections['product_model']) ? $collections['product_model'] : ''
	);	
		$this->load->model('localisation/language');
		$data['languages'] = $this->model_localisation_language->getLanguages();
	
		
		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/customcollection_form', $data));
	}


	public function edit(){
		$data = array();

		$data = array_merge($data,$this->language->load('mobikul/customcollection'));

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('setting/setting');

		$this->load->model('mobikul/customcollection');

	

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
			
			if ($this->request->post['collection_type'] == 'latest_count') {
				$this->request->post['mobikul_customcollection_customcollection_product'] = $this->model_mobikul_customcollection->getLatestProducts($this->request->post['latest_count']);
			}

			if ($this->request->post['collection_type'] == 'product_attribute') {
				if ($this->request->post['product_attribute'] == 'price') {
					$this->request->post['mobikul_customcollection_customcollection_product'] = $this->model_mobikul_customcollection->getProductsByAttribute($this->request->post['product_attribute'],$this->request->post['price_from'],$this->request->post['price_to']);
				} else if($this->request->post['product_attribute'] == 'manufacturer'){ 
					$this->request->post['mobikul_customcollection_customcollection_product'] = $this->model_mobikul_customcollection->getProductsByAttribute($this->request->post['product_attribute'],$this->request->post['manufacturer_id']);
				} else {
					$this->request->post['mobikul_customcollection_customcollection_product'] = $this->model_mobikul_customcollection->getProductsByAttribute($this->request->post['product_attribute'],$this->request->post['product_model']);
				}

			}

			$this->request->post['mobikul_customcollection_customcollection_product_names'] = array();

			if ($this->request->post['mobikul_customcollection_customcollection_product']) {
				foreach ($this->request->post['mobikul_customcollection_customcollection_product'] as $key =>  $value) {
					$this->request->post['mobikul_customcollection_customcollection_product_names'][$key] = $this->model_mobikul_customcollection->getProductName($value);
				}
			}

			if (isset($this->request->get['collection_id']) && $this->request->get['collection_id']) {
				$this->model_mobikul_customcollection->addCollectionById($this->request->get['collection_id'],$this->request->post);
			} else {
				$this->model_mobikul_customcollection->addCollection(0,$this->request->post);
			}


			$this->session->data['success'] = $this->language->get('text_success');

			$this->response->redirect($this->url->link('mobikul/customcollection', 'user_token=' . $this->session->data['user_token'], 'SSL'));
			$this->session->data['success'] = $this->language->get('text_success');
		}


		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}

		if (isset($this->error['image'])) {
			$data['error_image'] = $this->error['image'];
		} else {
			$data['error_image'] = array();
		}

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = array();
		}

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], 'SSL'),
		);

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('mobikul/customcollection', 'user_token=' . $this->session->data['user_token'], 'SSL'),
		);

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('heading_title_edit'),
			'href'      => $this->url->link('mobikul/customcollection/edit', 'user_token=' . $this->session->data['user_token'], 'SSL'),
		);

		if (isset($this->request->get['collection_id'])) {
			$data['collection_heading'] = $this->language->get('heading_title_edit');
			$collection_id = $this->request->get['collection_id'];
		} else {
			$data['collection_heading'] = $this->language->get('heading_title_add');
			$collection_id = '';
		}

		$data['action'] = $this->url->link('mobikul/customcollection/edit&collection_id='.$collection_id, 'user_token=' . $this->session->data['user_token'], 'SSL');

		$data['cancel'] = $this->url->link('mobikul/customcollection', 'user_token=' . $this->session->data['user_token'], 'SSL');

		$data['user_token'] = $this->session->data['user_token'];	
		
		$collections = $this->model_mobikul_customcollection->getCustomCollectionById($collection_id);
		$products = array();
		if($collections){
				foreach($collections['products']  as $product){
					$products[] = array(						
						"product_id" => $product['product_id'],
						"name" => $product['product_name']						
					);				  
				}
				$manufacturer = $this->model_mobikul_customcollection->getManufacturerName($collections['manufacturer_id']);
				
				if (isset($this->request->post['name'])) {
					$collections['collection_name'] = $this->request->post['name'];
				} elseif (!empty($collections)) {
					$collections['collection_name'] = $collections['collection_name'];
				} else {
					$collections['collection_name'] = array();
				}

				if (isset($this->request->post['collection_type'])) {
					$collections['collection_type'] = $this->request->post['collection_type'];
				} elseif (!empty($collections)) {
					$collections['collection_type'] = $collections['collection_type'];
				} else {
					$collections['collection_type'] = '';
				}
				
				if (isset($this->request->post['product'])) {
					$products = $this->request->post['product'];
				} elseif (!empty($products)) {
					$products = $products;
				} else {
					$products = array();
				}
				if (isset($this->request->post['latest_count'])) {
					$collections['latest_count'] = $this->request->post['latest_count'];
				} elseif (!empty($collections)) {
					$collections['latest_count'] = $collections['latest_count'];
				} else {
					$collections['latest_count'] = '';
				}
				
				if (isset($this->request->post['product_attribute'])) {
					$collections['product_attribute'] = $this->request->post['product_attribute'];
				} elseif (!empty($collections)) {
					$collections['product_attribute'] = $collections['product_attribute'];
				} else {
					$collections['product_attribute'] = '';
				}
				if (isset($this->request->post['price_from'])) {
					$collections['price_from'] = $this->request->post['price_from'];
				} elseif (!empty($collections)) {
					$collections['price_from'] = $collections['price_from'];
				} else {
					$collections['price_from'] = '';
				}
				if (isset($this->request->post['price_to'])) {
					$collections['price_to'] = $this->request->post['price_to'];
				} elseif (!empty($collections)) {
					$collections['price_to'] = $collections['price_to'];
				} else {
					$collections['price_to'] = '';
				}
				if (isset($this->request->post['manufacturer_name'])) {
					$manufacturer = $this->request->post['manufacturer_name'];
				} elseif (!empty($manufacturer)) {
					$manufacturer = $manufacturer;
				} else {
					$manufacturer = '';
				}
				if (isset($this->request->post['product_model'])) {
					$collections['product_model'] = $this->request->post['product_model'];
				} elseif (!empty($collections)) {
					$collections['product_model'] = $collections['product_model'];
				} else {
					$collections['product_model'] = '';
				}

				$data['custom_collection'] = array(	
						
						"collection_type"   =>   $collections['collection_type'],
						"collection_name"   =>  $collections['collection_name'],
						"products"   =>    $products,
						"latest_count"   =>  !is_null($collections['latest_count']) ? $collections['latest_count'] : '',
						"product_attribute"   => !is_null($collections['product_attribute']) ? $collections['product_attribute'] : '',
						"price_from"   =>   !is_null($collections['price_from']) ? $collections['price_from'] : '',
						"price_to"   =>    !is_null($collections['price_to']) ? $collections['price_to'] : '',
						"manufacturer_name"   =>  !is_null($manufacturer) ? $manufacturer : '',
						"product_model"   =>  !is_null($collections['product_model']) ? $collections['product_model'] : ''
				);	
		
		}

		
		$this->load->model('localisation/language');
		$data['languages'] = $this->model_localisation_language->getLanguages();
		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/customcollection_form', $data));
	}

	protected function validate() {
		if (!$this->user->hasPermission('modify', 'mobikul/customcollection')) {
			$this->error['warning'] = $this->language->get('error_permission');
		} else{
			if(isset($this->request->post['name'])){
				foreach ($this->request->post['name'] as $language_id => $collection_name) {
					if ((utf8_strlen($collection_name['collection_name']) < 2) || (utf8_strlen($collection_name['collection_name']) > 64) || empty($collection_name['collection_name']) || ctype_space($collection_name['collection_name'] ) ) {
					$this->error['error_collection_name'][$language_id] = $this->language->get('error_name_range');
					$this->error['warning'] = $this->language->get('error_name');
					}
				}
		
			}
			else{
				$this->error['warning'] = $this->language->get('error_name');
			}
	
			if( !isset($this->error['warning']) ){
				if (!$this->request->post['collection_type']) {
					$this->error['warning'] = $this->language->get('error_type');
				}
			}
			
			
			if( !isset($this->error['warning']) ){
				if ($this->request->post['collection_type'] == 'latest_count' && !$this->request->post['latest_count'] > 0) {
					$this->error['warning'] = $this->language->get('error_count');
				}else if ($this->request->post['collection_type'] == 'latest_count' && !is_numeric($this->request->post['latest_count']) ) {
					$this->error['warning'] = $this->language->get('error_numric_count');
				}
			
			}
		
			if( !isset($this->error['warning']) ){
	
				if ($this->request->post['collection_type'] == 'product_ids' && empty($this->request->post['mobikul_customcollection_customcollection_product']) ) {
					$this->error['warning'] = $this->language->get('error_product_ids');
				}
		
			}
	
	
			if( !isset($this->error['warning']) ){
	
			   if ($this->request->post['collection_type'] == 'product_attribute') {
	
				if ($this->request->post['product_attribute'] == 'price') {
					if (!isset($this->request->post['price_from']) || !isset($this->request->post['price_to']) || !$this->request->post['price_from'] || !$this->request->post['price_to']) {
						$this->error['warning'] = $this->language->get('error_price');
					}else if(!is_numeric($this->request->post['price_from'])  || !is_numeric($this->request->post['price_to'])  ){
						$this->error['warning'] = $this->language->get('error_number');
					}else if(!$this->model_mobikul_customcollection->getProductsByAttribute($this->request->post['product_attribute'],$this->request->post['price_from'],$this->request->post['price_to'])){
						
						$product_id = $this->model_mobikul_customcollection->getProductsByAttribute($this->request->post['product_attribute'],$this->request->post['price_from'],$this->request->post['price_to']);
					
						if(!isset($product_id) || !$product_id){
							$this->error['warning'] = $this->language->get('error_no_product_to_price');
						}
					}
	
					
				} else if($this->request->post['product_attribute'] == 'manufacturer'){
					if (!isset($this->request->post['manufacturer_name']) || !$this->request->post['manufacturer_name']) {
						$this->error['warning'] = $this->language->get('error_manufacturer');
					}
					else if( empty($this->request->post['manufacturer_id']) ){					
						$this->error['warning'] = $this->language->get('error_no_product_to_manufacture');
					
					}
					else if(!$this->request->post['mobikul_customcollection_customcollection_product'] = $this->model_mobikul_customcollection->getProductsByAttribute($this->request->post['product_attribute'],$this->request->post['manufacturer_id'])){
						
						$product_id = $this->request->post['mobikul_customcollection_customcollection_product'] = $this->model_mobikul_customcollection->getProductsByAttribute($this->request->post['product_attribute'],$this->request->post['manufacturer_id']);
					
						if(!isset($product_id) || !$product_id){
							$this->error['warning'] = $this->language->get('error_no_product_to_manufacture');
						}
					}
	
				} else {
					
					if ( !isset($this->request->post['product_model']) || !$this->request->post['product_model']) {
						$this->error['warning'] = $this->language->get('error_model');
					}else if( empty($this->request->post['product_model']) ){					
							$this->error['warning'] = $this->language->get('error_no_product_to_model');
						
					}else if(!$this->request->post['mobikul_customcollection_customcollection_product'] = $this->model_mobikul_customcollection->getProductsByAttribute($this->request->post['product_attribute'],$this->request->post['product_model'])){
						$this->error['warning'] = $this->language->get('error_no_product_to_model');
					}
				}
			}
		  }
		}
		
		
		
		if (!$this->error) {
			return true;
		} else {
			return false;
		}
	}

	public function delete() {

		$json['success'] = '';

		$this->load->model('mobikul/customcollection');

		$this->language->load('mobikul/customcollection');

		if (isset($this->request->post['post_id']) && $this->request->post['post_id']) {
		   
			foreach($this->request->post['post_id'] as $id){
				$this->model_mobikul_customcollection->deleteCollection($id);
			}
			$this->session->data['success'] = $this->language->get('text_success_delete');
			$json['success'] = $this->language->get('text_success_delete');
		}

		if (isset($this->request->post['id']) && $this->request->post['id']) {

			$this->model_mobikul_customcollection->deleteCollection($this->request->post['id']);

			$this->session->data['success'] = $this->language->get('text_success_delete');
			$json['success'] = $this->language->get('text_success_delete');
		}
		$this->response->setOutput(json_encode($json));
	}
}
