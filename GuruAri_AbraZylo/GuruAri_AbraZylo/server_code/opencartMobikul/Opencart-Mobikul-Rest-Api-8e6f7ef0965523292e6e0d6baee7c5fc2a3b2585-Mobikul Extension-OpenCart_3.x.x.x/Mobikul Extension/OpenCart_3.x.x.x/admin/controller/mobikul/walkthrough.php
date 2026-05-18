<?php
class ControllerMobikulWalkthrough extends Controller {
	private $error = array();

	public function index() {

		$data = array();

		$this->language->load('mobikul/walkthrough');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('setting/setting');

		$this->load->model('mobikul/walkthrough');
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
			'href'      => $this->url->link('mobikul/walkthrough', 'user_token=' . $this->session->data['user_token'], 'SSL'),
		);

	
		$data['add'] = $this->url->link('mobikul/walkthrough/add', 'user_token=' . $this->session->data['user_token'], 'SSL');
		$data['cancel'] = $this->url->link('mobikul/walkthrough', 'user_token=' . $this->session->data['user_token'], 'SSL');

		

		$data['user_token'] = $this->session->data['user_token'];

		if (isset($this->session->data['success'])) {
			$data['success'] = $this->session->data['success'];

			unset($this->session->data['success']);
		} else {
			$data['success'] = '';
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
			'filter_title'	  => $filter_title,
			'filter_status'	  => $filter_status,						
			'sort'            => $sort,
			'order'           => $order,
			'start'           => ($page - 1) * $this->config->get('config_limit_admin'),
			'limit'           => $this->config->get('config_limit_admin')
		);

		 $walkthrough = $this->model_mobikul_walkthrough->getWalkthrough($filter);
		 $walkthrough_total = $this->model_mobikul_walkthrough->getWalkthrough($filter,true);

		

		if($walkthrough){
			foreach ($walkthrough as $key => $value) {

				if(isset($value['image'])) {
					if (is_file(DIR_IMAGE . $value['image']))
						$walkthrough_image = $value['image'];
					else
						$walkthrough_image = 'no_image.png';
				}  else {
						$walkthrough_image = 'no_image.png';
				}

				if( strlen($value['description']) == 100 ){
					$value['description'] = substr($value['description'],0,100) ." ....." ;
				}
				$data['walkthroughs'][] = array(

					"id" =>  $value['id'],
					"title" =>  $value['title'],
					"description" => 	$value['description'],					
					"image" =>   $walkthrough_image,	
					"thumb" =>   $this->model_tool_image->resize($walkthrough_image, 100, 100),					
					"status" =>  $value['status'],
					"sort_order" =>  $value['sort_order'],
					"edit" => $this->url->link('mobikul/walkthrough/edit&walkthrough_id='.$value['id'], 'user_token=' . $this->session->data['user_token'], 'SSL')						   
	   
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

	

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}
		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}
		
		
		$pagination = new Pagination();
		$pagination->total = $walkthrough_total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_limit_admin');
		$pagination->url = $this->url->link('mobikul/walkthrough', 'user_token=' . $this->session->data['user_token'] .$url.'&page={page}', 'SSL');

		$data['pagination'] = $pagination->render();

		$data['results'] = sprintf($this->language->get('text_pagination'), ($walkthrough_total) ? (($page - 1) * $this->config->get('config_limit_admin')) + 1 : 0, ((($page - 1) * $this->config->get('config_limit_admin')) > ($walkthrough_total - $this->config->get('config_limit_admin'))) ? $walkthrough_total : ((($page - 1) * $this->config->get('config_limit_admin')) + $this->config->get('config_limit_admin')), $walkthrough_total, ceil($walkthrough_total / $this->config->get('config_limit_admin')));


		$url = '';

		if (isset($this->request->get['filter_title'])) {
			$url .= '&filter_title=' . urlencode(html_entity_decode($this->request->get['filter_title'], ENT_QUOTES, 'UTF-8'));
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

		$data['sort_id'] = $this->url->link('mobikul/walkthrough', 'user_token=' . $this->session->data['user_token'] . '&sort=w.id' . $url, true);
		$data['sort_title'] = $this->url->link('mobikul/walkthrough', 'user_token=' . $this->session->data['user_token'] . '&sort=w.title' . $url, true);		
		$data['sort_status'] = $this->url->link('mobikul/walkthrough', 'user_token=' . $this->session->data['user_token'] . '&sort=w.status' . $url, true);
		$data['sort_order'] = $this->url->link('mobikul/walkthrough', 'user_token=' . $this->session->data['user_token'] . '&sort=w.sort_order' . $url, true);
		

		$data['sort'] = $sort;
		$data['order'] = $order;
		$data['filter_title'] = $filter_title;
		$data['filter_status'] = $filter_status;
	
		
		
		$data['action'] = $this->url->link('mobikul/walkthrough/add', 'user_token=' . $this->session->data['user_token'], 'SSL');	
		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/walkthrough_list', $data));
	}

	public function add(){
		$data = array();

		$data = array_merge($data,$this->language->load('mobikul/walkthrough'));

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('mobikul/walkthrough');
		$this->load->model('setting/setting');	
		$this->load->model('tool/image');

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate() ) {			
			$status = $this->model_mobikul_walkthrough->addwalkthrough($this->request->post);	
			if($status){
				$this->response->redirect($this->url->link('mobikul/walkthrough', 'user_token=' . $this->session->data['user_token'], 'SSL'));
				$this->session->data['success'] = $this->language->get('text_success');
			}else{
				$this->response->redirect($this->url->link('mobikul/walkthrough', 'user_token=' . $this->session->data['user_token'], 'SSL'));
			}
			
		}

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}
		if (isset($this->error['error_title']) ) {
			$data['error_title'] = $this->error['error_title'];
		} else {
			$data['error_title'] = '';
		}

