<?php
class ControllerMobikulOrderHistory extends Controller
{
	public function index()
	{
		$this->load->language('mobikul/order_history');
        $this->load->model('sale/order');
		$this->document->setTitle($this->language->get('heading_title'));

        $data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], true)
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('heading_title'),
			'href' => $this->url->link('mobikul/order_history', 'user_token=' . $this->session->data['user_token'], true)
		);

        $query = $this->db->query("SELECT DISTINCT order_id FROM " . DB_PREFIX . "order_history ");
		$order_histories = $query->rows;

        $data['all_order'] = array();
        foreach ($order_histories as $order_history){
            $data['order'] = $this->model_sale_order->getOrder($order_history['order_id']);
            $order_array = [
                "order_id" => $data['order']['order_id'],
                "customer" => $data['order']['customer'],
                "status" => $data['order']['order_status'],
                "total" => $data['order']['total'],
                "date_added" => $data['order']['date_added'],
                "store_id" => $data['order']['store_id'],
                "url" => $this->url->link('sale/order/info', 'user_token=' . $this->session->data['user_token'] . '&order_id=' . $data['order']['order_id'], true),
            ];
            array_push($data['all_order'],  $order_array);

        }

        $data['user_token'] = $this->session->data['user_token'];
		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');
        $this->response->setOutput($this->load->view('mobikul/order_history_list', $data));

	}
}