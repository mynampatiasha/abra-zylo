<?php

/**
 * Mobikul module's controller
 */
class ControllerExtensionModuleMobikul extends Controller
{
    private $error = array();

    public function install()
    {
        $this->load->model('extension/module/mobikul');
        $this->model_extension_module_mobikul->createTable();
    }

    public function uninstall()
    {
        $this->load->model('extension/module/mobikul');
        $this->model_extension_module_mobikul->deleteTable();
    }

    public function index()
    {
        $this->load->language('extension/module/mobikul');

        $this->document->setTitle($this->language->get('heading_title'));

        $this->load->model('setting/setting');

        if (file_exists(DIR_APPLICATION . '../vendor/autoload.php')){
            $data['warning_composer']  =  "";
        }else{
            $data['warning_composer'] = "Please install the composer first";
        }

        if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {

            $data_value = array();

            $post_array = array(
                'mobikul_status',
                'mobikul_api_key',
                'mobikul_api_password',
                'mobikul_banner_status',
                'mobikul_notification_status',
                'mobikul_gcm_key',
                'mobikul_topic_name',
                'mobikul_carousel_status',
                'mobikul_featured_status',
                'mobikul_theme_status',
                'mobikul_theme_value',
                'mobikul_playstore_link_status',
                'mobikul_applestore_link_status',
                'mobikul_playstore_link',
                'mobikul_applestore_link',
                'mobikul_header_status',
                'mobikul_footer_status',
                'mobikul_front_text',
                'mobikul_launcher_icon_type',
                'mobikul_app_category_view_status',
                'mobikul_display_search_status',
                'mobikul_number_of_tag',
                'mobikul_display_product_status',
                'mobikul_number_of_product'
            );
            foreach ($post_array as $value) {
                if (isset($this->request->post['module_' . $value])) {
                    $data_value[$value] = $this->request->post['module_' . $value];
                }

            }

            // Upload json file
            if (isset($_FILES['module_mobikul_gcm_key']) && !$_FILES['module_mobikul_gcm_key']['error']) {
                $json_file = $_FILES['module_mobikul_gcm_key'];
                if($json_file['type'] == 'application/json'){
                    $tmpFilePath = $json_file['tmp_name'];
                    $newFileName = 'fcm_credentials.json';
                    $uploadFile = DIR_SYSTEM . 'mobikul_fcm_file/' . $newFileName;
        
                    if (!file_exists(DIR_SYSTEM . 'mobikul_fcm_file')) {
                        mkdir(DIR_SYSTEM . 'mobikul_fcm_file');
                    } else {
                        unlink(DIR_SYSTEM . 'mobikul_fcm_file' .'/'. $this->config->get('module_mobikul_gcm_key'));
                    }
        
                    if (move_uploaded_file($tmpFilePath, $uploadFile)) {
                        $this->request->post['module_mobikul_gcm_key'] = $newFileName;
                    }
                }
            } else {
                $this->request->post['module_mobikul_gcm_key'] = $this->config->get('module_mobikul_gcm_key');
            }


            $this->model_setting_setting->editSetting('mobikul', $data_value);

            $this->model_setting_setting->editSetting('module_mobikul', $this->request->post);

            $this->session->data['success'] = $this->language->get('text_success');

            $this->response->redirect($this->url->link('marketplace/extension', 'user_token=' . $this->session->data['user_token'] . '&type=module', true));
        }

        $errorData = array(
            'warning',
            'playstore_link',
            'applestore_link',
            'api_key',
            'api_password',
        );

        foreach ($errorData as $key) {
            if (isset($this->error[$key])) {
                $data['error_' . $key] = $this->error[$key];
            } else {
                $data['error_' . $key] = '';
            }
        }

        if (isset($this->session->data['success'])) {
            $data['success'] = $this->session->data['success'];

            unset($this->session->data['success']);
        } else {
            $data['success'] = '';
        }

        $data['breadcrumbs'] = array();

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], true),
        );

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_module'),
            'href' => $this->url->link('marketplace/extension', 'user_token=' . $this->session->data['user_token'] . '&type=module', true),
        );

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('heading_title'),
            'href' => $this->url->link('extension/module/mobikul', 'user_token=' . $this->session->data['user_token'], true),
        );

        $data['action'] = $this->url->link('extension/module/mobikul', 'user_token=' . $this->session->data['user_token'], true);

        $data['cancel'] = $this->url->link('marketplace/extension', 'user_token=' . $this->session->data['user_token'] . '&type=module', true);
        $data['token'] = $this->session->data['user_token'];

        $config_array = array(
            'module_mobikul_status',
            'module_mobikul_api_key',
            'module_mobikul_api_password',
            'module_mobikul_banner_status',
            'module_mobikul_notification_status',
            'module_mobikul_gcm_key',
            'module_mobikul_topic_name',
            'module_mobikul_carousel_status',
            'module_mobikul_featured_status',
            'module_mobikul_theme_status',
            'module_mobikul_theme_value',
            'module_mobikul_playstore_link_status',
            'module_mobikul_applestore_link_status',
            'module_mobikul_playstore_link',
            'module_mobikul_applestore_link',
            'module_mobikul_header_status',
            'module_mobikul_footer_status',
            'module_mobikul_front_text',
            'module_mobikul_walkthrough_status',
            'module_mobikul_launcher_icon_type',
            'module_mobikul_app_category_view_status',
            'module_mobikul_display_search_status',
            'module_mobikul_number_of_tag',
            'module_mobikul_display_product_status',
            'module_mobikul_number_of_product'
        );

        foreach ($config_array as $config_val) {

            if (isset($this->request->post[$config_val])) {
                $data[$config_val] = $this->request->post[$config_val];
            } else {
                $data[$config_val] = $this->config->get($config_val);
            }
        }

        $launcher_types = array();
        for ($launcher = 0; $launcher <= 5; $launcher++) {
            $launcher_types[$launcher] = array(
                'name' => 'Type ' . $launcher,
                'value' => $launcher,
            );
        }
        $data['launcher_types'] = $launcher_types;

        if (version_compare(VERSION, '2.3.0.0', '>=')) {
            $this->load->model('extension/module/mobikul');
            $shipping_results = $this->model_extension_module_mobikul->getExtensions('shipping');
            $payment_results = $this->model_extension_module_mobikul->getExtensions('payment');
        } else {
            $this->load->model('module/mobikul');
            $shipping_results = $this->model_module_mobikul->getExtensions('shipping');
            $payment_results = $this->model_module_mobikul->getExtensions('payment');
        }

        foreach ($shipping_results as $result) {
            if (version_compare(VERSION, '3.0.0.0', '>=')) {
                $status = 'shipping_' . $result['code'] . '_status';
            } else {
                $status = $result['code'] . '_status';
            }
            if ($this->config->get($status)) {
                $title = ucwords(str_replace('_', ' ', str_replace('.', ' ', $result['code'])));
                if ($this->config->get('module_mobikul_shipping') && !in_array($result['code'], $this->config->get('module_mobikul_shipping'))) {
                    $selected = false;
                } else {
                    $selected = true;
                }

                $data['shipping_methods'][] = array(
                    'title' => $title,
                    'code' => $result['code'],
                    'selected' => $selected,
                );
            }
        }

        foreach ($payment_results as $result) {
            if (version_compare(VERSION, '3.0.0.0', '>=')) {
                $status = 'payment_' . $result['code'] . '_status';
            } else {
                $status = $result['code'] . '_status';
            }
            if ($this->config->get($status)) {
                $title = ucwords(str_replace('_', ' ', str_replace('.', ' ', $result['code'])));
                if ($this->config->get('module_mobikul_payment') && !in_array($result['code'], $this->config->get('module_mobikul_payment'))) {
                    $selected = false;
                } else {
                    $selected = true;
                }

                $data['payment_methods'][] = array(
                    'title' => $title,
                    'code' => $result['code'],
                    'selected' => $selected,
                );
            }
        }

        //banner section start
        $this->load->model('mobikul/banner');
        $this->load->model('tool/image');

        $filter = array(
            'filter_id_from' => null,
            'filter_id_to' => null,
            'filter_title' => null,
            'filter_status' => 1,
            'filter_type' => null,
            'sort' => null,
            'order' => null,
            'start' => 0,
            'limit' => 100,
        );

        $data['banners'] = $this->model_mobikul_banner->getBanner($filter);
        $data['json_banners'] = json_encode($data['banners']);

        //banner section end

        //carousel section start

        $filter_data = array(
            'filter_title' => null,
            'filter_type' => null,
            'filter_status' => 1,
            'filter_sort_order' => null,
            'sort' => null,
            'order' => null,
            'start' => 0,
            'limit' => 100,
        );

        $data['json_carousels'] = array();

        $this->load->model('extension/module/mobikul');

        $data['carousels'] = $this->model_extension_module_mobikul->getConfigHome();

        $data['product_homecount'] = $this->config->get('product_homecount');

        $data['json_carousels'] = json_encode($data['carousels']);

        $this->load->model('localisation/order_status');

		$data['order_statuses'] = $this->model_localisation_order_status->getOrderStatuses();

        //carousel section end

        // get project id from fcm file
        if($this->config->get('module_mobikul_gcm_key')){
			$filepath = file_get_contents(DIR_SYSTEM .'mobikul_fcm_file/fcm_credentials.json');
			$json = json_decode($filepath, true); 
			$data['project_id'] = isset($json['project_id']) ? $json['project_id'] : '';
		}else{
			$data['project_id'] = '';
		}

        $data['help_home_settings'] = sprintf($this->language->get('help_home_settings'), $this->config->get('config_owner'));

        $data['header'] = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer'] = $this->load->controller('common/footer');

        $this->response->setOutput($this->load->view('extension/module/mobikul', $data));
    }

    public function saveHomeSequence()
    {

        $this->load->model('setting/setting');
        if (!isset($this->request->post['mobikulhome_sequence'])) {
            $this->request->post['mobikulhome_sequence'] = array();
        }

        $this->model_setting_setting->editSetting('mobikulhome', $this->request->post);
    }

    public function saveHomeCount()
    {
        $this->load->model('setting/setting');
        $this->model_setting_setting->editSetting('product', $this->request->post);
    }
    public function getHomeCount()
    {
        $this->response->addHeader('Content-Type:application/json');
        $this->response->setOutput(json_encode(["product_homecount" => $this->config->get('product_homecount')]));

    }
    public function getHomeSequence()
    {
        $json = array();
        $this->load->model('extension/module/mobikul');
        $this->language->load('extension/module/mobikul');
        if ($this->config->get('mobikulhome_sequence')) {

            foreach ($this->config->get('mobikulhome_sequence') as $type) {

                if (strpos($type, "banner") !== false) {
                    $id = explode("_", $type)[1];
                    $title = $this->model_extension_module_mobikul->getBannerName($id);

                    $json[] = array(
                        'type' => $type,
                        'title' => $this->db->escape($title),
                        'value' => 'banner',
                    );
                } else if (strpos($type, "carousel") !== false) {
                    $id = explode("_", $type)[1];
                    $getbanner = $this->model_extension_module_mobikul->getCarouselName($id);

                    $json[] = array(
                        'type' => $type,
                        'title' => $this->db->escape($getbanner['title']),
                        'value' => $getbanner['value'],
                    );
                }

                // else {
                //     $json[] = array(
                //         'type' => $type,
                //         'title' => $this->language->get('section_' . $type)
                //     );
                // }
            }
        }

        $this->response->addHeader('Content-Type:application/json');
        $this->response->setOutput(json_encode($json));
    }

    protected function validate()
    {

        if (!$this->request->post['module_mobikul_api_key'] || !preg_match("/^[a-zA-Z_0-9@-]+$/", $this->request->post['module_mobikul_api_key'])) {
            $this->error['api_key'] = $this->language->get('error_key');
        }

        if (!$this->request->post['module_mobikul_api_password'] || !preg_match("/^[a-zA-Z_0-9@-]+$/", $this->request->post['module_mobikul_api_password'])) {
            $this->error['api_password'] = $this->language->get('error_key');
        }

        if (isset($this->request->post['mobikul_playstore_link']) && $this->request->post['mobikul_playstore_link']) {
            $this->request->get['application_url'] = $this->request->post['mobikul_playstore_link'];
            if (!$this->checkUrl()['status']) {
                $this->error['playstore_link'] = $this->language->get('error_store_link');
            }
        }

        if (isset($this->request->post['mobikul_applestore_link']) && $this->request->post['mobikul_applestore_link']) {
            $this->request->get['application_url'] = $this->request->post['mobikul_applestore_link'];
            if (!$this->checkUrl()['status']) {
                $this->error['applestore_link'] = $this->language->get('error_store_link');
            }
        }

        if (!$this->user->hasPermission('modify', 'extension/module/mobikul')) {
            $this->error['warning'] = $this->language->get('error_permission');
        }

        return !$this->error;
    }

    public function checkUrl()
    {
        if (isset($this->request->get['application_url']) && $this->request->get['application_url']) {
            $url = $this->request->get['application_url'];
            $ch = @curl_init($url);
            @curl_setopt($ch, CURLOPT_HEADER, true);
            @curl_setopt($ch, CURLOPT_NOBODY, true);
            @curl_setopt($ch, CURLOPT_FOLLOWLOCATION, false);
            @curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            $status = array();
            preg_match('/HTTP\/.* ([0-9]+) .*/', @curl_exec($ch), $status);
            if (isset($status[1]) && $status[1] == 200) {
                $json = array('status' => true);
            } else {
                $json = array('status' => false);
            }
            curl_close($ch);
        } else {
            $json = array('status' => false);
        }
        if (isset($this->request->post['mobikul_api_key'])) {
            return $json;
        }
        $this->response->addHeader('Content-Type: application/json');
        $this->response->setOutput(json_encode($json));
    }
}
