<?php
class ControllerMobikulAR extends Controller
{
	private $error = array();

	public function index()
	{
		$this->language->load('mobikul/ar');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('mobikul/ar');

		$this->getList();
	}

	protected function getList()
	{
		if (isset($this->request->get['filter_name'])) {
			$filter_name = $this->request->get['filter_name'];
		} else {
			$filter_name = null;
		}

		if (isset($this->request->get['filter_ios_file'])) {
			$filter_ios_file = $this->request->get['filter_ios_file'];
		} else {
			$filter_ios_file = null;
		}

		if (isset($this->request->get['filter_android_file'])) {
			$filter_android_file = $this->request->get['filter_android_file'];
		} else {
			$filter_android_file = null;
		}

		if (isset($this->request->get['filter_status'])) {
			$filter_status = $this->request->get['filter_status'];
		} else {
			$filter_status = null;
		}

		if (isset($this->request->get['sort'])) {
			$sort = $this->request->get['sort'];
		} else {
			$sort = 'pd.name';
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

		if (isset($this->request->get['filter_name'])) {
			$url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_ios_file'])) {
			$url .= '&filter_ios_file=' . $this->request->get['filter_ios_file'];
		}

		if (isset($this->request->get['filter_android_file'])) {
			$url .= '&filter_android_file=' . $this->request->get['filter_android_file'];
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

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], 'SSL')
		);

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('mobikul/ar', 'user_token=' . $this->session->data['user_token'], 'SSL')
		);

		$data['insert'] = $this->url->link('mobikul/ar/update', 'user_token=' . $this->session->data['user_token'], 'SSL');
		$data['delete'] = $this->url->link('mobikul/ar/delete', 'user_token=' . $this->session->data['user_token'] . $url, 'SSL');

		$data['products'] = array();

		$filter_array = array(
			'filter_name'	         => $filter_name,
			'filter_ios_file'      => $filter_ios_file,
			'filter_android_file'  => $filter_android_file,
			'filter_status'        => $filter_status,
			'sort'                 => $sort,
			'order'                => $order,
			'start'                => ($page - 1) * $this->config->get('config_admin_limit'),
			'limit'                => $this->config->get('config_admin_limit')
		);

		$this->load->model('tool/image');

		$product_total = $this->model_mobikul_ar->getTotalArProducts($filter_array);

		$results = $this->model_mobikul_ar->getArProducts($filter_array);

		$data['action'] = $this->url->link('mobikul/ar/delete', 'user_token=' . $this->session->data['user_token'] . $url, 'SSL');

		foreach ($results as $result) {
			if ($result['image'] && file_exists(DIR_IMAGE . $result['image'])) {
				$image = $this->model_tool_image->resize($result['image'], 40, 40);
			} else {
				$image = $this->model_tool_image->resize('no_image.jpg', 40, 40);
			}

			$data['products'][] = array(
				'product_id'    => $result['product_id'],
				'name'          => $result['name'],
				'image'         => $image,
				'android_file'  => $result['android_file'],
				'ios_file'      => $result['ios_file'],
				'status'        => $result['status'] ? $this->language->get('text_enabled') : $this->language->get('text_disabled'),
				'selected'      => isset($this->request->post['selected']) && in_array($result['product_id'], $this->request->post['selected']),
				'edit'          => $this->url->link('mobikul/ar/update', 'user_token=' . $this->session->data['user_token'] . '&product_id=' . $result['product_id'], 'SSL')
			);
		}

		$data['heading_title'] = $this->language->get('heading_title');

		$data['text_enabled'] = $this->language->get('text_enabled');
		$data['text_disabled'] = $this->language->get('text_disabled');
		$data['text_no_results'] = $this->language->get('text_no_results');
		$data['text_confirm'] = $this->language->get('text_confirm');

		$data['column_image'] = $this->language->get('column_image');
		$data['column_name'] = $this->language->get('column_name');
		$data['column_status'] = $this->language->get('column_status');
		$data['column_action'] = $this->language->get('column_action');
		$data['column_android_file'] = $this->language->get('column_android_file');
		$data['column_ios_file'] = $this->language->get('column_ios_file');
		$data['column_status'] = $this->language->get('column_status');

		$data['button_insert'] = $this->language->get('button_insert');
		$data['button_delete'] = $this->language->get('button_delete');
		$data['button_filter'] = $this->language->get('button_filter');

		$data['entry_name'] = $this->language->get('entry_name');

		$data['user_token'] = $this->session->data['user_token'];

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} elseif (isset($this->session->data['warning'])) {
			$data['error_warning'] = $this->session->data['warning'];
			unset($this->session->data['warning']);
		} else {
			$data['error_warning'] = '';
		}

		if (isset($this->session->data['success'])) {
			$data['success'] = $this->session->data['success'];

			unset($this->session->data['success']);
		} else {
			$data['success'] = '';
		}

		$url = '';

		if (isset($this->request->get['filter_name'])) {
			$url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_ios_file'])) {
			$url .= '&filter_ios_file=' . $this->request->get['filter_ios_file'];
		}

		if (isset($this->request->get['filter_android_file'])) {
			$url .= '&filter_android_file=' . $this->request->get['filter_android_file'];
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

		$data['sort_name'] = $this->url->link('mobikul/ar', 'user_token=' . $this->session->data['user_token'] . '&sort=pd.name' . $url, 'SSL');
		$data['sort_android_file'] = $this->url->link('mobikul/ar', 'user_token=' . $this->session->data['user_token'] . '&sort=ma.android_file' . $url, 'SSL');
		$data['sort_ios_file'] = $this->url->link('mobikul/ar', 'user_token=' . $this->session->data['user_token'] . '&sort=ma.android_file' . $url, 'SSL');
		$data['sort_status'] = $this->url->link('mobikul/ar', 'user_token=' . $this->session->data['user_token'] . '&sort=ma.status' . $url, 'SSL');

		$url = '';

		if (isset($this->request->get['filter_name'])) {
			$url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_ios_file'])) {
			$url .= '&filter_ios_file=' . $this->request->get['filter_ios_file'];
		}

		if (isset($this->request->get['filter_android_file'])) {
			$url .= '&filter_android_file=' . $this->request->get['filter_android_file'];
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
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = $this->url->link('mobikul/ar', 'user_token=' . $this->session->data['user_token'] . $url . '&page={page}', 'SSL');

		$data['pagination'] = $pagination->render();

		$data['results'] = sprintf($this->language->get('text_pagination'), ($product_total) ? (($page - 1) * $this->config->get('config_limit_admin')) + 1 : 0, ((($page - 1) * $this->config->get('config_limit_admin')) > ($product_total - $this->config->get('config_limit_admin'))) ? $product_total : ((($page - 1) * $this->config->get('config_limit_admin')) + $this->config->get('config_limit_admin')), $product_total, ceil($product_total / $this->config->get('config_limit_admin')));

		$data['filter_name'] = $filter_name;
		$data['filter_ios_file'] = $filter_ios_file;
		$data['filter_android_file'] = $filter_android_file;
		$data['filter_status'] = $filter_status;

		$data['sort'] = $sort;
		$data['order'] = $order;

		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/ar_list', $data));
	}

	public function delete()
	{
		$this->language->load('mobikul/ar');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('mobikul/ar');

		$url = '';
		if ($this->validateDelete()) {
			foreach ($this->request->post['selected'] as $product_id) {
				$this->model_mobikul_ar->deleteProduct($product_id);
			}

			$this->session->data['success'] = $this->language->get('text_success_delete');

			if (isset($this->request->get['filter_name'])) {
				$url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
			}

			if (isset($this->request->get['filter_ios_file'])) {
				$url .= '&filter_ios_file=' . $this->request->get['filter_ios_file'];
			}

			if (isset($this->request->get['filter_android_file'])) {
				$url .= '&filter_android_file=' . $this->request->get['filter_android_file'];
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

			if (isset($this->request->get['page'])) {
				$url .= '&page=' . $this->request->get['page'];
			}
		}
		$this->response->redirect($this->url->link('mobikul/ar', 'user_token=' . $this->session->data['user_token'] . $url, 'SSL'));
	}

	public function update()
	{

		$this->language->load('mobikul/ar');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('mobikul/ar');

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
			$this->url->link('mobikul/ar', 'user_token=' . $this->session->data['user_token'], 'SSL');
			if (isset($this->request->get['product_id']) && $this->request->get['product_id']) {
				$this->session->data['success'] = $this->language->get('text_success_edit');
			} else {
				$this->session->data['success'] = $this->language->get('text_success_add');
			}
			$this->model_mobikul_ar->updateAR($this->request->post);
			$this->response->redirect($this->url->link('mobikul/ar', 'user_token=' . $this->session->data['user_token'], 'SSL'));
		}

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], 'SSL')
		);

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('mobikul/ar', 'user_token=' . $this->session->data['user_token'], 'SSL')
		);

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}

		if (isset($this->error['error_product'])) {
			$data['error_product'] = $this->error['error_product'];
		} else {
			$data['error_product'] = '';
		}

		$data['heading_title'] = $this->language->get('heading_title');

		$data['text_enabled'] = $this->language->get('text_enabled');
		$data['text_disabled'] = $this->language->get('text_disabled');
		$data['text_confirm'] = $this->language->get('text_confirm');

		$data['column_name'] = $this->language->get('column_name');
		$data['entry_android'] = $this->language->get('entry_android');
		$data['entry_ios'] = $this->language->get('entry_ios');
		$data['entry_status'] = $this->language->get('entry_status');

		$data['button_save'] = $this->language->get('button_save');
		$data['button_cancel'] = $this->language->get('button_cancel');

		$data['text_loading'] = $this->language->get('text_loading');
		$data['button_upload'] = $this->language->get('button_upload');

		$data['help_android'] = $this->language->get('help_android');
		$data['help_ios'] = $this->language->get('help_ios');

		$data['user_token'] = $this->session->data['user_token'];

		$data['android_file'] = '';
		$data['ios_file'] = '';
		$data['product_id'] = '';
		$data['name'] = '';
		$data['status'] = '';

		if (isset($this->request->get['product_id'])) {
			$ar_data = $this->model_mobikul_ar->getArProduct($this->request->get['product_id']);
			if ($ar_data) {
				$data['android_file'] = $ar_data['android_file'];
				$data['ios_file'] = $ar_data['ios_file'];
				$data['product_id'] = $ar_data['product_id'];
				$data['name'] = $ar_data['name'];
				$data['status'] = $ar_data['status'];
			}
		}

		if (isset($this->request->post['product_id'])) {
			$data['product_id'] = $this->request->post['product_id'];
		}

		if (isset($this->request->post['name'])) {
			$data['name'] = $this->request->post['name'];
		}

		if (isset($this->request->post['status'])) {
			$data['status'] = $this->request->post['status'];
		}

		if (isset($this->request->post['android_file'])) {
			$data['android_file'] = $this->request->post['android_file'];
		}

		if (isset($this->request->post['ios_file'])) {
			$data['ios_file'] = $this->request->post['ios_file'];
		}

		$data['action'] = $this->url->link('mobikul/ar/update', 'user_token=' . $this->session->data['user_token'], 'SSL');
		$data['cancel'] = $this->url->link('mobikul/ar', 'user_token=' . $this->session->data['user_token'], 'SSL');

		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/ar_form', $data));
	}

	protected function validate()
	{
		if (!$this->user->hasPermission('modify', 'mobikul/ar')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		if (!isset($this->request->post['product_id']) || !$this->request->post['product_id']) {
			$this->error['error_product'] = $this->language->get('error_product');
			$this->error['warning'] = $this->language->get('error_product');
		}
		return !$this->error;
	}

	protected function validateDelete()
	{
		if (!$this->user->hasPermission('modify', 'mobikul/ar')) {
			$this->session->data['warning'] = $this->language->get('error_permission');
			$this->error['error'] = true;
		}

		if (!isset($this->request->post['selected'])) {
			$this->session->data['warning'] = $this->language->get('error_delete');
			$this->error['error'] = true;
		}
		return !$this->error;
	}

	public function autocomplete()
	{
		$json = array();

		if (isset($this->request->get['filter_name'])) {
			$this->load->model('mobikul/ar');

			if (isset($this->request->get['filter_name'])) {
				$filter_name = $this->request->get['filter_name'];
			} else {
				$filter_name = '';
			}

			if (isset($this->request->get['limit'])) {
				$limit = $this->request->get['limit'];
			} else {
				$limit = 10;
			}

			$data = array(
				'filter_name'  => $filter_name,
				'start'        => 0,
				'limit'        => $limit
			);

			$results = $this->model_mobikul_ar->getProducts($data);

			foreach ($results as $result) {
				$json[] = array(
					'product_id' => $result['product_id'],
					'name'       => strip_tags(html_entity_decode($result['name'], ENT_QUOTES, 'UTF-8'))
				);
			}
		}

		$this->response->setOutput(json_encode($json));
	}

	public function upload()
	{
		$this->load->language('mobikul/ar');

		$json = array();
		// Check user has permission
		if (!$this->user->hasPermission('modify', 'mobikul/ar')) {
			$json['error'] = $this->language->get('error_permission');
		}

		if (!$json) {
			if (!empty($this->request->files['upload_android']['name']) && is_file($this->request->files['upload_android']['tmp_name'])) {
				$valid = true;
				$allowed = array(
					'glb',
				);
				$name = $this->request->files['upload_android']['name'];
				$type = $this->request->files['upload_android']['type'];
				$tmp_name = $this->request->files['upload_android']['tmp_name'];
				$error = $this->request->files['upload_android']['error'];
			} elseif (!empty($this->request->files['upload_ios']['name']) && is_file($this->request->files['upload_ios']['tmp_name'])) {
				$valid = true;
				$allowed = array(
					'usdz',
				);
				$name = $this->request->files['upload_ios']['name'];
				$type = $this->request->files['upload_ios']['type'];
				$tmp_name = $this->request->files['upload_ios']['tmp_name'];
				$error = $this->request->files['upload_ios']['error'];
			} else {
				$valid = false;
			}
			if ($valid) {
				// Sanitize the filename
				$filename = basename(html_entity_decode($name, ENT_QUOTES, 'UTF-8'));

				// Allowed file extension types


				if (!in_array(strtolower(substr(strrchr($filename, '.'), 1)), $allowed)) {
					$json['error'] = $this->language->get('error_filetype');
				}

				// Allowed file mime types
				$mime_allowed = array(
					'application/octet-stream'
				);

				if (!in_array($type, $mime_allowed)) {
					$json['error'] = $this->language->get('error_filetype');
				}

				// Check to see if any PHP files are trying to be uploaded
				$content = file_get_contents($tmp_name);

				if (preg_match('/\<\?php/i', $content)) {
					$json['error'] = $this->language->get('error_filetype');
				}
				// Return any upload error
				if ($error != UPLOAD_ERR_OK) {
					$json['error'] = $this->language->get('error_upload_' . $error);
				}
			} else {
				$json['error'] = sprintf($this->language->get('error_upload'), ini_get('memory_limit'), ini_get('post_max_size'), ini_get('upload_max_filesize'));
			}
		}

		if (!$json) {
			if (!is_dir(DIR_DOWNLOAD . "mobikul_ar/"))
				mkdir(DIR_DOWNLOAD . "mobikul_ar/");

			move_uploaded_file($tmp_name, DIR_DOWNLOAD . "mobikul_ar/" . $filename);

			$json['filename'] = $filename;
			$json['mask'] = $filename;

			$json['success'] = $this->language->get('text_upload');
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}
}
