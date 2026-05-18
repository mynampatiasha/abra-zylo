<?php
class ControllerMobikulBanner extends Controller
{
	private $error = array();

	public function index()
	{

		$data = array();

		$this->language->load('mobikul/banner');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('setting/setting');

		$this->load->model('mobikul/banner');
		$this->load->model('tool/image');

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
			'href'      => $this->url->link('mobikul/banner', 'user_token=' . $this->session->data['user_token'], 'SSL'),
		);


		$data['add'] = $this->url->link('mobikul/banner/add', 'user_token=' . $this->session->data['user_token'], 'SSL');
		$data['cancel'] = $this->url->link('mobikul/banner', 'user_token=' . $this->session->data['user_token'], 'SSL');

		$data['user_token'] = $this->session->data['user_token'];

		if (isset($this->session->data['success'])) {
			$data['success'] = $this->session->data['success'];

			unset($this->session->data['success']);
		} else {
			$data['success'] = '';
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

		if (isset($this->request->get['filter_title'])) {
			$filter_title = $this->request->get['filter_title'];
		} else {
			$filter_title = null;
		}

		if (isset($this->request->get['filter_status'])) {
			$filter_status = $this->request->get['filter_status'];
		} else {
			$filter_status = null;
		}
		if (isset($this->request->get['filter_type'])) {
			$filter_type = $this->request->get['filter_type'];
		} else {
			$filter_type = null;
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

		$filter = array(
			'filter_id_from'	  => $filter_id_from,
			'filter_id_to'	  => $filter_id_to,
			'filter_title'	  => $filter_title,
			'filter_status' => $filter_status,
			'filter_type' => $filter_type,
			'sort'            => $sort,
			'order'           => $order,
			'start'           => ($page - 1) * $this->config->get('config_limit_admin'),
			'limit'           => $this->config->get('config_limit_admin')
		);

		$banner = $this->model_mobikul_banner->getBanner($filter);
		$banner_total = $this->model_mobikul_banner->getBanner($filter, true);



		if ($banner) {
			foreach ($banner as $key => $value) {

				if (isset($value['image'])) {
					if (is_file(DIR_IMAGE . $value['image']))
						$image_section_image = $value['image'];
					else
						$image_section_image = 'no_image.png';
				} else {
					$image_section_image = 'no_image.png';
				}

				$data['banners'][] = array(

					"id" =>  $value['id'],
					"title" =>  $value['title'],
					"status" =>  $value['status'],
					"image" =>   $this->model_tool_image->resize($image_section_image, 100, 100),
					"type" =>  $value['type'],
					"sort_order" =>  $value['sort_order'],
					"edit" => $this->url->link('mobikul/banner/edit&banner_id=' . $value['id'], 'user_token=' . $this->session->data['user_token'], 'SSL')

				);
			}
		}

		$url = '';

		if (isset($this->request->get['filter_id_from'])) {
			$url .= '&filter_id_from=' . urlencode(html_entity_decode($this->request->get['filter_id_from'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_id_to'])) {
			$url .= '&filter_id_to=' . $this->request->get['filter_id_to'];
		}

		if (isset($this->request->get['filter_title'])) {
			$url .= '&filter_title=' . $this->request->get['filter_title'];
		}


		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}
		if (isset($this->request->get['filter_type'])) {
			$url .= '&filter_type=' . $this->request->get['filter_type'];
		}

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}
		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}


		$pagination = new Pagination();
		$pagination->total = $banner_total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_limit_admin');
		$pagination->url = $this->url->link('mobikul/banner', 'user_token=' . $this->session->data['user_token'] . $url . '&page={page}', 'SSL');

		$data['pagination'] = $pagination->render();

		$data['results'] = sprintf($this->language->get('text_pagination'), ($banner_total) ? (($page - 1) * $this->config->get('config_limit_admin')) + 1 : 0, ((($page - 1) * $this->config->get('config_limit_admin')) > ($banner_total - $this->config->get('config_limit_admin'))) ? $banner_total : ((($page - 1) * $this->config->get('config_limit_admin')) + $this->config->get('config_limit_admin')), $banner_total, ceil($banner_total / $this->config->get('config_limit_admin')));


		$url = '';

		if (isset($this->request->get['filter_id_from'])) {
			$url .= '&filter_id_from=' . urlencode(html_entity_decode($this->request->get['filter_id_from'], ENT_QUOTES, 'UTF-8'));
		}

		if (isset($this->request->get['filter_id_to'])) {
			$url .= '&filter_id_to=' . $this->request->get['filter_id_to'];
		}

		if (isset($this->request->get['filter_title'])) {
			$url .= '&filter_title=' . $this->request->get['filter_title'];
		}


		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}
		if (isset($this->request->get['filter_type'])) {
			$url .= '&filter_type=' . $this->request->get['filter_type'];
		}


		if ($order == 'ASC') {
			$url .= '&order=DESC';
		} else {
			$url .= '&order=ASC';
		}

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}

		$data['sort_id'] = $this->url->link('mobikul/banner', 'user_token=' . $this->session->data['user_token'] . '&sort=b.id' . $url, true);
		$data['sort_title'] = $this->url->link('mobikul/banner', 'user_token=' . $this->session->data['user_token'] . '&sort=bd.title' . $url, true);
		$data['sort_status'] = $this->url->link('mobikul/banner', 'user_token=' . $this->session->data['user_token'] . '&sort=b.status' . $url, true);
		$data['sort_type'] = $this->url->link('mobikul/banner', 'user_token=' . $this->session->data['user_token'] . '&sort=b.type' . $url, true);
		$data['sort_sortorder'] = $this->url->link('mobikul/banner', 'user_token=' . $this->session->data['user_token'] . '&sort=b.sort_order' . $url, true);


