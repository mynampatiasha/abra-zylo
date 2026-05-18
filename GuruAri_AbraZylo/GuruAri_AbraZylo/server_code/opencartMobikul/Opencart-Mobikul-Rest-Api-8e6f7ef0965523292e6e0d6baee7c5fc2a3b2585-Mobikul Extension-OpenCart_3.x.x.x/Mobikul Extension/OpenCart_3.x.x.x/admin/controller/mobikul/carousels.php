<?php
class ControllerMobikulCarousels extends Controller
{
	private $error = array();

	public function index()
	{
		$this->load->language('mobikul/carousels');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->getList();
	}

	public function add()
	{
		$lang_array = $this->load->language('mobikul/carousels');
		$this->load->language('catalog/product');
		$this->load->model('catalog/product');
		$this->load->model('tool/image');
		$this->load->model('mobikul/carousels');
		$this->document->setTitle($this->language->get('heading_title'));

		if (($this->request->server['REQUEST_METHOD'] == 'POST')  && $this->validate()) {
			$this->load->model('mobikul/carousels');
			$carousels = $this->model_mobikul_carousels->addcarousels($this->request->post);
			$this->response->redirect($this->url->link('mobikul/carousels', 'user_token=' . $this->session->data['user_token'], true));
		}

		$data['heading_title'] = $this->language->get('heading_title');

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}

		if (isset($this->request->post['image'])) {
			if (is_file(DIR_IMAGE . $this->request->post['image']))
				$carousel_image = $this->request->post['image'];
			else
				$carousel_image = 'no_image.png';
		} elseif (!empty($notification_info) && $notification_info['image']) {
			if (is_file(DIR_IMAGE . $notification_info['image']))
				$carousel_image = $notification_info['image'];
			else
				$carousel_image = 'no_image.png';
		} else {
			$carousel_image = 'no_image.png';
		}

		$data['image'] = $this->model_tool_image->resize($carousel_image, 100, 100);

		$data['image_name'] = $carousel_image;


		$data['placeholder'] = $this->model_tool_image->resize('no_image.png', 100, 100);
		$this->load->model('localisation/language');
		$data['languages'] = $this->model_localisation_language->getLanguages();


		$data['product_json'] = json_encode(array());
		$data['image_json'] = json_encode(array());


		if (isset($this->request->post['title'])) {
			$data['carousel']['title'] = $this->request->post['title'];
		} else {
			$data['carousel']['title'] = array();
		}

		
		if (isset($this->request->post['status'])) {
			$data['carousel']['status'] = $this->request->post['status'];
		} else {
			$data['carousel']['status'] = '';
		}

		if (isset($this->request->post['sort_order'])) {
			$data['carousel']['sort_order'] = $this->request->post['sort_order'];
		} else {
			$data['carousel']['sort_order'] = '';
		}
		if (isset($this->request->post['type'])) {
			$data['carousel']['type'] = $this->request->post['type'];
		}

		if (isset($this->request->post['product_type'])) {
			$data['carousel']['product_type'] = $this->request->post['product_type'];
		}
		if (isset($this->request->post['image_sub_type'])) {
			$data['carousel']['image_sub_type'] = $this->request->post['image_sub_type'];
		}

		//errors part
		if (isset($this->error['error_common'])) {
			$data['error_common'] = $this->error['error_common'];
		} else {
			$data['error_common'] = '';
		}

		if (isset($this->error['error_title'])) {
			$data['error_title'] = $this->error['error_title'];
		} else {
			$data['error_title'] = '';
		}
		if (isset($this->error['error_sort_order'])) {
			$data['error_sort_order'] = $this->error['error_sort_order'];
		} else {
			$data['error_sort_order'] = '';
		}
		
		if (isset($this->error['error_product'])) {
			$data['error_product'] = $this->error['error_product'];
		} else {
			$data['error_product'] = '';
		}
		if (isset($this->error['error_manufacturer'])) {
			$data['error_manufacturer'] = $this->error['error_manufacturer'];
		} else {
			$data['error_manufacturer'] = '';
		}
		if (isset($this->error['error_catagories'])) {
			$data['error_catagories'] = $this->error['error_catagories'];
		} else {
			$data['error_catagories'] = '';
		}
	
		$data['db_product_type'] = json_encode('');

		if (isset($this->request->post['catagories_id']) && $this->request->post['catagories_id'] && $this->request->post['type'] == 'Product') {
			foreach ($this->request->post['catagories_id'] as $cat_id) {
				$catagories[] = [
					'catagories_id' =>  $cat_id,
					'name' => $this->request->post['catagories_name'][$cat_id]
				];
			}

			$data['carousel']['catagories'] = $catagories;
		} elseif (isset($this->request->post['image_catagories_id'])  && $this->request->post['image_catagories_id'] && $this->request->post['type'] == 'Image') {
			foreach ($this->request->post['image_catagories_id'] as $category_id) {
				$image_catagories_id[] = [
					'catagories_id' =>  $category_id,
					'name' => $this->request->post['image_catagories_name'][$category_id]
				];
			}

			$data['carousel']['catagories'] = $image_catagories_id;
		} elseif (!empty($data['carousel']['catagories'])) {
			$data['carousel']['catagories'] = $data['carousel']['catagories'];
		} else {
			$data['carousel']['catagories'] = array();
		}




