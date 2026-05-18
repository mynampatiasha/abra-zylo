<?php
if (file_exists(DIR_APPLICATION . '../vendor/autoload.php')){
    require DIR_SYSTEM . '../vendor/autoload.php';
}

class ControllerMobikulNotification extends Controller
{
	private $error = array();

	public function index()
	{
		$this->load->language('mobikul/notification');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('mobikul/notification');

		$this->getList();
	}

	public function add()
	{
		$lang_array = $this->load->language('mobikul/notification');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('mobikul/notification');

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {

			if ($this->request->post['type'] == 4) {
				$this->request->post['id'] = $this->request->post['input-custom_id'];
				$this->request->post['product_category'] = $this->model_mobikul_notification->getCustomCollectionName($this->request->post['input-custom_id']);
			}

			$notification_id = $this->model_mobikul_notification->addNotification($this->request->post);

			$this->session->data['success'] = $this->language->get('text_success');

			if (isset($this->request->post['send'])) {
				$this->sendNotification($notification_id);
				$this->session->data['success'] = $this->language->get('text_send_success');
			}

			$url = '';

			if (isset($this->request->get['filter_title'])) {
				$url .= '&filter_title=' . urlencode(html_entity_decode($this->request->get['filter_title'], ENT_QUOTES, 'UTF-8'));
			}

			if (isset($this->request->get['filter_type'])) {
				$url .= '&filter_type=' . $this->request->get['filter_type'];
			}

			if (isset($this->request->get['filter_status'])) {
				$url .= '&filter_status=' . $this->request->get['filter_status'];
			}

			if (isset($this->request->get['filter_date_added'])) {
				$url .= '&filter_date_added=' . $this->request->get['filter_date_added'];
			}

			if (isset($this->request->get['sort'])) {
				$url .= '&sort=' . $this->request->get['sort'];
			}

			if (isset($this->request->get['order'])) {
				$url .= '&order=' . $this->request->get['order'];
			}

			if (isset($this->request->get['page'])) {
				$url .= '&page=' . $this->request->get['page'];
			}

			$this->response->redirect($this->url->link('mobikul/notification', 'user_token=' . $this->session->data['user_token'] . $url, true));
		}

		$this->getForm();
	}

	public function edit()
	{
		$lang_array = $this->load->language('mobikul/notification');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('mobikul/notification');

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {

			if ($this->request->post['type'] == 4) {
				$this->request->post['id'] = $this->request->post['input-custom_id'];
				$this->request->post['product_category'] = $this->model_mobikul_notification->getCustomCollectionName($this->request->post['input-custom_id']);
			}

			$this->model_mobikul_notification->editNotification($this->request->get['notification_id'], $this->request->post);

			$this->session->data['success'] = $this->language->get('text_success');

			if (isset($this->request->post['send'])) {
				$this->sendNotification($this->request->get['notification_id']);
				$this->session->data['success'] = $this->language->get('text_send_success');
			}

			$url = '';

			if (isset($this->request->get['filter_title'])) {
				$url .= '&filter_title=' . urlencode(html_entity_decode($this->request->get['filter_title'], ENT_QUOTES, 'UTF-8'));
			}

			if (isset($this->request->get['filter_type'])) {
				$url .= '&filter_type=' . $this->request->get['filter_type'];
			}

			if (isset($this->request->get['filter_status'])) {
				$url .= '&filter_status=' . $this->request->get['filter_status'];
			}

			if (isset($this->request->get['filter_date_added'])) {
				$url .= '&filter_date_added=' . $this->request->get['filter_date_added'];
			}

			if (isset($this->request->get['sort'])) {
				$url .= '&sort=' . $this->request->get['sort'];
			}

			if (isset($this->request->get['order'])) {
				$url .= '&order=' . $this->request->get['order'];
			}

			if (isset($this->request->get['page'])) {
				$url .= '&page=' . $this->request->get['page'];
			}

			$this->response->redirect($this->url->link('mobikul/notification', 'user_token=' . $this->session->data['user_token'] . $url, true));
		}

		$this->getForm();
	}