		$data['sort'] = $sort;
		$data['order'] = $order;
		$data['filter_title'] = $filter_title;
		$data['filter_status'] = $filter_status;
		$data['filter_id_from'] = $filter_id_from;
		$data['filter_id_to'] = $filter_id_to;
		$data['filter_type'] = $filter_type;



		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/banner_list', $data));
	}

	public function add()
	{
		$data = array();

		$data = array_merge($data, $this->language->load('mobikul/banner'));

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('mobikul/banner');
		$this->load->model('setting/setting');
		$this->load->model('tool/image');

		if (($this->request->server['REQUEST_METHOD'] == 'POST')  && $this->validate()) {
			$this->model_mobikul_banner->addBanner($this->request->post);
			$this->response->redirect($this->url->link('mobikul/banner', 'user_token=' . $this->session->data['user_token'], 'SSL'));
			$this->session->data['success'] = $this->language->get('text_success');
		}

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}
		if (isset($this->error['error_title'])) {
			$data['error_title'] = $this->error['error_title'];
		} else {
			$data['error_title'] = array();
		}

		if (isset($this->error['error_pro_cat_id'])) {
			$data['error_pro_cat_id'] = $this->error['error_pro_cat_id'];
		} else {
			$data['error_pro_cat_id'] = '';
		}
		$this->load->model('localisation/language');
		$data['languages'] = $this->model_localisation_language->getLanguages();
		$data['banner']['thumb'] = $this->model_tool_image->resize('no_image.png', 100, 100);
		$data['cancel'] = $this->url->link('mobikul/banner', 'user_token=' . $this->session->data['user_token'], 'SSL');
		$data['user_token'] = $this->session->data['user_token'];
		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/banner_form', $data));
	}


	public function edit()
	{
		$data = array();

		$this->language->load('mobikul/banner');
		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('setting/setting');
		$this->load->model('tool/image');
		$this->load->model('mobikul/banner');

		if (isset($this->request->get['banner_id'])) {
			$banner_id = $this->request->get['banner_id'];
		} else {
			$banner_id = 0;
		}

		if (($this->request->server['REQUEST_METHOD'] == 'POST')  && $this->validate()) {

			$this->model_mobikul_banner->addBannerById($banner_id, $this->request->post);
			$this->session->data['success'] = $this->language->get('text_success');
			$this->response->redirect($this->url->link('mobikul/banner', 'user_token=' . $this->session->data['user_token'], 'SSL'));
			$this->session->data['success'] = $this->language->get('text_success');
		}

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}
		if (isset($this->error['error_title'])) {
			$data['error_title'] = $this->error['error_title'];
		} else {
			$data['error_title'] = array();
		}

		if (isset($this->error['error_pro_cat_id'])) {
			$data['error_pro_cat_id'] = $this->error['error_pro_cat_id'];
		} else {
			$data['error_pro_cat_id'] = '';
		}

		$banner = $this->model_mobikul_banner->getBannerById($banner_id);

		if ($banner) {
			if (isset($banner["image"])) {
				if (is_file(DIR_IMAGE . $banner["image"]))
					$image = $banner["image"];
				else
					$image = 'no_image.png';
			} else {
				$image = 'no_image.png';
			}

			$data['banner'] = array(
				"id" => $banner["id"],
				"title" => $banner["title"],
				"status" => $banner["status"],
				"type" => $banner["type"],				
				"pro_cat_id" => $banner["pro_cat_id"],
				"pro_cat_name" => $banner["pro_cat_name"],
				"sort_order" => $banner["sort_order"],
				"thumb" => $this->model_tool_image->resize($image, 100, 100),
				"image" => $banner["image"],
			);
		}
		$data['user_token'] = $this->session->data['user_token'];
		$data['cancel'] = $this->url->link('mobikul/banner', 'user_token=' . $this->session->data['user_token'], 'SSL');
		$this->load->model('localisation/language');
		$data['languages'] = $this->model_localisation_language->getLanguages();
		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/banner_form', $data));
	}

	public function delete()
	{

		$json['success'] = '';

		$this->load->model('mobikul/banner');

		$this->language->load('mobikul/carousels');

		if (isset($this->request->post['post_id']) && $this->request->post['post_id']) {

			foreach ($this->request->post['post_id'] as $id) {
				$this->model_mobikul_banner->deleteBanner($id);
			}
			$this->session->data['success'] = $this->language->get('text_success_delete');
			$json['success'] = $this->language->get('text_success_delete');
		}


		$this->response->setOutput(json_encode($json));
	}

	protected function validate()
	{
		if (!$this->user->hasPermission('modify', 'mobikul/banner')) {
			$this->error['error_warning'] = $this->language->get('error_permission');
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

			if( ( isset($this->request->post['type']) &&  $this->request->post['type']  &&  $this->request->post['type'] == '1' )  || ($this->request->post['type'] == '2' ) ){
				if ( !isset($this->request->post['product_category']) || !$this->request->post['product_category'] || !isset($this->request->post['pro_cat_id']) || !$this->request->post['pro_cat_id']) {
					$this->error['error_pro_cat_id'] = $this->language->get('error_pro_cat_id');
				}
			}

		
		}

		if (!$this->error) {
			return true;
		} else {
			return false;
		}
	}
}