		if (isset($this->error['error_description']) ) {
			$data['error_description'] = $this->error['error_description'];
		} else {
			$data['error_description'] = '';
		}



		if (isset($this->error['error_sort_order']) ) {
			$data['error_sort_order'] = $this->error['error_sort_order'];
		} else {
			$data['error_sort_order'] = '';
		}

		if (isset($this->request->post['title'])) {
			$data['walkthrough']['title'] = $this->request->post['title'];
		}else {
			$data['walkthrough']['title'] = '';
		}

		if(isset($this->request->post['image'])) {
			if (is_file(DIR_IMAGE . $this->request->post['image']))
				$image = $this->request->post['image'];
			else
				$image = 'no_image.png';
		}else {
				$image = 'no_image.png';
		}

		$this->load->model('tool/image');

		$data['walkthrough']['thumb']= $this->model_tool_image->resize($image, 100, 100);
		$data['walkthrough']['image'] = $image;

		if (isset($this->request->post['description'])) {
			$data['walkthrough']['description'] = $this->request->post['description'];
		}else {
			$data['walkthrough']['description'] = '';
		}
		
		if (isset($this->request->post['status'])) {
				$data['walkthrough']['status'] = $this->request->post['status'];
		} else {
				$data['walkthrough']['status'] = '';
		}
		if (isset($this->request->post['sort_order'])) {
			$data['walkthrough']['sort_order'] = $this->request->post['sort_order'];
		}  else {
			$data['walkthrough']['sort_order'] = '';
		}
		
		
		$this->load->model('localisation/language');
		$data['languages'] = $this->model_localisation_language->getLanguages();		
		$data['placeholder']= $this->model_tool_image->resize('no_image.png',100,100);
		$data['cancel'] = $this->url->link('mobikul/walkthrough', 'user_token=' . $this->session->data['user_token'], 'SSL');
		$data['user_token'] = $this->session->data['user_token'];
		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/walkthrough_form', $data));
	}


	public function edit(){
		$data = array();

		$this->language->load('mobikul/walkthrough');
		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('setting/setting');
		$this->load->model('tool/image');
		$this->load->model('mobikul/walkthrough');

		if (isset($this->request->get['walkthrough_id'])) {
			$walkthrough_id = $this->request->get['walkthrough_id'];
		} else {
			$walkthrough_id = 0;
		}

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()   ) {	

			$status = $this->model_mobikul_walkthrough->addwalkthroughById($walkthrough_id, $this->request->post );
			
			if($status){
				$this->session->data['success'] = $this->language->get('text_success');
			    $this->response->redirect($this->url->link('mobikul/walkthrough', 'user_token=' . $this->session->data['user_token'], 'SSL'));
			}else{
				$this->response->redirect($this->url->link('mobikul/walkthrough', 'user_token=' . $this->session->data['user_token'], 'SSL'));
			}
		}

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}
		if (isset($this->error['error_title']) ) {
			$data['error_title'] = $this->error['error_title'];
		} else {
			$data['error_title'] = '';
		}

		if (isset($this->error['error_description']) ) {
			$data['error_description'] = $this->error['error_description'];
		} else {
			$data['error_description'] = '';
		}


		if (isset($this->error['error_sort_order']) ) {
			$data['error_sort_order'] = $this->error['error_sort_order'];
		} else {
			$data['error_sort_order'] = '';
		}


		

		$walkthrough = $this->model_mobikul_walkthrough->getwalkthroughById($walkthrough_id);	

		if (isset($walkthrough["id"])) {
			$data['walkthrough']['id']= $walkthrough["id"];
		} else {
			$data['walkthrough']['id']= null;
		}
		if (isset($this->request->post['title'])) {
			$data['walkthrough']['title'] = $this->request->post['title'];
		} elseif (!empty($walkthrough)) {
			$data['walkthrough']['title'] = $walkthrough['title'];
		} else {
			$data['walkthrough']['title'] = '';
		}

		if(isset($this->request->post['image'])) {
			if (is_file(DIR_IMAGE . $this->request->post['image']))
				$image = $this->request->post['image'];
			else
				$image = 'no_image.png';
		} elseif (!empty($walkthrough) && $walkthrough['image']) {
			if (is_file(DIR_IMAGE . $walkthrough['image']))
				$image = $walkthrough['image'];
			else
				$image = 'no_image.png';
		} else {
				$image = 'no_image.png';
		}

		$this->load->model('tool/image');

		$data['walkthrough']['thumb']= $this->model_tool_image->resize($image, 100, 100);
		$data['walkthrough']['image'] = $image;

		if (isset($this->request->post['description'])) {
			$data['walkthrough']['description'] = $this->request->post['description'];
		} elseif (!empty($walkthrough)) {
			$data['walkthrough']['description'] = $walkthrough['description'];
		} else {
			$data['walkthrough']['description'] = '';
		}
		
		if (isset($this->request->post['status'])) {
				$data['walkthrough']['status'] = $this->request->post['status'];
		} elseif (!empty($walkthrough)) {
				$data['walkthrough']['status'] = $walkthrough['status'];
		} else {
				$data['walkthrough']['status'] = '';
		}
		if (isset($this->request->post['sort_order'])) {
			$data['walkthrough']['sort_order'] = $this->request->post['sort_order'];
		} elseif (!empty($walkthrough)) {
				$data['walkthrough']['sort_order'] = $walkthrough['sort_order'];
		} else {
				$data['walkthrough']['sort_order'] = '';
		}

		
		$data['user_token'] = $this->session->data['user_token'];
		$data['cancel'] = $this->url->link('mobikul/walkthrough', 'user_token=' . $this->session->data['user_token'], 'SSL');
		$this->load->model('localisation/language');	
		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('mobikul/walkthrough_form', $data));
	}

	public function delete() {

		$json['success'] = '';

		$this->load->model('mobikul/walkthrough');
		$this->language->load('mobikul/walkthrough');
		$this->language->load('mobikul/carousels');

		if (isset($this->request->post['post_id']) && $this->request->post['post_id']) {
		   
			foreach($this->request->post['post_id'] as $id){
				$this->model_mobikul_walkthrough->deleteCarousel($id);
			}
			$this->session->data['success'] = $this->language->get('text_success_delete');
			$json['success'] = $this->language->get('text_success_delete');
		}

	
		$this->response->setOutput(json_encode($json));
	}

	protected function validate() { 
		if (!$this->user->hasPermission('modify', 'mobikul/walkthrough')) {
			$this->error['error_warning'] = $this->language->get('error_permission');
		} else{

			if( !isset($this->request->post['title']) || !$this->request->post['title'] ||  (utf8_strlen($this->request->post['title']) < 2)  || (utf8_strlen($this->request->post['title']) > 64) || empty($this->request->post['title']) || ctype_space($this->request->post['title'] ) ){
			
				$this->error['error_title'] = $this->language->get('error_title');
			}

			if( !isset($this->request->post['description']) || !$this->request->post['description'] ||  (utf8_strlen($this->request->post['description']) < 2)  || (utf8_strlen($this->request->post['description']) > 200) || empty($this->request->post['description']) || ctype_space($this->request->post['description'] ) ){
			
				$this->error['error_description'] = $this->language->get('error_description');
			}
		    
			if(  !isset($this->request->post['sort_order']) || !$this->request->post['sort_order'] || !is_numeric($this->request->post['sort_order'] ) ){
				$this->error['error_sort_order'] = $this->language->get('error_sort_order');
			}
			
		
		
		}
	
		if (!$this->error) {
			return true;
		} else {
			return false;
		}
	}

}