	public function delete()
	{
		$lang_array = $this->load->language('mobikul/notification');

		foreach ($lang_array as $key => $value) {
			$data[$key] = $value;
		}

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('mobikul/notification');

		if (isset($this->request->post['selected']) && $this->validateDelete()) {
			foreach ($this->request->post['selected'] as $notification_id) {
				$this->model_mobikul_notification->deleteNotification($notification_id);
			}

			$this->session->data['success'] = $this->language->get('text_success');

			$url = '';

			if (isset($this->request->get['filter_title'])) {
				$url .= '&filter_title=' . urlencode(html_entity_decode($this->request->get['filter_title'], ENT_QUOTES, 'UTF-8'));
			}

			if (isset($this->request->get['filter_type'])) {
				$url .= '&filter_type=' . $this->request->get['filter_type'];
			}

			if (isset($this->request->get['filter_status'])) {
				$url .= '&filter_status=' . $this->request->get['filter_status'];
			}

			if (isset($this->request->get['filter_date_added'])) {
				$url .= '&filter_date_added=' . $this->request->get['filter_date_added'];
			}

			if (isset($this->request->get['sort'])) {
				$url .= '&sort=' . $this->request->get['sort'];
			}

			if (isset($this->request->get['order'])) {
				$url .= '&order=' . $this->request->get['order'];
			}

			if (isset($this->request->get['page'])) {
				$url .= '&page=' . $this->request->get['page'];
			}

			$this->response->redirect($this->url->link('mobikul/notification', 'user_token=' . $this->session->data['user_token'] . $url, true));
		}

		$this->getList();
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

		if (isset($this->request->get['filter_date_added'])) {
			$filter_date_added = $this->request->get['filter_date_added'];
		} else {
			$filter_date_added = null;
		}

		if (isset($this->request->get['sort'])) {
			$sort = $this->request->get['sort'];
		} else {
			$sort = 'mnd.title';
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

		$url = '';

		if (isset($this->request->get['filter_title'])) {
			$url .= '&filter_title=' . urlencode(html_entity_decode($this->request->get['filter_title'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_type'])) {
			$url .= '&filter_type=' . $this->request->get['filter_type'];
		}

		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}

		if (isset($this->request->get['filter_date_added'])) {
			$url .= '&filter_date_added=' . $this->request->get['filter_date_added'];
		}

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}

		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], true)
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('heading_title'),
			'href' => $this->url->link('mobikul/notification', 'user_token=' . $this->session->data['user_token'] . $url, true)
		);

		$data['send'] = $this->url->link('mobikul/notification/send', 'user_token=' . $this->session->data['user_token'] . $url, true);
		$data['add'] = $this->url->link('mobikul/notification/add', 'user_token=' . $this->session->data['user_token'] . $url, true);
		$data['delete'] = $this->url->link('mobikul/notification/delete', 'user_token=' . $this->session->data['user_token'] . $url, true);

		$data['notifications'] = array();

		$filter_data = array(
			'filter_title'      => $filter_title,
			'filter_type'       => $filter_type,
			'filter_status'     => $filter_status,
			'filter_date_added' => $filter_date_added,
			'sort'              => $sort,
			'order'             => $order,
			'start'             => ($page - 1) * $this->config->get('config_limit_admin'),
			'limit'             => $this->config->get('config_limit_admin')
		);

		$notification_total = $this->model_mobikul_notification->getTotalNotifications($filter_data);

		$results = $this->model_mobikul_notification->getNotifications($filter_data);

		$this->load->model('tool/image');