		if (isset($this->request->post['manufacturer_id']) && $this->request->post['manufacturer_id'] && $this->request->post['type'] == 'Product') {
			foreach ($this->request->post['manufacturer_id'] as $manuf_id) {
				$manufacturer[] = [
					'manufacturer_id' =>  $manuf_id,
					'name' => $this->request->post['manufacturer_name'][$manuf_id]
				];
			}

			$data['carousel']['manufacturer'] = $manufacturer;
		} elseif (isset($this->request->post['image_manufacturer_id']) && $this->request->post['image_manufacturer_id'] && $this->request->post['type'] == 'Image') {
			foreach ($this->request->post['image_manufacturer_id'] as $manufacture_id) {
				$image_manufacturer_id[] = [
					'manufacturer_id' =>  $manufacture_id,
					'name' => $this->request->post['image_manufacturer_name'][$manufacture_id]
				];
			}
			$data['carousel']['manufacturer'] = $image_manufacturer_id;
		} elseif (!empty($data['carousel']['manufacturer'])) {
			$data['carousel']['manufacturer'] = $data['carousel']['manufacturer'];
		} else {
			$data['carousel']['manufacturer'] = array();
		}


		$data['user_token'] = $this->session->data['user_token'];
		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/carousel_form', $data));
	}

	protected function getList()
	{

		if (isset($this->request->get['filter_title'])) {
			$filter_title = $this->request->get['filter_title'];
		} else {
			$filter_title = null;
		}

		if (isset($this->request->get['filter_type'])) {
			$filter_type = $this->request->get['filter_type'];
		} else {
			$filter_type = null;
		}

		if (isset($this->request->get['filter_status'])) {
			$filter_status = $this->request->get['filter_status'];
		} else {
			$filter_status = null;
		}

		if (isset($this->request->get['filter_sort_order'])) {
			$filter_sort_order = $this->request->get['filter_sort_order'];
		} else {
			$filter_sort_order = null;
		}


		if (isset($this->request->get['sort'])) {
			$sort = $this->request->get['sort'];
		} else {
			$sort = 'c.id';
		}

		if (isset($this->request->get['filter_id_from'])) {
			$filter_id_from = $this->request->get['filter_id_from'];
		} else {
			$filter_id_from = null;
		}
		if (isset($this->request->get['filter_id_to'])) {
			$filter_id_to = $this->request->get['filter_id_to'];
		} else {
			$filter_id_to = null;
		}
		if (isset($this->request->get['order'])) {
			$order = $this->request->get['order'];
		} else {
			$order = 'ASC';
		}

		if (isset($this->request->get['page'])) {
			$page = $this->request->get['page'];
		} else {
			$page = 1;
		}
		$data['filter_title'] = $filter_title;
		$data['filter_type'] = $filter_type;
		$data['filter_status'] = $filter_status;
		$data['filter_sort_order'] = $filter_sort_order;
		$data['filter_id_from'] = $filter_id_from;
		$data['filter_id_to'] = $filter_id_to;

		$filter_data = array(
			'filter_title'      => $filter_title,
			'filter_type'       => $filter_type,
			'filter_status'     => $filter_status,
			'filter_sort_order'     => $filter_sort_order,
			'filter_id_from'     => $filter_id_from,
			'filter_id_to'     => $filter_id_to,
			'sort'              => $sort,
			'order'             => $order,
			'start'             => ($page - 1) * $this->config->get('config_limit_admin'),
			'limit'             => $this->config->get('config_limit_admin')
		);

		$data['carousels'] = array();
		$this->load->model('mobikul/carousels');
		$carousels_total = $this->model_mobikul_carousels->getcarousels($filter_data, true);
		$carousels = $this->model_mobikul_carousels->getcarousels($filter_data);


		if ($carousels) {
			foreach ($carousels as $key => $value) {

				$data['carousels'][] = array(
					"id" => $value['id'],
					"title" => $value['title'],
					"type" => $value['type'],
					"status" => $value['status'],
					"sort_order" => $value['sort_order'],
					"edit" => $this->url->link('mobikul/carousels/edit&carousel_id=' . $value['id'], 'user_token=' . $this->session->data['user_token'], 'SSL')

				);
			}
		}

		$url = '';

		if (isset($this->request->get['filter_title'])) {
			$url .= '&filter_title=' . urlencode(html_entity_decode($this->request->get['filter_title'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}

		if (isset($this->request->get['filter_id_from'])) {
			$url .= '&filter_id_from=' . $this->request->get['filter_id_from'];
		}

		if (isset($this->request->get['filter_id_to'])) {
			$url .= '&filter_id_to=' . $this->request->get['filter_id_to'];
		}

		if (isset($this->request->get['filter_type'])) {
			$url .= '&filter_type=' . $this->request->get['filter_type'];
		}

		if (isset($this->request->get['filter_sort_order'])) {
			$url .= '&filter_sort_order=' . $this->request->get['filter_sort_order'];
		}


		if ($order == 'ASC') {
			$url .= '&order=DESC';
		} else {
			$url .= '&order=ASC';
		}

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}

		$data['sort_id'] = $this->url->link('mobikul/carousels', 'user_token=' . $this->session->data['user_token'] . $url . '&sort=c.id', true);
		$data['sort_title'] = $this->url->link('mobikul/carousels', 'user_token=' . $this->session->data['user_token'] . $url . '&sort=cd.title', true);
		$data['sort_type'] = $this->url->link('mobikul/carousels', 'user_token=' . $this->session->data['user_token'] . $url . '&sort=c.type', true);
		$data['sort_status'] = $this->url->link('mobikul/carousels', 'user_token=' . $this->session->data['user_token'] . $url . '&sort=c.status', true);
		$data['sort_order'] = $this->url->link('mobikul/carousels', 'user_token=' . $this->session->data['user_token'] . $url . '&sort=c.sort_order', true);

		$url = '';

		if (isset($this->request->get['filter_title'])) {
			$url .= '&filter_title=' . urlencode(html_entity_decode($this->request->get['filter_title'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}

		if (isset($this->request->get['filter_id_from'])) {
			$url .= '&filter_id_from=' . $this->request->get['filter_id_from'];
		}

		if (isset($this->request->get['filter_id_to'])) {
			$url .= '&filter_id_to=' . $this->request->get['filter_id_to'];
		}

		if (isset($this->request->get['filter_type'])) {
			$url .= '&filter_type=' . $this->request->get['filter_type'];
		}

		if (isset($this->request->get['filter_sort_order'])) {
			$url .= '&filter_sort_order=' . $this->request->get['filter_sort_order'];
		}

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}

		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}



		$pagination = new Pagination();
		$pagination->total = $carousels_total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_limit_admin');
		$pagination->url = $this->url->link('mobikul/carousels', 'user_token=' . $this->session->data['user_token'] . $url . '&page={page}', 'SSL');

		$data['pagination'] = $pagination->render();

		$data['results'] = sprintf($this->language->get('text_pagination'), ($carousels_total) ? (($page - 1) * $this->config->get('config_limit_admin')) + 1 : 0, ((($page - 1) * $this->config->get('config_limit_admin')) > ($carousels_total - $this->config->get('config_limit_admin'))) ? $carousels_total : ((($page - 1) * $this->config->get('config_limit_admin')) + $this->config->get('config_limit_admin')), $carousels_total, ceil($carousels_total / $this->config->get('config_limit_admin')));

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}

		$data['user_token'] = $this->session->data['user_token'];
		$data['add'] = $this->url->link('mobikul/carousels/add', 'user_token=' . $this->session->data['user_token'], true);
		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/carousel_list', $data));
	}

	public function edit()
	{

		$this->load->language('catalog/product');
		$this->load->language('mobikul/carousels');
		$this->document->setTitle($this->language->get('heading_title'));
		$this->load->model('mobikul/carousels');
		$this->load->model('setting/setting');

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {

			$this->load->model('mobikul/carousels');

			if (isset($this->request->get['carousel_id']) && $this->request->get['carousel_id']) {
				$this->request->post['carousel_id'] = $this->request->get['carousel_id'];
			}

			$this->model_mobikul_carousels->addCarouselsById($this->request->post);
			$this->response->redirect($this->url->link('mobikul/carousels', 'user_token=' . $this->session->data['user_token'], true));
		}

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], 'SSL'),
		);

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('mobikul/carousels', 'user_token=' . $this->session->data['user_token'], 'SSL'),
		);

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('heading_title_edit'),
			'href'      => $this->url->link('mobikul/carousels/edit', 'user_token=' . $this->session->data['user_token'], 'SSL'),
		);

		if (isset($this->request->get['carousel_id'])) {
			$data['collection_heading'] = $this->language->get('text_add');
			$carousel_id = $this->request->get['carousel_id'];
		} else {
			$data['collection_heading'] = $this->language->get('text_edit');
			$carousel_id = '';
		}

		$json_product = array();
		$json_image = array();
		$data['carousel'] = $this->model_mobikul_carousels->getcarouselsById($carousel_id);
		$data['db_product_type'] = json_encode($data['carousel']['product_type']);


		if (isset($this->request->post['catagories_id']) && $this->request->post['catagories_id'] && $this->request->post['type'] == 'Product') {
			foreach ($this->request->post['catagories_id'] as $cat_id) {
				$catagories[] = [
					'catagories_id' =>  $cat_id,
					'name' => $this->request->post['catagories_name'][$cat_id]
				];
			}

			$data['carousel']['catagories'] = $catagories;
		} elseif (isset($this->request->post['image_catagories_id'])  && $this->request->post['image_catagories_id'] && $this->request->post['type'] == 'Image') {
			foreach ($this->request->post['image_catagories_id'] as $category_id) {
				$image_catagories_id[] = [
					'catagories_id' =>  $category_id,
					'name' => $this->request->post['image_catagories_name'][$category_id]
				];
			}

			$data['carousel']['catagories'] = $image_catagories_id;
		} elseif (!empty($data['carousel']['catagories'])) {
			$data['carousel']['catagories'] = $data['carousel']['catagories'];
		} else {
			$data['carousel']['catagories'] = array();
		}




		if (isset($this->request->post['manufacturer_id']) && $this->request->post['manufacturer_id'] && $this->request->post['type'] == 'Product') {
			foreach ($this->request->post['manufacturer_id'] as $manuf_id) {
				$manufacturer[] = [
					'manufacturer_id' =>  $manuf_id,
					'name' => $this->request->post['manufacturer_name'][$manuf_id]
				];
			}

			$data['carousel']['manufacturer'] = $manufacturer;
		} elseif (isset($this->request->post['image_manufacturer_id']) && $this->request->post['image_manufacturer_id'] && $this->request->post['type'] == 'Image') {
			foreach ($this->request->post['image_manufacturer_id'] as $manufacture_id) {
				$image_manufacturer_id[] = [
					'manufacturer_id' =>  $manufacture_id,
					'name' => $this->request->post['image_manufacturer_name'][$manufacture_id]
				];
			}
			$data['carousel']['manufacturer'] = $image_manufacturer_id;
		} elseif (!empty($data['carousel']['manufacturer'])) {
			$data['carousel']['manufacturer'] = $data['carousel']['manufacturer'];
		} else {
			$data['carousel']['manufacturer'] = array();
		}


		if (isset($this->request->post['title'])) {
			$data['carousel']['title'] = $this->request->post['title'];
		} elseif (!empty($data['carousel'])) {
			$data['carousel']['title'] = $data['carousel']['title'];
		} else {
			$data['carousel']['title'] = array();
		}

	

		if (isset($this->request->post['status'])) {
			$data['carousel']['status'] = $this->request->post['status'];
		} elseif (!empty($data['carousel'])) {
			$data['carousel']['status'] = $data['carousel']['status'];
		} else {
			$data['carousel']['status'] = '';
		}

		if (isset($this->request->post['sort_order'])) {
			$data['carousel']['sort_order'] = $this->request->post['sort_order'];
		} elseif (!empty($data['carousel'])) {
			$data['carousel']['sort_order'] = $data['carousel']['sort_order'];
		} else {
			$data['carousel']['sort_order'] = '';
		}
		if (isset($this->request->post['type'])) {
			$data['carousel']['type'] = $this->request->post['type'];
		} elseif (!empty($data['carousel'])) {
			$data['carousel']['type'] = $data['carousel']['type'];
		}


		if (isset($this->request->post['product_type'])) {
			$data['carousel']['product_type'] = $this->request->post['product_type'];
		} elseif (!empty($data['carousel'])) {
			$data['carousel']['product_type'] = $data['carousel']['product_type'];
		}


		if (isset($data['carousel']['products']) && $data['carousel']['products']) {
			foreach ($data['carousel']['products'] as $product) {
				$json_product[] =  $product['product_id'];
			}
		}
		
		if (isset($this->request->post['image_sub_type'])) {
			$data['carousel']['image_sub_type'] = $this->request->post['image_sub_type'];
		}
		$data['product_json'] = json_encode($json_product);
		$data['image_json'] = json_encode($json_image);

		$this->load->model('localisation/language');
		$data['languages'] = $this->model_localisation_language->getLanguages();

		if (isset($this->error['error_permission'])) {
			$data['error_warning'] = $this->error['error_permission'];
		} else {
			$data['error_warning'] = '';
		}
		if (isset($this->error['error_common'])) {
			$data['error_common'] = $this->error['error_common'];
		} else {
			$data['error_common'] = '';
		}
		if (isset($this->error['error_product'])) {
			$data['error_product'] = $this->error['error_product'];
		} else {
			$data['error_product'] = '';
		}
		if (isset($this->error['error_title'])) {
			$data['error_title'] = $this->error['error_title'];
		} else {
			$data['error_title'] = '';
		}
		if (isset($this->error['error_sort_order'])) {
			$data['error_sort_order'] = $this->error['error_sort_order'];
		} else {
			$data['error_sort_order'] = '';
		}
		
		if (isset($this->error['error_product'])) {
			$data['error_product'] = $this->error['error_product'];
		} else {
			$data['error_product'] = '';
		}
		if (isset($this->error['error_manufacturer'])) {
			$data['error_manufacturer'] = $this->error['error_manufacturer'];
		} else {
			$data['error_manufacturer'] = '';
		}
		if (isset($this->error['error_catagories'])) {
			$data['error_catagories'] = $this->error['error_catagories'];
		} else {
			$data['error_catagories'] = '';
		}
	
		if (isset($this->error['error_manufacturer'])) {
			$data['error_manufacturer'] = $this->error['error_manufacturer'];
		} else {
			$data['error_manufacturer'] = '';
		}
		if (isset($this->error['error_catagories'])) {
			$data['error_catagories'] = $this->error['error_catagories'];
		} else {
			$data['error_catagories'] = '';
		}
		$data['action'] = $this->url->link('mobikul/carousels/edit&carousel_id=' . $carousel_id, 'user_token=' . $this->session->data['user_token'], 'SSL');

		$data['cancel'] = $this->url->link('mobikul/carousels', 'user_token=' . $this->session->data['user_token'], 'SSL');

		$data['user_token'] = $this->session->data['user_token'];

		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/carousel_form', $data));
	}

	public function getAllProduct()
	{
		$data = array();
		$this->load->model('catalog/product');
		$this->load->model('mobikul/carousels');
		$data['products'] = array();
		if (isset($this->request->get['product_type'])) {
			$product_type = $this->request->get['product_type'];
		} else {
			$product_type = null;
		}
		if (isset($this->request->get['filter_name'])) {
			$filter_name = $this->request->get['filter_name'];
		} else {
			$filter_name = null;
		}

		if (isset($this->request->get['filter_model'])) {
			$filter_model = $this->request->get['filter_model'];
		} else {
			$filter_model = null;
		}

		if (isset($this->request->get['filter_price'])) {
			$filter_price = $this->request->get['filter_price'];
		} else {
			$filter_price = null;
		}

		if (isset($this->request->get['filter_quantity'])) {
			$filter_quantity = $this->request->get['filter_quantity'];
		} else {
			$filter_quantity = null;
		}

		if (isset($this->request->get['filter_status'])) {
			$filter_status = $this->request->get['filter_status'];
		} else {
			$filter_status = null;
		}

		if (isset($this->request->get['sort'])) {
			$sort = $this->request->get['sort'];
		} else {
			$sort = '';
		}

		if (isset($this->request->get['order'])) {
			$order = $this->request->get['order'];
		} else {
			$order = '';
		}

		if (isset($this->request->get['page'])) {
			$page = $this->request->get['page'];
		} else {
			$page = 1;
		}
		$filter_data = array(
			'filter_name'	  => $filter_name,
			'filter_model'	  => $filter_model,
			'filter_price'	  => $filter_price,
			'filter_quantity' => $filter_quantity,
			'filter_status'   => $filter_status,
			'sort'            => $sort,
			'order'           => $order,
			'start'           => ($page - 1) * $this->config->get('config_limit_admin'),
			'limit'           => $this->config->get('config_limit_admin')
		);

		$this->load->model('tool/image');

		if (isset($this->request->get['product_type']) && $this->request->get['product_type'] == 'random_product') {
			$product_total = $this->model_catalog_product->getTotalProducts($filter_data);
			$results = $this->model_catalog_product->getProducts($filter_data);
		} else if (isset($this->request->get['product_type']) && $this->request->get['product_type'] == 'popular') {
			$product_total = $this->model_mobikul_carousels->getPopularProduct($filter_data, true);
			$results = $this->model_mobikul_carousels->getPopularProduct($filter_data);
		} else if (isset($this->request->get['product_type']) && $this->request->get['product_type'] == 'best') {
			$product_total = $this->model_mobikul_carousels->getBestProduct($filter_data, true);
			$results = $this->model_mobikul_carousels->getBestProduct($filter_data);
		} else if (isset($this->request->get['product_type']) && $this->request->get['product_type'] == 'latest') {
			$product_total = $this->model_mobikul_carousels->getLatestProduct($filter_data, true);
			$results = $this->model_mobikul_carousels->getLatestProduct($filter_data);
		} else if (isset($this->request->get['product_type']) && ($this->request->get['product_type'] == 'manufacturer_products'  || $this->request->get['product_type'] == 'manufacturer')) {
			if (!isset($this->request->get['manufacturer_id']) || !$this->request->get['manufacturer_id']) {
				$this->request->get['manufacturer_id'] = array(0);
			}
			$filter_data['manufacturer_id'] = $this->request->get['manufacturer_id'];
			$product_total = $this->model_mobikul_carousels->getManufacturerProduct($filter_data, true);
			$results = $this->model_mobikul_carousels->getManufacturerProduct($filter_data);
		} else if (isset($this->request->get['product_type']) && ($this->request->get['product_type'] == 'catagories'  || $this->request->get['product_type'] == 'catagory_products')) {

			if (!isset($this->request->get['catagory_id']) || !$this->request->get['catagory_id']) {
				$this->request->get['catagory_id'] = array();
			}

			$filter_data['catagory_id'] = $this->request->get['catagory_id'];
			$product_total = $this->model_mobikul_carousels->getCatagoriesProduct($filter_data, true);
			$results = $this->model_mobikul_carousels->getCatagoriesProduct($filter_data);
		}



		foreach ($results as $result) {
			if (is_file(DIR_IMAGE . $result['image'])) {
				$image = $this->model_tool_image->resize($result['image'], 40, 40);
			} else {
				$image = $this->model_tool_image->resize('no_image.png', 40, 40);
			}

			$special = false;

			$product_specials = $this->model_catalog_product->getProductSpecials($result['product_id']);

			foreach ($product_specials  as $product_special) {
				if (($product_special['date_start'] == '0000-00-00' || strtotime($product_special['date_start']) < time()) && ($product_special['date_end'] == '0000-00-00' || strtotime($product_special['date_end']) > time())) {
					$special = $this->currency->format($product_special['price'], $this->config->get('config_currency'));

					break;
				}
			}

			$data['products'][] = array(
				'product_id' => $result['product_id'],
				'image'      => $image,
				'name'       => $result['name'],
				'model'      => $result['model'],
				'price'      => $this->currency->format($result['price'], $this->config->get('config_currency')),
				'special'    => $special,
				'quantity'   => $result['quantity'],
				'status'     => $result['status'] ? $this->language->get('text_enabled') : $this->language->get('text_disabled'),

			);
		}


		$url = '';

		if (isset($this->request->get['product_type'])) {
			$url .= '&product_type=' . urlencode(html_entity_decode($this->request->get['product_type'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_name'])) {
			$url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_model'])) {
			$url .= '&filter_model=' . urlencode(html_entity_decode($this->request->get['filter_model'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_price'])) {
			$url .= '&filter_price=' . $this->request->get['filter_price'];
		}

		if (isset($this->request->get['filter_quantity'])) {
			$url .= '&filter_quantity=' . $this->request->get['filter_quantity'];
		}

		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}

		if ($order == 'ASC') {
			$url .= '&order=DESC';
		} else {
			$url .= '&order=ASC';
		}

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}

		$data['sort_name'] = $this->url->link('mobikul/carousels/getAllProduct', 'user_token=' . $this->session->data['user_token'] . '&sort=pd.name' . $url, true);
		$data['sort_model'] = $this->url->link('mobikul/carousels/getAllProduct', 'user_token=' . $this->session->data['user_token'] . '&sort=p.model' . $url, true);
		$data['sort_price'] = $this->url->link('mobikul/carousels/getAllProduct', 'user_token=' . $this->session->data['user_token'] . '&sort=p.price' . $url, true);
		$data['sort_quantity'] = $this->url->link('mobikul/carousels/getAllProduct', 'user_token=' . $this->session->data['user_token'] . '&sort=p.quantity' . $url, true);
		$data['sort_status'] = $this->url->link('mobikul/carousels/getAllProduct', 'user_token=' . $this->session->data['user_token'] . '&sort=p.status' . $url, true);
		$data['sort_order'] = $this->url->link('mobikul/carousels/getAllProduct', 'user_token=' . $this->session->data['user_token'] . '&sort=p.sort_order' . $url, true);


		$url = '';

		if (isset($this->request->get['product_type'])) {
			$url .= '&product_type=' . urlencode(html_entity_decode($this->request->get['product_type'], ENT_QUOTES, 'UTF-8'));
		}


		if (isset($this->request->get['filter_name'])) {
			$url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_model'])) {
			$url .= '&filter_model=' . urlencode(html_entity_decode($this->request->get['filter_model'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_price'])) {
			$url .= '&filter_price=' . $this->request->get['filter_price'];
		}

		if (isset($this->request->get['filter_quantity'])) {
			$url .= '&filter_quantity=' . $this->request->get['filter_quantity'];
		}

		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}

		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}

		$pagination = new Pagination();
		$pagination->total = $product_total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_limit_admin');
		$pagination->url = $this->url->link('mobikul/carousels/getAllProduct', 'user_token=' . $this->session->data['user_token'] . $url . '&page={page}', true);

		$data['product_pagination'] = $pagination->render();
		$data['text_no_results']  = 'No record';
		$data['product_results'] = sprintf($this->language->get('text_pagination'), ($product_total) ? (($page - 1) * $this->config->get('config_limit_admin')) + 1 : 0, ((($page - 1) * $this->config->get('config_limit_admin')) > ($product_total - $this->config->get('config_limit_admin'))) ? $product_total : ((($page - 1) * $this->config->get('config_limit_admin')) + $this->config->get('config_limit_admin')), $product_total, ceil($product_total / $this->config->get('config_limit_admin')));
		$data['sort'] = $sort;
		$data['order'] = $order;
		$data['filter_name'] = $filter_name;
		$data['filter_model'] = $filter_model;
		$data['filter_price'] = $filter_price;
		$data['filter_quantity'] = $filter_quantity;
		$data['filter_status'] = $filter_status;

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($data));
	}

	public function getAllImage()
	{

		$this->load->model('tool/image');
		$this->load->language('mobikul/carousels');
		$image_filter_data = array();
		if (isset($this->request->get['filter_carousel_image_id_from'])) {
			$filter_carousel_image_id_from = $this->request->get['filter_carousel_image_id_from'];
		} else {
			$filter_carousel_image_id_from = null;
		}

		if (isset($this->request->get['filter_carousel_image_id_to'])) {
			$filter_carousel_image_id_to = $this->request->get['filter_carousel_image_id_to'];
		} else {
			$filter_carousel_image_id_to = null;
		}

		if (isset($this->request->get['filter_carousel_image_title'])) {
			$filter_carousel_image_title = $this->request->get['filter_carousel_image_title'];
		} else {
			$filter_carousel_image_title = null;
		}

		if (isset($this->request->get['filter_carousel_image_status'])) {
			$filter_carousel_image_status = $this->request->get['filter_carousel_image_status'];
		} else {
			$filter_carousel_image_status = null;
		}
		if (isset($this->request->get['sort'])) {
			$sort = $this->request->get['sort'];
		} else {
			$sort = null;
		}

		if (isset($this->request->get['order'])) {
			$order = $this->request->get['order'];
		} else {
			$order = '';
		}

		if (isset($this->request->get['page'])) {
			$page = $this->request->get['page'];
		} else {
			$page = 1;
		}

		$image_filter_data = array(
			'filter_carousel_image_id_from'	  => $filter_carousel_image_id_from,
			'filter_carousel_image_id_to'	  => $filter_carousel_image_id_to,
			'filter_carousel_image_title'	  => $filter_carousel_image_title,
			'filter_carousel_image_status' => $filter_carousel_image_status,
			'sort'            => $sort,
			'order'           => $order,
			'start'           => ($page - 1) * $this->config->get('config_limit_admin'),
			'limit'           => $this->config->get('config_limit_admin')
		);

		$data['carousels_images'] = array();
		$this->load->model('mobikul/carousels');
		$carousels_images_total = $this->model_mobikul_carousels->getcarouselImage($image_filter_data, true);
		$carousels_images = $this->model_mobikul_carousels->getcarouselImage($image_filter_data);

		if ($carousels_images) {
			foreach ($carousels_images as $key => $value) {
				if (isset($value['image'])) {
					if (is_file(DIR_IMAGE . $value['image']))
						$image_section_image = $value['image'];
					else
						$image_section_image = 'no_image.png';
				} else {
					$image_section_image = 'no_image.png';
				}
				$data['carousels_images'][] = array(
					'id' => $value['id'],
					'title' => $value['title'],
					'status' => ($value['status'] == 1) ? $this->language->get('text_enabled') : $this->language->get('text_disabled'),
					'image' =>  $this->model_tool_image->resize($image_section_image, 100, 100),
				);
			}
		}

		$url = '';

		if (isset($this->request->get['filter_carousel_image_id_from'])) {
			$url .= '&filter_carousel_image_id_from=' . urlencode(html_entity_decode($this->request->get['filter_carousel_image_id_from'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_carousel_image_id_to'])) {
			$url .= '&filter_carousel_image_id_to=' . urlencode(html_entity_decode($this->request->get['filter_carousel_image_id_to'], ENT_QUOTES, 'UTF-8'));
		}


		if (isset($this->request->get['filter_carousel_image_title'])) {
			$url .= '&filter_carousel_image_title=' . $this->request->get['filter_carousel_image_title'];
		}

		if (isset($this->request->get['filter_carousel_image_status'])) {
			$url .= '&filter_carousel_image_status=' . $this->request->get['filter_carousel_image_status'];
		}

		if ($order == 'ASC') {
			$url .= '&order=DESC';
		} else {
			$url .= '&order=ASC';
		}

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}

		$data['carousel_image_sort_id'] = $this->url->link('mobikul/carousels/getAllImage', 'user_token=' . $this->session->data['user_token'] . $url . '&sort=ci.id', true);
		$data['carousel_image_title'] = $this->url->link('mobikul/carousels/getAllImage', 'user_token=' . $this->session->data['user_token'] . $url . '&sort=cid.title', true);
		$data['carousel_image_status'] = $this->url->link('mobikul/carousels/getAllImage', 'user_token=' . $this->session->data['user_token'] . $url . '&sort=ci.status', true);

		$url = '';

		if (isset($this->request->get['filter_carousel_image_id_from'])) {
			$url .= '&filter_carousel_image_id_from=' . urlencode(html_entity_decode($this->request->get['filter_carousel_image_id_from'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_carousel_image_id_to'])) {
			$url .= '&filter_carousel_image_id_to=' . urlencode(html_entity_decode($this->request->get['filter_carousel_image_id_to'], ENT_QUOTES, 'UTF-8'));
		}


		if (isset($this->request->get['filter_carousel_image_title'])) {
			$url .= '&filter_carousel_image_title=' . $this->request->get['filter_carousel_image_title'];
		}

		if (isset($this->request->get['filter_carousel_image_status'])) {
			$url .= '&filter_carousel_image_status=' . $this->request->get['filter_carousel_image_status'];
		}

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}

		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}
		$data['filter_carousel_image_id_from'] = $filter_carousel_image_id_from;
		$data['filter_carousel_image_id_to'] = $filter_carousel_image_id_to;
		$data['filter_carousel_image_title'] = $filter_carousel_image_title;
		$data['filter_carousel_image_status'] = $filter_carousel_image_status;
		$data['sort'] = $sort;
		$data['order'] = $order;
		$pagination = new Pagination();
		$pagination->total = $carousels_images_total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_limit_admin');
		$pagination->url = $this->url->link('mobikul/carousels/getAllImage', 'user_token=' . $this->session->data['user_token'] . $url . '&page={page}', true);

		$data['carousels_image_pagination'] = $pagination->render();

		$data['carousels_image_results'] = sprintf($this->language->get('text_pagination'), ($carousels_images_total) ? (($page - 1) * $this->config->get('config_limit_admin')) + 1 : 0, ((($page - 1) * $this->config->get('config_limit_admin')) > ($carousels_images_total - $this->config->get('config_limit_admin'))) ? $carousels_images_total : ((($page - 1) * $this->config->get('config_limit_admin')) + $this->config->get('config_limit_admin')), $carousels_images_total, ceil($carousels_images_total / $this->config->get('config_limit_admin')));
		$data['text_no_results']  = 'No record';

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($data));
	}



	public function delete()
	{

		$json['success'] = '';

		$this->load->model('mobikul/carousels');

		$this->language->load('mobikul/carousels');

		if (isset($this->request->post['post_id']) && $this->request->post['post_id']) {

			foreach ($this->request->post['post_id'] as $id) {
				$this->model_mobikul_carousels->deleteCarousel($id);
			}
			$this->session->data['success'] = $this->language->get('text_success_delete');
			$json['success'] = $this->language->get('text_success_delete');
		}


		$this->response->setOutput(json_encode($json));
	}

	protected function validate()
	{

		if (!$this->user->hasPermission('modify', 'mobikul/carousels')) {
			$this->error['error_permission'] = $this->language->get('error_permission');
		} else {

			if (isset($this->request->post['title'])) {
				foreach ($this->request->post['title'] as $language_id => $title) {
					if ((utf8_strlen($title) < 2) || (utf8_strlen($title) > 64) || empty($title) || ctype_space($title)) {
						$this->error['error_title'][$language_id] = $this->language->get('error_title');
					}
				}
			} else {
				$this->error['error_title'] = $this->language->get('error_title');
			}

			if (isset($this->request->post['color_code']) || (isset($this->request->post['description']) && $this->request->post['description'])) {
				if ((strlen($this->request->post['color_code']) < 4) ||  (strlen($this->request->post['color_code']) > 7)) {
					$this->error['error_color_code'] = $this->language->get('error_color_code');
				}

				if (!(strpos($this->request->post['color_code'], "#") !== false)) {
					$this->error['error_color_code'] = $this->language->get('error_color_code');
				}
			}

			if (!isset($this->request->post['sort_order']) || !$this->request->post['sort_order'] || !is_numeric($this->request->post['sort_order'])) {
				$this->error['error_sort_order'] = $this->language->get('error_sort_order');
			}


			if (isset($this->request->post['type']) && $this->request->post['type']) {

				if ($this->request->post['type'] == 'Product') {

					if (isset($this->request->post['product_type']) &&  ($this->request->post['product_type'] == 'random_product'  ||  $this->request->post['product_type'] == 'manufacturer_products' ||  $this->request->post['product_type'] == 'catagory_products')) {

						if (isset($this->request->post['saved_product_ids']) && $this->request->post['saved_product_ids']) {
							$this->request->post['saved_product_ids'] = stripslashes(html_entity_decode($this->request->post['saved_product_ids']));
							$this->request->post['saved_product_ids'] = json_decode($this->request->post['saved_product_ids'], true);

							if (!$this->request->post['saved_product_ids'] || empty($this->request->post['saved_product_ids']) || !is_array($this->request->post['saved_product_ids'])) {
								$this->error['error_product'] = $this->language->get('error_product');
							}
						} else {
							$this->error['error_product'] = $this->language->get('error_product');
						}
					}

					if (isset($this->request->post['product_type']) && ($this->request->post['product_type'] == 'manufacturer' ||  $this->request->post['product_type'] == 'manufacturer_products')) {
						if (!isset($this->request->post['manufacturer_id']) || !$this->request->post['manufacturer_id']) {
							$this->error['error_manufacturer'] = $this->language->get('error_manufacturer');
						}
					}

					if (isset($this->request->post['product_type']) && ($this->request->post['product_type'] == 'catagories' ||  $this->request->post['product_type'] == 'catagory_products')) {
						if (!isset($this->request->post['catagories_id']) || !$this->request->post['catagories_id']) {
							$this->error['error_catagories'] = $this->language->get('error_catagories');
						}
					}
				} else if ($this->request->post['type'] == 'Image' &&  $this->request->post['image_sub_type'] == 'image_carousel') {


					if (isset($this->request->post['saved_image_ids']) && $this->request->post['saved_image_ids']) {
						$this->request->post['saved_image_ids'] = stripslashes(html_entity_decode($this->request->post['saved_image_ids']));
						$this->request->post['saved_image_ids'] = json_decode($this->request->post['saved_image_ids'], true);

						if (!$this->request->post['saved_image_ids'] || empty($this->request->post['saved_image_ids']) || !is_array($this->request->post['saved_image_ids'])) {
							$this->error['error_image'] = $this->language->get('error_image');
						}
					}
				} else if ($this->request->post['type'] == 'Image' &&  $this->request->post['image_sub_type'] == 'image_manufacturer') {

					if (!isset($this->request->post['image_manufacturer_id']) || !$this->request->post['image_manufacturer_id']) {
						$this->error['error_manufacturer'] = $this->language->get('error_manufacturer');
					}
				} else if ($this->request->post['type'] == 'Image' &&  $this->request->post['image_sub_type'] == 'image_catagory') {

					if (!isset($this->request->post['image_catagories_id']) || !$this->request->post['image_catagories_id']) {
						$this->error['error_catagories'] = $this->language->get('error_catagories');
					}
				}
			}
		}

		if (!$this->error) {
			return true;
		} else {
			if (!isset($this->error['error_permission']) || !$this->error['error_permission']) {
				$this->error['error_common'] = $this->language->get('error_common');
			}
			return false;
		}
	}
}
