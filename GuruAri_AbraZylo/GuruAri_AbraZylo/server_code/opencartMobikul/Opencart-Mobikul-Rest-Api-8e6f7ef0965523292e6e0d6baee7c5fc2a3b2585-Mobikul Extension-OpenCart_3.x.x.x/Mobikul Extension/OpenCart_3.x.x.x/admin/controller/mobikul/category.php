<?php
class ControllerMobikulcategory extends Controller
{
	public function index()
	{
		$this->language->load('mobikul/category');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('setting/setting');

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {

			$this->load->model('mobikul/category');
			$categories = $this->request->post['category'];
			$this->model_mobikul_category->updateIcons($categories);
			$this->session->data['success'] = $this->language->get('text_success');

			$url = '';

			if (isset($this->request->get['sort'])) {
				$url .= '&sort=' . $this->request->get['sort'];
			} else {
				$url .= '&sort=mc.category_icon';
			}

			if (isset($this->request->get['order'])) {
				$url .= '&order=' . $this->request->get['order'];
			}

			if (isset($this->request->get['filter_name'])) {
				$url .= '&filter_name=' . $this->request->get['filter_name'];
			}
			if (isset($this->request->get['filter_count'])) {
				$url .= '&filter_count=' . $this->request->get['filter_count'];
			}


			$this->response->redirect($this->url->link('mobikul/category', 'user_token=' . $this->session->data['user_token'] . $url, true));
		}

		if (isset($this->request->get['sort'])) {
			$sort = $this->request->get['sort'];
		} else {
			$sort = 'mc.category_icon';
		}

		if (isset($this->request->get['filter_name'])) {
			$data['filter_name'] = $this->request->get['filter_name'];
		} else {

			$data['filter_name'] = '';
		}

		if (isset($this->request->get['order'])) {
			$order = $this->request->get['order'];
		} else {
			$order = 'DESC';
		}

		if (isset($this->request->get['page'])) {
			$page = $this->request->get['page'];
		} else {
			$page = 1;
		}
		if (isset($this->request->get['filter_count'])) {

			$data['filter_count'] = $this->request->get['filter_count'];
		} else {

			$data['filter_count'] = 10;
		}

		$url = '';

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		} else {
			$url .= '&sort=mc.category_icon';
		}


		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}

		if (isset($this->request->get['filter_name'])) {
			$url .= '&filter_name=' . $this->request->get['filter_name'];
		}

		if (isset($this->session->data['success'])) {
			$data['success'] = $this->session->data['success'];
			unset($this->session->data['success']);
		} else {
			$data['success'] = '';
		}
		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], true),
		);

		$data['breadcrumbs'][] = array(
			'text'      => $this->language->get('text_module'),
			'href'      => $this->url->link('mobikul/category', 'user_token=' . $this->session->data['user_token'], true),
		);

		$this->load->model('mobikul/category');
		$this->load->model('tool/image');
		$data['placeholder'] = $this->model_tool_image->resize('no_image.png', 100, 100);
		$category_slab_total = $this->model_mobikul_category->getTotalCategories(array(), true);

		$count = array();
		if ($category_slab_total) {
			$slab_difference = 10;
			$count_slab = ceil($category_slab_total / $slab_difference);
			for ($i = 1; $i <= $count_slab; $i++) {
				$count[] = $slab_difference * $i;
			}
			$data['count'] = $count;
		} else {
			$data['count'] = 10;
		}


		$filter_data = array(
			'filter_name'  => $data['filter_name'],
			'sort'  => $sort,
			'order' => $order,
			'start' => ($page - 1) * $data['filter_count'],
			'limit' => $data['filter_count'],

		);
		$category_total =  $this->model_mobikul_category->getTotalCategories($filter_data);
		$categories =  $this->model_mobikul_category->getCategories($filter_data);

		if (!empty($categories)) {

			foreach ($categories as $category) {

				if (is_file(DIR_IMAGE . $category['category_image']) && $category['category_image'] != 'no_image.png') {
					$image = $category['category_image'];
					$thumb = $category['category_image'];
				} elseif (is_file(DIR_IMAGE . $category['image'])) {
					$image = $category['image'];
					$thumb = $category['image'];
				} else {
					$image = '';
					$thumb = 'no_image.png';
				}

				if (is_file(DIR_IMAGE . $category['category_icon'])) {
					$category_image = $category['category_icon'];
					$category_thumb = $category['category_icon'];
				} else {
					$category_image = '';
					$category_thumb = 'no_image.png';
				}
				$data['categories'][] = array(
					'id'  => $category['category_id'],
					'name' => $category['name'],
					'icon' => $category_thumb,
					'image' => $thumb,
					'image_thumb' => $this->model_tool_image->resize($thumb, 100, 100),
					'icon_thumb' => $this->model_tool_image->resize($category_thumb, 100, 100),
					'parrent_category' => $category['parent_id'],

				);
			}
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


		if (isset($this->request->post['selected'])) {
			$data['selected'] = (array)$this->request->post['selected'];
		} else {
			$data['selected'] = array();
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
		if (isset($this->request->get['filter_name'])) {
			$url .= '&filter_name=' . $this->request->get['filter_name'];
		}
		if (isset($this->request->get['filter_count'])) {
			$url .= '&filter_count=' . $this->request->get['filter_count'];
		}

		$data['sort_name'] = $this->url->link('mobikul/category', 'user_token=' . $this->session->data['user_token'] . '&sort=name' . $url, true);
		$data['sort_image'] = $this->url->link('mobikul/category', 'user_token=' . $this->session->data['user_token'] . '&sort=mc.category_image' . $url, true);
		$data['sort_image_icon'] = $this->url->link('mobikul/category', 'user_token=' . $this->session->data['user_token'] . '&sort=mc.category_icon' . $url, true);

		$url = '';

		if ($order == 'ASC') {
			$url .= '&order=DESC';
		} else {
			$url .= '&order=ASC';
		}
		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		} else {
			$url .= '&sort=mc.category_icon';
		}

		if (isset($this->request->get['filter_name'])) {
			$url .= '&filter_name=' . $this->request->get['filter_name'];
		}
		if (isset($this->request->get['filter_count'])) {
			$url .= '&filter_count=' . $this->request->get['filter_count'];
		}

		$pagination = new Pagination();
		$pagination->total = $category_total;
		$pagination->page = $page;
		$pagination->limit = $data['filter_count'];
		$pagination->url = $this->url->link('mobikul/category', 'user_token=' . $this->session->data['user_token'] . $url . '&page={page}', false);

		$data['pagination'] = $pagination->render();

		$data['results'] = sprintf($this->language->get('text_pagination'), ($category_total) ? (($page - 1) * $data['filter_count']) + 1 : 0, ((($page - 1) * $data['filter_count']) > ($category_total - $data['filter_count'])) ? $category_total : ((($page - 1) * $data['filter_count']) + $data['filter_count']), $category_total, ceil($category_total / $data['filter_count']));

		$data['sort'] = $sort;
		$data['order'] = $order;


		$url = '';

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}

		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}
		$data['clear_filter'] = $this->url->link('mobikul/category', 'user_token=' . $this->session->data['user_token'] . $url . '&page=' . $page, true);
		if (isset($this->request->get['filter_name'])) {
			$url .= '&filter_name=' . $this->request->get['filter_name'];
		}
		if (isset($this->request->get['filter_count'])) {
			$url .= '&filter_count=' . $this->request->get['filter_count'];
		}

		$data['action'] = html_entity_decode($this->url->link('mobikul/category', 'user_token=' . $this->session->data['user_token'] . $url, true));
		$data['delete_action'] = html_entity_decode($this->url->link('mobikul/category/delete', 'user_token=' . $this->session->data['user_token'] . $url, true));

		$data['cancel'] = $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], true);

		$data['user_token'] = $this->session->data['user_token'];

		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/category', $data));
	}
	public function delete()
	{
		$this->load->model('mobikul/category');
		$this->language->load('mobikul/category');
		if (isset($this->request->post['selected']) && $this->validateDelete()) {
			$this->model_mobikul_category->delete($this->request->post['selected']);
			$this->session->data['success'] = $this->language->get('text_success');

			$url = '';

			if (isset($this->request->get['sort'])) {
				$url .= '&sort=' . $this->request->get['sort'];
			}

			if (isset($this->request->get['order'])) {
				$url .= '&order=' . $this->request->get['order'];
			}

			if (isset($this->request->get['filter_name'])) {
				$url .= '&filter_name=' . $this->request->get['filter_name'];
			}
			if (isset($this->request->get['filter_count'])) {
				$url .= '&filter_count=' . $this->request->get['filter_count'];
			}
		}
		$this->response->redirect($this->url->link('mobikul/category', 'user_token=' . $this->session->data['user_token'] . $url, true));
	}
	protected function validate()
	{
		if (!$this->user->hasPermission('modify', 'mobikul/category')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}
		if (!$this->error) {
			return true;
		} else {
			return false;
		}
	}

	protected function validateDelete()
	{
		if (!$this->user->hasPermission('modify', 'mobikul/category')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		return !$this->error;
	}
}