		foreach ($results as $result) {
			if (is_file(DIR_IMAGE . $result['image'])) {
				$image = $result['image'];
			} else {
				$image = 'no_image.jpg';
			}
			$data['notifications'][] = array(
				'notification_id' => $result['notification_id'],
				'title'        => $result['title'],
				'type'         => $result['type'],
				'status'       => $result['status'] ? $this->language->get('text_enabled') : $this->language->get('text_disabled'),
				'status_value' => (int) $result['status'],
				'content'      => (html_entity_decode($result['content']) > 50) ? substr(html_entity_decode($result['content']), 0, 50) . '...' : html_entity_decode($result['content']),
				'date_added'   => date($this->language->get('date_format_short'), strtotime($result['date_added'])),
				'edit'         => $this->url->link('mobikul/notification/edit', 'user_token=' . $this->session->data['user_token'] . '&notification_id=' . $result['notification_id'] . $url, true),
				'image'        => $this->model_tool_image->resize($image, 100, 100)
			);
		}

		$data['placeholder'] = $this->model_tool_image->resize('no_image.png', 100, 100);

		$lang_array = $this->load->language('mobikul/notification');

		foreach ($lang_array as $key => $value) {
			$data[$key] = $value;
		}

		$data['user_token'] = $this->session->data['user_token'];

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}

		if (isset($this->session->data['error_warning'])) {
			$data['error_warning'] = $this->session->data['error_warning'];

			unset($this->session->data['error_warning']);
		}

		if (isset($this->session->data['success'])) {
			$data['success'] = $this->session->data['success'];

			unset($this->session->data['success']);
		} else {
			$data['success'] = '';
		}

		if (isset($this->request->post['selected'])) {
			$data['selected'] = (array)$this->request->post['selected'];
		} else {
			$data['selected'] = array();
		}

		$url = '';

		if (isset($this->request->get['filter_title'])) {
			$url .= '&filter_title=' . urlencode(html_entity_decode($this->request->get['filter_title'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_type'])) {
			$url .= '&filter_type=' . $this->request->get['filter_type'];
		}

		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}

		if (isset($this->request->get['filter_date_added'])) {
			$url .= '&filter_date_added=' . $this->request->get['filter_date_added'];
		}

		if ($order == 'ASC') {
			$url .= '&order=DESC';
		} else {
			$url .= '&order=ASC';
		}

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}

		$data['sort_title'] = $this->url->link('mobikul/notification', 'user_token=' . $this->session->data['user_token'] . '&sort=mn.title' . $url, true);
		$data['sort_type'] = $this->url->link('mobikul/notification', 'user_token=' . $this->session->data['user_token'] . '&sort=mn.type' . $url, true);
		$data['sort_status'] = $this->url->link('mobikul/notification', 'user_token=' . $this->session->data['user_token'] . '&sort=mn.status' . $url, true);
		$data['sort_date_added'] = $this->url->link('mobikul/notification', 'user_token=' . $this->session->data['user_token'] . '&sort=mn.date_added' . $url, true);

		$url = '';

		if (isset($this->request->get['filter_title'])) {
			$url .= '&filter_title=' . urlencode(html_entity_decode($this->request->get['filter_title'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_type'])) {
			$url .= '&filter_type=' . $this->request->get['filter_type'];
		}

		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}

		if (isset($this->request->get['filter_date_added'])) {
			$url .= '&filter_date_added=' . $this->request->get['filter_date_added'];
		}

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}

		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}

		$pagination = new Pagination();
		$pagination->total = $notification_total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_limit_admin');
		$pagination->url = $this->url->link('mobikul/notification', 'user_token=' . $this->session->data['user_token'] . $url . '&page={page}', true);

		$data['pagination'] = $pagination->render();

		$data['results'] = sprintf($this->language->get('text_pagination'), ($notification_total) ? (($page - 1) * $this->config->get('config_limit_admin')) + 1 : 0, ((($page - 1) * $this->config->get('config_limit_admin')) > ($notification_total - $this->config->get('config_limit_admin'))) ? $notification_total : ((($page - 1) * $this->config->get('config_limit_admin')) + $this->config->get('config_limit_admin')), $notification_total, ceil($notification_total / $this->config->get('config_limit_admin')));

		$data['filter_title'] = $filter_title;
		$data['filter_type'] = $filter_type;
		$data['filter_status'] = $filter_status;
		$data['filter_date_added'] = $filter_date_added;

		$data['sort'] = $sort;
		$data['order'] = $order;

		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/notification_list', $data));
	}

	protected function getForm()
	{
		$data['heading_title'] = $this->language->get('heading_title');

		$data['text_form'] = !isset($this->request->get['notification_id']) ? $this->language->get('text_add') : $this->language->get('text_edit');

		$lang_array = $this->load->language('mobikul/notification');

		foreach ($lang_array as $key => $value) {
			$data[$key] = $value;
		}

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}

		if (isset($this->error['title'])) {
			$data['error_title'] = $this->error['title'];
		} else {
			$data['error_title'] = '';
		}

		if (isset($this->error['error_content'])) {
			$data['error_content'] = $this->error['error_content'];
		} else {
			$data['error_content'] = '';
		}

		if (isset($this->error['id'])) {
			$data['error_id'] = $this->error['id'];
		} else {
			$data['error_id'] = '';
		}

		$url = '';

		if (isset($this->request->get['filter_title'])) {
			$url .= '&filter_title=' . urlencode(html_entity_decode($this->request->get['filter_title'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_type'])) {
			$url .= '&filter_type=' . $this->request->get['filter_type'];
		}

		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}

		if (isset($this->request->get['filter_date_added'])) {
			$url .= '&filter_date_added=' . $this->request->get['filter_date_added'];
		}

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}

		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], true)
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('heading_title'),
			'href' => $this->url->link('mobikul/notification', 'user_token=' . $this->session->data['user_token'] . $url, true)
		);

		if (!isset($this->request->get['notification_id'])) {
			$data['action'] = $this->url->link('mobikul/notification/add', 'user_token=' . $this->session->data['user_token'] . $url, true);
		} else {
			$data['action'] = $this->url->link('mobikul/notification/edit', 'user_token=' . $this->session->data['user_token'] . '&notification_id=' . $this->request->get['notification_id'] . $url, true);
		}

		$data['cancel'] = $this->url->link('mobikul/notification', 'user_token=' . $this->session->data['user_token'] . $url, true);

		if (isset($this->request->get['notification_id']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
			$notification_info = $this->model_mobikul_notification->getNotification($this->request->get['notification_id']);
		}

		$data['user_token'] = $this->session->data['user_token'];

		$data['store'] = HTTP_CATALOG;

		if (isset($this->request->post['title'])) {
			$data['title'] = $this->request->post['title'];
		} elseif (!empty($notification_info)) {
			$data['title'] = $notification_info['title'];
		} else {
			$data['title'] = '';
		}

		if (isset($this->request->post['content'])) {
			$data['content'] = $this->request->post['content'];
		} elseif (!empty($notification_info)) {
			$data['content'] = $notification_info['content'];
		} else {
			$data['content'] = '';
		}

		if (isset($this->request->post['type'])) {
			$data['type'] = $this->request->post['type'];
		} elseif (!empty($notification_info)) {
			$data['type'] = $notification_info['type'];
		} else {
			$data['type'] = '';
		}

		if (isset($this->request->post['name'])) {
			$data['name'] = $this->request->post['name'];
		} elseif (!empty($notification_info)) {
			$data['name'] = $notification_info['name'];
		} else {
			$data['name'] = '';
		}

		if (isset($this->request->post['id'])) {
			$data['id'] = $this->request->post['id'];
		} elseif (!empty($notification_info)) {
			$data['id'] = $notification_info['pro_cat_id'];
		} else {
			$data['id'] = '';
		}

		if (isset($this->request->post['status'])) {
			$data['status'] = $this->request->post['status'];
		} elseif (!empty($notification_info)) {
			$data['status'] = $notification_info['status'];
		} else {
			$data['status'] = '';
		}
		if (isset($this->request->post['image'])) {
			if (is_file(DIR_IMAGE . $this->request->post['image']))
				$image = $this->request->post['image'];
			else
				$image = 'no_image.png';
		} elseif (!empty($notification_info) && $notification_info['image']) {
			if (is_file(DIR_IMAGE . $notification_info['image']))
				$image = $notification_info['image'];
			else
				$image = 'no_image.png';
		} else {
			$image = 'no_image.png';
		}
		$this->load->model('tool/image');

		$data['image'] = $this->model_tool_image->resize($image, 100, 100);
		$data['image_name'] = $image;

		$data['placeholder'] = $this->model_tool_image->resize('no_image.png', 100, 100);
		$this->load->model('localisation/language');

		$data['languages'] = $this->model_localisation_language->getLanguages();
		$collection = $this->model_mobikul_notification->getCustomCollection();
		$collection_name = array();

		foreach ($collection as $key => $collections) {
			foreach ($collections['name'] as $language_id => $name) {
				$collection_name[$language_id] = $name;
			}
			$data['custom_collections'][] = array(
				"id"   => $collections['id'],
				"name"  => $collection_name[$this->config->get('config_language_id')]['name']
			);
		}

		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/notification_form', $data));
	}

	public function getItem()
	{

		$json = array();

		if (isset($this->request->post['type']) && isset($this->request->get['filter_name'])) {

			$filter_data = array(
				'filter_name' => '%' . $this->request->get['filter_name'],
				'filter_status' => 1,
				'sort'        => 'name',
				'order'       => 'ASC',
				'start'       => 0,
				'limit'       => 8
			);

			$this->load->model('catalog/product');
			$this->load->model('catalog/category');

			if ($this->request->post['type'] == 1) {

				$results = $this->model_catalog_product->getProducts($filter_data);

				foreach ($results as $result) {
					$json[] = array(
						'id'		=> $result['product_id'],
						'name'		=> strip_tags(html_entity_decode($result['name'], ENT_QUOTES, 'UTF-8'))
					);
				}
			} elseif ($this->request->post['type'] == 2) {

				$results = $this->model_catalog_category->getCategories($filter_data);

				foreach ($results as $result) {
					$json[] = array(
						'id'		=> $result['category_id'],
						'name'		=> strip_tags(html_entity_decode($result['name'], ENT_QUOTES, 'UTF-8'))
					);
				}
			}

			$sort_order = array();

			foreach ($json as $key => $value) {
				$sort_order[$key] = $value['name'];
			}

			array_multisort($sort_order, SORT_ASC, $json);
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	public function send()
	{

		$this->load->language('mobikul/notification');

		if (isset($this->request->post['selected']) and $this->request->post['selected']) {
			foreach ($this->request->post['selected'] as $notification_id) {
				$this->sendNotification($notification_id);
				$this->session->data['success'] = $this->language->get('text_notify_send');
			}
		} else {
			$this->session->data['error_warning'] = $this->language->get('error_notify');
		}
		$this->response->redirect($this->url->link('mobikul/notification', 'user_token=' . $this->session->data['user_token'], true));
	}

	protected function sendNotification($notification_id)
	{
		$accessToken = $this->generateToken();
		if($accessToken){
			$filepath = file_get_contents(DIR_SYSTEM .'mobikul_fcm_file/fcm_credentials.json');
            $json = json_decode($filepath, true); 
            $project_id = isset($json['project_id']) ? $json['project_id'] : '';
            $url = 'https://fcm.googleapis.com/v1/projects/' . $project_id . '/messages:send';

			$notification_info = $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_notification mn LEFT JOIN " . DB_PREFIX . "mobikul_notification_description mnd ON (mn.notification_id = mnd.notification_id) WHERE mnd.language_id = '" . $this->config->get('config_language_id') . "' AND mn.notification_id = '" . $notification_id . "'")->row;
	
			$type = '';
	
			if ($notification_info['type'] == 1) {
				$type = 'product';
			} elseif ($notification_info['type'] == 2) {
				$type = 'category';
			} elseif ($notification_info['type'] == 3) {
				$type = 'other';
			} elseif ($notification_info['type'] == 4) {
				$type = 'Custom';
			}

			$data = array(
                'body' => strip_tags(html_entity_decode($notification_info['content'], ENT_QUOTES, 'UTF-8')),
                'image' => HTTP_CATALOG . "image/" . str_replace(" ", "%20", $notification_info['image']),
                'title' => strip_tags(html_entity_decode($notification_info['title'], ENT_QUOTES, 'UTF-8')),
                'type' => $type ? $type : $notification_info['type'],
                'type_data' => '',
                'sound' => 'default',
				'notification_id' => $notification_info['notification_id'],
				'id'	=> $notification_info['pro_cat_id']
            );

			$notification = array(
                'body' => strip_tags(html_entity_decode($notification_info['content'], ENT_QUOTES, 'UTF-8')),
                'image' => HTTP_CATALOG . "image/" . str_replace(" ", "%20", $notification_info['image']),
                'title' => strip_tags(html_entity_decode($notification_info['title'], ENT_QUOTES, 'UTF-8')),
				
            );

			// Topic 1
			$fields1 = array(
                "message" => array(
                    'topic' => $this->config->get('module_mobikul_topic_name'),
                    'data' => $data,
                    'notification' => $notification,
					
                ),
            );
			// topic 2
			$fields2 = array(
                "message" => array(
                    'topic' => $this->config->get('module_mobikul_topic_name'),
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
			curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields1));
			// Execute post
			$result = curl_exec($ch);
			if ($result === FALSE) {
				die('Curl failed: ' . curl_error($ch));
			}
			// Close connection
			curl_close($ch);
	
	
			// Open connection
			$ch = curl_init();
			// Set the url, number of POST vars, POST data
			curl_setopt($ch, CURLOPT_URL, $url);
			curl_setopt($ch, CURLOPT_POST, true);
			curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			// Disabling SSL Certificate support temporarly
			curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
			curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields2));
			// Execute post
			$result = curl_exec($ch);
			if ($result === FALSE) {
				die('Curl failed: ' . curl_error($ch));
			}
			// Close connection
			curl_close($ch);
	
			$this->load->model('mobikul/notification');
	
			if (isset(json_decode($result)->message_id)) {
				$message_id = json_decode($result)->message_id;
				$this->model_mobikul_notification->sendNotification($message_id, $fields2, $headers, $error = '');
			} elseif (isset(json_decode($result)->error)) {
				$error = json_decode($result)->error;
				$this->model_mobikul_notification->sendNotification($message_id = '', $fields2, $headers, $error);
			}
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

	protected function validateForm()
	{

		if (!$this->user->hasPermission('modify', 'mobikul/notification')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		if (isset($this->request->post['title'])) {
			foreach ($this->request->post['title'] as $language_id => $title) {
				if ((utf8_strlen($title) < 2) || (utf8_strlen($title) > 64)) {
					$this->error['title'][$language_id] = $this->language->get('error_title');
				}
			}
		}

		if (($this->request->post['type'] == 1 || $this->request->post['type'] == 2) && !$this->request->post['id']) {

			$this->error['id'] = $this->language->get('error_id');
		}

		if ($this->request->post['type'] == 4 && !$this->request->post['input-custom_id']) {

			$this->error['id'] = $this->language->get('error_custom_collection');
		}

		if (isset($this->request->post['content']) && $this->request->post['content']) {
			if (preg_match("/<[^<]+>/", $_POST['content'], $matches)) {
				if ($matches > 0) {
					$this->error['error_content'] = $this->language->get('error_content');
				}
			}
		}


		return !$this->error;
	}

	protected function validateDelete()
	{
		if (!$this->user->hasPermission('modify', 'mobikul/notification')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		return !$this->error;
	}
}
